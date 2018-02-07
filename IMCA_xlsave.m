%Callback handle: IMCA_xlsave
%Passed Vars: UserData - Structure containing all data
%             hObject - reference to master gui
%Description: performs saving and formatting in Excel
%return: N/A
%Author: Joshua Brock
function IMCA_xlsave(UserData,hObject)





[rname,rpath] = uiputfile(... %get excel save-file name
    {'*.xls','Excel Workbook(*.xls)'},'Save Data');


if (rpath)
    disp('Saving...')
    filename = fullfile(rpath,rname); %get filepath
%---------------Title Declaration------------------
%Worksheet Titles
W_Titles = {'BabyEE Pilot';'Infant Chamber Processed Data'};
%Table Titles
Raw_Data = {'Raw Data'};
Raw_Calc = {'Raw Calculations'};
WVP_Calc = {'WVP Corrected Calculations'};
%Column Titles
Column_Titles = {'Actual Time', 'Time', 'RER','Flow','Delta O2', 'Delta CO2' ...
    'Ves','Raw O2', 'Raw CO2', 'Temp', 'Press', 'RH(%)','RH', 'Haldane',...
    'VO2', 'VCO2','RQ', 'EE', 'Buck Equation', 'Pressure of water vapor x RH',...
    'WVP correction', '%O2 Corrected', '%CO2 COrrected', 'Haldane Corrected', ...
    'VO2 Corrected', 'VCO2 Corrected', 'RQ Corrected', 'EE Corrected'}; 
%Average Titles
A_Titles = {'VO2(L/min)','VCO2(L/min)','RQ','EE'};
A_Name = {'Averages:'};
WVP_Name = {'Average WVP Correction'};
%Sum Titles
S_Titles = {'O2(L)','CO2(L)'};
S_Name = {'Measured Value from Instrument'};


a_titles = {'VO2(L/min)','VCO2(L/min)','RQ','EE','VO2(L/min)','VCO2(L/min)','RQ','EE'};
     
 
%write to excel file
    xlswrite(filename,UserData.rawData,'Sheet1','A2'); %write in Initial Data to Raw Sheet
    xlswrite(filename,UserData.rawData,'Sheet2','A2'); %write in initial Data to Process Sheet
    xlServer = actxserver('excel.application'); %open excel in COM server
    xlServer.DisplayAlerts = 0; %turn off excel warnings
    xlWorkbooks = xlServer.Workbooks; %Get excel workbook data
    xlFile = xlWorkbooks.Open(filename); %Open current excel file
    xlWorksheet = xlFile.Worksheets.Item('Sheet2'); %Get Worksheet data
    xlWorksheet.Range('B16:O16').Insert; %Select Cell range to insert blank cells
    xlFile.Save; %Save Excel File
    xlFile.Close; %Close Excel File
    xlServer.Quit; %Close Com Server
    
%formatting excel file
    xlswrite(filename,W_Titles,'Sheet2','A1'); %write in Titles
    xlswrite(filename,Raw_Data,'Sheet2','B16');%write in Titles
    xlswrite(filename,Raw_Calc,'Sheet2','N16');%write in Titles
    xlswrite(filename,WVP_Calc,'Sheet2','S16');%write in Titles
    xlswrite(filename,Column_Titles,'Sheet2','A17');%write in Titles
    xlswrite(filename,A_Titles,'Sheet2','I8');%write in Titles
    xlswrite(filename,A_Name,'Sheet2','H9');%write in Titles
    xlswrite(filename,S_Titles,'Sheet2','K5');%write in Titles
    xlswrite(filename,S_Name,'Sheet2','H6');%write in Titles
    xlswrite(filename,S_Name,'Sheet2','N6');%write in Titles
    xlswrite(filename,A_Name,'Sheet2','N9');%write in Titles
    xlswrite(filename,A_Titles,'Sheet2','O8');%write in Titles
    xlswrite(filename,S_Titles,'Sheet2','Q5');%write in Titles
    xlswrite(filename,WVP_Name,'Sheet2','K11');%write in Titles
    tmp = {'Raw Calculations'};
    xlswrite(filename,tmp,'Sheet2','H4');%write in Titles
    tmp = {'WVP Calculations'};
    xlswrite(filename,tmp,'Sheet2','N4');%write in Titles
    tmp = {'%O2 corrected','%CO2 corrected'};
    xlswrite(filename,tmp,'Sheet2','H12');%write in Titles
    
    
    xlServer = actxserver('excel.application'); %open excel through COM server
    xlServer.DisplayAlerts = 0; %turn off excel warnings
    xlWorkbooks = xlServer.Workbooks; %get workbook data
    xlFile = xlWorkbooks.Open(filename); %open excel file
    xlWorksheet = xlFile.Worksheets.Item('Sheet2'); %get worksheet data
    xlWorksheet.Range(strcat('A',num2str(length(UserData.rawData(1:end-3,1))))).Insert; %Insert Empty Cells

    
    
    
    
    
    

    
    xlSheetData = xlServer.ActiveWorkbook.Sheets;
