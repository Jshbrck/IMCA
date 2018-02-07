function TT = TimeTags(InitialTime,length_of_TT)

 
     
    % InitialTime = ['11:59:14   PM'];  
    % length_of_TT = 35;
% k = strfind(InitialTime);
   %n = num(1:end-4,7);
   matrixLength = length_of_TT;
    
   Initial = datetime(InitialTime, 'Format','hh:mm:ss a');
   InitialStr = cellstr(Initial);
   InitialStr1 = InitialStr{1,1};
   InitialSec = str2double(InitialStr1(end-4:end-3));
   %InitialSecStr = (InitialStr1(end-1:end));
   RoundInitialSec = round(InitialSec/15)*15;
   RISstr = num2str(RoundInitialSec);
    
   if (RoundInitialSec >= 60)
       InitialStr1(end-4:end-3) = '00';
       InitialStr1(end-7:end-6)= num2str((str2double(InitialStr1(end-7:end-6)))+1);
       InitialStr2 = InitialStr1;
       if (str2double(InitialStr2(end-7:end-6)) >= 60)
            InitialStr2(end-7:end-6) = '00';
%             InitialStr2(end-10:end-9) = num2str(mod((str2num(InitialStr2(end-10:end-9))+1),12))
            if (str2double(InitialStr2(end-10:end-9))<12)
                hr = ...
                    num2str((str2double(InitialStr2(end-10:end-9))+1));
                if str2double(hr) == 12
                    if strcmp(InitialStr2(end-1:end),'AM')== 1 
                        InitialStr2(end-1:end)='PM';
                    elseif strcmp(InitialStr2(end-1:end),'PM')== 1
                        InitialStr2(end-1:end)='AM';
                    end 
                end     
                         
            elseif (str2double(InitialStr2(end-10:end-9))==12)
                hr = num2str(1);...num2str(mod(str2num(InitialStr2(end-10:end-9)),12)+1);
%                 InitialStr2(end-10:end-9) = '1';...hr;...num2str(mod(str2num(InitialStr2(end-10:end-9)),12)+1);  
            end
             
            if str2double(hr) < 10
                InitialStr2(end-10) = '0';
                InitialStr2(end-9) = hr;
            else
                InitialStr2(end-10:end-9) = hr;
            end
                     
                     
       end
        InitialStr1 = InitialStr2;
   else
       if (RoundInitialSec < 10)
           InitialStr1(end-3) = RISstr;
           InitialStr1(end-4) = '0';
       else
           InitialStr1(end-4:end-3) = RISstr;
       end
   end
    
   Time = datetime(InitialStr1, 'Format','hh:mm:ss a');
   Time = datetime(Time, 'Format','HH:mm:ss');
   interval = duration(0,0,15);
    
   X1 = 0:1:matrixLength;
   X2 = X1*interval;
   TimeTag_vector_tmp = (X2+ Time)';
    
   cellTimeTag_vector_tmp = cellstr(TimeTag_vector_tmp);
   matTimeTag_vector_tmp = cell2mat(cellTimeTag_vector_tmp);
    
   end_indx = size(matTimeTag_vector_tmp,2);
    
   strTimeTag_vector =  cellstr(matTimeTag_vector_tmp);
     
TimeTag_vector = matTimeTag_vector_tmp(:,[end_indx-7,end_indx-6,end_indx-4,end_indx-3,end_indx-1,end]);
TimeTag_vector = str2num(TimeTag_vector);
  

TT = {TimeTag_vector,strTimeTag_vector}; %store data in TT cell
 
end