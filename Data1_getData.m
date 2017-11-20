
%% import all data from csv files
SP500_fundamental=readtable('2-SP500 Fundamental.csv','TreatAsEmpty',{''});

sp500_targetT=readtable('sp500list_1990.txt');
%SP500_price1=readtable('1-SP500 Price 1990 to 1999.csv');
%SP500_price2=readtable('1-SP500 Price 2000 to 2009.csv');
%SP500_price3=readtable('1-SP500 Price 2010 to 2017.csv');
%SP500_price=[SP500_price1;SP500_price2;SP500_price3];


sp500_price=readtable('1-SP500 Price 1990 to 2017.csv');
%sp500_price = sp500_price(:,[1:5 8 6:7 end]);
%calculate adjusted close price
adjusted_close = table(repmat(NaN,size(sp500_price,1),1));
sp500_price=[sp500_price,adjusted_close];
sp500_price.Properties.VariableNames{size(sp500_price,2)}= strcat('adj_cprice');
sp500_price.adj_cprice=sp500_price.prccd./sp500_price.ajexdi;

%SP500_price(:,c(2,5:12))=[];


tickers_price=unique(sp500_price.tic);
tickers_fundamental=unique(SP500_fundamental.tic);
SP500_fundamental(SP500_fundamental.datadate==20170831,:)

%create an empty column tradedate added to the fundamental table
trade_date = table(repmat(NaN,size(SP500_fundamental,1),1));
SP500_fundamental=[SP500_fundamental,trade_date];
SP500_fundamental.Properties.VariableNames{size(SP500_fundamental,2)}= strcat('tradedate');

%% trade date convert
fundamental_date=unique(SP500_fundamental.datadate);
%determine the trade date
for i =1:length(fundamental_date)
    date_year=round(fundamental_date(i)/10000)*10000;
    if (fundamental_date(i)-date_year)<=331
        fundamental_date(i,2)=date_year+601;
    end
    
    if (fundamental_date(i)-date_year)>331 && (fundamental_date(i)-date_year)<=630
        fundamental_date(i,2)=date_year+901;
    end
    
    if (fundamental_date(i)-date_year)>630 && (fundamental_date(i)-date_year)<=930
        fundamental_date(i,2)=date_year+1201;
    end
    
    if (fundamental_date(i)-date_year)>930 
        fundamental_date(i,2)=round(fundamental_date(i)/10000+1)*10000+301;
    end
        
end

%convert to business date
fundamental_date(:,3)=fundamental_date(:,2);
for i=1:length(fundamental_date)
   convert_to_yyyymmdd=datetime(fundamental_date(i,3),'ConvertFrom','yyyymmdd');
   if isbusday(convert_to_yyyymmdd)==0
       
       fundamental_date(i,3)=yyyymmdd(busdate(convert_to_yyyymmdd));
   end
end

for i =1:size(SP500_fundamental.tradedate,1)
    index=SP500_fundamental.datadate(i)==fundamental_date(:,1);
    SP500_fundamental.tradedate(i)=fundamental_date(index,3);
    
end

%% match close and adjusted price
%narrow price table to only trade days
sp500_index = repmat(NaN,size(sp500_price,1),1);
for i =1:size(sp500_price,1)
    
index=sp500_price.datadate(i)==fundamental_date(:,3);
if sum(index)==0
    sp500_index(i)=0;
else
    sp500_index(i)=1;
end

end

sp500_index=logical(sp500_index);
sp500_trade=table2array(sp500_price(sp500_index,:));


%create 2 empty columns close_price, adj_cprice
close_price = table(repmat(NaN,size(SP500_fundamental,1),1));
adj_cprice = table(repmat(NaN,size(SP500_fundamental,1),1));


SP500_fundamental=[SP500_fundamental,close_price];
SP500_fundamental.Properties.VariableNames{size(SP500_fundamental,2)}= strcat('close_price');

SP500_fundamental=[SP500_fundamental,adj_cprice];
SP500_fundamental.Properties.VariableNames{size(SP500_fundamental,2)}= strcat('adj_cprice');

%match close price and adjusted price to fundamental table
for i=1:size(SP500_fundamental,1)
    index = logical(string(SP500_fundamental.tic{i})==sp500_trade.tic & SP500_fundamental.tradedate(i)==sp500_trade.datadate);
    if isempty(sp500_trade.prccd(index))==1
        SP500_fundamental.close_price(i)=NaN;
        SP500_fundamental.adj_cprice(i)=NaN;
    else
        SP500_fundamental.close_price(i)=sp500_trade.prccd(index);
        SP500_fundamental.adj_cprice(i)=sp500_trade.adj_cprice(index);
    end
end

%filename='SP500 Fundamental with Price.xlsx';
%writetable(SP500_fundamental,filename,'Sheet',1,'Range','A1')
    


%% calculate change/momentum
SP500_fundamental_test=readtable('SP500 Fundamental with Price.csv','TreatAsEmpty',{''});

TickerList = string(unique(SP500_fundamental_test.tic));


adj_return=[];
wcapq_change=[];
REVGH=[];


for j=1:size(TickerList,1)
    
	rows = strcmp(SP500_fundamental_test.tic,TickerList(j,1));
    %%current change, current quarter (T) / previous quarter (T-1)
	revtq_window = table2array(SP500_fundamental_test(rows,'revtq'));
	if length(revtq_window) < 2
		revtq_Mom_1 = repelem(NaN,length(revtq_window),1);
	else
		revtq_Mom_1 = [NaN; revtq_window(2:end,1) ./ revtq_window(1:end-1,1) - 1];
	end
	REVGH = [REVGH; revtq_Mom_1];
	
	wcapq_window = table2array(SP500_fundamental_test(rows,'wcapq'));
	if length(wcapq_window) < 2
		wcapq_Mom_1 = repelem(NaN,length(wcapq_window),1);
	else
		wcapq_Mom_1 = [NaN; wcapq_window(2:end,1) - wcapq_window(1:end-1,1)];
	end
	wcapq_change = [wcapq_change; wcapq_Mom_1];

    price_window = table2array(SP500_fundamental_test(rows,'adj_cprice'));
	if length(price_window) < 2
		price_ForwardRet_1 = [NaN];
	else
		price_ForwardRet_1 = [price_window(2:end,1) ./ price_window(1:end-1,1) - 1; NaN];
	end
	adj_return = [adj_return; price_ForwardRet_1];


end



SP500_fundamental_sorted = sortrows(SP500_fundamental_test,'tic');

SP500_fundamental_sorted.REVGH = REVGH;
SP500_fundamental_sorted.wcapq_change = wcapq_change;
SP500_fundamental_sorted.adj_return = adj_return;

filename='SP500 Fundamental sorted.xlsx';
writetable(SP500_fundamental_sorted,filename,'Sheet',1,'Range','A1')






%% testing
SP500_fundamental=readtable('2-SP500 Fundamental.csv','TreatAsEmpty',{''});

fundamental_final=readtable('SP500 Fundamental_Final Table.csv','TreatAsEmpty',{''});
fundamental_ml=readtable('SP500 Fundamental_Machine Learning.csv','TreatAsEmpty',{''});

ind=string(sp500_price.tic)=='PNW';
pnw=sp500_price(ind,:);

ind=string(sp500_price.tic)=='LDG';
ldg=sp500_price(ind,:);
SP500_fundamental(SP500_fundamental.datadate==20170131,:)


ind=fundamental_ml.datadate==20170331;
quarter20170331=fundamental_ml(ind,:);

ind=fundamental_ml.datadate==20170131;
quarter20170131=fundamental_ml(ind,:);
