function[earnings]=getPRetMom(SP500_fundamental_test)
%get return and momentum on price
TickerList = string(unique(SP500_fundamental_test.tic));
SP500_fundamental_sorted = sortrows(SP500_fundamental_test,5);

% Create 6 and 12-month momentum and 1, 6 and 12-month forward return

adj_return=[];
working_capital_change=[];

revenues_growth=[];

% Add a waitbar to monitor the process

for j=1:size(TickerList,1)
	rows = strcmp(SP500_fundamental_test.tic,TickerList(j,1));
	ticker_window = table2array(SP500_fundamental_test(rows,'revtq'));
%%current change, current quarter (T) / previous quarter (T-1)
	
	if length(ticker_window) < 2
		new_Mom_1 = repelem(NaN,length(ticker_window),1);
	else
		new_Mom_1 = [NaN; ticker_window(2:end,1) ./ ticker_window(1:end-1,1) - 1];
	end
	revenues_growth = [revenues_growth; new_Mom_1];
	


	%if length(ticker_window) < 2
	%	new_ForwardRet_1 = [NaN];
	%else
	%	new_ForwardRet_1 = [ticker_window(2:end,1) ./ ticker_window(1:end-1,1) - 1; NaN];
	%end
	%ForwardRet_1 = [ForwardRet_1; new_ForwardRet_1];

	waitbar(j/size(TickerList,1));

end

earnings.Mom_1 = Mom_1;


end