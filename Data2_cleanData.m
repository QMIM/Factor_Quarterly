%% handle NaN
fundamental_ml=readtable('SP500 Fundamental_Machine Learning.csv','TreatAsEmpty',{''});

TickerList = string(unique(fundamental_ml.tic));

%delete stocks with a '' ticker
%91216-90630=586 rows
fundamental_ml(string(fundamental_ml.tic)=='',:)=[];
%delete rows with NaN y_return, if this stock don't have a close price
%that means we can't trade it (delisted), so we delete this row
sum(isnan(fundamental_ml.y_return))/size(fundamental_ml,1)
%10370 rows
fundamental_ml(isnan(fundamental_ml.y_return),:)=[];


%% Separate 11 sectors
%sector 10: Energy
fundamental_sector10= fundamental_ml(fundamental_ml.gsector==10,:);
%sum(ismissing(earnings_sector10))
size(unique(fundamental_sector10.tic))  
%79 stocks stocks
sum(ismissing(fundamental_sector10))
%541/5847=9.25% missing values, acceptable
fundamental_sector10_clean=rmmissing(fundamental_sector10);
sum(ismissing(fundamental_sector10_clean))

writetable(fundamental_sector10,'fundamental_sector10.xlsx','Sheet',1,'Range','A1')
writetable(fundamental_sector10_clean,'fundamental_sector10_clean.xlsx','Sheet',1,'Range','A1')

%sector 15: Materials
fundamental_sector15= fundamental_ml(fundamental_ml.gsector==15,:);
size(unique(fundamental_sector15.tic))
%80 stocks
writetable(fundamental_sector15,'fundamental_sector15.xlsx','Sheet',1,'Range','A1')

%sector 20: Industrials
fundamental_sector20= fundamental_ml(fundamental_ml.gsector==20,:);
size(unique(fundamental_sector20.tic))
%141 stocks
writetable(fundamental_sector20,'fundamental_sector20.xlsx','Sheet',1,'Range','A1')

%sector 25: Consumer Discretionary
fundamental_sector25= fundamental_ml(fundamental_ml.gsector==25,:);
size(unique(fundamental_sector25.tic))
%185 stocks
writetable(fundamental_sector25,'fundamental_sector25.xlsx','Sheet',1,'Range','A1')

%sector 30: Consumer Staples
fundamental_sector30= fundamental_ml(fundamental_ml.gsector==30,:);
size(unique(fundamental_sector30.tic))
%77 stocks
writetable(fundamental_sector30,'fundamental_sector30.xlsx','Sheet',1,'Range','A1')

%sector 35: Health Cares
fundamental_sector35= fundamental_ml(fundamental_ml.gsector==35,:);
size(unique(fundamental_sector35.tic))
%111 stocks
writetable(fundamental_sector35,'fundamental_sector35.xlsx','Sheet',1,'Range','A1')

%sector 40: Financials
fundamental_sector40= fundamental_ml(fundamental_ml.gsector==40,:);
size(unique(fundamental_sector40.tic))
%156 stocks
sum(ismissing(fundamental_sector40))/size(fundamental_sector40,1)
%541/5847=9.25% missing values, acceptable
fundamental_sector10_clean=rmmissing(fundamental_sector40);
sum(ismissing(fundamental_sector40_clean))

writetable(fundamental_sector40,'fundamental_sector40.xlsx','Sheet',1,'Range','A1')

%sector 45: Information Technology
fundamental_sector45= fundamental_ml(fundamental_ml.gsector==45,:);
size(unique(fundamental_sector45.tic))
%157 Stocks
writetable(fundamental_sector45,'fundamental_sector45.xlsx','Sheet',1,'Range','A1')

%sector 50: Telecommunication Serivices
fundamental_sector50= fundamental_ml(fundamental_ml.gsector==50,:);
size(unique(fundamental_sector50.tic))
%27 stocks
writetable(fundamental_sector50,'fundamental_sector50.xlsx','Sheet',1,'Range','A1')

%sector 55: Utilities
fundamental_sector55= fundamental_ml(fundamental_ml.gsector==55,:);
size(unique(fundamental_sector55.tic))
%57 stocks
writetable(fundamental_sector55,'fundamental_sector55.xlsx','Sheet',1,'Range','A1')

%sector 60: Real Estate
fundamental_sector60= fundamental_ml(fundamental_ml.gsector==60,:);
size(unique(fundamental_sector60.tic))
%38 stocks
writetable(fundamental_sector60,'fundamental_sector60.xlsx','Sheet',1,'Range','A1')