%****************************************************************************
    %###################### Cell Formatting ######################         %*
    %Authors: Taylor & Shelby                                              %* 
                                                                           %*
                                                                           %*                            
                                                                           %*
    Range1 = xlServer.Range('B16:M16');                                    %*
    Range1.Select;                                                         %*
    Range1.MergeCells = true;                                              %*
                                                                           %*
    Range2 = xlServer.Range('N16:R16');                                    %*
    Range2.Select;                                                         %*
    Range2.MergeCells = true;                                              %*
                                                                           %*
    Range3 = xlServer.Range('S16:AB16');                                   %*
    Range3.Select;                                                         %*
    Range3.MergeCells = true;                                              %*
                                                                           %*
    xlSheetData.Item(2).Range('F17:F382').Interior.ColorIndex = 15;        %*
    xlSheetData.Item(2).Range('B17,D17,H17:L17').Interior.ColorIndex = 6;  %*
                                                                           %*
                                                                           %*
    xlSheetData.Item(2).Range(strcat('B17:AB', ...                         %*
    num2str(length(UserData.rawData(1:end-3,1))))).Borders.LineStyle = 1;  %*
    %*********Needs to be formatted to correct border***********           %*
                                                                           %*
                                                                           %*
    xlSheetData.Item(2).Range('H5:L6').Borders.ColorIndex = 1;             %*
    xlSheetData.Item(2).Range('N5:R6').Borders.ColorIndex = 1;             %*
    xlSheetData.Item(2).Range('N8:R9').Borders.ColorIndex = 1;             %*
    xlSheetData.Item(2).Range('H8:L9').Borders.ColorIndex = 1;             %*
    xlSheetData.Item(2).Range('B16:M382').Borders.ColorIndex = 1;          %*
    xlSheetData.Item(2).Range('N16:R382').Borders.ColorIndex = 1;          %*
    xlSheetData.Item(2).Range('S16:AB382').Borders.ColorIndex = 1;         %*
                                                                           %*
    xlSheetData.Item(1).Range('B16:O16').Font.Bold = 5;                    %*
    xlSheetData.Item(2).Range('A1:A2').Font.Bold = 1;                      %*
    xlSheetData.Item(2).Range('B16:S16').Font.Bold = 1;                    %*
    xlSheetData.Item(2).Range('A17:AB17').Font.Bold = 5;                   %*
    xlSheetData.Item(2).Range('H4:H9').Font.Bold = 1;                      %*
    xlSheetData.Item(2).Range('I8:R8').Font.Bold = 1;                      %*
    xlSheetData.Item(2).Range('K5:R5').Font.Bold = 1;                      %*
    xlSheetData.Item(2).Range('N6:N9').Font.Bold = 1;                      %*
    xlSheetData.Item(2).Range('N4').Font.Bold = 1;                         %*
    xlSheetData.Item(2).Range('K11').Font.Bold = 1;                        %*              
                                                                           %*
    xlSheetData.Item(2).Range('B17:R17').ColumnWidth = 10;                 %*
    xlSheetData.Item(2).Range('A17').ColumnWidth = 12;                     %*
    xlSheetData.Item(2).Range('O8:P8').ColumnWidth = 12;                   %*
    xlSheetData.Item(2).Range('H12:I12').ColumnWidth = 15;                 %*
    xlSheetData.Item(2).Range('I8:J8').ColumnWidth = 12;                   %*
    xlSheetData.Item(2).Range('S17:AB17').ColumnWidth = 16;                %*
                                                                           %*
    xlSheetData.Item(2).Range('17:17').RowHeight = 30;                     %*
    xlSheetData.Item(2).Range('11:11').RowHeight = 30;                     %*
                                                                           %*
    xlSheetData.Item(2).Range('K11:K11').WrapText = true;                  %*
    xlSheetData.Item(2).Range('T17:T17').WrapText = true;                  %*
                                                                           %*
                                                                           %*
    xlSheetData.Item(1).Name = 'Raw Data';                                 %*
    xlSheetData.Item(2).Name = 'Processed Data';                           %*
