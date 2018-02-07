function IndexOfTime = time2Index (Time,TT)

Time = datetime(Time,'Format','hh:mm:ss');
Time = cellstr(Time);
Time = Time{1,1};
Time = Time([1,2,4,5,7,8]);
Time = str2double(Time);

if mod(mod(Time,100),15) ~= 0
   Time = (Roundto15(Time)); 
end

IndexOfTime = find(TT==Time);