%****************************************************************************    
    
    xlFile.Save; %Save excel file
    xlFile.Close; %close excel file
    xlServer.Quit;%quit COM server
    
   %%
   %Access Data and convert to cell format
   VO2 = mat2cell(UserData.calcStruct.Raw_Calcs(:,2),numel(UserData.calcStruct.Raw_Calcs(:,2)),1);
   VCO2 = mat2cell(UserData.calcStruct.Raw_Calcs(:,3),numel(UserData.calcStruct.Raw_Calcs(:,3)),1);
   RQ = mat2cell(UserData.calcStruct.Raw_Calcs(:,4),numel(UserData.calcStruct.Raw_Calcs(:,4)),1);
   EE = mat2cell(UserData.calcStruct.Raw_Calcs(:,5),numel(UserData.calcStruct.Raw_Calcs(:,5)),1);
   Haldane =  mat2cell(UserData.calcStruct.Raw_Calcs(:,1),numel(UserData.calcStruct.Raw_Calcs(:,1)),1);
 
   Buck = mat2cell(UserData.calcStruct.WVP_Corr(:,1),numel(UserData.calcStruct.WVP_Corr(:,1)),1);
   PressRH = mat2cell(UserData.calcStruct.WVP_Corr(:,2),numel(UserData.calcStruct.WVP_Corr(:,2)),1);
   WVP_c = mat2cell(UserData.calcStruct.WVP_Corr(:,3),numel(UserData.calcStruct.WVP_Corr(:,3)),1);
   O2_c = mat2cell(UserData.calcStruct.WVP_Corr(:,4),numel(UserData.calcStruct.WVP_Corr(:,4)),1);
   CO2_c = mat2cell(UserData.calcStruct.WVP_Corr(:,5),numel(UserData.calcStruct.WVP_Corr(:,5)),1);
 
   VO2_c = mat2cell(UserData.calcStruct.WVP_Calcs(:,2),numel(UserData.calcStruct.WVP_Calcs(:,2)),1);
   VCO2_c = mat2cell(UserData.calcStruct.WVP_Calcs(:,3),numel(UserData.calcStruct.WVP_Calcs(:,3)),1);
   RQ_c = mat2cell(UserData.calcStruct.WVP_Calcs(:,4),numel(UserData.calcStruct.WVP_Calcs(:,4)),1);
   EE_c = mat2cell(UserData.calcStruct.WVP_Calcs(:,5),numel(UserData.calcStruct.WVP_Calcs(:,5)),1);
   Haldane_c =  mat2cell(UserData.calcStruct.WVP_Calcs(:,1),numel(UserData.calcStruct.WVP_Calcs(:,1)),1);
   %%
   %%Organize data
   Processed_Data = cell2mat([Buck,PressRH,WVP_c,O2_c,CO2_c]);
   Raw_Calcs = cell2mat([Haldane,VO2,VCO2,RQ,EE]);
   WVP_Calcs = cell2mat([Haldane_c,VO2_c,VCO2_c,RQ_c,EE_c,]);
   TT = UserData.TT{1,2};
   TT = TT(1:end - 1,1);
   tmp = UserData.numData(5,1);
   Time_Correction = ((0.25 * (0:1:(length(TT)-1))) + tmp).';
   %%
  
    %writing calculations
    xlswrite(filename,TT,'Processed Data','A18');%write in Times
    xlswrite(filename,Time_Correction,'Processed Data','B18');%Correct Experiment times
    xlswrite(filename,UserData.calcStruct.RH,'Processed Data','M18');%write in RH
    xlswrite(filename,Raw_Calcs,'Processed Data','N34');    %write in Raw Calculations
    xlswrite(filename,Processed_Data,'Processed Data','S18'); %write in Processed Calculations
    xlswrite(filename,WVP_Calcs,'Processed Data','X34'); %write in WVP_Calculations



    %writing raw sums and averages
    Raw_Averages = {UserData.calcStruct.Avg_Uncorr(1,1),UserData.calcStruct.Avg_Uncorr(1,2),...
                UserData.calcStruct.Avg_Uncorr(1,3),UserData.calcStruct.Avg_Uncorr(1,4)};
    xlswrite(filename,Raw_Averages,'Processed Data','I9');
    
     tmp = {UserData.calcStruct.Sums(1,1),UserData.calcStruct.Sums(1,2)};
     xlswrite(filename,tmp,'Processed Data','K6');
     
     
     %writing wvp sums and averages
     WVP_Averages = {UserData.calcStruct.Avg_Corr(1,2),UserData.calcStruct.Avg_Corr(1,3),...
                     UserData.calcStruct.Avg_Corr(1,4),UserData.calcStruct.Avg_Corr(1,5)};
     xlswrite(filename,WVP_Averages,'Processed Data','O9');
     
     
     tmp = {UserData.calcStruct.Avg_Uncorr(1,3),UserData.calcStruct.Avg_Uncorr(1,4)};
     xlswrite(filename,tmp,'Processed Data','Q6');
     
     xlswrite(filename,UserData.calcStruct.Avg_Corr(1,1),'Processed Data','L11');
     xlswrite(filename,UserData.calcStruct.AmbientO2_c,'Processed Data','H13');
     xlswrite(filename,UserData.calcStruct.AmbientCO2_c,'Processed Data','I13');
     
          %%
     %Graphing RQ vs EE
     set(0,'DefaultFigureVisible','off');
     figure(3);
     yyaxis left;
     xdata = UserData.TT{1,1};
     xlabels = UserData.TT{1,2};
     lenx = length(xdata);
     indecesForGraph = [1:floor(lenx/5):lenx lenx-16];
     tmp = [NaN(16,1);UserData.calcStruct.WVP_Calcs(:,4);NaN(16,1)]; %pad cells
     plot(1:lenx-1,tmp); %Plot RQ
     a = gca;
     title('RQ vs EE');
     ylabel('RQ');
     xlabel('Times');
     yyaxis right;
     tmp = [NaN(16,1);UserData.calcStruct.WVP_Calcs(:,5);NaN(16,1)]; %pad cells
     plot(1:lenx-1,tmp); %Plot EE.
     a.XTick = indecesForGraph;
     a.XTickLabels = xlabels(indecesForGraph);
     ylabel('EE');
     legend('RQ','EE');
     f = gcf;
     Image = getframe(f);
     img = 'graph.png';
     name = char(img);
     imwrite(Image.cdata,name);

     xlServer = actxserver('excel.application'); %Open Excel in COM Server
     xlWorkbooks = xlServer.Workbooks; %Get Workbook data
     xlFile = xlWorkbooks.Open(filename); %Open excel file
     xlSheetData = xlServer.ActiveWorkbook.Sheets; %get sheet data
     lastsheet = xlSheetData.Item(xlSheetData.Count);
     newsheet = xlSheetData.Add([],lastsheet);
     set(newsheet,'Name','RQ vs EE');
     Shapes = newsheet.Shapes;
     Shapes.AddPicture([pwd '\' img],0,1,100,18,700,500);
     
     
     
     xlFile.Save;
     xlFile.Close;
     xlServer.Quit;
     %%
     
      %%
     %Graphing Environmental Parameter     
     figure(4);
     yyaxis left;
     xdata = UserData.TT{1,1};
     xlabels = UserData.TT{1,2};
     lenx = length(xdata);
     indecesForGraph = [1:floor(lenx/5):lenx lenx-16];
     tmp = UserData.numData(5:end-4,9); %Get Tempurature
     plot(1:lenx-1,tmp); %Plot temperature vs time
     a = gca;
     title('Environmental Parameters');
     ylabel('Temperature');
     xlabel('Times');
     yyaxis right;
     tmp = UserData.numData(5:end-4,10); %Get Pressure
     plot(1:lenx-1,tmp); %Plot Pressure vs time
     a.XTick = indecesForGraph;
     a.XTickLabels = xlabels(indecesForGraph);
     ylabel('Pressure');
     legend('Temperature','Pressure');
     f = gcf;
     Image = getframe(f);
     img = 'graph.png';
     name = char(img);
     imwrite(Image.cdata,name);
     
     
     xlServer = actxserver('excel.application'); %Open Excel in COM Server
     xlWorkbooks = xlServer.Workbooks; %Get Workbook data
     xlFile = xlWorkbooks.Open(filename); %Open excel file
     xlSheetData = xlServer.ActiveWorkbook.Sheets; %get sheet data
     lastsheet = xlSheetData.Item(xlSheetData.Count);
     newsheet = xlSheetData.Add([],lastsheet);
     set(newsheet,'Name','Environmental Parameters');
     Shapes = newsheet.Shapes;
     Shapes.AddPicture([pwd '\' img],0,1,100,18,700,500);
     
     
     
     xlFile.Save;
     xlFile.Close;
     xlServer.Quit;
     %%
     
           %%
     %Graphing VO2_VCO2(Corrected) vs RQ    
     figure(5);
     yyaxis left;
     xdata = UserData.TT{1,1};
     xlabels = UserData.TT{1,2};
     lenx = length(xdata);
     indecesForGraph = [1:floor(lenx/5):lenx lenx-16];
     tmp = [NaN(16,1);UserData.calcStruct.WVP_Calcs(:,2);NaN(16,1)]; %VO2_c
     plot(1:lenx-1,tmp); %Plot VO2_c
     hold on;
     tmp =[NaN(16,1);UserData.calcStruct.WVP_Calcs(:,3);NaN(16,1)]; %VCO2_c
     plot(1:lenx-1,tmp,'k')
     a = gca;
     hold off;
     title('VO2 & VCO2 vs RQ');
     ylabel('VO2 & VCO2(L/min)');
     xlabel('Times');
     yyaxis right;
     tmp = [NaN(16,1);UserData.calcStruct.WVP_Calcs(:,4);NaN(16,1)]; %RQ and Pad
     plot(1:lenx-1,tmp); %Plot EE.
     a.XTick = indecesForGraph;
     a.XTickLabels = xlabels(indecesForGraph);
     ylabel('RQ');
     legend('VO2','VCO2','RQ');
     f = gcf;
     Image = getframe(f);
     img = 'graph.png';
     name = char(img);
     imwrite(Image.cdata,name);
     
     
     
     xlServer = actxserver('excel.application'); %Open Excel in COM Server
     xlWorkbooks = xlServer.Workbooks; %Get Workbook data
     xlFile = xlWorkbooks.Open(filename); %Open excel file
     xlSheetData = xlServer.ActiveWorkbook.Sheets; %get sheet data
     lastsheet = xlSheetData.Item(xlSheetData.Count);
     newsheet = xlSheetData.Add([],lastsheet);
     set(newsheet,'Name','VO2 & VCO2 vs RQ');
     Shapes = newsheet.Shapes;
     Shapes.AddPicture([pwd '\' img],0,1,100,18,700,500);
     
     
     xlFile.Save;
     xlFile.Close;
     xlServer.Quit;
    
     
     
     %%
     ActNum = size(UserData.Activity,1); %Get number of activities
     SheetName = 'Void';
     Hits = 0;
     for i = 1:ActNum
         data =  UserData.TotMatrix(UserData.S_TT(i,1):UserData.S_TT(i,2),:); %get Matrix of Activity Data
         data = Average_Calculations(data);
         ActivityName = UserData.Activity(i,3);
         ActivityName = ActivityName{1,1};

         
         %Determining Worksheet
         if((strcmp(SheetName,ActivityName)))
             xlswrite(filename,data,SheetName,strcat('A',num2str(Hits+4)));
             Hits = Hits + 1;
         else
             SheetName = ActivityName;
             xlswrite(filename,UserData.Activity(i,3),SheetName,'A1')
             xlswrite(filename,a_titles,SheetName,'A3')
             xlswrite(filename,data,SheetName,'A4');
             Hits = 1;
         end
             
     end
     
     
 
   
 %%SAVE USER SELECTED GRAPHS  
     
fig_dat = SaveGraph(hObject);

[rows,~] = size(fig_dat);
for i = 1:rows
cur_act_dat = fig_dat{i,1};
cur_act = fig_dat{i,2};
[~,cols] = size(cur_act_dat);
if(cols)  
figure('Position',[1000,1000,1000,1000])
for k = 1:cols
Graph = cur_act_dat{1,k};
LHS = Graph{1,1};
RHS = Graph{1,2};
LHS_N = Graph{1,3};
RHS_N = Graph{1,4};



LHS_H = LHS{1,1};
LHS_I = LHS{1,2};
LHS_Is = LHS_I(1,1);
LHS_Ie = LHS_I(1,length(LHS_I));
LHS_L = LHS{1,3};
LHS_H = padarray(LHS_H,[0 LHS_Is-1],0,'pre');
LHS_H = padarray(LHS_H,[0 length(LHS_L)-LHS_Ie],0,'post');
LHS_H(LHS_H==0)=NaN;

X = 1:length(LHS{1,3});
lenx = length(X);
indecesForGraph = [1:floor(lenx/5):lenx lenx];
RHS_H = RHS{1,1};
RHS_I = RHS{1,2};
RHS_Is = RHS_I(1,1);
RHS_Ie = RHS_I(1,length(RHS_I));
RHS_L = RHS{1,3};
RHS_H = padarray(RHS_H,[0 RHS_Is-1],0,'pre');
RHS_H = padarray(RHS_H,[0 length(RHS_L)-RHS_Ie],0,'post');
RHS_H(RHS_H==0)=NaN;


ax = subplot(cols,1,k);

yyaxis(ax,'left');
xlabel('Time');
plot(ax,X,LHS_L,'Color','b', 'LineStyle', '--')
ax.XTick = indecesForGraph;
ax.XTickLabel = RHS{1,5};
ylabel(LHS_N);
hold on
plot(ax,X,LHS_H,'Color','b', 'LineStyle','-','LineWidth', 4);
ax.XTick = indecesForGraph;
ax.XTickLabel = RHS{1,5};
[Limrows,~] = size(LHS);
if(Limrows == 2)
ax.YLim = [LHS{2,1} LHS{2,2}];
end
delete Limrows;
hold off
yyaxis(ax,'right')
plot(ax,X,RHS_L,'Color','r', 'LineStyle', '--');
ax.XTick = indecesForGraph;
ax.XTickLabel = RHS{1,5};
hold on
plot(ax,X,RHS_H,'Color','r', 'LineStyle','-','LineWidth', 4);
ax.XTick = indecesForGraph;
ax.XTickLabel = RHS{1,5};
[Limrows,~] = size(RHS);
if(Limrows == 2)
ax.YLim = [RHS{2,1} RHS{2,2}];
end
delete Limrows;
ylabel(RHS_N);
hold off
h = gcf;
r = groot; 
h.Units = 'pixels';
h.Position = r.ScreenSize;
h.Units = 'normalized';
end


     xlServer = actxserver('excel.application'); %Open Excel in COM Server
     xlFile = xlServer.Workbooks.Open(filename); %Open excel file
     xlSheetData = xlServer.ActiveWorkbook.Sheets; %get sheet data
     SheetCount = xlSheetData.Count;
     for j = 1:SheetCount
         if(strcmp(cur_act, xlSheetData.Item(j).Name))            
             Image = getframe(h);
             img = 'graph.png';
             name = char(img);
             imwrite(Image.cdata,name);
             Shapes = xlSheetData.Item(j).Shapes;
             Shapes.AddPicture([pwd '\' img],0,1,100,100,1000,800);
         end
     end
     xlFile.Save;
     xlFile.Close;
     xlServer.Quit;
             
end             
end
%%
     delete graph.png
     set(0,'DefaultFigureVisible','on');
     disp('Save Completed');
     uiwait(msgbox('Save Completed','Save Completed','modal'));
else
     disp('Save Canceled');
end



%Callback handle: Average_Calculations
%Description: wrapper function forr IMCA_Average,
%Passed Vars: Vector - Matrix averages are gotten from
%return: rtrn - matrix of the calculated averages
%Author: Joshua Brock
function [rtrn]=Average_Calculations(TotMat)
    A_VO2 = IMCA_Average(TotMat(:,2));
    A_VCO2 = IMCA_Average(TotMat(:,3));
    A_RQ = IMCA_Average(TotMat(:,4));
    A_EE = IMCA_Average(TotMat(:,5));
    A_VO2_c = IMCA_Average(TotMat(:,12));
    A_VCO2_c = IMCA_Average(TotMat(:,13));
    A_RQ_c = IMCA_Average(TotMat(:,14));
    A_EE_c = IMCA_Average(TotMat(:,15));
    rtrn = [A_VO2,A_VCO2,A_RQ,A_EE,A_VO2_c,A_VCO2_c,A_RQ_c,A_EE_c];


%Callback handle: IMCA_Average
%Description: performs mean calculations by throwing out all 0 values
%Passed Vars: Vector - Vector to be averaged
%return: rtrn - Average value without 0's
%Author: Joshua Brock
function [rtrn]=IMCA_Average(Vector)
rtrn = (sum(Vector)/(length(find(Vector))));

