%Main Author:LSU 2017 Math Consultation Clinic
 
 
function IMCA_GUI(varargin)
% IMCA_GUI MATLAB code for IMCA_GUI.fig
%      IMCA_GUI, by itself, creates a new IMCA_GUI or raises the existing
%      singleton*.
%
%      H = IMCA_GUI returns the handle to a new IMCA_GUI or the handle to
%      the existing singleton*.
%
%      IMCA_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMCA_GUI.M with the given input arguments.
%
%      IMCA_GUI('Property','Value',...) creates a new IMCA_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IMCA_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IMCA_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
 
% Edit the above text to modify the response to help IMCA_GUI
 
 
 
%   ##################################################
%   #    GUI Generation and Fig Declarations         #
%   ##################################################
fig = figure(...
    'Tag',             'fig',...
    'Name',            'IMCA_GUI',...
    'NumberTitle',     'off',...
    'Visible',         'on',... 
    'MenuBar',         'none',...
    'Units',           'normalized',...
    'Position',        [.15 .15 .75 .75],...
    'UserData',        struct(... % use for passing params
                            'txtData',[],...%string data from excel
                            'numData',[],...%numeric data from excel
                            'rawData',[],...%combination of num and txt data 
                            'Activity',[],...%start time, end time, and activity type
                            'S_TT',[],...%Time tag index
                            'Stat_Per_Act',[],...%sv stats
                            'Selected_Act',[],...%index of selected row in tab 1
                            'TT',{},...%cell containing time tag vectors in strings and num 
                            'Plotted', {},... %1x2 cell of plotted data
                            'TableVect',[],...%vector containing 0/1's for tab 3 graph saving
                            'TotMatrix',[],...%Combined Matrix Holding all Data
                            'GraphCell',{},...%Contains the graphs in a cell format
                            'OutAxes',{},...
                            'tmp',[],...
                            'calcStruct', struct(...
                            'Raw_Calcs',[],'WVP_Corr',[],'WVP_Calcs',[],...
                            'Avg_Uncorr',[],'Avg_Corr',[],'Sums',[],...
                            'AmbientO2_c',[],'AmbientCO2_c',[],'RH',[]...
                             )));
                             %Raw_Calcs = [Haldane,VO2,VCO2,RQ,EE]
                             %WVP_Corr = [Buck,PressRH,WVP_c,O2_c,CO2_c]%has 32 more lines of data than  Raw Calcs and Wvp Calcs
                             %WVP_Calcs = [Haldane_c,VO2_c,VCO2_c,RQ_c,EE_c]
                             %Avg_Uncorr = [A_VO2,A_VCO2,A_RQ,A_EE] only using raw calcs
                             %Avg_Corr =
                             %[A_WVP_c,A_VO2_c,A_VCO2_c,A_RQ_c,A_EE_c] only using wvpcalcs
                             %Sums = [S_VO2,S_VCO2,S_VO2_c,S_VCO2_c] 
                             %A:=average, c:=corrected, S:=Sum
 
                             
     
 
 
%   ##################################################
%   #             Toolbar Generation                 #
%   ##################################################
 
 
% add toolbar
tb = uitoolbar('Parent',fig);
 
% get open icon
path = strrep(mfilename('fullpath'),strcat('\',mfilename),'');
[img_open,~,~] = imread(fullfile(path,...
    'IMCA_GUI',...Comment Line IMCA_GUI if running in Matlab, uncomment for standalone
    'file_open.png'));

% get save icon
[img_save,~,~] = imread(fullfile(path,...
    'IMCA_GUI',...Comment Line IMCA_GUI if running in Matlab, uncomment for standalone
    'file_save.png'));


 
% [openBtn] - open button
uipushtool(...
    'Parent',          tb,...
    'Tag',             'openBtn',...
    'CData',           double(img_open)/256/256,...
    'TooltipString',   'Open File',...
    'ClickedCallback', @Open_Button_Callback);
 
% [saveBtn] - save button
uipushtool(...
    'Parent',          tb,...
    'Tag',             'saveBtn',...
    'CData',           double(img_save)/256/256,...
    'TooltipString',   'Save File',...
    'ClickedCallback', @Save_Button_Callback);
 
%   #################################################
%   #               Tab Generation                  #
%   #################################################
  
% create tab group
tgroup = uitabgroup('Parent',fig);
  
% Tabs
  
% Tab One this is the tab for selecting basic yes/no information
tab1 = uitab(...
    'Parent',          tgroup,...
    'Tag',             'tab1',...
    'Title',           'Activity and Behaviour');
  
%Tab Two
tab2 = uitab(...
    'Parent',          tgroup,...
    'Tag',             'tab2',...
    'Title',           'Single Variable Statistics');
  
%Tab Three
tab3 = uitab(...
    'Parent',          tgroup,...
    'Tag',             'tab3',...
    'Title',           'Graph');
 
%Tab Four
tab4 = uitab(...
    'Parent',          tgroup,...
    'Tag',             'tab4',...
    'Title',           'Table');
 
%%%%%%%%%%%%%%%%%% TAB 1 %%%%%%%%%%%%%%%%%%%%
%@Author: Logan Hart
  
%===================Raw Panel=================
  
% [tab1] - tab 1 panel to contain parameters
uipanel(...
    'Parent',          tab1,...
    'Tag',             'tab1Pan',...
    'Title',           'Activity Times',...
    'FontSize',        14,...
    'FontWeight',      'bold',...
    'Units',           'normalized',...
    'Position',        [.05 .15 .9 .8]); %The origin is the bottom left [left bottom width height]
  
%==================Labels=================
 
%%% Text Labels
 
% [StartTxt] - Start Time Text
uicontrol(...
    'Parent',          tab1,...
    'Tag',             'StartTime',...
    'Style',           'text',...
    'String',          'Start :',...
    'FontSize',        15,...
    'Units',           'normalized',...
    'Position',        [.5 .5 .25 .09]);
 
% [EndTxt] - End Time Text
uicontrol(...
    'Parent',          tab1,...
    'Tag',             'EndTime',...
    'Style',           'text',...
    'String',          'End :',...
    'FontSize',        15,...
    'Units',           'normalized',...
    'Position',        [.5 .4 .25 .09]);
 
% [PortholesTxt] - Number of Open Portholes intervals
uicontrol(...
    'Parent',          tab1,...
    'Tag',             'PortholesTxt',...
    'Style',           'text',...
    'String',          'Portholes Open: ',...
    'FontSize',        15,...
    'Units',           'normalized',...
    'HorizontalAlignment',      'left',...
    'Position',        [.088 .75 .2 .1]);
 
% [CryingTxt] - Number of Crying intervals
uicontrol(...
    'Parent',          tab1,...
    'Tag',             'CryingTxt',...
    'Style',           'text',...
    'String',          'Crying: ',...
    'FontSize',        15,...
    'Units',           'normalized',...
    'HorizontalAlignment',      'left',...
    'Position',        [.255 .75 .2 .1]);
 
% [FeedingTxt] - Number of Feeding intervals
uicontrol(...
    'Parent',          tab1,...
    'Tag',             'FeedingTxt',...
    'Style',           'text',...
    'String',          'Feeding: ',...
    'FontSize',        15,...
    'Units',           'normalized',...
    'HorizontalAlignment',      'left',...
    'Position',        [.40 .75 .2 .1]);
 
% [SleepingTxt] - Number of Sleeping intervals
uicontrol(...
    'Parent',          tab1,...
    'Tag',             'SleepingTxt',...
    'Style',           'text',...
    'String',          'Sleeping: ',...
    'FontSize',        15,...
    'Units',           'normalized',...
    'HorizontalAlignment',      'left',...
    'Position',        [.55 .75 .2 .1]);
 
% [AwakeTxt] - Number of Sleeping intervals
uicontrol(...
    'Parent',          tab1,...
    'Tag',             'AwakeTxt',...
    'Style',           'text',...
    'String',          'Awake and Calm: ',...
    'FontSize',        15,...
    'Units',           'normalized',...
    'HorizontalAlignment',      'left',...
    'Position',        [.68 .75 .2 .1]);
 
%%% Edit Text
 
% [Start Time] - Start Time edit text
uicontrol(...
    'Parent',          tab1,...
    'Tag',             'StartEditTxt',...
    'Style',           'edit',...
    'Units',           'normalized',...
    'Position',        [.65 .55 .2 .05]);
 
% [End Time] - End Time edit text
uicontrol(...
    'Parent',          tab1,...
    'Tag',             'EndEditTxt',...
    'Style',           'edit',...
    'Units',           'normalized',...
    'Position',        [.65 .45 .2 .05]);
 
% [PortholesEditTxt] - # of Portholes Intervals edit text
uicontrol(...
    'Parent',          tab1,...
    'Tag',             'PortholesEditTxt',...
    'Style',           'edit',...
    'Units',           'normalized',...
    'Position',        [.1 .75 .05 .05]);
 
% [CryingEditTxt] - # of Crying Intervals edit text
uicontrol(...
    'Parent',          tab1,...
    'Tag',             'CryingEditTxt',...
    'Style',           'edit',...
    'Units',           'normalized',...
    'Position',        [.25 .75 .05 .05]);
 
% [FeedingEditTxt] - # of Feeding Intervals edit text
uicontrol(...
    'Parent',          tab1,...
    'Tag',             'FeedingEditTxt',...
    'Style',           'edit',...
    'Units',           'normalized',...
    'Position',        [.40 .75 .05 .05]);
 
% [SleepingEditTxt] - # of Sleeping Intervals edit text
uicontrol(...
    'Parent',          tab1,...
    'Tag',             'SleepingEditTxt',...
    'Style',           'edit',...
    'Units',           'normalized',...
    'Position',        [.55 .75 .05 .05]);
 
% [AwakeEditTxt] - # of Awake Intervals edit text
uicontrol(...
    'Parent',          tab1,...
    'Tag',             'AwakeEditTxt',...
    'Style',           'edit',...
    'Units',           'normalized',...
    'Position',        [.7 .75 .05 .05]);
 
 
%%%Button
 
% [NextButton] - Label Button
uicontrol(...
    'Parent',          tab1,...
    'Tag',             'Label',...
    'Style',           'pushbutton',...
    'String',          'Next',...
    'FontSize',        15,...
    'Units',           'normalized',...
    'Position',        [.65 .35 .2 .05],...
    'Callback',         @next_button_Callback);
 
% [SubmitButton] - Submit Button
uicontrol(...
    'Parent',          tab1,...
    'Tag',             'Submit',...
    'Style',           'pushbutton',...
    'String',          'Submit',...
    'FontSize',        15,...
    'Units',           'normalized',...
    'Position',        [.80 .75 .10 .05],...
    'Callback',         @submit_button_Callback);
 
%%Table
% define/format column headers
ActivityTblHeaders = {... % is font size relative in this context?
    '<html><center><font size=+2><b>View<br />&nbsp;',...
    '<html><center><font size=+2><b>Start<br />&nbsp;',...
    '<html><center><font size=+2><b>End<br />&nbsp;',...
    '<html><center><font size=+2><b>Activity<br />&nbsp;',...
};
 
% [ActivityTbl] - Time/Activity table
uitable(...
    'Parent',          tab1,...
    'Tag',             'ActivityTbl',... 
    'RowName',         {},...
    'ColumnName',      ActivityTblHeaders,...
    'FontSize',        11,...
    'ColumnFormat',    {'logical','bank','bank','bank'},...
    'ColumnEditable',  [true false false false],...
    'ColumnWidth',     {100 100 100 200},...
    'Units',           'normalized',...
    'Position',        [.1 .22 .4 .5],...
    'CellEditCallback',@cellEditCallback,...
    'Data',            []);
 
%%  %%%%%%%%%%%%%%%% TAB 2 %%%%%%%%%%%%%%%%%%%%
%@Author: Tom Ayton
AmbPan = uipanel(...
    'Parent',       tab2,...
    'Tag',          'AmbPan',...
    'Title',        'Ambient Measurements',...
    'FontSize',     14,...
    'FontWeight',   'bold',...
    'Position',     [.52 .55 .43 .4]);
 
StatsPan = uipanel(...
    'Parent',       tab2,...
    'Tag',          'StatsPan',...
    'Title',        'Statistics',...
    'FontSize',     14,...
    'FontWeight',   'bold',...
    'Position',     [.05 .1 .9 .4]);
 
CaliPan = uipanel(...
    'Parent',       tab2,...
    'Tag',          'CaliPan',...
    'Title',        'Calibrations',...
    'FontSize',     14,...
    'FontWeight',   'bold',...
    'Position',     [.05 .55 .43 .4]);
 
uitable(...
    'Parent',       StatsPan,...
    'Tag',          'StatsTable',...
    'Units',        'normalized',...
    'ColumnName',   {'VO2','VCO2','RQ','EE'},...
    'ColumnWidth',  {100 100 100 100},...
    'FontSize',      11,...
    'RowName',      {'Overall Raw','Overall WVP','***Selected*** Raw','***Selected*** WVP'},...
    'Data',         '',...
    'Position',     [.05 .3 .9 .6]);
 
uitable(...
    'Parent',       CaliPan,...
    'Tag',          'CalibrationTable',...
    'Units',        'normalized',...
    'ColumnName',   {'Calibrated','Target'},...
    'ColumnWidth',  {100 100},...
    'FontSize',      11,...
    'RowName',      {'Percent O2 Gas 1','Percent CO2 Gas 1','Percent O2 Gas 2','Percent CO2 Gas 2'},...
    'Data',         '',...
    'Position',     [.05 .15 .9 .8]);
 
uitable(...
    'Parent',       AmbPan,...
    'Tag',          'AmbientMeasurementsTable',...
    'Units',        'normalized',...
    'ColumnWidth',  {120 120},...
    'FontSize',      11,...
    'RowName',      {'Time','Percent O2','Percent CO2','Ves', 'Raw Percent O2','Raw Percent CO2'},...
    'Data',         '',...
    'ColumnName',   {'Before','After'},...
    'Position',     [.05 .15 .9 .8]);
 
 
%% %%%%%%%%%%%%%%% TAB 3 UIOBJECTS %%%%%%%%%%%%%%%%%%%%
%@Author: Sonia, Kyle
tab3Panel = uipanel(... 
    'Parent',          tab3,...
    'Tag',             'tab3Pan',...
    'Title',           'Graph',...
    'FontSize',         14,...
    'FontWeight',      'bold',...
    'Units',           'normalized',...
    'Position',        [.05 .05 .9 .9]);
%LHS DROP DOWN
uicontrol(...guid
    'Parent',          tab3Panel,...
    'Tag',             'lhs',...
    'Callback',        @Start_Callback,... 
    'Style',           'popupmenu',...
    'String',          {'Choose Left Side:',...
                        'Ves','Temperature','Pressure','RH(%)',...
                        'VO2-Haldane','VCO2-Haldane','RQ-Haldane','EE-Haldane',...
                        '%O2 Corrected','%CO2 Corrected',...
                        'VO2 Corrected','VCO2 Corrected','RQ Corrected',...
                        'EE Corrected'},...
    'Value',           1,...   
    'Units',           'normalized',...
    'Position',        [0.02 0.90 0.2 0.05]);
 
uicontrol(...
    'Parent',tab3Panel,...
    'Units','normalized',...
    'String','Left YMin:',...
    'Style','edit',...
    'Callback', @AdjustYAxisCallback,...
    'Position',[0.02 0.825 0.08 0.05],...
    'Tag','lmin');
 
uicontrol(...
    'Parent',tab3Panel,...
    'Units','normalized',...
    'String','Left YMax:',...
    'Style','edit',...
    'Callback', @AdjustYAxisCallback,...
    'Position',[0.14 0.825 0.08 0.05],...
    'Tag','lmax');
 
%RHS DROP DOWN
uicontrol(...
    'Parent',          tab3Panel,...
    'Tag',             'rhs',...
    'Callback',        @Start_Callback,... 
    'Style',           'popupmenu',...
    'String',          {'Choose Right Side:',...
                        'Ves','Temperature','Pressure','RH(%)',...
                        'VO2-Haldane','VCO2-Haldane','RQ-Haldane','EE-Haldane',...
                        '%O2 Corrected','%CO2 Corrected',...
                        'VO2 Corrected','VCO2 Corrected','RQ Corrected',...
                        'EE Corrected'},...
    'Value',           1,...     
    'Units',           'normalized',...
    'Position',        [0.02 0.75 0.2 0.05]);
 
uicontrol(...
    'Parent',tab3Panel,...
    'Units','normalized',...
    'String','Right YMin:',...
    'Style','edit',...
    'Callback', @AdjustYAxisCallback,...
    'Position',[0.02 0.675 0.08 0.05],...    
    'Tag','rmin');
 
uicontrol(...
    'Parent',tab3Panel,...
    'Units','normalized',...
    'String','Right YMax:',...
    'Style','edit',...
    'Callback', @AdjustYAxisCallback,...
    'Position',[0.14 0.675  0.08 0.05],...
    'Tag','rmax');
 
uicontrol(...
    'Parent',          tab3Panel,...
    'Tag',             'AddGraphTag',...
    'Style',           'pushbutton',...
    'String',          'Add Graph',...
    'FontSize',        10,...
    'Units',           'normalized',...
    'Position',        [.02 0.55 0.2 0.075],...
    'Callback',         @AddGraph_button_Callback);
 
%%Table
% define/format column headers
GraphTblHeaders = {... % is font size relative in this context?
    '<html><center><font size=+1><b>Save<br />&nbsp;',...
    '<html><center><font size=+1><b>Graph<br />&nbsp;',...
    '<html><center><font size=+1><b>Activity<br />&nbsp;',...
};
 
% [GraphTbl] - Graph/Activity table
uitable(...
    'Parent',          tab3Panel,...
    'Tag',             'GraphTbl',... 
    'ColumnName',      GraphTblHeaders,...
    'RowName',         {},...
    'FontSize',        10,...
    'ColumnFormat',    {'logical','bank', 'bank'},...
    'ColumnEditable',  [true false false],...
    'ColumnWidth',     {70 70 70 120},...
    'Units',           'normalized',...
    'Position',        [.02 .05 .2 .5],...
    'CellEditCallback',@cellEditCallback2,...
    'Data',            []);
 
%BEGIN TOP GRAPH OVER ALL TIMES
tab3TopPan = uipanel(... 
    'Parent',          tab3Panel,...
    'Tag',             'toppan',...
    'Title',           'For All Times:',...
    'FontSize',         14,...
    'FontWeight',      'bold',...
    'Units',           'normalized',...
    'Position',        [0.3 0.55 0.65 0.4]);
 
axes(...
    'Parent',           tab3TopPan,...
    'Tag',              'topg',...
    'Position',         [0.1 0.2 0.8 0.7])
xlabel('Time');
%END OF TOP GRAPH PANEL
 
%BEGIN BOTTOM GRAPH OVER SELECTED INTERVALS
tab3BotPan = uipanel(... 
    'Parent',          tab3Panel,...
    'Tag',             'botpan',...
    'Title',           'For Selected Interval:',...
    'FontSize',         14,...
    'FontWeight',      'bold',...
    'Units',           'normalized',...
    'Position',        [0.3 0.05 0.65 0.4]);
 
axes(...
    'Parent',           tab3BotPan,...
    'Tag',              'botg',...
    'Position',         [0.1 0.2 0.8 0.7]);
xlabel('Time');
%END OF BOTTOM GRAPH PANEL
%%
 
%%%%%%%%%%%%%%%%%% TAB 4 %%%%%%%%%%%%%%%%%%%%
%@Author: Matthew Cabrera 
tab4Pan = uipanel(... 
    'Parent',          tab4,...
    'Tag',             'tab4Pan',...
    'Title',           'Data',...
    'FontSize',         24,...
    'FontWeight',      'bold',...
    'Units',           'normalized',...
    'Position',        [.01 .01 .99 .99]);
 
colNames = {'Haldane', 'VO2-Haldane', 'VCO2-Haldane', 'RQ-Haldane', 'EE=Haldane',...
            'Buck Equation' 'Pressure of Water Vapor x RH',...
            'WVP Correction', '%O2 Corrected', '%CO2 Corrected',...
            'Haldane Corrected', 'VO2 Corrected', 'VCO2 Corrected',...
            'RQ Corrected', 'EE Corrected'};
myData = zeros(15);
 
uitable(...
    'Parent',          tab4Pan,...
    'Tag',             'TableTag4',...
    'Units',           'normalized',...
    'Position',        [.01 .01 .99 .99],...
    'ColumnName',      colNames,...        
    'Data',             myData);

 %   ##################################################                           
 %   #                Callbacks                       #                           
 %   ################################################## 

% Toolbar Callbacks
%--------------------------------------------------------------------

%Callback handle: Save_Button_Callback
%Passed Vars: hObject
%Description: saves data to user-defined excel workbook, also formats said
%             workbook
%return: N/A
%Author: Joshua Brock
function Save_Button_Callback(hObject,~)
format long %data output should be as many digits as possible
warning('off','all');%disable all matlab warnings
data = guidata(hObject); %get data stored in gui


% try

IMCA_xlsave(data.UserData,hObject)%Call Save function

%    catch Hands
%            uiwait(msgbox('Unknown Error, Please Try Again','Error','error', 'modal'));
%            disp('Save Aborted');
%            disp(Hands);
%  end
warning('on','all');%enable warnings

    
%Callback handle: Open_Button_Callback
%Passed Vars: hObject
%Description: opens excel raw data file and stores in UserData structure
%return: N/A
%Author: Joshua Brock,Tom Ayton
function Open_Button_Callback(hObject,~)
handles = guihandles; %returns a structure for all child handles of curr fig


 try
%open target raw excel file
disp('Opening...')
[fname,fpath] = uigetfile(...
    {'*.xls;*.xlsx;*.xlsm','Excel File(*.xls;*.xlsx;*.xlsm)'; ...
    '*.*','All Files(*.*)'},'Open Raw Data File');

if (fpath)%without this cancel on diaog box breaks gui
   [num,txt,raw] = xlsread(fullfile(fpath,fname)); %read file
   data = guidata(hObject); %get data stored in gui
   data.UserData.txtData = txt; %stores text data
   data.UserData.numData = num; %stores numeric data
   data.UserData.rawData = raw; %stores both text and numeric data
   [data.UserData.calcStruct,~] = IMCA_Calculations(data.UserData.numData,1);
   
   %time tags
   data.UserData.Plotted = cell(1,2); %initiate new cell for plot data
   initialTime = txt(12,1); %get initial time from txt data
   [TT_length,~] = size(num(5:end-4,1)); %calculate length of TT
   data.UserData.TT = TimeTags(initialTime,TT_length); %calculate time tags
   data.UserData.TableVect = [];
   data.UserData.GraphCell = {};

   %%
   
   VO2_cDat = data.UserData.calcStruct.Avg_Corr(1,2);
   VCO2_cDat = data.UserData.calcStruct.Avg_Corr(1,3);
   RQ_cDat = data.UserData.calcStruct.Avg_Corr(1,4);
   EE_cDat = data.UserData.calcStruct.Avg_Corr(1,5);
   VO2dat = data.UserData.calcStruct.Avg_Uncorr(1,1);
   VCO2dat = data.UserData.calcStruct.Avg_Uncorr(1,2);
   RQdat = data.UserData.calcStruct.Avg_Uncorr(1,3);
   EEdat = data.UserData.calcStruct.Avg_Uncorr(1,4);
   
   data.UserData.AveragesMatrix = [VO2dat VCO2dat RQdat EEdat; VO2_cDat VCO2_cDat RQ_cDat EE_cDat; 0 0 0 0; 0 0 0 0];
   set(handles.StatsTable, 'Data', data.UserData.AveragesMatrix);
   tmpSO1 = transpose(num(1,1:6));
   tmpSO2 = transpose(num(end,1:6));
   set(handles.AmbientMeasurementsTable,'Data',tmpSO1);
   handles.AmbientMeasurementsTable.Data(:,2) = tmpSO2;

   %Need to Redo
   tmpCali = txt(4:7,1);
   calibData = zeros(4,2);
   for i=1:4
       tmp_tmpCali = tmpCali{i,1};
       str_i = strfind(tmp_tmpCali,'= ');
       end_i = strfind(tmp_tmpCali,', ');
       calibData(i,1) = str2double(tmp_tmpCali(str_i(1)+3:end_i-1));
       calibData(i,2) = str2double(tmp_tmpCali(str_i(2)+3:length(tmp_tmpCali)-2));       
   end
   set(handles.CalibrationTable,'Data',calibData);
   
   %create TotMatrix, created by Matthew Cabrera

Raw_Calcs = data.UserData.calcStruct.Raw_Calcs; %              *
WVP_Corr  = data.UserData.calcStruct.WVP_Corr;  %              *
WVP_Calcs = data.UserData.calcStruct.WVP_Calcs; %              *
m         = length(WVP_Corr);                   %              *
                                                %              *
%Just some labels to make the code more readable               *
[r1, c1]  = size(Raw_Calcs);                    %              *
c2        = size(WVP_Corr,2);                   %              *
[r3, c3]  = size(WVP_Calcs);                    %              *
                                                %              *
%The following lines create the matrix consisting of Raw_Calcs *
%WVP_Corr and WVP_Calcs                                        *
data.UserData.TotMatrix(1:16, 1:c1)       = zeros(16, c1);    %              *
data.UserData.TotMatrix(16+1:r1+16, 1:c1) = Raw_Calcs(:, :);  %              *
data.UserData.TotMatrix(r1+16+1:m, 1:c1)  = zeros(16, c1);    %              *
                                                %              *
data.UserData.TotMatrix(1:end, c1+1:c1+c2) = WVP_Corr(:, :);  %              *
                                                %              *
data.UserData.TotMatrix(1:16, c1+c2+1:c1+c2+c3)       = zeros(16, c3);%      *
data.UserData.TotMatrix(16+1:r3+16, c1+c2+1:c1+c2+c3) = WVP_Calcs(:, :);%    *
data.UserData.TotMatrix(r3+16+1:m, c1+c2+1:c1+c2+c3)  = zeros(16, c3);%

data.UserData.OutAxes = cell(1,2);



   guidata(hObject,data); %save data to gui handle

   disp('Open Completed');
   uiwait(msgbox('Open Completed','Open Completed','modal'));
else
    disp('Open Canceled');
end
 catch ME
       if (strcmp (ME.identifier,'MATLAB:badsubscript'))
           uiwait(msgbox('Please Select a Raw Data File','Error','error', 'modal'));
            disp('Open Aborted');
          
       elseif (strcmp(ME.identifier,'MATLAB:COM:E2148140012'));
           uiwait(msgbox('Please enable editing in Excel','Error','error','modal'));
           disp('Open Aborted');
       else
            uiwait(msgbox('Unknown Error, Please Try Again','Error','error', 'modal'));
            disp('Open Aborted');
            disp(ME);
       end
end

 
%%% Tab 1 Callbacks %%% 
function submit_button_Callback(hObject,~)
    % extract guidata
    data = guidata(hObject);
    % get all handles
    handles = guihandles;
     
    PortholesNum = str2double(handles.PortholesEditTxt.String);
    if(isnan(PortholesNum))
        PortholesNum = 0;
    end
    CryingNum =  str2double(handles.CryingEditTxt.String);
    if(isnan(CryingNum))
        CryingNum = 0;
    end
    FeedingNum = str2double(handles.FeedingEditTxt.String);
    if(isnan(FeedingNum))
        FeedingNum = 0;
    end    
    SleepingNum = str2double(handles.SleepingEditTxt.String);
    if(isnan(SleepingNum))
        SleepingNum = 0;
    end
    AwakeNum = str2double(handles.AwakeEditTxt.String);
    if(isnan(AwakeNum))
        AwakeNum = 0;
    end
    
    
    
    NumberofAct = PortholesNum + CryingNum + FeedingNum + SleepingNum + AwakeNum;
     
    %type = {'Portholes 1';'Crying 1'; 'Sleeping 1'; 'Sleep 2'};
    data.UserData.S_TT = zeros(NumberofAct,2);
    L = [1; zeros(NumberofAct-1,1)];
    L = num2cell(logical(L));
     
    time = num2cell(zeros(NumberofAct,2)); %%%%will need to change to cellstr because time is a string
 
    n = 0;
     
    data.UserData.entered_location = n;
     
    PortholesList = repmat('Portholes Open ', PortholesNum, 1);
    PortholesCount = num2str((1:PortholesNum)');
    PortholesList = cellstr([PortholesList PortholesCount]);
     
    CryingList = repmat('Crying ', CryingNum, 1);
    CryingCount = num2str((1:CryingNum)');
    CryingList = cellstr([CryingList CryingCount]);
     
    FeedingList = repmat('Feeding ', FeedingNum, 1);
    FeedingCount = num2str((1:FeedingNum)');
    FeedingList = cellstr([FeedingList FeedingCount]);
     
    SleepingList = repmat('Sleeping ', SleepingNum, 1);
    SleepingCount = num2str((1:SleepingNum)');
    SleepingList = cellstr([SleepingList SleepingCount]);
     
    AwakeList = repmat('Awake and Calm ', AwakeNum, 1);
    AwakeCount = num2str((1:AwakeNum)');
    AwakeList = cellstr([AwakeList AwakeCount]);
     
    Activity_type = [PortholesList; CryingList; FeedingList; SleepingList; AwakeList];
     
    %Gets Rid of Empty Cells
    Check_empty = repmat({''},length(Activity_type),1); 
    emptyIndex = find(strcmp(Activity_type,Check_empty));
    Activity_type(emptyIndex,:) = []; %#ok<FNDSB>
     
    Activity = [time Activity_type];
    data.UserData.Activity = Activity;
    guidata(hObject,data);
     
     
    Table = [L Activity];
    handles.ActivityTbl.Data = Table;
     
function valid = validTime(data, giventime)
try
valid = '';
expr = '(\d{1,2}[:]\d{2})([:]\d{2})?';
[starti, endi] = regexp(giventime, expr);
if (~starti) %start index = 0
    return %time entered not correct format
end
if (endi == 4)
    giventime = ['0' giventime ':00']; %before in hh:mm format
elseif (endi == 5)
    giventime = [giventime ':00']; %before in hh:mm format
elseif (endi == 7)
    giventime = ['0' giventime]; %before in h:mm:ss format
end
 
%check if within timetag vector
TT = data.UserData.TT{1,1}; %double time vec
firstt = TT(1);
endt = TT(end);
 
%remove colons
intgiventime = str2double(strrep(giventime, ':', ''));
 
if (endt < firstt)
    return
elseif ((intgiventime < firstt) || (intgiventime > endt))
    return
end
valid = giventime;
catch
end
   
function next_button_Callback(hObject,~)
    % extract guidata
    data = guidata(hObject);
    % get all handles
    handles = guihandles;
     
    Activity = data.UserData.Activity;
    n = data.UserData.entered_location;
          %error check                                                             
    if (sum(isletter(handles.StartEditTxt.String)) + sum(isletter(handles.EndEditTxt.String))>0)
        uiwait(msgbox('Please Only Enter Times','Error','error','modal'));      
  
       else 
    N = size(Activity,1);
    if (n ~= N)
        n = n+1;
        data.UserData.entered_location = n;
        data.UserData.Selected_Act = n;
         %NEW CODE BELOW
        startt = handles.StartEditTxt.String;
        startt = validTime(data, startt);
        endt = validTime(data, handles.EndEditTxt.String);
        if ((isempty(startt)) || (isempty(endt)))
            uiwait(msgbox('Invalid Time Entered or Data Not Loaded','Invalid Time Entered','modal'));
            data.UserData.entered_location = n-1;
        else
            Activity(n,1) = cellstr(startt);
            Activity(n,2) = cellstr(endt);
            data.UserData.Activity = Activity;        
            L = zeros(N,1);
            L(n) = 1;
            L = num2cell(logical(L));
 
            Table = [L Activity];
            handles.ActivityTbl.Data = Table;
            StartTime = Activity(n,1);
            EndTime = Activity(n,2);
 
            TT = data.UserData.TT{:,1}; %Fetch TT from global
            IndexOfStartTime = time2Index (StartTime,TT);
            IndexOfEndTime = time2Index (EndTime,TT);
            data.UserData.S_TT(n,:) = [IndexOfStartTime IndexOfEndTime];
            guidata(hObject, data);
            updateData(hObject,n);
            guidata(hObject, data);
        end
    end
    end
         
function cellEditCallback(hObject, eventdata)
data = guidata(hObject);
% get all handles
handles = guihandles;
     
n = eventdata.Indices(1,1);
rownum = size(data.UserData.Activity,1);
L = zeros(rownum,1);
L(n) = 1;
L = num2cell(logical(L));
handles.ActivityTbl.Data(:,1)=L;
 
data.UserData.Selected_Act = n;
guidata(hObject, data);
%updates tabs 2 and 4
updateData(hObject,n);
% if isfield(data.UserData,'botPlotL')
%    delete(data.UserData.botPlotL);    
% end 
if isfield(data.UserData,'botPlotLH')
    data.UserData.tmp(1,1) = 1;
    yyaxis(handles.botg,'left')
    delete(handles.botg.Children(1,1));
   delete(data.UserData.botPlotLH);
end
% if isfield(data.UserData,'botPlotR')
%    delete(data.UserData.botPlotR);
% end    
if isfield(data.UserData,'botPlotRH') 
    data.UserData.tmp(1,2) = 1;
    yyaxis(handles.botg,'right')
    delete(handles.botg.Children(1,1));
    delete(data.UserData.botPlotRH);
end
try
if(~isempty(data.UserData.tmp))
    yldata = data.UserData.Plotted{1,1};
    yrdata = data.UserData.Plotted{1,2};
    S_TT = data.UserData.S_TT;
    nrow = data.UserData.Selected_Act;
    starti = S_TT(nrow, 1); %S_TT(N,1) = index in TT of start time
    endi = S_TT(nrow, 2);
    hlydata = yldata(starti:endi);
    hrydata = yrdata(starti:endi);
    hold 'on'
    yyaxis(handles.botg,'left')
    data.UserData.botPlotLH = plot(handles.botg,starti:endi,hlydata,'-', 'LineWidth', 4);
    yyaxis(handles.botg,'right')
    data.UserData.botPlotRH = plot(handles.botg,starti:endi,hrydata,'-', 'LineWidth', 4);
    hold 'off'
end
catch
end
    
    



 
 

 
%%%%%%%%%%%%%%%%%% TAB 3 CALLBACKS %%%%%%%%%%%%%%%%%%%%
function ydata = retrieveYData(data, value)
%% UNCOMMENT THIS SECTION FOR TESTING:
%declares the vars that are created from the 51162017 raw copy file
%     XRaw_Calcs = [0.999871254548690,0.0203424082020360,0.0234328604905656,0.106086174426789,1.15192165341664;0.999876303389918,0.0207165009895721,0.0200550079512320,0.103824569193966,0.968069268132052;0.999890187703295,0.0213769503065755,0.0199322799059117,0.106291662734152,0.932419246901677;0.999892712123909,0.0219028045769914,0.0197833190446898,0.108199303701350,0.903232231066517;0.999896498754829,0.0223774164196621,0.0196144210687501,0.109882947811926,0.876527508846629;0.999907858647592,0.0225285793898855,0.0193436757737204,0.110179236781273,0.858628297814687;0.999905334226978,0.0226060806197451,0.0196202879456032,0.110790602190253,0.867920816334077;0.999910383068206,0.0221726436756298,0.0194400277968170,0.108883059468937,0.876757326785697;0.999921742960969,0.0216407067775919,0.0193433010525092,0.106679716374565,0.893838692576273;0.999928054012503,0.0212162771827461,0.0188702039493803,0.104483793945217,0.889421069815503;0.999915431909434,0.0208252306254579,0.0186920726618671,0.102745666258955,0.897568579097361;0.999933102853731,0.0206421870768553,0.0187595570832680,0.102098929403981,0.908796970661209;0.999934365064038,0.0206482226315375,0.0187446710524979,0.102106251574952,0.907810390608040;0.999943200536187,0.0214085680365847,0.0191960156465767,0.105601959937294,0.896651079781375;0.999945724956801,0.0213791956849962,0.0192008268128401,0.105491524649571,0.898108006294880;0.999950773798029,0.0210876215684719,0.0192874044558271,0.104438185929493,0.914631571569155;0.999955822639257,0.0209102701668204,0.0191366217899329,0.103572478427105,0.915178122389739;0.999960871480484,0.0208022527280218,0.0193147686365970,0.103343812113210,0.928494086151493;0.999957084849564,0.0205316439076175,0.0188050774220068,0.101713624268660,0.915907050922007;0.999953298218642,0.0205239179301329,0.0190049878835081,0.101904277161814,0.925992198380663;0.999964658111405,0.0208710202180383,0.0191812169063585,0.103467116577721,0.919035902700179;0.999965920321712,0.0210079711309680,0.0190458199359984,0.103857091076359,0.906599681485796;0.999973493583554,0.0212551146960318,0.0190172173562803,0.104799449413108,0.894712525819994;0.999965920321712,0.0209802719399848,0.0188730594840507,0.103556855504840,0.899562195286987;0.999977280214475,0.0209288445329378,0.0186480821785434,0.103105355193777,0.891023016067373;0.999981066845396,0.0211970323380132,0.0180263120088153,0.103474605525860,0.850416781055159;1.00000252442061,0.0214593895670748,0.0177902108512536,0.104247427485328,0.829017563414250;1.00002650641645,0.0215665231770954,0.0176468918821014,0.104511130262537,0.818253908485497;1.00001893315460,0.0216241736849788,0.0175124563176624,0.104589645179836,0.809855515072344;1.00002271978553,0.0215570876872512,0.0170322995080258,0.103794205831333,0.790102065507607;1.00001893315460,0.0211454750943562,0.0166815036307921,0.101784060362514,0.788892354338471;1.00001135989276,0.0208684166115256,0.0162519839382135,0.100217124101686,0.778783759244945;1.00000631105154,0.0205265338649351,0.0160977614457130,0.0986991941206680,0.784241584655083;1.00000631105153,0.0205469193270631,0.0160645004412637,0.0987427465559934,0.781844722585956;1.00000504884123,0.0205102662679606,0.0155216623892770,0.0979979179645731,0.756775274708337;1.00002398199583,0.0200162005328268,0.0151351244879339,0.0956232939835253,0.756143727832469;1.00001009768246,0.0199099903872300,0.0149706029138125,0.0950227589387502,0.751914120632344;1.00002903083706,0.0199848651460545,0.0147611675000114,0.0950862047956134,0.738617318262243;1.00003786630921,0.0197040099628251,0.0139244833539288,0.0930539818529389,0.706682719923493;1.00006184830504,0.0194503084728302,0.0138393569110710,0.0919599944350682,0.711523775080635;1.00006058609473,0.0190579573048090,0.0134626727391541,0.0899971257877567,0.706406910448742;1.00007320819780,0.0188174796503654,0.0132878452799759,0.0888560441817433,0.706143730556282;1.00009971461425,0.0183430800357375,0.0131115702194163,0.0867914750835161,0.714796544193847;1.00013000766162,0.0183130573334167,0.0126558186986467,0.0861690944316983,0.691081694783591;1.00014641639561,0.0180001729503198,0.0122076073373869,0.0844402953123602,0.678193891307586;1.00016534955021,0.0176476672783966,0.0117410082136796,0.0825350118284905,0.665300859794222;1.00019311817696,0.0171378654781718,0.0112164001773336,0.0799456664456059,0.654480582288371;1.00019942922850,0.0170966899903478,0.0109014079537728,0.0794350124488334,0.637632662224522;1.00021710017280,0.0167975315894346,0.0106046044122467,0.0779277644739067,0.631319212336939;1.00021205133157,0.0164297354293244,0.0103388248345204,0.0761843275939470,0.629275186992198;1.00021205133157,0.0161283289218329,0.0103284217880471,0.0749849787785236,0.640390076250587;1.00022719785525,0.0159139368698149,0.00989393184217701,0.0736595138213884,0.621714910842930;1.00023729553771,0.0155741689654639,0.00972726916256764,0.0721361595866932,0.624577091987256;1.00023350890679,0.0153199386937380,0.00951882133901328,0.0709036947929701,0.621335471982279;1.00024991764078,0.0149531353500671,0.00936978993119313,0.0692932940785142,0.626610387175494;1.00026001532323,0.0149806201179154,0.00925404112986062,0.0692735933743303,0.617734183032496;1.00025875311293,0.0150182526205756,0.00917569382149444,0.0693352509442612,0.610969468506835;1.00025496648201,0.0143610554535583,0.00926122586506340,0.0668398353492332,0.644884764564344;1.00025622869231,0.0142767348023720,0.00966852442873940,0.0669579998743337,0.677222387512098;1.00024234437894,0.0141814229708331,0.00976352508745981,0.0666874466747840,0.688472878041957;1.00024613100986,0.0134973064513914,0.00956694108967499,0.0637739215701140,0.708803724960159;1.00024486879955,0.0129811086165527,0.00987982151564257,0.0620856316541347,0.761092277052860;1.00022972227587,0.0129732716235857,0.00986910963622594,0.0620428987262172,0.760726355122609;1.00021583796249,0.0124728764257920,0.0100826525010054,0.0603070196601582,0.808366262665439;1.00021583796249,0.0124406268449040,0.00993973289234229,0.0600218549746972,0.798973638246683;1.00021583796249,0.0127203518449033,0.0101491828923423,0.0613559028996946,0.797869667135722;1.00020952691095,0.0124664605280246,0.0103413687356326,0.0605678747625544,0.829535272853528;1.00020321585942,0.0125841669629252,0.0106072338810865,0.0613258026733701,0.842903142682147;1.00019438038727,0.0123906564365987,0.0105120383315006,0.0604578914112753,0.848384295480168;1.00020447806973,0.0124764046471739,0.0106391298500153,0.0609363883286292,0.852740044178134;1.00020195364911,0.0126745293923610,0.0108717379062165,0.0619744624595703,0.857762648983947;1.00020574028003,0.0127832818258285,0.0108197980128329,0.0623456102777834,0.846402211908649;1.00021205133157,0.0127090798594787,0.0107654881010235,0.0619931135659374,0.847070615658649;1.00023350890679,0.0130622343193600,0.0108961436209317,0.0635294002973481,0.834171501944519;1.00021710017280,0.0134327467902165,0.0108366085352952,0.0649237441402797,0.806730648953186;1.00022341122433,0.0137019783251090,0.0108846073275511,0.0660378722835263,0.794382173821204;1.00022846006556,0.0139001952269857,0.0109406438185730,0.0668810214528926,0.787085622893479;1.00021962459341,0.0141123811180808,0.0108292057499120,0.0675939955457592,0.767354967195263;1.00020826470065,0.0142206443240305,0.0108223212996285,0.0680130466383934,0.761028899466996;1.00022467343464,0.0137877123060508,0.0108448054432195,0.0663317290183471,0.786555826122087;1.00020321585942,0.0136997259213596,0.0108605388108881,0.0660023757809202,0.792755918857848;1.00020447806973,0.0134945414800125,0.0106240371565280,0.0649321730678493,0.787284041644823;1.00021205133157,0.0138086460194596,0.0108042684929625,0.0663693949159070,0.782427797608599;1.00020574028003,0.0138246940876190,0.0105215992038646,0.0661200081187806,0.761072840901956;1.00021331354188,0.0134635761654905,0.0104312541660703,0.0645969207758717,0.774775887019337;1.00019942922850,0.0135934783895003,0.0104141626602673,0.0650899622352763,0.766114629520523;1.00021331354188,0.0135227640850514,0.0104248952637540,0.0648231474208994,0.770914525919896;1.00021962459341,0.0133186075027385,0.0101042488918879,0.0636639314427204,0.758656555485272;1.00022341122433,0.0130096522844406,0.0103896291700462,0.0627619695150516,0.798609289694246;1.00020574028003,0.0132411356914993,0.0102546336390053,0.0635249405649386,0.774452726557944;1.00022593564495,0.0127702652060678,0.0102236700159606,0.0616349942147656,0.800584001270614;1.00023603332740,0.0126604492179967,0.0101402156403685,0.0611099088663727,0.800936480670391;1.00024865543047,0.0129281522275047,0.0102305009495394,0.0622647819787866,0.791335124270420;1.00026001532323,0.0132951364548897,0.0101517974328346,0.0636240207294354,0.763572263231717;1.00027137521600,0.0128635852307794,0.0102501029114799,0.0620320032145986,0.796830955568586;1.00025622869231,0.0130801950160019,0.0100753789157929,0.0626924176389303,0.770277423499193;1.00023981995832,0.0129465915455509,0.0101579439978776,0.0622572033426686,0.784603728490098;1.00023603332740,0.0128362912504512,0.0101971541222097,0.0618658762771921,0.794400339105059;1.00022719785525,0.0129367827661790,0.00992606567125038,0.0619620895139143,0.767274665630190;1.00023098448617,0.0127523003511343,0.0100527882956639,0.0613751995388247,0.788311757005450;1.00023603332740,0.0130604129203089,0.00988397694159500,0.0624027658163415,0.756789008272889;1.00023729553771,0.0126625851648030,0.0100350500272353,0.0610020134646109,0.792496152770513;1.00023729553771,0.0129685877951547,0.0102072922490183,0.0623984697281191,0.787078162267746;1.00023098448617,0.0129910106451283,0.0101562004286883,0.0624303306265798,0.781786783655429;1.00024108216863,0.0135751006353068,0.0101534739306838,0.0647292137710805,0.747948335961219;1.00023729553771,0.0133523734671154,0.0102177932508984,0.0639225831693955,0.765241720961672;1.00023350890679,0.0129865976661143,0.0103295817120116,0.0626046987756411,0.795403228588840;1.00020574028003,0.0127483890031407,0.0103364554444274,0.0616735207829143,0.810804835174146;1.00020069143881,0.0123864376594369,0.0103319215462518,0.0602420560459954,0.834131800468085;1.00019438038727,0.0122616912278035,0.0104103620871039,0.0598371855971105,0.849015188337011;1.00020069143881,0.0124139037027285,0.0104182334611264,0.0604457607004589,0.839239107262978;1.00019311817696,0.0129277055553624,0.0103541008324302,0.0623997231143510,0.800923318379212;1.00020574028003,0.0130654999034387,0.0105958092156467,0.0632101001119571,0.810976181084204;1.00020069143881,0.0133002869113874,0.0106707832441014,0.0642183169857537,0.802297222247539;1.00020447806973,0.0131866791669572,0.0105648907513547,0.0636534717679764,0.801179024498290;1.00022088680372,0.0132987250358788,0.0108110770686554,0.0643673266043314,0.812940867601069;1.00020700249034,0.0133935360369026,0.0108954957232276,0.0648343437913230,0.813489110956783;1.00021836238310,0.0132474041066899,0.0108838091955568,0.0642455125547505,0.821580523089841;1.00020195364911,0.0134799335804106,0.0109144217436867,0.0651957686889157,0.809679193044977;1.00021583796249,0.0136984843541218,0.0110141172834918,0.0661673405551359,0.804039118399091;1.00021962459341,0.0138396214257516,0.0109691336789240,0.0666738098877769,0.792589142540675;1.00023603332740,0.0140391857580798,0.0109815501301048,0.0674740255164884,0.782207053837491;1.00024234437894,0.0144206944564745,0.0108590534843631,0.0688420700066716,0.753018761831383;1.00024108216863,0.0143506006024056,0.0110443596303131,0.0687707787252068,0.769609574979164;1.00024613100986,0.0142780959627162,0.0108593125511366,0.0682803758706217,0.760557470652460;1.00024108216863,0.0142946292096354,0.0108472093398312,0.0683321472450265,0.758831109275611;1.00023855774801,0.0146658266646562,0.0111083934023617,0.0700839059884220,0.757433839657489;1.00023477111709,0.0144643185006077,0.0112436559946722,0.0694393627410026,0.777337417881097;1.00024613100986,0.0142337702846111,0.0112182361218235,0.0685026578423891,0.788142276958912;1.00023729553771,0.0144040511549567,0.0115118942584186,0.0694985206514953,0.799212258730225;1.00023603332740,0.0140220976073170,0.0115462866293153,0.0680312796824590,0.823435048925225;1.00022972227587,0.0141600950870957,0.0117592516850811,0.0688106671019437,0.830450050847290;1.00023224669648,0.0143784142291215,0.0119795020475146,0.0699146597415192,0.833158779307649;1.00022972227587,0.0144854210583397,0.0119578291568063,0.0703124034383446,0.825507875031480;1.00022972227587,0.0142071804510416,0.0121406864665773,0.0694180973895894,0.854545805792676;1.00022972227587,0.0144480782862279,0.0121350672197988,0.0703612608711215,0.839908739376511;1.00024234437894,0.0141514070736119,0.0122877121677743,0.0693609049346627,0.868303208568367;1.00023981995832,0.0144001661234668,0.0124141061699819,0.0704810561165827,0.862080760981748;1.00024108216863,0.0142876323964754,0.0126646440196829,0.0703146555602787,0.886406065626882;1.00024234437894,0.0139628702278962,0.0127528548386270,0.0691323290196603,0.913340497367679;1.00021962459341,0.0142586044898613,0.0128773683692533,0.0704355297109374,0.903129642063492;1.00022214901402,0.0147516278715458,0.0130056625746705,0.0725204282493475,0.881642533822108;1.00023224669648,0.0151836257048513,0.0132035030827076,0.0744417433122936,0.869588288025894;1.00023350890679,0.0149562258762232,0.0132498600290018,0.0735968313702716,0.885909328908031;1.00022088680372,0.0153366138483492,0.0132502718060601,0.0750963957938467,0.863963319222929;1.00020700249034,0.0156049622433179,0.0136261049744687,0.0765696283026782,0.873190512223341;1.00020574028003,0.0155742923840357,0.0138535315399433,0.0767002921686620,0.889512743072919;1.00020195364911,0.0156963467161215,0.0140163261708187,0.0773613591531602,0.892967416196456;1.00018302049451,0.0159664663057059,0.0142276871518477,0.0786596657007304,0.891098060111347;1.00019564259758,0.0162730166888577,0.0143906918864579,0.0800480639972105,0.884328466049651;1.00018680712543,0.0162466306286298,0.0143985742088327,0.0799527943823991,0.886249865461921;1.00017418502236,0.0162945530516986,0.0148060103692192,0.0805922810451007,0.908647836012649;1.00018554491512,0.0166340660823355,0.0151056776987697,0.0822617339653236,0.908116970559058;1.00017544723267,0.0168602534002433,0.0153205993978689,0.0833908415844020,0.908681443521351;1.00018806933574,0.0168850969161377,0.0155576575108695,0.0837509361535202,0.921383962919428;1.00016534955021,0.0172005518692929,0.0156847538233934,0.0851347126455565,0.911875034160646;1.00015903849868,0.0174454901014723,0.0158832787833555,0.0863195828242935,0.910451852654746;1.00016534955021,0.0173793059615390,0.0158997984399649,0.0860770218690265,0.914869585422550;1.00017797165328,0.0174403162484743,0.0157453126815936,0.0861466021610798,0.902811190879120;1.00018554491512,0.0178871223882809,0.0157099497831056,0.0878683537923298,0.878282679689062;1.00018806933574,0.0185002719161375,0.0156406565108695,0.0902081377225197,0.845428466228457;1.00021078912126,0.0185249724889426,0.0157203550735648,0.0903936292902856,0.848603423457070;1.00020574028003,0.0187598217413501,0.0159504912533957,0.0915737008089163,0.850247484934137;1.00018680712543,0.0190447584975105,0.0155838407601434,0.0922911211194075,0.818274527460169;1.00019816701819,0.0191448539654883,0.0156518019333799,0.0927607624163077,0.817546164708010;1.00019438038727,0.0192502738986583,0.0158786663463404,0.0934271344136649,0.824854047788230;1.00020574028003,0.0196088852109013,0.0157330458147088,0.0946793652872301,0.802342695441053;1.00021205133157,0.0195756248019636,0.0161281430444740,0.0949852635517269,0.823889056294958;1.00019942922850,0.0198994173148619,0.0162121693940122,0.0963542629876483,0.814705734217862;1.00020321585942,0.0198890949083106,0.0163842968925676,0.0965039553968320,0.823782930701459;1.00019942922850,0.0201204643310876,0.0163807111910242,0.0974118165060889,0.814131867012373;1.00019942922850,0.0203727143051258,0.0166839903158050,0.0987413603657812,0.818938020036304;1.00019438038727,0.0202959779967741,0.0167496975796840,0.0985116148084171,0.825271764797254;1.00019690480789,0.0202711944852039,0.0168702983540083,0.0985473274457217,0.832230106929422;1.00019438038727,0.0202593891644871,0.0169692378944931,0.0986102298085529,0.837598693461039;1.00020195364911,0.0202844153089889,0.0170072708894228,0.0987509223364269,0.838440281879170;1.00021457575218,0.0202298169653576,0.0172794398036840,0.0988367690833490,0.854157001680936;1.00022719785525,0.0203443928886614,0.0172865565087414,0.0992961838728827,0.849696356305416;1.00022214901402,0.0204640076708278,0.0172777410445156,0.0997578358259667,0.844298991792584;1.00022972227587,0.0206349255815351,0.0175909204254166,0.100777799707341,0.852482862412533;1.00024486879955,0.0208533108331517,0.0176148885514376,0.101664964731341,0.844704646296943;1.00026001532323,0.0210969865119560,0.0178731017830374,0.102910874415658,0.847187429963444;1.00023855774801,0.0210061230440652,0.0178184690295982,0.102492357663396,0.848251197625563;1.00024991764078,0.0212930531888360,0.0179466025595542,0.103764865048070,0.842838384913427;1.00024234437894,0.0213473243108520,0.0181273991955208,0.104178708619314,0.849164931939768;1.00024613100986,0.0217110617561253,0.0180469560163923,0.105523227735020,0.831233231203020;1.00024991764078,0.0216557425961049,0.0181147738023719,0.105380221396673,0.836488230407307;1.00024108216863,0.0217033796076860,0.0181889201914994,0.105649964765689,0.838068564448737;1.00023477111709,0.0215794205321938,0.0180799877224494,0.105040962738405,0.837834718289878;1.00023224669648,0.0219423990689319,0.0184728718256256,0.106905990969803,0.841880223196800;1.00023729553771,0.0220628173471810,0.0184986824144316,0.107409105915602,0.838455131243483;1.00023477111709,0.0221430531912780,0.0185114677016949,0.107739455904901,0.835994365446696;1.00022846006556,0.0219743451689175,0.0188258066407017,0.107422236455320,0.856717526551401;1.00022341122433,0.0221113995571406,0.0189307576626396,0.108078443629571,0.856153750635206;1.00022593564495,0.0221994597875093,0.0192668822459455,0.108797242786590,0.867898698002830;1.00021078912126,0.0220671823225074,0.0193584013970851,0.108377157478178,0.877248445867079;1.00020321585942,0.0218276758382272,0.0194424916704912,0.107526266266017,0.890726608484865;1.00020069143881,0.0221404878287046,0.0190042368100512,0.108274348444841,0.858347700244108;1.00022088680372,0.0222767428613987,0.0191840727243806,0.109010228049937,0.861170452239807;1.00022214901402,0.0222443303398871,0.0190960044783651,0.108785086822567,0.858466143353544;1.00022088680372,0.0223583389889962,0.0192187380030066,0.109370138186959,0.859578075655136;1.00021583796249,0.0221810183063427,0.0191353658051494,0.108579107725792,0.862691042443152;1.00023477111709,0.0223247825713123,0.0189997733187813,0.108995717404114,0.851061964795857;1.00023224669648,0.0223318961174732,0.0189316237552397,0.108948378472257,0.847739200274493;1.00023098448617,0.0223906315867832,0.0190467009401561,0.109307130323325,0.850654920846405;1.00023477111709,0.0223812813768763,0.0192163086774813,0.109457867303564,0.858588404921937;1.00022846006556,0.0224274969947139,0.0189234811070878,0.109316135760607,0.843762507762145;1.00024234437894,0.0227217625193740,0.0188759030170739,0.110423214825737,0.830741145233743;1.00026253974385,0.0229752796393422,0.0188982268438961,0.111447015947997,0.822546107840854;1.00025117985108,0.0227217639601176,0.0185821915645791,0.110098375637248,0.817814655464053;1.00024739322016,0.0230779786172737,0.0184356621448329,0.111340156062861,0.798842153837251;1.00024865543047,0.0232436546902533,0.0182922715471227,0.111834495465406,0.786979147250590;1.00025749090262,0.0228188330518345,0.0180767933306410,0.109921954480969,0.792187457157798;1.00025622869231,0.0224439903407963,0.0177486755545104,0.108081801096367,0.790798573917080;1.00026758858508,0.0223270955459156,0.0179703687283357,0.107866311359993,0.804868178728384;1.00027263742630,0.0224301432367855,0.0176183494896739,0.107883089031751,0.785476459230974;1.00026885079538,0.0225566980179147,0.0173646957635154,0.108101300403050,0.769824366568382;1.00027516184692,0.0220463009331854,0.0174140314642296,0.106144390777121,0.789884503391542;1.00026380195415,0.0220167684544687,0.0171284458851174,0.105712145628001,0.777972749295133;1.00027011300569,0.0218293674174872,0.0172203485177271,0.105075242452923,0.788861545476216;1.00026885079538,0.0217846990926284,0.0175984217861159,0.105317353619493,0.807834054135317;1.00026127753354,0.0215499437082946,0.0171296135525168,0.103873680743473,0.794879735389915;1.00025875311293,0.0210952699393651,0.0171215373820181,0.102072879175550,0.811629215043519;1.00026885079538,0.0208224600398447,0.0174993770572482,0.101415626042345,0.840408723261436;1.00026885079538,0.0209857450398456,0.0170957055572482,0.101612671548348,0.814634196917414;1.00028021068814,0.0211712933812941,0.0171093437602381,0.102359001414504,0.808138806264667;1.00029030837060,0.0208637576765563,0.0169522023681400,0.100973204822471,0.812519136338921;1.00030419268398,0.0210088446967283,0.0169283397146584,0.101518600674218,0.805772043109761;1.00030924152520,0.0211640374214293,0.0173261677355076,0.102570212993324,0.818660796638183;1.00029409500152,0.0210679703576512,0.0171702532291896,0.102019171250987,0.814993230847884;1.00030545489428,0.0208462452643849,0.0172893368458633,0.101277059138466,0.829374145156083;1.00028273510876,0.0211486615292500,0.0172591269445202,0.102435469487414,0.816086016632761;1.00030924152520,0.0209043108960493,0.0171217906402398,0.101320589689436,0.819055491729966;1.00032312583858,0.0210750901581612,0.0170084937957397,0.101868324451401,0.807042516454110;1.00031555257674,0.0212532748763953,0.0171446844246877,0.102721177261578,0.806684359205709;1.00032565025919,0.0211013992356604,0.0172328528079440,0.102220149593324,0.816668724926128;1.00030924152520,0.0210818068288673,0.0171180929861939,0.102016011555297,0.811984149420919;1.00029409500152,0.0208589220148000,0.0168143270338089,0.100801657359719,0.806097602832913;1.00030419268398,0.0205877369434236,0.0169408076221340,0.0998728045241128,0.822859145164346;1.00028778394999,0.0203301155211971,0.0169270630010906,0.0988423169482438,0.832610271370158;1.00026885079538,0.0201827693047688,0.0167708534170728,0.0980888577093762,0.830949071647476;1.00028399731907,0.0203861706599521,0.0172102532333095,0.0993764386469114,0.844212163254300;1.00028273510876,0.0200986826759378,0.0171418386539247,0.0981677819771117,0.852883690454344;1.00026632637477,0.0204316262002711,0.0171269037677167,0.0994633944223632,0.838254556922612;1.00028021068814,0.0198565309547873,0.0171487014617683,0.0972210523095324,0.863630283699371;1.00027137521600,0.0200821591861766,0.0174436503118291,0.0984364665976051,0.868614283459930;1.00028021068814,0.0203064514950754,0.0173914793936373,0.0992627015514549,0.856450936189173;1.00027642405722,0.0203503689525837,0.0173869987521158,0.0994308246619722,0.854382482825126;1.00028021068814,0.0195891791917553,0.0173423420666712,0.0963815855204459,0.885302130166347;1.00026885079538,0.0198693981912210,0.0171800268844358,0.0973064080057880,0.864647571058622;1.00027642405722,0.0196968009234463,0.0171890334982051,0.0966361634883169,0.872681485943434;1.00028021068814,0.0196987547581082,0.0171711227887344,0.0966240543060447,0.871685697882329;1.00027263742630,0.0198352554728559,0.0168490911818832,0.0968058366656878,0.849451684902213;1.00028147289845,0.0199255039633812,0.0168202218630679,0.0971295765002382,0.844155404750607;1.00028021068814,0.0201823401396246,0.0166682834862829,0.0979737240260894,0.825884578843144;1.00027516184692,0.0204198955185603,0.0165167891363604,0.0987423770234609,0.808857671252416;1.00027389963661,0.0202222877317774,0.0164584353513312,0.0978990654495069,0.813876034681692;1.00028021068814,0.0201194505614286,0.0165566721157005,0.0976024340225547,0.822918700744328;1.00027516184692,0.0207024557868734,0.0163069730926437,0.0996238904965318,0.787683029516882;1.00028525952937,0.0207622330710526,0.0165022670032982,0.100075467838666,0.794821392613408;1.00030545489428,0.0204403568402648,0.0162498128161837,0.0985277392821826,0.794986748185028;1.00025875311293,0.0202569705518676,0.0162149073770879,0.0977664085039695,0.800460628383196;1.00026253974385,0.0201960151488368,0.0162091465457065,0.0975198117811172,0.802591324390055;1.00025622869231,0.0208365083920290,0.0161629007222052,0.0999928477717454,0.775701015645609;1.00028399731907,0.0206027015751622,0.0162569242289473,0.0991754051049300,0.789067597258506;1.00026253974385,0.0206433136507363,0.0159262362860686,0.0989697164299436,0.771496115184035;1.00027768626753,0.0204116130939197,0.0157340315318058,0.0978440060773147,0.770837241496251;1.00027389963661,0.0202927161063553,0.0158257211237282,0.0974768417379895,0.779872001401126;1.00026253974385,0.0194887536507363,0.0157633982860686,0.0942394966419436,0.808845889715121;1.00027011300569,0.0196390555387991,0.0157179825196810,0.0947816065451746,0.800343096368784;1.00028652173968,0.0200306366802126,0.0158138464996251,0.0964308533853033,0.789482968119876;1.00029661942213,0.0202580407739267,0.0157469786453896,0.0972530970718460,0.777319920574792;1.00030166826336,0.0200109547278988,0.0157318022825357,0.0962625459071335,0.786159505953148;1.00030545489428,0.0200642520052863,0.0156003063929122,0.0963271560233942,0.777517466826174;1.00029409500152,0.0199798782367835,0.0156840640457652,0.0960872749657802,0.784992974426161;1.00032060141797,0.0197520868427259,0.0154981173974107,0.0949838920887190,0.784631898432453;1.00031429036643,0.0206038591948389,0.0153940221938395,0.0982255976332467,0.747142661394987;1.00032438804889,0.0203378802632116,0.0152050470664175,0.0969683681727746,0.747622017124437;1.00032943689012,0.0204774935810238,0.0152118465700849,0.0975261045093288,0.742856859404972;1.00032565025919,0.0200064169562987,0.0153025737008599,0.0957699357379244,0.764883273915880;1.00035468109626,0.0203622465177349,0.0154480555921950,0.0973331630113609,0.758661652521504;1.00033196131073,0.0204154113396348,0.0155772169946078,0.0976855380855368,0.763012644490097;1.00035594330656,0.0206248925128308,0.0153158938688273,0.0982220800119892,0.742592663661120;1.00035720551687,0.0205353321109784,0.0154115771486177,0.0979749481757371,0.750490767099817;1.00034458341380,0.0200678701134849,0.0153062608836520,0.0960162006545632,0.762724733471674;1.00030797931490,0.0197855489675140,0.0153417524156206,0.0949428266526491,0.775401907766638;1.00030797931490,0.0196786109675139,0.0153077214156206,0.0944837457086488,0.777886276673241;1.00031176594582,0.0197976274061259,0.0149782031220015,0.0945883422604759,0.756565562869761;1.00032312583858,0.0197119135334286,0.0149401461508802,0.0942084528781157,0.757924699981249;1.00031302815613,0.0199365902634394,0.0151290053354538,0.0953027821292268,0.758856210392108;1.00032438804889,0.0195278373760353,0.0151611475820468,0.0937274363246989,0.776386411362310;1.00031176594582,0.0198288533275168,0.0149549789793364,0.0946857177148897,0.754202914930190;1.00032943689012,0.0197254190809565,0.0150713175893740,0.0944067538518972,0.764055634383163;1.00033322352104,0.0196788487069596,0.0151547705969283,0.0943155190343306,0.770104533176712;1.00032817467981,0.0196785085021074,0.0151826645703121,0.0943450290215705,0.771535330977249;1.00033069910042,0.0191986771904632,0.0153070978770727,0.0925916370596580,0.797299612114754;1.00031050373551,0.0194661282181842,0.0152248720873235,0.0935547198364437,0.782121227019416;1.00030924152520,0.0195019171845946,0.0153806212042092,0.0938680226763426,0.788672265327793;1.00031050373551,0.0195536031814859,0.0151184593062286,0.0937817661309246,0.773180224938972;1.00032943689012,0.0197254539271208,0.0153183876248679,0.0946801506398872,0.776579726959107;1.00031429036643,0.0202338110572656,0.0154162024606096,0.0967917692981180,0.761903055088274;1.00032312583858,0.0203023139238872,0.0155548309289174,0.0972150621814221,0.766160497135055;1.00032691246950,0.0204628275001769,0.0156639217835032,0.0979683006707517,0.765481788055328;1.00033069910042,0.0207082871369850,0.0156896216776441,0.0989640811823323,0.757649417059822;1.00035468109626,0.0205081135983142,0.0156048773437504,0.0980814700331443,0.760912371044847;1.00035972993748,0.0205812497722345,0.0157139907910689,0.0984903791672984,0.763510037775650;1.00034584562411,0.0206368454552988,0.0156068673171000,0.0985910031920454,0.756262256792389;1.00035215667564,0.0208488397243975,0.0158818309954674,0.0997305824348377,0.761760903983655;1.00036730319932,0.0208486863868730,0.0158463525150803,0.0996907389323453,0.760064793581318;1.00035972993748,0.0208829034787169,0.0157919285230208,0.0997653955560845,0.756213260244935;1.00035972993748,0.0208004645026070,0.0158998707621920,0.0995598876677586,0.764399793100737;1.00035341888595,0.0213213179907070,0.0157787702964137,0.101478634149210,0.740046666124999;1.00035846772718,0.0209086002642612,0.0158016309918019,0.0998773975183862,0.755747911963838;1.00035972993748,0.0211787587483445,0.0153437400518977,0.100435664724624,0.724487220153877;1.00037613867147,0.0211827104611509,0.0159104779386944,0.101078050527592,0.751106803252315;1.00038497414362,0.0211750532603501,0.0154457343765596,0.100533867119515,0.729430721455680;1.00037613867147,0.0211356470900278,0.0157067508556498,0.100667251628148,0.743140287531606;1.00036099214779,0.0210122507476510,0.0158929160813368,0.100386845382451,0.756364288252821;1.00035341888595,0.0211729086115388,0.0159930365455740,0.101130731257479,0.755353779634138;1.00035720551687,0.0209892056594156,0.0160882011632568,0.100512009990319,0.766498810117657;1.00036730319932,0.0209657545619737,0.0160842019613877,0.100415166098033,0.767165422729892;0.627200000000000,0,0,0,0;0.626600000000000,0,0,0,0;0.626300000000000,0,0,0,0;0.626300000000000,0,0,0,0;0.626000000000000,0,0,0,0;0.625800000000000,0,0,0,0;0.625900000000000,0,0,0,0;0.625700000000000,0,0,0,0;0.625300000000000,0,0,0,0;0.624800000000000,0,0,0,0;0.624600000000000,0,0,0,0;0.625000000000000,0,0,0,0;0.625700000000000,0,0,0,0;0.626400000000000,0,0,0,0;0.625800000000000,0,0,0,0;0.625800000000000,0,0,0,0;0.625400000000000,0,0,0,0;0.625100000000000,0,0,0,0;0.625000000000000,0,0,0,0;0.624400000000000,0,0,0,0;0.623900000000000,0,0,0,0;0.623700000000000,0,0,0,0;0.623400000000000,0,0,0,0;0.623100000000000,0,0,0,0;0.622400000000000,0,0,0,0;0.622000000000000,0,0,0,0;0.621700000000000,0,0,0,0;0.621400000000000,0,0,0,0;0.620800000000000,0,0,0,0;0.620400000000000,0,0,0,0;0.619600000000000,0,0,0,0;0.619200000000000,0,0,0,0];
%     XRH = [0.501100000000000;0.512000000000000;0.515200000000000;0.518000000000000;0.519900000000000;0.522000000000000;0.524200000000000;0.526300000000000;0.528500000000000;0.532300000000000;0.536300000000000;0.540100000000000;0.545100000000000;0.548200000000000;0.551600000000000;0.554900000000000;0.558700000000000;0.561100000000000;0.564100000000000;0.567500000000000;0.570700000000000;0.575700000000000;0.580100000000000;0.584300000000000;0.589300000000000;0.592700000000000;0.596700000000000;0.600400000000000;0.604000000000000;0.609100000000000;0.613400000000000;0.617900000000000;0.622300000000000;0.626100000000000;0.629700000000000;0.632900000000000;0.636200000000000;0.639100000000000;0.642900000000000;0.645300000000000;0.648000000000000;0.650800000000000;0.652800000000000;0.656200000000000;0.661000000000000;0.664700000000000;0.667600000000000;0.670800000000000;0.674300000000000;0.678000000000000;0.678400000000000;0.680300000000000;0.681900000000000;0.684400000000000;0.686000000000000;0.687200000000000;0.688200000000000;0.689000000000000;0.689400000000000;0.690000000000000;0.690300000000000;0.690500000000000;0.690700000000000;0.690600000000000;0.690800000000000;0.690900000000000;0.690900000000000;0.691000000000000;0.691000000000000;0.692700000000000;0.690900000000000;0.690100000000000;0.688900000000000;0.687600000000000;0.686600000000000;0.685600000000000;0.684800000000000;0.684200000000000;0.683200000000000;0.683700000000000;0.683200000000000;0.683100000000000;0.681800000000000;0.680900000000000;0.680000000000000;0.679200000000000;0.678100000000000;0.677300000000000;0.675900000000000;0.674700000000000;0.673700000000000;0.672900000000000;0.671800000000000;0.670800000000000;0.669700000000000;0.668700000000000;0.667500000000000;0.666500000000000;0.665500000000000;0.664300000000000;0.663100000000000;0.662200000000000;0.661500000000000;0.660700000000000;0.659900000000000;0.658900000000000;0.658100000000000;0.657000000000000;0.656500000000000;0.655600000000000;0.655100000000000;0.654400000000000;0.653400000000000;0.653200000000000;0.653000000000000;0.652500000000000;0.651900000000000;0.651700000000000;0.651000000000000;0.650400000000000;0.650000000000000;0.649700000000000;0.649400000000000;0.648800000000000;0.648700000000000;0.648300000000000;0.647900000000000;0.647300000000000;0.646900000000000;0.646400000000000;0.645600000000000;0.645100000000000;0.644500000000000;0.644100000000000;0.643400000000000;0.642800000000000;0.642300000000000;0.641600000000000;0.640800000000000;0.640000000000000;0.639300000000000;0.638600000000000;0.638000000000000;0.637400000000000;0.636900000000000;0.636300000000000;0.636000000000000;0.635500000000000;0.634800000000000;0.634400000000000;0.634000000000000;0.633500000000000;0.633100000000000;0.632900000000000;0.632900000000000;0.632400000000000;0.632100000000000;0.631900000000000;0.632500000000000;0.632800000000000;0.632800000000000;0.632800000000000;0.632500000000000;0.632900000000000;0.633100000000000;0.632900000000000;0.633400000000000;0.632800000000000;0.632600000000000;0.632500000000000;0.632700000000000;0.632200000000000;0.632000000000000;0.631600000000000;0.631000000000000;0.630400000000000;0.629900000000000;0.629500000000000;0.629300000000000;0.628600000000000;0.628300000000000;0.627700000000000;0.627100000000000;0.626600000000000;0.626200000000000;0.625600000000000;0.626200000000000;0.626100000000000;0.625500000000000;0.624900000000000;0.624300000000000;0.623600000000000;0.623300000000000;0.623500000000000;0.623800000000000;0.624000000000000;0.624300000000000;0.624800000000000;0.625100000000000;0.625400000000000;0.625600000000000;0.625600000000000;0.625500000000000;0.625900000000000;0.626900000000000;0.627300000000000;0.627600000000000;0.628200000000000;0.629000000000000;0.629700000000000;0.630600000000000;0.631500000000000;0.632500000000000;0.633000000000000;0.633400000000000;0.634100000000000;0.635500000000000;0.635700000000000;0.637500000000000;0.638800000000000;0.638400000000000;0.638500000000000;0.638700000000000;0.639600000000000;0.639800000000000;0.640900000000000;0.641200000000000;0.641500000000000;0.641300000000000;0.641600000000000;0.642200000000000;0.642400000000000;0.643300000000000;0.643600000000000;0.643700000000000;0.644500000000000;0.644800000000000;0.644100000000000;0.643100000000000;0.643100000000000;0.643700000000000;0.643200000000000;0.641800000000000;0.641700000000000;0.641000000000000;0.640200000000000;0.640900000000000;0.640500000000000;0.641100000000000;0.640600000000000;0.640500000000000;0.640600000000000;0.641400000000000;0.641600000000000;0.641800000000000;0.641800000000000;0.642300000000000;0.642600000000000;0.642300000000000;0.642200000000000;0.642700000000000;0.642800000000000;0.643000000000000;0.643100000000000;0.643900000000000;0.644300000000000;0.644400000000000;0.644800000000000;0.645400000000000;0.646000000000000;0.646400000000000;0.646900000000000;0.647200000000000;0.647400000000000;0.646900000000000;0.647400000000000;0.647300000000000;0.647500000000000;0.647600000000000;0.647900000000000;0.647200000000000;0.646600000000000;0.646600000000000;0.646400000000000;0.646300000000000;0.645500000000000;0.645100000000000;0.644600000000000;0.643900000000000;0.644000000000000;0.643500000000000;0.643200000000000;0.642700000000000;0.641400000000000;0.640700000000000;0.639600000000000;0.638600000000000;0.637600000000000;0.636700000000000;0.635800000000000;0.635100000000000;0.634200000000000;0.633400000000000;0.632600000000000;0.631900000000000;0.631200000000000;0.630500000000000;0.629500000000000;0.629100000000000;0.628500000000000;0.628200000000000;0.628200000000000;0.628800000000000;0.628700000000000;0.628900000000000;0.628300000000000;0.627500000000000;0.627100000000000;0.626800000000000;0.626200000000000;0.626100000000000;0.627200000000000;0.626600000000000;0.626300000000000;0.626300000000000;0.626000000000000;0.625800000000000;0.625900000000000;0.625700000000000;0.625300000000000;0.624800000000000;0.624600000000000;0.625000000000000;0.625700000000000;0.626400000000000;0.625800000000000;0.625800000000000;0.625400000000000;0.625100000000000;0.625000000000000;0.624400000000000;0.623900000000000;0.623700000000000;0.623400000000000;0.623100000000000;0.622400000000000;0.622000000000000;0.621700000000000;0.621400000000000;0.620800000000000;0.620400000000000;0.619600000000000;0.619200000000000];
%     XWVP_Calcs = [1.00053072171789,0.0110963929954605,0.0238803272355700,2.15208016202557,0.0701425267176502;1.00050807935883,0.0123251545501423,0.0204523821803254,1.65940168110016,0.0711937687735506;1.00050301846464,0.0126808480435919,0.0203322367655964,1.60338146910222,0.0724626760025455;1.00048153400848,0.0129095631933970,0.0201851806991695,1.56358355405037,0.0732013983984591;1.00046085912072,0.0129224913979662,0.0200178858214555,1.54907325568860,0.0730673203179148;1.00044680900005,0.0124943598063455,0.0197474471709974,1.58050892379203,0.0710809485679307;1.00040412294709,0.0118930578906780,0.0200352233760287,1.68461497120372,0.0690294982010496;1.00037398244756,0.0110032781944394,0.0198561709868700,1.80456865999303,0.0653248444757637;1.00035189300403,0.00985997716547104,0.0197635502259769,2.00442150060828,0.0607166565590518;1.00031821198328,0.00920120648673944,0.0192856227824748,2.09598847827932,0.0575918535616573;1.00027800271890,0.00864845184778051,0.0191069149840269,2.20928731758279,0.0552157967044368;1.00026395538744,0.00807448205248378,0.0191802773434222,2.37541890845150,0.0530349205106636;1.00023263025177,0.00775082013153327,0.0191699733956754,2.47328322298239,0.0517479727139896;1.00021272994547,0.00792261649702320,0.0196348380066838,2.47832745836698,0.0529391624501607;1.00017430434951,0.00745151918073440,0.0196449908061118,2.63637391646298,0.0510937969228339;1.00014192334854,0.00667859669521552,0.0197376509599625,2.95535901637875,0.0481501915375629;1.00011086597807,0.00603562670027170,0.0195889860288287,3.24555957510541,0.0454518233736553;1.00007759650690,0.00530279025805556,0.0197762487930986,3.72940430051070,0.0427708275721641;1.00004309511556,0.00500798954967328,0.0192579486806316,3.84544506125976,0.0410357780560409;1.00000715032660,0.00480528894727694,0.0194646246389816,4.05066684907924,0.0404655185919321;0.999989902419389,0.00505605868610218,0.0196455666569873,3.88554957065431,0.0416539240045567;0.999964551261468,0.00516832032277012,0.0195095334427992,3.77483054926876,0.0419458943797730;0.999945285136706,0.00541610569534849,0.0194816103624229,3.59697750713290,0.0428915336062081;0.999903182438863,0.00531632900987517,0.0193348044825725,3.63687131602610,0.0423359463856432;0.999892271251321,0.00553024982616866,0.0191050187305791,3.45463936189208,0.0429248652809511;0.999870627375329,0.00585576044466380,0.0184719256563299,3.15448793216309,0.0435075016883209;0.999866762311856,0.00643088906205644,0.0182296131175192,2.83469562942357,0.0455060859015407;0.999871945914209,0.00668088699867440,0.0180833927015027,2.70673530402336,0.0463296079896378;0.999833398954346,0.00681029416479356,0.0179467096693425,2.63523266911431,0.0466884301977442;0.999798295995362,0.00698403693208124,0.0174562361471286,2.49944785757693,0.0468306867280564;0.999761115616466,0.00692301280201143,0.0170968873408503,2.46957326669726,0.0461927508517075;0.999726514981370,0.00697741515893080,0.0166570901706505,2.38728666579774,0.0459207348700858;0.999692023080315,0.00697958805972046,0.0164981266950577,2.36376796938334,0.0457534846680921;0.999663518060808,0.00712486355994933,0.0164636896685700,2.31073753624092,0.0462879280631988;0.999628769657879,0.00755363152905859,0.0159068361491575,2.10585280576162,0.0473618226369881;0.999644928642037,0.00744901849164183,0.0155104067902831,2.08220812012839,0.0465110917856136;0.999615197432459,0.00768043156195762,0.0153406840489641,1.99737266392020,0.0472353773438292;0.999621573787089,0.00776720477275594,0.0151271887543363,1.94757177091507,0.0473412247717271;0.999607454020441,0.00818371826648775,0.0142691949803412,1.74360779729838,0.0480337633364856;0.999619004192536,0.00839448757583963,0.0141792388650338,1.68911309200616,0.0487649137211113;0.999611829399144,0.00857033822434984,0.0137914025555297,1.60920166678439,0.0490289941685785;0.999617176859357,0.00886637777445335,0.0136092660182289,1.53492963693034,0.0499942430252818;0.999637851062129,0.00888421432086633,0.0134259786192515,1.51121732708743,0.0498618209914263;0.999669040867710,0.00948757821159141,0.0129569806776689,1.36567840482609,0.0517209663613835;0.999680989175961,0.00999714949395866,0.0124941338705277,1.24976963464215,0.0532172782164947;0.999701342852209,0.0102912257768797,0.0120136671504661,1.16736989460050,0.0538448366550985;0.999728206768908,0.0104615976570521,0.0114737220313665,1.09674663540823,0.0539190929331336;0.999736425057559,0.0109003272406987,0.0111489150264171,1.02280553420363,0.0552888896748108;0.999758737798345,0.0111954783355822,0.0108419232037792,0.968419827969364,0.0561125471839091;0.999755299120288,0.0114073762234986,0.0105665715631449,0.926292896466263,0.0566430978456464;0.999754486710255,0.0113600879983403,0.0105541094565480,0.929051734290262,0.0564429518604012;0.999773393285640,0.0115671221790227,0.0101076919499436,0.873829444654275,0.0567651358041661;0.999786306195760,0.0115628238593041,0.00993529763941143,0.859244918049747,0.0565575280187066;0.999785233863297,0.0116955968966953,0.00971969694550598,0.831056083016371,0.0568423321916057;0.999789999972075,0.0118335501729672,0.00956388252689039,0.808200614954783,0.0572136753064046;0.999817211996375,0.0121643560681305,0.00944380345112576,0.776350461810934,0.0583845738814475;0.999826849940472,0.0126681664645432,0.00936078594714876,0.738921924759083,0.0602782732943114;0.999835477711469,0.0123515786432763,0.00944576608188070,0.764741605480738,0.0591245887197119;0.999847289772508,0.0123929823348486,0.00986033511904624,0.795638600348794,0.0597462740233033;0.999844469379754,0.0125874622641601,0.00995537988791944,0.790896503123198,0.0606178389390939;0.999856438055055,0.0120902912452424,0.00975351774539513,0.806723142358806,0.0584352284239074;0.999864932262099,0.0117438409910654,0.0100717806889414,0.857622365340597,0.0574218667877580;0.999854786014139,0.0119847006061765,0.0100593024055929,0.839345323354070,0.0583572935495273;0.999852476235846,0.0114831098593072,0.0102773844860352,0.895000101188204,0.0566217231970847;0.999848981781575,0.0115598470762907,0.0101307477304263,0.876373853699544,0.0567619643175131;0.999854099680911,0.0120279905037750,0.0103433611768919,0.859940916451970,0.0588420680370199;0.999848433672483,0.0118916569411128,0.0105387101555986,0.886227227020264,0.0585208334370175;0.999852451281528,0.0122269418812634,0.0108088315318128,0.884017576658010,0.0601409456282442;0.999850651950133,0.0121552995141436,0.0107109078130178,0.881171854346730,0.0597502994264375;0.999864975257760,0.0126449380740983,0.0108379844411176,0.857100634072534,0.0618205117418975;0.999868844980590,0.0127556181432658,0.0110761684854039,0.868336474250085,0.0625201334474673;0.999881608436063,0.0128491346326434,0.0110234667195424,0.857915107491921,0.0628303937790616;0.999891255574452,0.0127914114259035,0.0109679564634029,0.857446930460863,0.0625415122780092;0.999924566772109,0.0132041694796165,0.0111011622671533,0.840731579846077,0.0643155173866402;0.999914160042363,0.0135660602848450,0.0110406975488026,0.813847006203891,0.0656748550715499;0.999925443859614,0.0139249404035667,0.0110891582560981,0.796352295573033,0.0671427991617010;0.999937088737360,0.0141595859303090,0.0111462785854614,0.787189585932908,0.0681307122668682;0.999933661619020,0.0144687609797149,0.0110320955826806,0.762476869867953,0.0692228847355014;0.999926312957771,0.0145844515686669,0.0110250613878923,0.755946244257719,0.0696710415271250;0.999952041340458,0.0143592262681261,0.0110467061413958,0.769310681169268,0.0688073677150689;0.999934886168201,0.0144197199627173,0.0110618634394885,0.767134415098862,0.0690625373371430;0.999942123694829,0.0143602213798916,0.0108195866520220,0.753441494096497,0.0685600952952893;0.999958522378735,0.0145970760045252,0.0110041351757186,0.753858866824234,0.0696976500381786;0.999956918838793,0.0147114411790582,0.0107152158563657,0.728359358267279,0.0698288184238088;0.999973883131049,0.0145068718583239,0.0106221776847124,0.732216965066626,0.0689197105129464;0.999966680262498,0.0146384121374787,0.0106047955147208,0.724449852560810,0.0694188860730848;0.999988213937454,0.0146417400639366,0.0106153701598371,0.725007418072073,0.0694436969887542;1.00000036096543,0.0145995940414241,0.0102873632809737,0.704633515958378,0.0689148239060095;1.00001125646243,0.0142220425125485,0.0105789689746490,0.743843155110450,0.0677494092279153;0.999999629616834,0.0145391265924032,0.0104408062077022,0.718117841628642,0.0688462295663797;1.00002843942019,0.0141090344424945,0.0104089176307791,0.737748403209562,0.0671159676375126;1.00004527588156,0.0141157784847182,0.0103231238323645,0.731318066767645,0.0670476579668697;1.00006713095415,0.0144048816310143,0.0104152376492549,0.723035281791585,0.0682888913479034;1.00008601874686,0.0148487313450968,0.0103345630706756,0.695989632413153,0.0699488769871938;1.00010495217239,0.0144514180962889,0.0104346820504316,0.722052464395252,0.0684937970652521;1.00009666081276,0.0147356882388752,0.0102562035433342,0.696011165347310,0.0694167084683348;1.00008447058466,0.0146796517480319,0.0103399678359500,0.704374191801673,0.0692885119655543;1.00009082160628,0.0145430582711221,0.0103802312691029,0.713758487079350,0.0687947284301199;1.00008551896298,0.0147196203555639,0.0101034853715936,0.686395785185763,0.0691844786422598;1.00009101753452,0.0145125364379578,0.0102328298592009,0.705102784957477,0.0685114159262681;1.00010340270229,0.0148744091859038,0.0100605127541850,0.676363856099853,0.0697469737077756;1.00011270820229,0.0143956989802358,0.0102151792944985,0.709599395522455,0.0680314379808245;1.00011432397362,0.0147697118013800,0.0103902920209817,0.703486443114678,0.0696990971844445;1.00011666726506,0.0148573940740852,0.0103379675485962,0.695812973462693,0.0699867821547171;1.00013500892146,0.0154322257175960,0.0103353770311446,0.669726922109497,0.0722493285494920;1.00013435601691,0.0152326550682199,0.0104008501496809,0.682799558126954,0.0715352338894017;1.00013604167917,0.0149113439138847,0.0105146125498792,0.705141844397304,0.0703947678447859;1.00011052165945,0.0146475555227332,0.0105217837988028,0.718330357749651,0.0693631091965674;1.00011281194079,0.0142773566106166,0.0105172883558834,0.736641147428004,0.0678991833240471;1.00010715141296,0.0141489906977287,0.0105973397122566,0.748982025548848,0.0674818300615046;1.00011684108019,0.0142775497644768,0.0106055793850807,0.742815088024966,0.0679975944217024;1.00011543818687,0.0148604334855859,0.0105399041942951,0.709259538392233,0.0702221024055845;1.00013320204027,0.0149211632638295,0.0107869141074392,0.722927154988505,0.0707346314255798;1.00013125024718,0.0152150433198709,0.0108629950494057,0.713964122285382,0.0719769582482537;1.00013915592160,0.0151763341031419,0.0107545759490444,0.708641222310595,0.0717044937001252;1.00016240823663,0.0152914715142320,0.0110056467261066,0.719724502371366,0.0724359345166623;1.00015220947908,0.0154027058632350,0.0110916689689769,0.720111717217935,0.0729694496866975;1.00016867808374,0.0152967803166613,0.0110795451565873,0.724305698795933,0.0725385881711478;1.00015197417142,0.0155483771430395,0.0111106305002174,0.714584576769882,0.0735645116539592;1.00017234586977,0.0157651018684446,0.0112124299323383,0.711218362298125,0.0745312139687062;1.00018105760817,0.0159979197741243,0.0111660247045960,0.697967289638269,0.0753974251531071;1.00020031175717,0.0161997394167874,0.0111787153185120,0.690055255267120,0.0762068321838333;1.00021292298174,0.0166734138972439,0.0110533379289935,0.662931898477046,0.0779349159185050;1.00021857993967,0.0165921559912891,0.0112423395134875,0.677569540654618,0.0778237142635877;1.00022709970548,0.0166611097754628,0.0110528325083947,0.663391134045130,0.0778858663793835;1.00022756839749,0.0167739455349533,0.0110399003326110,0.658157635578714,0.0783162491211186;1.00023011790871,0.0169903606695865,0.0113071722586872,0.665505134268722,0.0794647439169483;1.00022798751417,0.0167671490103066,0.0114451852482749,0.682595785439712,0.0787377091342102;1.00024395671441,0.0165697397445506,0.0114189976821755,0.689147678733512,0.0779307557697601;1.00023793008660,0.0167749680783117,0.0117180470737126,0.698543628757352,0.0790703092601526;1.00024097234731,0.0163372944285154,0.0117535005050006,0.719427599008427,0.0773846489013100;1.00023642421507,0.0164491832474486,0.0119706404313840,0.727734638936603,0.0780657594953057;1.00024304295750,0.0166861197873026,0.0121950725530844,0.730851312859707,0.0792477483254709;1.00024610352788,0.0168660146679419,0.0121725001112444,0.721717628669046,0.0799317489293952;1.00024932981031,0.0165201701263595,0.0123593010501496,0.748134005619541,0.0787753774294483;1.00025562417335,0.0168189623721574,0.0123532740712723,0.734484910420051,0.0799462518314995;1.00027258143643,0.0165646454407661,0.0125085226898177,0.755133741591227,0.0791156937769975;1.00027628175155,0.0167587238077835,0.0126377690363668,0.754100919695166,0.0800235030806965;1.00027918534157,0.0165820784391506,0.0128934658164636,0.777554265213332,0.0796101443217014;1.00028353715328,0.0162562015075725,0.0129833312480984,0.798669433449779,0.0784252545017400;1.00026429427846,0.0165506555052313,0.0131102927246474,0.792131328001091,0.0797261170995764;1.00027234817002,0.0170829045947123,0.0132408517293608,0.775093700017461,0.0819681090204342;1.00028784756405,0.0175433413795613,0.0134423235230723,0.766235076445194,0.0840055181933692;1.00028431704014,0.0173176979571041,0.0134894166677368,0.778938211138116,0.0831683424834640;1.00027253180509,0.0177528105197046,0.0134894877320672,0.759850825709798,0.0848831996898223;1.00026136486658,0.0179921937422296,0.0138726409591215,0.771036659446421,0.0862503764389153;1.00026312236000,0.0179815945632291,0.0141042188380487,0.784369750327409,0.0864647302085675;1.00026115354933,0.0180836234080556,0.0142702351338597,0.789124768408021,0.0870504399091959;1.00024160439610,0.0182704004439620,0.0144861501231562,0.792875348714293,0.0880253301858651;1.00025647287697,0.0186309543340739,0.0146518988545591,0.786427715501530,0.0896295911637275;1.00024902785846,0.0185251954988172,0.0146604337724142,0.791378086852051,0.0892222352131285;1.00023464520539,0.0185887125308165,0.0150753810831947,0.810996515127264,0.0899314875619611;1.00025108448773,0.0188535422280240,0.0153812580093485,0.815828549527723,0.0913134812789822;1.00024184876548,0.0190894900309535,0.0156001693891905,0.817212474712258,0.0924854675564323;1.00025557516258,0.0189435954047385,0.0158429256037980,0.836320944641538,0.0921789852078752;1.00023375136382,0.0192215089506988,0.0159726783162848,0.830979417758148,0.0934177489925151;1.00022825054766,0.0194262439879518,0.0161752227184649,0.832647975002103,0.0944486238831403;1.00023631539850,0.0193357594954640,0.0161921772783387,0.837421321988270,0.0941107762414661;1.00025244481125,0.0195668451627677,0.0160336255068638,0.819428240653378,0.0948461265970587;1.00026500598652,0.0201582458318788,0.0159966494022907,0.793553642301214,0.0971359410623677;1.00027239692814,0.0207700385755361,0.0159261595570346,0.766785266147416,0.0994690544962680;1.00029966547866,0.0207294754882558,0.0160078365258048,0.772225835375043,0.0993995300967561;1.00029467014316,0.0208599528321184,0.0162431179145262,0.778674719221626,0.100173962524845;1.00027688663971,0.0211441400687679,0.0158696040544024,0.750543838755753,0.100880838095183;1.00029110162643,0.0211710906836962,0.0159394068167282,0.752885482135464,0.101064252323748;1.00028660335400,0.0212332792825644,0.0161708361529135,0.761579779445189,0.101565298437709;1.00030304892714,0.0216165970491643,0.0160224270896985,0.741209499962344,0.102911813331963;1.00031179655035,0.0214829267871169,0.0164257021151442,0.764593310674712,0.102831041007377;1.00030134699963,0.0217540765389130,0.0165117461321196,0.759018481091760,0.103994806861980;1.00030541596919,0.0217163537363321,0.0166873039196225,0.768421076679374,0.104040308209987;1.00030284720566,0.0218715357622719,0.0166842397941287,0.762828910391779,0.104648491651420;1.00029499981043,0.0220950607182970,0.0169933541023917,0.769101941789161,0.105871283928054;1.00029063475703,0.0218698795324146,0.0170614396403999,0.780134139061541,0.105059147479528;1.00029502487338,0.0218188575913020,0.0171845120086173,0.787599072806991,0.104994188048852;1.00029424965787,0.0217122441107091,0.0172860214989443,0.796141633762232,0.104686293818137;1.00030381757530,0.0216831735356570,0.0173251899737792,0.799015418351409,0.104615047015024;1.00032238218899,0.0215107649951642,0.0176034447018095,0.818355121529471,0.104243334686143;1.00033470772910,0.0215693644928275,0.0176111454761688,0.816488843796259,0.104482792362876;1.00032792576070,0.0214849682731477,0.0176037843826624,0.819353520045173,0.104142045491700;1.00033024162956,0.0215178396920112,0.0179239382427831,0.832980378110987,0.104625681922734;1.00034364239267,0.0216334115936200,0.0179492150950116,0.829698774848119,0.105109106985539;1.00035673055447,0.0217441906936331,0.0182132824259034,0.837616018113583,0.105837745886657;1.00033122021805,0.0215748366904484,0.0181581356170107,0.841634904474141,0.105109329389471;1.00034043152644,0.0217498489582641,0.0182896286625786,0.840908306888689,0.105944484045331;1.00032976113931,0.0216323108878376,0.0184752836641485,0.854059640689425,0.105686600941516;1.00033103332467,0.0219860570397415,0.0183934144988064,0.836594504669887,0.106990167229301;1.00033342301946,0.0218117707492364,0.0184636443968803,0.846499104045767,0.106380979225690;1.00032518316870,0.0217262987008743,0.0185403306066020,0.853358911329703,0.106128948831047;1.00031852306778,0.0215471078485687,0.0184297065585062,0.855321590629637,0.105300407484917;1.00030786901765,0.0218522215185344,0.0188304510156114,0.861717926465278,0.106946083827810;1.00031334505875,0.0219509221604733,0.0188569171704065,0.859048974460028,0.107364334624895;1.00030883789693,0.0217917702583903,0.0188718287827025,0.866007146685866,0.106753609221985;1.00030057675684,0.0215645342481339,0.0191926073235088,0.890007968763324,0.106212853171697;1.00029200145229,0.0215517835930869,0.0193008522936590,0.895557075835248,0.106282321777142;1.00029248989997,0.0216110441186615,0.0196436679994381,0.908964318964833,0.106895021679024;1.00026973530197,0.0214110667585129,0.0197373706125474,0.921830324250423,0.106210545992777;1.00025778600987,0.0211781532534965,0.0198229079582646,0.936007390304055,0.105387238173870;1.00025020983745,0.0214843404599902,0.0193764898136052,0.901888975818902,0.106100183486669;1.00026992655383,0.0215188144029496,0.0195606746384189,0.909003361994597,0.106439753712116;1.00027106029792,0.0214833635332124,0.0194710212166361,0.906330202276505,0.106200885149990;1.00026720339167,0.0213834125232601,0.0195979622814164,0.916503025889738,0.105947375037415;1.00025385872497,0.0211794495145561,0.0195131532956554,0.921324857015029,0.105049758081860;1.00027470615279,0.0211077872807146,0.0193768432817635,0.917995004595645,0.104616578342927;1.00025718932427,0.0208614088258592,0.0193094216197377,0.925604870741148,0.103571032494141;1.00024905139081,0.0209950379066502,0.0194261410795527,0.925272970019239,0.104226756424094;1.00025613464399,0.0210244482825365,0.0195987605506184,0.932189053774014,0.104533579850460;1.00024886962283,0.0212535843593421,0.0192987768731901,0.908024573497753,0.105104823181916;1.00026456061409,0.0214674123312217,0.0192511230633689,0.896760297251592,0.105894814105431;1.00027803853850,0.0216161078239790,0.0192748069900520,0.891687215247428,0.106507017465299;1.00026480198578,0.0213204915416516,0.0189530636656708,0.888959976773712,0.104986145579881;1.00025211501012,0.0218965749188757,0.0188018577702729,0.858666610642605,0.107089256449211;1.00025050120574,0.0220676050534023,0.0186557428838792,0.845390464381314,0.107601683145029;1.00025714851846,0.0217730988039914,0.0184350080089505,0.846687381291405,0.106196901244429;1.00025745742876,0.0214413368564545,0.0181001698420611,0.844171702689911,0.104519096396607;1.00026618595596,0.0211416025883146,0.0183276560020178,0.866900033971305,0.103589443338780;1.00026295545272,0.0212563178446214,0.0179687407118028,0.845336470933015,0.103644575852907;1.00025747361928,0.0212867055771157,0.0177111572996610,0.832029044395737,0.103479446652838;1.00025362584381,0.0207624341665607,0.0177612990837825,0.855453601504409,0.101468749837079;1.00023958277571,0.0209038477201891,0.0174687927611775,0.835673556132253,0.101702548659128;1.00024214348007,0.0207237704962722,0.0175623928669167,0.847451619389237,0.101096386036618;1.00023182990269,0.0204504881640613,0.0179495903521372,0.877709627669474,0.100447620784029;1.00021956908493,0.0201570825157586,0.0174722223744552,0.866803137844756,0.0987633401407522;1.00021949871468,0.0197239761720045,0.0174637824712728,0.885408820157686,0.0970471335070977;1.00023788184813,0.0195607391379837,0.0178480613337866,0.912443093682931,0.0968288287779617;1.00023477692255,0.0196034527762189,0.0174376979267325,0.889521765670092,0.0965433012980449;1.00023847866969,0.0199435464559853,0.0174502182225756,0.874980699199496,0.0978974579372066;1.00024973862651,0.0197920162544964,0.0172886917716015,0.873518470745688,0.0971216291583615;1.00027213224063,0.0199862491127481,0.0172641052075955,0.863799160623072,0.0978599081129410;1.00027500577218,0.0201082251693961,0.0176698739383202,0.878738615142081,0.0987893959683721;1.00026203019927,0.0201327145567300,0.0175098872902787,0.869723118605752,0.0987089634111213;1.00027702028113,0.0199781788319257,0.0176307381920599,0.882499768391575,0.0982335992170376;1.00024809583671,0.0203381036202635,0.0175993810676395,0.865340318657076,0.0996173818282678;1.00027537468945,0.0201348574122474,0.0174590403599546,0.867105239560069,0.0986611716997766;1.00028164464361,0.0203679149969737,0.0173429356191266,0.851483110652390,0.0994512397978273;1.00027792683142,0.0206428208121113,0.0174809967936328,0.846831784897178,0.100687339274288;1.00028597281128,0.0205738784894540,0.0175701113457532,0.854000929127652,0.100514198275341;1.00026835441063,0.0205373061360085,0.0174532794053142,0.849832947404580,0.100240850504287;1.00024636807970,0.0201753622801474,0.0171447091720407,0.849784451648294,0.0984731510903379;1.00025198147712,0.0197422135746107,0.0172749187983287,0.875024410664106,0.0969101238884924;1.00023355244350,0.0195117966645714,0.0172606028672031,0.884623961797642,0.0959862174262025;1.00021415556640,0.0194702034521054,0.0171004177411526,0.878286546066035,0.0956451338264620;1.00022562665368,0.0196848416955674,0.0175481926391816,0.891457137962813,0.0969862621811661;1.00022502486703,0.0193389106687178,0.0174788982160531,0.903820205567554,0.0955463083723717;1.00021013045239,0.0197193508541017,0.0174633564718733,0.885594896154552,0.0970284339739066;1.00022465365933,0.0191359872776579,0.0174855623771853,0.913752822024524,0.0947539578504168;1.00021416523784,0.0192991012011428,0.0177867485311624,0.921636108634383,0.0957299017091694;1.00022552648972,0.0196003537200896,0.0177329929395760,0.904728210154718,0.0968576842020442;1.00022003094422,0.0196641681875407,0.0177282244651590,0.901549676349477,0.0971039030855636;1.00022621993023,0.0190954885798123,0.0176809327273055,0.925921986934531,0.0948104320894402;1.00021124088412,0.0193829244308643,0.0175153852198346,0.903650286741256,0.0957601212351731;1.00021889151425,0.0192677492263251,0.0175240310305525,0.909500680370584,0.0953157780207383;1.00022508338500,0.0192874017548610,0.0175056709285498,0.907622040077938,0.0953729223628833;1.00021409995520,0.0195260624491201,0.0171764925821253,0.879670062865098,0.0959494129078127;1.00022143738111,0.0197353940694760,0.0171460117771884,0.868795004387955,0.0967406770533751;1.00021843378362,0.0200788549580711,0.0169903793627133,0.846182683135707,0.0979221269649190;1.00021367512194,0.0203821518335006,0.0168354140434664,0.825988059601996,0.0989460283078996;1.00021148316968,0.0202885237167650,0.0167749755401022,0.826820904974992,0.0985101949151237;1.00021866075667,0.0201818966271276,0.0168751198181256,0.836151335521300,0.0982007371263567;1.00021500436000,0.0207998547394609,0.0166204082458445,0.799063669147304,0.100354399048119;1.00022936535655,0.0208697903546715,0.0168194711364249,0.805924297780980,0.100850178864646;1.00024967179092,0.0206228453120938,0.0165614151435805,0.803061599548943,0.0995915585237618;1.00020523815117,0.0205658808485969,0.0165247571850327,0.803503497209072,0.0993265178709664;1.00020751303417,0.0205640428402986,0.0165183235519977,0.803262455747628,0.0993121586821263;1.00020024514179,0.0212758025049558,0.0164706651916265,0.774150126078208,0.102064493373970;1.00022889820404,0.0212338166296287,0.0165647755945632,0.780112962426617,0.102003113144954;1.00021252778473,0.0214217281356220,0.0162265262736323,0.757479796723277,0.102369568641124;1.00023285548867,0.0212215376617553,0.0160303907670545,0.755383093466592,0.101363692113340;1.00022897625273,0.0212426437126812,0.0161225948807098,0.758973087285039,0.101548848809742;1.00021894209330,0.0205072519598004,0.0160583475763913,0.783057018457170,0.0985796123930622;1.00022750226265,0.0208397353538502,0.0160105166860255,0.768268714269802,0.0998370284842680;1.00024761633009,0.0213291070472131,0.0161075104022486,0.755189158486279,0.101872917377954;1.00026116918968,0.0216724959953693,0.0160384605980316,0.740037538890698,0.103149844139174;1.00027035171029,0.0214821251569019,0.0160225349084054,0.745854276119308,0.102381978852047;1.00027623479806,0.0216097513905498,0.0158878891896024,0.735218508647461,0.102736035673857;1.00026430275993,0.0215069445635465,0.0159734122363600,0.742709508975736,0.102425462458351;1.00029236608752,0.0214270239081122,0.0157826191516533,0.736575420802046,0.101899478003599;1.00028622241985,0.0223062664487796,0.0156764556190268,0.702782586006652,0.105247155989284;1.00029798900205,0.0221968270145788,0.0154824493882358,0.697507322919035,0.104601284287844;1.00031360795417,0.0224453594306402,0.0154886102345314,0.690058463193418,0.105587564435545;1.00031226193292,0.0220228223536914,0.0155805911810475,0.707474770073507,0.104024076742136;1.00034775472698,0.0222701985126921,0.0157299619358805,0.706323382205855,0.105164190239603;1.00032944209484,0.0223669408768924,0.0158613330955660,0.709141817062366,0.105690748399529;1.00035897390244,0.0226104545722444,0.0155949269222999,0.689721954614906,0.106355790645279;1.00036393212530,0.0226154129623042,0.0156915665771709,0.693843910934806,0.106482215118792;1.00035518045531,0.0222968207534452,0.0155829849730557,0.698888202285426,0.105106551969527;1.00032025910423,0.0220677657090975,0.0156187131736760,0.707761419056442,0.104243361429639;1.00032701881896,0.0220553631330585,0.0155833101590957,0.706554231960847,0.104155327143344;1.00033428454925,0.0222792543378317,0.0152467178054754,0.684345964828160,0.104665411238250;1.00034881077309,0.0222560203337691,0.0152075014968753,0.683298328668445,0.104530472790928;1.00034106024055,0.0223977067719579,0.0154006367186065,0.687598818727648,0.105302466599065;1.00035835355234,0.0221402457820091,0.0154321768061742,0.697019218219983,0.104322696174527;1.00034802636329,0.0226169431721442,0.0152206188571516,0.672974183173339,0.105967377497430;1.00037421206904,0.0225921945905105,0.0153386237368727,0.678934650435218,0.106000356734183;1.00038132505223,0.0224844418664916,0.0154243307827965,0.686000162885220,0.105670495241616;1.00037795667625,0.0225478974887270,0.0154522123838650,0.685306130719746,0.105951410899628;1.00038296959740,0.0220131408998751,0.0155794707723722,0.707735022604639,0.103984682960651;1.00036228772722,0.0221722483340963,0.0154966892513610,0.698922771288392,0.104520168996679;1.00035613934058,0.0222631249655607,0.0156549036492411,0.703176381278818,0.105053298925335;1.00036129280851,0.0223722489871162,0.0153873957758527,0.687789403055277,0.105187492986318;1.00037956412721,0.0225867749059912,0.0155907680351594,0.690260920385933,0.106257869351398;1.00036840577593,0.0230911395982241,0.0156905529560177,0.679505352660221,0.108355932725957;1.00038547275687,0.0230484012747783,0.0158329097178820,0.686941776530408,0.108344947571879;1.00039208605663,0.0231229491628491,0.0159448829071286,0.689569604414767,0.108762583146072;1.00040192630753,0.0234964692945316,0.0159701282443947,0.679682042616992,0.110262547328050;1.00043436542632,0.0232968754870844,0.0158838898953419,0.681803442017268,0.109380568518848;1.00044337478564,0.0232978777953185,0.0159957782284738,0.686576621656419,0.109508267112042;1.00042028257211,0.0233951034606537,0.0158861364229567,0.679036809974971,0.109770169622227;1.00043461911879,0.0235575105427387,0.0161668766509413,0.686272712119173,0.110720714624874;1.00045557729404,0.0235775008996856,0.0161306897169628,0.684156042898421,0.110759473872622;1.00045085079435,0.0237002743018260,0.0160745341590714,0.678242536536086,0.111181215803429;1.00045629157135,0.0236605367440358,0.0161841989012867,0.684016557881607,0.111145899293068;1.00045446149354,0.0242173398582997,0.0160606471894290,0.663187917558369,0.113203612173067;1.00046234219282,0.0239301907358961,0.0160827814809590,0.672070760256594,0.112096438008107;1.00046474786228,0.0242587677275472,0.0156158869685925,0.643721360622114,0.112874974601527;1.00048827298883,0.0244500356612539,0.0161918247920987,0.662241356881045,0.114265748761063;1.00050434631199,0.0244390991160350,0.0157184572710099,0.643168440717878,0.113699103358031;1.00049942243062,0.0242394391675150,0.0159858501539302,0.659497525642175,0.113207980029423;1.00048070636340,0.0240637922121136,0.0161758698047855,0.672207840817486,0.112725917112032;1.00047035069549,0.0241198951790325,0.0162787415321457,0.674909298374434,0.113060795035120;1.00046861537446,0.0238907005498551,0.0163760182781048,0.685455758985856,0.112265127082563;1.00048376437783,0.0238130124887796,0.0163725263494522,0.687545364416481,0.111955096360775];
%     XWVP_Corr = [2.97911356520264,1.49283380752305,1.01486928231282,21.0302227550145,0.0483077778380902;2.98448751731340,1.52805760886446,1.01522546866330,21.0374006390941,0.0655835652756494;2.98807485272167,1.53945616412221,1.01534078546341,21.0402978926869,0.0687385711758725;2.99166595254119,1.54968296341634,1.01544427015166,21.0414268995206,0.0717919098997225;2.99346291514439,1.55630136958357,1.01550970704514,21.0429859455066,0.0739291066728862;2.99526082009774,1.56352614809102,1.01558282933481,21.0432824569490,0.0764733870489113;2.99705966781735,1.57105867786985,1.01565751698362,21.0421893053633,0.0786118918145323;2.99885945871943,1.57829973312403,1.01573081816540,21.0385277174146,0.0811568923714158;2.99885945871943,1.58489722393322,1.01579761375845,21.0341211880962,0.0842096221805756;3.00066019322036,1.59725142085120,1.01592271614002,21.0322416231604,0.0876741304028839;3.00066019322036,1.60925406162408,1.01604428807152,21.0294750479316,0.0894118973502941;3.00066019322036,1.62065657035831,1.01615980835985,21.0289191541029,0.0915559987332226;3.00066019322036,1.63565987132442,1.01631184876635,21.0288133563792,0.0942121083806406;3.00066019322036,1.64496191792340,1.01640613666926,21.0314757799604,0.0950339737785761;3.00066019322036,1.65516416258035,1.01650956932656,21.0308714326679,0.0979915224830800;3.00066019322036,1.66506634121798,1.01660997998049,21.0298990288704,0.0994244560420920;2.99885945871943,1.67546277958654,1.01671542390526,21.0292334703444,0.101874885475307;2.99885945871943,1.68266004228747,1.01678843360502,21.0280999165420,0.103407383697630;2.99885945871943,1.69165662066363,1.01687971047636,21.0275470930854,0.105653801918494;2.99705966781735,1.70083136148634,1.01697281181547,21.0275400407838,0.107290631646532;2.99705966781735,1.71042195242336,1.01707015124965,21.0283322051470,0.107606022002213;2.99705966781735,1.72540725076245,1.01722228142486,21.0301551684057,0.109147950796888;2.99705966781735,1.73859431330084,1.01735619363013,21.0310924415802,0.110586618247595;2.99705966781735,1.75118196390568,1.01748405181134,21.0310901057249,0.112330239319972;2.99705966781735,1.76616726224476,1.01763630584092,21.0319983509672,0.114077029884767;2.99705966781735,1.77635726511534,1.01773986461092,21.0327138160358,0.116531214497951;2.99705966781735,1.78834550378661,1.01786172544576,21.0329929084386,0.117359456943896;2.99885945871943,1.80051521901514,1.01798546084773,21.0341245847663,0.118697104734846;2.99885945871943,1.81131111306653,1.01809525312677,21.0339497391243,0.120440668444897;2.99885945871943,1.82660529630600,1.01825083273518,21.0345165772270,0.122902875511136;3.00066019322036,1.84060496252137,1.01839328559778,21.0352188320078,0.124753177485728;3.00066019322036,1.85410793339086,1.01853072213035,21.0359187103026,0.126501515688590;3.00246187173665,1.86843202278172,1.01867655676096,21.0370970442932,0.127945775529176;3.00246187173665,1.87984137789432,1.01879274614565,21.0390890006538,0.128673523838196;3.00426449468498,1.89178535230313,1.01891440833019,21.0404806405776,0.130115369943765;3.00606806248216,1.90254047674496,1.01902398566881,21.0403996464954,0.131555996549844;3.00606806248216,1.91246050135115,1.01912507558625,21.0411620480765,0.132791997348889;3.00787257554512,1.92233136303089,1.01922760741712,21.0421578006480,0.133314971050160;3.00967803429098,1.93492200824567,1.01935791604710,21.0428093325435,0.135982346000683;3.01148443913698,1.94331090857509,1.01944347457871,21.0429444248638,0.136707369941005;3.01329179050050,1.95261308024432,1.01954031963042,21.0429043810439,0.138453575405811;3.01510008879908,1.96222713779044,1.01963841948816,21.0432977013966,0.138364933524543;3.01690933445040,1.96943841352922,1.01971201424811,21.0423692412183,0.138884776340593;3.01871952787228,1.98088375418979,1.01982884162174,21.0436582324438,0.140634397259638;3.01871952787228,1.99537360792357,1.01997678401570,21.0447729938824,0.142286761370190;3.02053066948268,2.00774673600514,1.02010314847606,21.0460540871542,0.143936554249973;3.02234275969974,2.01771602637554,1.02020498576728,21.0468288563791,0.145889312964722;3.02415579894169,2.02860370993009,1.02031622776748,21.0487156523520,0.146721473552964;3.02415579894169,2.03918825522638,1.02042439579156,21.0499266910259,0.147757452510619;3.02596978762696,2.05160751601108,1.02055134280901,21.0507084378529,0.149714881990082;3.02596978762696,2.05281790392613,1.02056371682365,21.0503513359479,0.148798189912887;3.02596978762696,2.05856724652262,1.02062249749116,21.0508493220039,0.150643880629695;3.02596978762696,2.06340879818282,1.02067200225272,21.0499311056592,0.151059456333403;3.02778472617408,2.07221586659354,1.02075998665552,21.0503165968076,0.151787010015676;3.02778472617408,2.07706032215542,1.02080952959465,21.0495008240536,0.151692296097765;3.02596978762696,2.07944643805725,1.02083184638690,21.0494505893131,0.152308111480925;3.02596978762696,2.08247240784487,1.02086070303527,21.0492289219545,0.152108244752255;3.02596978762696,2.08489318367498,1.02088545908106,21.0480038640579,0.151703579219446;3.02415579894169,2.08485300779040,1.02088504821288,21.0461577999375,0.151090987135507;3.02415579894169,2.08666750126977,1.02090360488913,21.0455194533475,0.150787462442125;3.02234275969974,2.08632320702073,1.02090008376818,21.0437113367051,0.150991122389313;3.02234275969974,2.08692767557267,1.02090626572572,21.0427157678855,0.149869039808536;3.02053066948268,2.08628053341169,1.02089964734394,21.0425793511237,0.149357618406418;3.01871952787228,2.08472770594859,1.02088376678611,21.0417415823585,0.148436499690700;3.01690933445040,2.08408096823833,1.02087715283217,21.0418094356004,0.148639713452365;3.01690933445040,2.08438265917178,1.02088023810617,21.0423834678444,0.148129722549205;3.01510008879908,2.08313265135128,1.02086745489144,21.0418137199858,0.147209086995345;3.01329179050050,2.08218462723584,1.02085776012889,21.0420222375526,0.145982659698431;3.01148443913698,2.08093574744365,1.02084707728955,21.0419041265077,0.146185301467864;3.00967803429098,2.08480397435336,1.02089291856297,21.0423385695443,0.145375151603366;3.00787257554512,2.07813916244413,1.02082891052646,21.0413255037714,0.144243125057389;3.00606806248216,2.07448756991894,1.02078738331418,21.0407757810868,0.144033099785631;3.00426449468498,2.06963781038849,1.02073985668532,21.0398982219404,0.144230541749635;3.00426449468498,2.06573226654539,1.02069990905753,21.0396872254029,0.143510407213489;3.00246187173665,2.06149032113439,1.02065652410810,21.0400177192693,0.143402241637189;3.00246187173665,2.05848785926265,1.02062581833790,21.0391806192175,0.143295864894641;3.00066019322036,2.05485210031730,1.02058863839752,21.0391286039733,0.142678291647973;3.00066019322036,2.05305170420137,1.02056816742300,21.0398292259592,0.142777486622478;2.99885945871943,2.04882078219711,1.02052285466575,21.0401196946437,0.142669095082271;2.99885945871943,2.05032021192647,1.02053612567948,21.0405974103589,0.142466843144855;2.99885945871943,2.04882078219711,1.02051668925047,21.0407069439594,0.141953871474740;2.99885945871943,2.04852089625124,1.02051362461919,21.0401335014987,0.142973958809148;2.99885945871943,2.04462237895490,1.02047378608744,21.0403326163081,0.142458140537807;2.99885945871943,2.04192340544206,1.02044620738749,21.0399680823982,0.142964513654987;3.00066019322036,2.04044893138984,1.02043114151968,21.0391472327386,0.142656273584452;3.00066019322036,2.03804840323527,1.02040661437622,21.0387435752088,0.142754885351233;3.00066019322036,2.03474767702272,1.02037289147909,21.0378442019376,0.142648130228777;3.00246187173665,2.03356742572724,1.02036083361523,21.0368813427285,0.142850516706132;3.00246187173665,2.02936397910680,1.02031789203547,21.0349756939925,0.142130282360541;3.00426449468498,2.02697725456396,1.02029351133806,21.0353913232567,0.142535003533927;3.00606806248216,2.02518805369423,1.02027523518573,21.0340962761126,0.142940560449521;3.00606806248216,2.02278319924424,1.02025067134746,21.0330797402306,0.143039144122913;3.00787257554512,2.02068879625121,1.02022927950849,21.0336589639147,0.142730076203238;3.00967803429098,2.01889202540239,1.02021295184186,21.0339344707140,0.143033855848229;3.00967803429098,2.01558137956467,1.02017913712072,21.0324211625355,0.142519025455764;3.01148443913698,2.01377964445090,1.02016073525740,21.0335720234636,0.142720486862511;3.01329179050050,2.01137227015908,1.02013816484944,21.0332086828657,0.142513301629466;3.01329179050050,2.00835897836858,1.02010537576346,21.0320225848031,0.142406710456579;3.01510008879908,2.00654910909579,1.02008689349702,21.0319475527429,0.142608147710884;3.01510008879908,2.00293098898923,1.02005195476072,21.0308191720836,0.142399252884596;3.01690933445040,2.00051257967406,1.02002525369582,21.0314926958526,0.142293522890566;3.01690933445040,1.99779736127305,1.01999753067005,21.0301050878489,0.141983656269270;3.01690933445040,1.99568552473894,1.01997596935849,21.0291505530548,0.141980654934702;3.01690933445040,1.99327199727138,1.01994933218006,21.0289073511557,0.141364977440157;3.01690933445040,1.99085846980382,1.01992469550193,21.0294193266762,0.141769532674769;3.01690933445040,1.98784156046937,1.01989390132793,21.0274585318482,0.141459284114183;3.01690933445040,1.98542803300181,1.01986926732754,21.0266446844918,0.140945932744665;3.01690933445040,1.98210943273391,1.01983539751997,21.0249265552717,0.140941251937260;3.01510008879908,1.97941320829660,1.01980788136892,21.0235434359966,0.140835468417048;3.01510008879908,1.97669961821668,1.01978018949304,21.0225646503611,0.140321754074242;3.01329179050050,1.97400745195688,1.01975271773088,21.0232220287398,0.140317973959769;3.01329179050050,1.97189814770353,1.01973514419458,21.0242873619173,0.140213582326754;3.01148443913698,1.96770393253210,1.01969628336873,21.0241999401249,0.139800360449854;3.00967803429098,1.96592169199887,1.01968203266527,21.0246198951188,0.139798406678409;3.00967803429098,1.96531975639201,1.01967588774974,21.0239833563905,0.140001499388039;3.00787257554512,1.96263685554319,1.01964850000800,21.0237245622650,0.139283985101093;3.00606806248216,1.95965576993212,1.01961807004507,21.0236069480664,0.138668057526130;3.00606806248216,1.95905455631962,1.01961193327001,21.0233784520943,0.138769184118048;3.00426449468498,1.95577618603992,1.01957847122054,21.0231982873320,0.138764629933116;3.00246187173665,1.95280120137752,1.01954810770334,21.0226741615998,0.137842904161492;3.00246187173665,1.95160021662882,1.01953585063285,21.0224214257091,0.138147107760751;3.00066019322036,1.94952892753527,1.01951471205898,21.0222914111849,0.138144243483991;3.00066019322036,1.94862872947730,1.01950357306378,21.0237948822921,0.138652485936674;2.99885945871943,1.94566001681716,1.01947523017663,21.0239240392716,0.138342788734969;2.99885945871943,1.94536013087129,1.01947216999550,21.0240648257323,0.138648215119389;2.99885945871943,1.94416058708780,1.01945992945470,21.0230987732289,0.138850442391730;2.99705966781735,1.94179495877886,1.01943579066382,21.0233145929646,0.138745211109345;2.99705966781735,1.93999672297817,1.01941744229153,21.0224264949359,0.138233005174732;2.99705966781735,1.93879789911104,1.01940521041027,21.0216645464754,0.139148811221002;2.99705966781735,1.93729936927713,1.01938992097148,21.0211453773292,0.139044785220510;2.99705966781735,1.93490172154288,1.01936545882335,21.0198254436670,0.138531765854094;2.99705966781735,1.93340319170897,1.01935017057695,21.0199179324503,0.139243233300812;2.99705966781735,1.93160495590828,1.01933182528658,21.0194377028696,0.138425261873918;2.99885945871943,1.93156537736118,1.01933142152052,21.0199390426012,0.139240672179704;2.99885945871943,1.92946617574008,1.01930807433825,21.0186421468919,0.138931690532304;2.99885945871943,1.92766686006485,1.01928972134940,21.0181617701132,0.138725331075653;3.00066019322036,1.92732404210544,1.01928043665935,21.0165433234792,0.138825995473004;3.00066019322036,1.92522357997018,1.01925709312799,21.0155523746594,0.138822816084032;3.00066019322036,1.92282305181560,1.01923069648033,21.0153138845886,0.138615374721325;3.00246187173665,1.92157559791146,1.01921798057527,21.0145420888951,0.138715567156295;3.00246187173665,1.91947387460124,1.01919655740379,21.0148138171087,0.138406892495435;3.00246187173665,1.91737215129103,1.01917705297957,21.0147174085016,0.138302326089327;3.00426449468498,1.91672074760902,1.01917041291245,21.0148862460895,0.138301425032219;3.00426449468498,1.91491818891221,1.01915395470774,21.0136296459325,0.138299191653840;3.00426449468498,1.91341605666487,1.01914247147291,21.0139024477942,0.138501461873169;3.00426449468498,1.91161349796806,1.01912600658070,21.0133591296874,0.138804962096291;3.00426449468498,1.91071221861965,1.01911872959110,21.0137186448038,0.138803970970308;3.00426449468498,1.90921008637231,1.01910341201047,21.0131989832676,0.138801884715827;3.00426449468498,1.90710710122603,1.01908196817114,21.0127568263112,0.139002780458543;3.00426449468498,1.90590539542815,1.01906971495383,21.0128098944621,0.138695388205217;3.00246187173665,1.90356082668104,1.01904580935975,21.0120112569315,0.138997848396670;3.00246187173665,1.90205959574517,1.01903050316047,21.0110842355147,0.138588148429823;3.00066019322036,1.89971796832781,1.01900662939326,21.0106938901338,0.138686802260423;3.00066019322036,1.89911783628916,1.01900051100278,21.0103639361619,0.138787869598579;2.99885945871943,1.89797815142352,1.01898889203361,21.0099205715058,0.138888185984181;2.99885945871943,1.89647872169417,1.01897360590643,21.0110319590693,0.139293691927408;2.99705966781735,1.89444141602735,1.01895283706944,21.0107056050882,0.138985166976272;2.99526082009774,1.89270531221976,1.01893324529919,21.0092826914994,0.139186281307869;2.99526082009774,1.89450246871182,1.01895156344437,21.0084376496269,0.140309630286289;2.99346291514439,1.89426333270337,1.01894723055662,21.0092653679548,0.140410928370703;2.99166595254119,1.89312621476807,1.01893564124474,21.0095358803895,0.141020692748272;2.98986993187222,1.89198969288874,1.01892405827118,21.0082781258411,0.142139906128830;2.98986993187222,1.89109273190918,1.01891680907182,21.0087400112092,0.141833219822798;2.98807485272167,1.89115257428755,1.01891741900588,21.0086506955147,0.143463572596029;2.98628071467390,1.89061432046005,1.01891004138113,21.0072758871713,0.143666315834739;2.98628071467390,1.89001706431711,1.01890395465993,21.0070485044103,0.144480580770779;2.98448751731340,1.89037439346631,1.01890948757682,21.0077739239102,0.144888929133424;2.98448751731340,1.88858370095592,1.01889123682420,21.0063787404808,0.144988223000084;2.98448751731340,1.88798680345246,1.01888704261828,21.0063941576611,0.145700847094414;2.98448751731340,1.88768835470073,1.01888400061614,21.0049050031021,0.146107965688355;2.98269526022482,1.88715129114424,1.01887852652780,21.0056072543077,0.147126059230614;2.98448751731340,1.88679300844553,1.01887487471870,21.0057357421256,0.147431194371797;2.98448751731340,1.88619611094207,1.01886879087790,21.0047952189806,0.147735974677296;2.98448751731340,1.88500231593515,1.01885662341425,21.0031179777108,0.148141753044432;2.98448751731340,1.88321162342476,1.01883837276367,21.0018247969639,0.148444750911667;2.98448751731340,1.88142093091437,1.01882012276692,21.0010410726067,0.148645855911693;2.98448751731340,1.87992868715571,1.01880491493572,20.9989956237061,0.148541756597628;2.98628071467390,1.87986370988722,1.01880425274636,20.9980650512288,0.149866105578989;2.98628071467390,1.87926645374429,1.01879816609403,20.9982452417308,0.151087768031744;2.98807485272167,1.87830385242084,1.01878835635286,20.9972280244325,0.150984434411494;2.98986993187222,1.87853527819532,1.01879071476469,20.9966653568713,0.151901695571415;2.98986993187222,1.87674135623619,1.01877243356570,20.9953716971386,0.151898969844645;2.99166595254119,1.87607371883858,1.01876375322132,20.9945815500097,0.151999551980621;2.99346291514439,1.87570386262947,1.01875435747759,20.9939804217194,0.153424406236125;2.99526082009774,1.87563232554521,1.01875362879512,20.9925391503151,0.154544925488219;2.99705966781735,1.87496052818653,1.01874866044841,20.9919273977357,0.155359170718382;2.99885945871943,1.87788579305010,1.01877846091498,20.9918283093070,0.156076860212174;2.99885945871943,1.87758590710423,1.01877540581530,20.9913578491214,0.156891412495557;3.00066019322036,1.87691295085933,1.01876855011423,20.9906053296985,0.157297864137637;3.00246187173665,1.87623842364823,1.01876167850162,20.9905656238474,0.157398679328500;3.00426449468498,1.87556232403183,1.01875479096347,20.9896087091785,0.157601366162048;3.00426449468498,1.87345933888556,1.01873336810273,20.9883523429997,0.157394305371872;3.00606806248216,1.87368222334513,1.01873563855765,20.9869728899262,0.157802150412580;3.00606806248216,1.87428343695762,1.01874176298488,20.9867934367226,0.158516218320447;3.00787257554512,1.87631091262505,1.01876241696430,20.9866076657062,0.158519432079644;3.00787257554512,1.87691248714016,1.01877042237443,20.9855500534487,0.158520677721462;3.00787257554512,1.87781484891282,1.01877961608775,20.9844150203291,0.158623986224863;3.00787257554512,1.87931878520059,1.01879305983090,20.9844881705610,0.160561786229350;3.00787257554512,1.88022114697326,1.01880225305035,20.9840662456274,0.160257594404819;3.00787257554512,1.88112350874592,1.01881332778962,20.9838868244862,0.161278149789097;3.00787257554512,1.88172508326103,1.01882322251563,20.9831736793206,0.161891010057733;3.00787257554512,1.88172508326103,1.01882887297013,20.9821693414960,0.162706971013329;3.00787257554512,1.88142429600347,1.01882580657919,20.9823099561759,0.163215894213987;3.00606806248216,1.88149800030758,1.01882655795975,20.9815103693115,0.164540489110499;3.00606806248216,1.88450406837006,1.01885720434769,20.9819377234545,0.164952981383890;3.00426449468498,1.88457511751589,1.01885604188218,20.9806911568545,0.165767878014230;3.00426449468498,1.88547639686430,1.01886334233707,20.9803320590706,0.166482270137877;3.00246187173665,1.88614654782497,1.01887017341185,20.9804727238794,0.166992821422202;3.00066019322036,1.88741526153560,1.01888310608949,20.9802295907312,0.167911935883549;2.99885945871943,1.88838180115562,1.01889106874400,20.9790689945458,0.169034028304629;2.99885945871943,1.89108077466847,1.01891857964576,20.9797373386221,0.170159402800842;2.99705966781735,1.89264318022666,1.01893450607782,20.9797595866917,0.171079103570466;2.99526082009774,1.89450246871182,1.01895345944448,20.9791308811564,0.172305029992061;2.99346291514439,1.89486202528640,1.01895712480299,20.9774741197441,0.172407545516665;2.99166595254119,1.89492121433959,1.01895772818511,20.9772827501468,0.172509543381739;2.98986993187222,1.89587652380017,1.01896746685245,20.9762604791311,0.173835849845027;2.98807485272167,1.89892156890462,1.01899851005824,20.9758805298468,0.175267743730016;2.98628071467390,1.89837865031820,1.01899297504817,20.9743400026064,0.175164892410780;2.98628071467390,1.90375395560461,1.01904968448343,20.9748958457856,0.175989880510289;2.98448751731340,1.90649062605980,1.01907568223292,20.9749214144226,0.176605815730964;2.98448751731340,1.90529683105288,1.01906350982735,20.9747727846705,0.176196080849149;2.98448751731340,1.90559527980461,1.01906655290148,20.9737144452312,0.177827113481308;2.98269526022482,1.90504746270559,1.01906096720587,20.9724785172902,0.177826138777424;2.98269526022482,1.90773188843979,1.01908833894294,20.9719208359407,0.177321370976072;2.98269526022482,1.90832842749184,1.01909442175086,20.9715364674423,0.178749161575102;2.98269526022482,1.91160939227808,1.01912787849248,20.9719192219817,0.179366506614676;2.98269526022482,1.91250420085615,1.01913891852849,20.9711272682364,0.180285674687690;2.98269526022482,1.91339900943422,1.01914804456938,20.9706016538863,0.180287289084324;2.98269526022482,1.91280247038217,1.01914196052396,20.9708841217016,0.179980470228532;2.98269526022482,1.91369727896024,1.01915300333223,20.9701941118643,0.179982420388472;2.98448751731340,1.91663788361867,1.01918491873563,20.9700354584611,0.180395730616206;2.98448751731340,1.91723478112213,1.01919100814599,20.9705684263094,0.180294889341025;2.98628071467390,1.92107438374972,1.01923018062406,20.9704571203038,0.180709511024645;2.98628071467390,1.92197026796412,1.01923932106689,20.9710528788154,0.181220751285693;2.98807485272167,1.92342378269694,1.01925415119847,20.9712560863235,0.180815686422608;2.98986993187222,1.92697117109165,1.01928841591371,20.9715533708999,0.181331409191050;2.99166595254119,1.92902620619856,1.01930551848083,20.9712936677764,0.182557618359916;2.99346291514439,1.92808946364450,1.01929596275026,20.9706893488351,0.183167484506222;2.99346291514439,1.92509600072936,1.01926542757292,20.9699592007143,0.182448511535553;2.99526082009774,1.92625223340486,1.01927722164609,20.9696922086472,0.182960261285474;2.99705966781735,1.92920730817403,1.01930736592657,20.9692930625780,0.183067602920412;2.99885945871943,1.92886640384833,1.01930388832101,20.9690176601509,0.182455396009460;3.00066019322036,1.92582371200882,1.01927285051076,20.9672579532866,0.182449840241425;3.00246187173665,1.92667978309341,1.01928158290688,20.9668260167112,0.182655259656914;3.00426449468498,1.92573354109307,1.01927193072651,20.9674428869750,0.183061238758481;3.00606806248216,1.92448477360108,1.01925919290224,20.9676904867885,0.181631988175179;3.00606806248216,1.92658902124481,1.01928065707899,20.9690493896919,0.182553165682848;3.00787257554512,1.92654238463665,1.01928018135694,20.9671029706029,0.182349224444756;3.00967803429098,1.92950458778395,1.01931039853059,20.9666033115351,0.182354630297123;3.00967803429098,1.92799974876680,1.01929504757630,20.9668991286445,0.182351884011400;3.01148443913698,1.92885578326723,1.01930377997958,20.9666710326679,0.181945724726354;3.01148443913698,1.92915693171115,1.01930685202879,20.9668361541766,0.183169441309573;3.01148443913698,1.93156611926246,1.01933142908913,20.9674436300776,0.184295122379315;3.01329179050050,1.93332801278512,1.01934940360136,20.9677114272589,0.183584827588605;3.01329179050050,1.93393067114322,1.01935555195609,20.9685514459576,0.184197548238466;3.01329179050050,1.93393067114322,1.01935555195609,20.9691630592888,0.185114968235226;3.01329179050050,1.93543731703847,1.01937092316742,20.9687657008309,0.184608074185621;3.01148443913698,1.93517990058942,1.01936829690194,20.9678961831245,0.185525030036153;3.01148443913698,1.93427645525768,1.01936101743351,20.9688677452179,0.185727577376386;3.01148443913698,1.93397530681377,1.01935988256543,20.9679269764062,0.185523498626909;3.00967803429098,1.93432007263881,1.01936533919622,20.9678353445967,0.186441920538989;3.00787257554512,1.93346049156040,1.01935656697164,20.9675529686664,0.185828702158930;3.00787257554512,1.93406206607551,1.01936270616345,20.9675773118879,0.186237566416063;3.00606806248216,1.93320237098227,1.01935393282065,20.9672949149746,0.186032092739769;3.00426449468498,1.93444590812766,1.01936662338929,20.9686772531047,0.185830535443867;3.00246187173665,1.93448618395993,1.01936703441825,20.9679721511697,0.185932547077889;3.00066019322036,1.93362542851120,1.01935825017983,20.9671798479489,0.186236752307855;3.00066019322036,1.93482569258849,1.01937049923579,20.9678395469807,0.186442864310226;2.99885945871943,1.93546389465752,1.01937701239976,20.9671580172457,0.186545993269156;2.99705966781735,1.93610054541001,1.01938350981471,20.9678013517298,0.186139428892167;2.99526082009774,1.93613659411118,1.01938193726920,20.9685845114338,0.185731388970449;2.99346291514439,1.93647115980690,1.01938535140654,20.9688586169678,0.185630072491132;2.99166595254119,1.93620620448466,1.01938264761921,20.9685991232624,0.185323765337173;2.98986993187222,1.93564179389407,1.01937688803106,20.9679709606660,0.186240157443274;2.98986993187222,1.93414685892814,1.01936163312202,20.9674533040134,0.185625753391519;2.98807485272167,1.93447965965201,1.01936309077879,20.9654445606655,0.186033764067128;2.98628071467390,1.93301950660842,1.01935012947400,20.9689495783966,0.186031398629004;2.98628071467390,1.93361676275135,1.01935622392013,20.9684633329043,0.186338317732600;2.98628071467390,1.93391539082282,1.01935927117053,20.9687298876133,0.186644682551323;2.98448751731340,1.93364946246736,1.01935849545070,20.9665732778281,0.186542604667477;2.98448751731340,1.93156032120524,1.01933717582752,20.9678676404896,0.186538703176436;2.98448751731340,1.92976962869485,1.01931890257457,20.9671859621784,0.185617972158830;2.98448751731340,1.92976962869485,1.01931890257457,20.9681033491908,0.185006380817285;2.98448751731340,1.92917273119138,1.01931281163585,20.9677741917552,0.186126519404706;2.98448751731340,1.92887428243965,1.01930976619378,20.9675076835359,0.185718239400507;2.98628071467390,1.92764420132200,1.01929721434548,20.9665359802008,0.185104374125139;2.98628071467390,1.92644968903614,1.01928502574029,20.9653679089444,0.185204089177011;2.98628071467390,1.92495654867880,1.01926979039372,20.9643410488181,0.185507101851658;2.98807485272167,1.92402139766749,1.01926217698009,20.9644902347796,0.184894158904188;2.98807485272167,1.92432020515276,1.01926329756306,20.9647171359259,0.185607846486234;2.98986993187222,1.92398130115977,1.01925983964346,20.9632190479310,0.184893734911324;2.99166595254119,1.92423954067449,1.01925861877874,20.9630920124224,0.185505068617732;2.99346291514439,1.92389861556330,1.01925321401424,20.9624712260239,0.185198308986388;2.99346291514439,1.92000711377361,1.01921352196992,20.9621645063554,0.184273804772162;2.99526082009774,1.91906360743662,1.01920389897977,20.9619665903169,0.184577826105236;2.99705966781735,1.91691936353598,1.01918203012783,20.9594784495789,0.184268111047113;2.99885945871943,1.91507165033823,1.01916318630497,20.9608235037784,0.184366620402569;3.00066019322036,1.91322093919730,1.01914431260621,20.9593142753342,0.183547890700378;3.00246187173665,1.91166747373473,1.01913038500099,20.9592316718534,0.183239643223179;3.00426449468498,1.91011136572071,1.01911451510480,20.9598224978059,0.183338701267353;3.00606806248216,1.90915382648242,1.01910474993044,20.9625770641692,0.183336944512486;3.00606806248216,1.90644836522618,1.01907906928883,20.9622526394574,0.183128508751203;3.00787257554512,1.90518648935028,1.01906620010001,20.9617841095772,0.183024289537962;3.00967803429098,1.90392232449247,1.01905521482414,20.9612524302822,0.182410883453521;3.01148443913698,1.90295701709066,1.01904536964146,20.9619670625987,0.182307216628856;3.01148443913698,1.90084897798326,1.01902387038461,20.9607095994892,0.182201468024769;3.01329179050050,1.89988047391056,1.01901399320699,20.9613216430664,0.182403504784051;3.01329179050050,1.89686718212006,1.01898326372110,20.9599762431111,0.181684715921472;3.01329179050050,1.89566186540386,1.01897097244568,20.9597234177213,0.181376833095330;3.01510008879908,1.89499040581022,1.01896412533265,20.9600920580926,0.181273717896678;3.01510008879908,1.89408587578358,1.01895490166274,20.9595966407320,0.181373972495967;3.01510008879908,1.89408587578358,1.01895490166274,20.9607174911238,0.181883449946798;3.01510008879908,1.89589493583686,1.01897334916955,20.9606893817573,0.182396229501349;3.01329179050050,1.89445654868766,1.01895868146677,20.9599800777715,0.182699291586992;3.01329179050050,1.89505920704576,1.01896292920183,20.9602712462675,0.180967816226245;3.01329179050050,1.89325123197146,1.01894639078438,20.9596253637956,0.182493298589482;3.01148443913698,1.88970648555845,1.01891592525987,20.9592024741881,0.181570817881309;3.01148443913698,1.88850189178280,1.01890553177746,20.9588867886623,0.181365184656388;3.00967803429098,1.88646619189359,1.01888287751179,20.9581151255543,0.181361152197099;3.00787257554512,1.88352980680636,1.01885293117817,20.9564802855245,0.180438854111654;3.00606806248216,1.88209921392008,1.01883834210419,20.9564858587412,0.179723083547180;3.00606806248216,1.88540588878881,1.01887206394823,20.9565681601128,0.181461114589180;3.00426449468498,1.88247213236961,1.01884214505701,20.9561565448197,0.180742596533114;3.00246187173665,1.88044187026867,1.01882144116609,20.9544062268953,0.180840805806981;3.00066019322036,1.87931347901391,1.01880993459713,20.9544752108199,0.181144406371369;2.99885945871943,1.87728602115836,1.01878926060957,20.9544575122177,0.180733214832139;2.99705966781735,1.87555994012010,1.01877166042262,20.9542992659045,0.181035724057099;2.99526082009774,1.87473374729918,1.01876135853927,20.9536798701640,0.181033893412429;2.99526082009774,1.87413469513516,1.01875712820398,20.9540003643251,0.180523763117746;2.99346291514439,1.87181236083979,1.01873157519477,20.9524560533458,0.180213615651954;2.99166595254119,1.86919288714774,1.01870487131198,20.9517030882734,0.179699539299432;2.98986993187222,1.86747275944739,1.01868920663858,20.9519921264596,0.179798644971709;2.98986993187222,1.86866870742014,1.01870139922324,20.9523447688038,0.180921368502047;2.98807485272167,1.86963843534795,1.01871128572867,20.9526499826101,0.181432479988276;2.98807485272167,1.87173008774486,1.01873261105690,20.9524773581295,0.181741897812551;2.98807485272167,1.86993724283322,1.01871433214947,20.9512864407188,0.181738636855465;2.98807485272167,1.86993724283322,1.01871620526731,20.9531586531791,0.181738971019689;2.98628071467390,1.86761995895706,1.01869444910311,20.9518962124834,0.181225742495444;2.98628071467390,1.86672407474266,1.01868718447215,20.9521542727863,0.181224450117595;2.98628071467390,1.86642544667119,1.01868413914525,20.9510729529726,0.181835118837428;2.98807485272167,1.86575393803941,1.01867729135152,20.9510339834975,0.181120822402300;2.98807485272167,1.86425990061305,1.01866392438759,20.9507590664871,0.181016579363674;2.98807485272167,1.86366228564251,1.01865782977220,20.9506337191418,0.181422959482428;2.98986993187222,1.86388491552914,1.01866010019464,20.9494580225728,0.181423363844665;2.98986993187222,1.86298795454958,1.01865282026761,20.9506325544439,0.182338854827902;2.99166595254119,1.86201288886164,1.01864100922156,20.9492691315497,0.180706915035905;2.99166595254119,1.86081622248062,1.01862321280190,20.9496161684115,0.181722381163858;2.99346291514439,1.86103589434527,1.01861986175643,20.9489360768827,0.181110611420293;2.99526082009774,1.86125507360874,1.01862023252672,20.9491474261911,0.180805091273493;2.99705966781735,1.86057464178101,1.01861329869708,20.9492085463236,0.181211305838211;2.99705966781735,1.85937581791388,1.01860108250752,20.9481424224166,0.181514712902840;2.99885945871943,1.85809332062256,1.01858801399800,20.9483829546842,0.180901231286044;3.00066019322036,1.85800879164204,1.01858715266855,20.9478559469203,0.180188067307067];
%%END OF TESTING CODE%%
%%
% ydata = [];
    if(value == 2)
        value = value + 4;
        ydata = data.UserData.numData(5:end-4,value);
    elseif (value <= 5) %look at raw/unproccessed variable
        value = value + 6;
        ydata = data.UserData.numData;
        ydata = ydata(5:end-4,value); 
    elseif (value <= 9) %look at calculated vars using raw
        value = value - 4;
        ydata = data.UserData.calcStruct.Raw_Calcs;
        ydata = ydata(:, value);
%       ydata = XRaw_Calcs; %uncomment if testing
        prefix = NaN(16,1);
        ydata = [prefix; ydata; prefix];
    elseif (value <= 11) %look at corrected raw variables
        value = value - 6;
        ydata = data.UserData.calcStruct.WVP_Corr;
%       ydata = XWVP_Corr; %uncomment if testing
        ydata = ydata(:,value); %calculated vars using corrected
    elseif (value <= 15)
        %ydata = XWVP_Calcs; %uncomment if testing
        value = value - 10;
        ydata = data.UserData.calcStruct.WVP_Calcs;
        ydata = ydata(:, value);
        prefix = NaN(16,1);
        ydata = [prefix; ydata; prefix];
end
ydata = [NaN; ydata];


 
function Start_Callback (hObject,~, ~)
 
%%UNCOMMENT THIS SECTION FOR TESTING:
%declares the vars that are created from the 51162017 raw copy file
%data.UserData.TT = zeros(length(data.UserData.calcStruct.WVP_Corr),1);
%[a,b] = TimeTags('9:00:00 AM',length(data.UserData.calcStruct.WVP_Corr));
%data.UserData.TT = {b,a};
%     TT = {b,a};
%     xdata = data.UserData.TT(:,1);
%     xdata = TT{:,1};
%     XRaw_Calcs = [0.999871254548690,0.0203424082020360,0.0234328604905656,0.106086174426789,1.15192165341664;0.999876303389918,0.0207165009895721,0.0200550079512320,0.103824569193966,0.968069268132052;0.999890187703295,0.0213769503065755,0.0199322799059117,0.106291662734152,0.932419246901677;0.999892712123909,0.0219028045769914,0.0197833190446898,0.108199303701350,0.903232231066517;0.999896498754829,0.0223774164196621,0.0196144210687501,0.109882947811926,0.876527508846629;0.999907858647592,0.0225285793898855,0.0193436757737204,0.110179236781273,0.858628297814687;0.999905334226978,0.0226060806197451,0.0196202879456032,0.110790602190253,0.867920816334077;0.999910383068206,0.0221726436756298,0.0194400277968170,0.108883059468937,0.876757326785697;0.999921742960969,0.0216407067775919,0.0193433010525092,0.106679716374565,0.893838692576273;0.999928054012503,0.0212162771827461,0.0188702039493803,0.104483793945217,0.889421069815503;0.999915431909434,0.0208252306254579,0.0186920726618671,0.102745666258955,0.897568579097361;0.999933102853731,0.0206421870768553,0.0187595570832680,0.102098929403981,0.908796970661209;0.999934365064038,0.0206482226315375,0.0187446710524979,0.102106251574952,0.907810390608040;0.999943200536187,0.0214085680365847,0.0191960156465767,0.105601959937294,0.896651079781375;0.999945724956801,0.0213791956849962,0.0192008268128401,0.105491524649571,0.898108006294880;0.999950773798029,0.0210876215684719,0.0192874044558271,0.104438185929493,0.914631571569155;0.999955822639257,0.0209102701668204,0.0191366217899329,0.103572478427105,0.915178122389739;0.999960871480484,0.0208022527280218,0.0193147686365970,0.103343812113210,0.928494086151493;0.999957084849564,0.0205316439076175,0.0188050774220068,0.101713624268660,0.915907050922007;0.999953298218642,0.0205239179301329,0.0190049878835081,0.101904277161814,0.925992198380663;0.999964658111405,0.0208710202180383,0.0191812169063585,0.103467116577721,0.919035902700179;0.999965920321712,0.0210079711309680,0.0190458199359984,0.103857091076359,0.906599681485796;0.999973493583554,0.0212551146960318,0.0190172173562803,0.104799449413108,0.894712525819994;0.999965920321712,0.0209802719399848,0.0188730594840507,0.103556855504840,0.899562195286987;0.999977280214475,0.0209288445329378,0.0186480821785434,0.103105355193777,0.891023016067373;0.999981066845396,0.0211970323380132,0.0180263120088153,0.103474605525860,0.850416781055159;1.00000252442061,0.0214593895670748,0.0177902108512536,0.104247427485328,0.829017563414250;1.00002650641645,0.0215665231770954,0.0176468918821014,0.104511130262537,0.818253908485497;1.00001893315460,0.0216241736849788,0.0175124563176624,0.104589645179836,0.809855515072344;1.00002271978553,0.0215570876872512,0.0170322995080258,0.103794205831333,0.790102065507607;1.00001893315460,0.0211454750943562,0.0166815036307921,0.101784060362514,0.788892354338471;1.00001135989276,0.0208684166115256,0.0162519839382135,0.100217124101686,0.778783759244945;1.00000631105154,0.0205265338649351,0.0160977614457130,0.0986991941206680,0.784241584655083;1.00000631105153,0.0205469193270631,0.0160645004412637,0.0987427465559934,0.781844722585956;1.00000504884123,0.0205102662679606,0.0155216623892770,0.0979979179645731,0.756775274708337;1.00002398199583,0.0200162005328268,0.0151351244879339,0.0956232939835253,0.756143727832469;1.00001009768246,0.0199099903872300,0.0149706029138125,0.0950227589387502,0.751914120632344;1.00002903083706,0.0199848651460545,0.0147611675000114,0.0950862047956134,0.738617318262243;1.00003786630921,0.0197040099628251,0.0139244833539288,0.0930539818529389,0.706682719923493;1.00006184830504,0.0194503084728302,0.0138393569110710,0.0919599944350682,0.711523775080635;1.00006058609473,0.0190579573048090,0.0134626727391541,0.0899971257877567,0.706406910448742;1.00007320819780,0.0188174796503654,0.0132878452799759,0.0888560441817433,0.706143730556282;1.00009971461425,0.0183430800357375,0.0131115702194163,0.0867914750835161,0.714796544193847;1.00013000766162,0.0183130573334167,0.0126558186986467,0.0861690944316983,0.691081694783591;1.00014641639561,0.0180001729503198,0.0122076073373869,0.0844402953123602,0.678193891307586;1.00016534955021,0.0176476672783966,0.0117410082136796,0.0825350118284905,0.665300859794222;1.00019311817696,0.0171378654781718,0.0112164001773336,0.0799456664456059,0.654480582288371;1.00019942922850,0.0170966899903478,0.0109014079537728,0.0794350124488334,0.637632662224522;1.00021710017280,0.0167975315894346,0.0106046044122467,0.0779277644739067,0.631319212336939;1.00021205133157,0.0164297354293244,0.0103388248345204,0.0761843275939470,0.629275186992198;1.00021205133157,0.0161283289218329,0.0103284217880471,0.0749849787785236,0.640390076250587;1.00022719785525,0.0159139368698149,0.00989393184217701,0.0736595138213884,0.621714910842930;1.00023729553771,0.0155741689654639,0.00972726916256764,0.0721361595866932,0.624577091987256;1.00023350890679,0.0153199386937380,0.00951882133901328,0.0709036947929701,0.621335471982279;1.00024991764078,0.0149531353500671,0.00936978993119313,0.0692932940785142,0.626610387175494;1.00026001532323,0.0149806201179154,0.00925404112986062,0.0692735933743303,0.617734183032496;1.00025875311293,0.0150182526205756,0.00917569382149444,0.0693352509442612,0.610969468506835;1.00025496648201,0.0143610554535583,0.00926122586506340,0.0668398353492332,0.644884764564344;1.00025622869231,0.0142767348023720,0.00966852442873940,0.0669579998743337,0.677222387512098;1.00024234437894,0.0141814229708331,0.00976352508745981,0.0666874466747840,0.688472878041957;1.00024613100986,0.0134973064513914,0.00956694108967499,0.0637739215701140,0.708803724960159;1.00024486879955,0.0129811086165527,0.00987982151564257,0.0620856316541347,0.761092277052860;1.00022972227587,0.0129732716235857,0.00986910963622594,0.0620428987262172,0.760726355122609;1.00021583796249,0.0124728764257920,0.0100826525010054,0.0603070196601582,0.808366262665439;1.00021583796249,0.0124406268449040,0.00993973289234229,0.0600218549746972,0.798973638246683;1.00021583796249,0.0127203518449033,0.0101491828923423,0.0613559028996946,0.797869667135722;1.00020952691095,0.0124664605280246,0.0103413687356326,0.0605678747625544,0.829535272853528;1.00020321585942,0.0125841669629252,0.0106072338810865,0.0613258026733701,0.842903142682147;1.00019438038727,0.0123906564365987,0.0105120383315006,0.0604578914112753,0.848384295480168;1.00020447806973,0.0124764046471739,0.0106391298500153,0.0609363883286292,0.852740044178134;1.00020195364911,0.0126745293923610,0.0108717379062165,0.0619744624595703,0.857762648983947;1.00020574028003,0.0127832818258285,0.0108197980128329,0.0623456102777834,0.846402211908649;1.00021205133157,0.0127090798594787,0.0107654881010235,0.0619931135659374,0.847070615658649;1.00023350890679,0.0130622343193600,0.0108961436209317,0.0635294002973481,0.834171501944519;1.00021710017280,0.0134327467902165,0.0108366085352952,0.0649237441402797,0.806730648953186;1.00022341122433,0.0137019783251090,0.0108846073275511,0.0660378722835263,0.794382173821204;1.00022846006556,0.0139001952269857,0.0109406438185730,0.0668810214528926,0.787085622893479;1.00021962459341,0.0141123811180808,0.0108292057499120,0.0675939955457592,0.767354967195263;1.00020826470065,0.0142206443240305,0.0108223212996285,0.0680130466383934,0.761028899466996;1.00022467343464,0.0137877123060508,0.0108448054432195,0.0663317290183471,0.786555826122087;1.00020321585942,0.0136997259213596,0.0108605388108881,0.0660023757809202,0.792755918857848;1.00020447806973,0.0134945414800125,0.0106240371565280,0.0649321730678493,0.787284041644823;1.00021205133157,0.0138086460194596,0.0108042684929625,0.0663693949159070,0.782427797608599;1.00020574028003,0.0138246940876190,0.0105215992038646,0.0661200081187806,0.761072840901956;1.00021331354188,0.0134635761654905,0.0104312541660703,0.0645969207758717,0.774775887019337;1.00019942922850,0.0135934783895003,0.0104141626602673,0.0650899622352763,0.766114629520523;1.00021331354188,0.0135227640850514,0.0104248952637540,0.0648231474208994,0.770914525919896;1.00021962459341,0.0133186075027385,0.0101042488918879,0.0636639314427204,0.758656555485272;1.00022341122433,0.0130096522844406,0.0103896291700462,0.0627619695150516,0.798609289694246;1.00020574028003,0.0132411356914993,0.0102546336390053,0.0635249405649386,0.774452726557944;1.00022593564495,0.0127702652060678,0.0102236700159606,0.0616349942147656,0.800584001270614;1.00023603332740,0.0126604492179967,0.0101402156403685,0.0611099088663727,0.800936480670391;1.00024865543047,0.0129281522275047,0.0102305009495394,0.0622647819787866,0.791335124270420;1.00026001532323,0.0132951364548897,0.0101517974328346,0.0636240207294354,0.763572263231717;1.00027137521600,0.0128635852307794,0.0102501029114799,0.0620320032145986,0.796830955568586;1.00025622869231,0.0130801950160019,0.0100753789157929,0.0626924176389303,0.770277423499193;1.00023981995832,0.0129465915455509,0.0101579439978776,0.0622572033426686,0.784603728490098;1.00023603332740,0.0128362912504512,0.0101971541222097,0.0618658762771921,0.794400339105059;1.00022719785525,0.0129367827661790,0.00992606567125038,0.0619620895139143,0.767274665630190;1.00023098448617,0.0127523003511343,0.0100527882956639,0.0613751995388247,0.788311757005450;1.00023603332740,0.0130604129203089,0.00988397694159500,0.0624027658163415,0.756789008272889;1.00023729553771,0.0126625851648030,0.0100350500272353,0.0610020134646109,0.792496152770513;1.00023729553771,0.0129685877951547,0.0102072922490183,0.0623984697281191,0.787078162267746;1.00023098448617,0.0129910106451283,0.0101562004286883,0.0624303306265798,0.781786783655429;1.00024108216863,0.0135751006353068,0.0101534739306838,0.0647292137710805,0.747948335961219;1.00023729553771,0.0133523734671154,0.0102177932508984,0.0639225831693955,0.765241720961672;1.00023350890679,0.0129865976661143,0.0103295817120116,0.0626046987756411,0.795403228588840;1.00020574028003,0.0127483890031407,0.0103364554444274,0.0616735207829143,0.810804835174146;1.00020069143881,0.0123864376594369,0.0103319215462518,0.0602420560459954,0.834131800468085;1.00019438038727,0.0122616912278035,0.0104103620871039,0.0598371855971105,0.849015188337011;1.00020069143881,0.0124139037027285,0.0104182334611264,0.0604457607004589,0.839239107262978;1.00019311817696,0.0129277055553624,0.0103541008324302,0.0623997231143510,0.800923318379212;1.00020574028003,0.0130654999034387,0.0105958092156467,0.0632101001119571,0.810976181084204;1.00020069143881,0.0133002869113874,0.0106707832441014,0.0642183169857537,0.802297222247539;1.00020447806973,0.0131866791669572,0.0105648907513547,0.0636534717679764,0.801179024498290;1.00022088680372,0.0132987250358788,0.0108110770686554,0.0643673266043314,0.812940867601069;1.00020700249034,0.0133935360369026,0.0108954957232276,0.0648343437913230,0.813489110956783;1.00021836238310,0.0132474041066899,0.0108838091955568,0.0642455125547505,0.821580523089841;1.00020195364911,0.0134799335804106,0.0109144217436867,0.0651957686889157,0.809679193044977;1.00021583796249,0.0136984843541218,0.0110141172834918,0.0661673405551359,0.804039118399091;1.00021962459341,0.0138396214257516,0.0109691336789240,0.0666738098877769,0.792589142540675;1.00023603332740,0.0140391857580798,0.0109815501301048,0.0674740255164884,0.782207053837491;1.00024234437894,0.0144206944564745,0.0108590534843631,0.0688420700066716,0.753018761831383;1.00024108216863,0.0143506006024056,0.0110443596303131,0.0687707787252068,0.769609574979164;1.00024613100986,0.0142780959627162,0.0108593125511366,0.0682803758706217,0.760557470652460;1.00024108216863,0.0142946292096354,0.0108472093398312,0.0683321472450265,0.758831109275611;1.00023855774801,0.0146658266646562,0.0111083934023617,0.0700839059884220,0.757433839657489;1.00023477111709,0.0144643185006077,0.0112436559946722,0.0694393627410026,0.777337417881097;1.00024613100986,0.0142337702846111,0.0112182361218235,0.0685026578423891,0.788142276958912;1.00023729553771,0.0144040511549567,0.0115118942584186,0.0694985206514953,0.799212258730225;1.00023603332740,0.0140220976073170,0.0115462866293153,0.0680312796824590,0.823435048925225;1.00022972227587,0.0141600950870957,0.0117592516850811,0.0688106671019437,0.830450050847290;1.00023224669648,0.0143784142291215,0.0119795020475146,0.0699146597415192,0.833158779307649;1.00022972227587,0.0144854210583397,0.0119578291568063,0.0703124034383446,0.825507875031480;1.00022972227587,0.0142071804510416,0.0121406864665773,0.0694180973895894,0.854545805792676;1.00022972227587,0.0144480782862279,0.0121350672197988,0.0703612608711215,0.839908739376511;1.00024234437894,0.0141514070736119,0.0122877121677743,0.0693609049346627,0.868303208568367;1.00023981995832,0.0144001661234668,0.0124141061699819,0.0704810561165827,0.862080760981748;1.00024108216863,0.0142876323964754,0.0126646440196829,0.0703146555602787,0.886406065626882;1.00024234437894,0.0139628702278962,0.0127528548386270,0.0691323290196603,0.913340497367679;1.00021962459341,0.0142586044898613,0.0128773683692533,0.0704355297109374,0.903129642063492;1.00022214901402,0.0147516278715458,0.0130056625746705,0.0725204282493475,0.881642533822108;1.00023224669648,0.0151836257048513,0.0132035030827076,0.0744417433122936,0.869588288025894;1.00023350890679,0.0149562258762232,0.0132498600290018,0.0735968313702716,0.885909328908031;1.00022088680372,0.0153366138483492,0.0132502718060601,0.0750963957938467,0.863963319222929;1.00020700249034,0.0156049622433179,0.0136261049744687,0.0765696283026782,0.873190512223341;1.00020574028003,0.0155742923840357,0.0138535315399433,0.0767002921686620,0.889512743072919;1.00020195364911,0.0156963467161215,0.0140163261708187,0.0773613591531602,0.892967416196456;1.00018302049451,0.0159664663057059,0.0142276871518477,0.0786596657007304,0.891098060111347;1.00019564259758,0.0162730166888577,0.0143906918864579,0.0800480639972105,0.884328466049651;1.00018680712543,0.0162466306286298,0.0143985742088327,0.0799527943823991,0.886249865461921;1.00017418502236,0.0162945530516986,0.0148060103692192,0.0805922810451007,0.908647836012649;1.00018554491512,0.0166340660823355,0.0151056776987697,0.0822617339653236,0.908116970559058;1.00017544723267,0.0168602534002433,0.0153205993978689,0.0833908415844020,0.908681443521351;1.00018806933574,0.0168850969161377,0.0155576575108695,0.0837509361535202,0.921383962919428;1.00016534955021,0.0172005518692929,0.0156847538233934,0.0851347126455565,0.911875034160646;1.00015903849868,0.0174454901014723,0.0158832787833555,0.0863195828242935,0.910451852654746;1.00016534955021,0.0173793059615390,0.0158997984399649,0.0860770218690265,0.914869585422550;1.00017797165328,0.0174403162484743,0.0157453126815936,0.0861466021610798,0.902811190879120;1.00018554491512,0.0178871223882809,0.0157099497831056,0.0878683537923298,0.878282679689062;1.00018806933574,0.0185002719161375,0.0156406565108695,0.0902081377225197,0.845428466228457;1.00021078912126,0.0185249724889426,0.0157203550735648,0.0903936292902856,0.848603423457070;1.00020574028003,0.0187598217413501,0.0159504912533957,0.0915737008089163,0.850247484934137;1.00018680712543,0.0190447584975105,0.0155838407601434,0.0922911211194075,0.818274527460169;1.00019816701819,0.0191448539654883,0.0156518019333799,0.0927607624163077,0.817546164708010;1.00019438038727,0.0192502738986583,0.0158786663463404,0.0934271344136649,0.824854047788230;1.00020574028003,0.0196088852109013,0.0157330458147088,0.0946793652872301,0.802342695441053;1.00021205133157,0.0195756248019636,0.0161281430444740,0.0949852635517269,0.823889056294958;1.00019942922850,0.0198994173148619,0.0162121693940122,0.0963542629876483,0.814705734217862;1.00020321585942,0.0198890949083106,0.0163842968925676,0.0965039553968320,0.823782930701459;1.00019942922850,0.0201204643310876,0.0163807111910242,0.0974118165060889,0.814131867012373;1.00019942922850,0.0203727143051258,0.0166839903158050,0.0987413603657812,0.818938020036304;1.00019438038727,0.0202959779967741,0.0167496975796840,0.0985116148084171,0.825271764797254;1.00019690480789,0.0202711944852039,0.0168702983540083,0.0985473274457217,0.832230106929422;1.00019438038727,0.0202593891644871,0.0169692378944931,0.0986102298085529,0.837598693461039;1.00020195364911,0.0202844153089889,0.0170072708894228,0.0987509223364269,0.838440281879170;1.00021457575218,0.0202298169653576,0.0172794398036840,0.0988367690833490,0.854157001680936;1.00022719785525,0.0203443928886614,0.0172865565087414,0.0992961838728827,0.849696356305416;1.00022214901402,0.0204640076708278,0.0172777410445156,0.0997578358259667,0.844298991792584;1.00022972227587,0.0206349255815351,0.0175909204254166,0.100777799707341,0.852482862412533;1.00024486879955,0.0208533108331517,0.0176148885514376,0.101664964731341,0.844704646296943;1.00026001532323,0.0210969865119560,0.0178731017830374,0.102910874415658,0.847187429963444;1.00023855774801,0.0210061230440652,0.0178184690295982,0.102492357663396,0.848251197625563;1.00024991764078,0.0212930531888360,0.0179466025595542,0.103764865048070,0.842838384913427;1.00024234437894,0.0213473243108520,0.0181273991955208,0.104178708619314,0.849164931939768;1.00024613100986,0.0217110617561253,0.0180469560163923,0.105523227735020,0.831233231203020;1.00024991764078,0.0216557425961049,0.0181147738023719,0.105380221396673,0.836488230407307;1.00024108216863,0.0217033796076860,0.0181889201914994,0.105649964765689,0.838068564448737;1.00023477111709,0.0215794205321938,0.0180799877224494,0.105040962738405,0.837834718289878;1.00023224669648,0.0219423990689319,0.0184728718256256,0.106905990969803,0.841880223196800;1.00023729553771,0.0220628173471810,0.0184986824144316,0.107409105915602,0.838455131243483;1.00023477111709,0.0221430531912780,0.0185114677016949,0.107739455904901,0.835994365446696;1.00022846006556,0.0219743451689175,0.0188258066407017,0.107422236455320,0.856717526551401;1.00022341122433,0.0221113995571406,0.0189307576626396,0.108078443629571,0.856153750635206;1.00022593564495,0.0221994597875093,0.0192668822459455,0.108797242786590,0.867898698002830;1.00021078912126,0.0220671823225074,0.0193584013970851,0.108377157478178,0.877248445867079;1.00020321585942,0.0218276758382272,0.0194424916704912,0.107526266266017,0.890726608484865;1.00020069143881,0.0221404878287046,0.0190042368100512,0.108274348444841,0.858347700244108;1.00022088680372,0.0222767428613987,0.0191840727243806,0.109010228049937,0.861170452239807;1.00022214901402,0.0222443303398871,0.0190960044783651,0.108785086822567,0.858466143353544;1.00022088680372,0.0223583389889962,0.0192187380030066,0.109370138186959,0.859578075655136;1.00021583796249,0.0221810183063427,0.0191353658051494,0.108579107725792,0.862691042443152;1.00023477111709,0.0223247825713123,0.0189997733187813,0.108995717404114,0.851061964795857;1.00023224669648,0.0223318961174732,0.0189316237552397,0.108948378472257,0.847739200274493;1.00023098448617,0.0223906315867832,0.0190467009401561,0.109307130323325,0.850654920846405;1.00023477111709,0.0223812813768763,0.0192163086774813,0.109457867303564,0.858588404921937;1.00022846006556,0.0224274969947139,0.0189234811070878,0.109316135760607,0.843762507762145;1.00024234437894,0.0227217625193740,0.0188759030170739,0.110423214825737,0.830741145233743;1.00026253974385,0.0229752796393422,0.0188982268438961,0.111447015947997,0.822546107840854;1.00025117985108,0.0227217639601176,0.0185821915645791,0.110098375637248,0.817814655464053;1.00024739322016,0.0230779786172737,0.0184356621448329,0.111340156062861,0.798842153837251;1.00024865543047,0.0232436546902533,0.0182922715471227,0.111834495465406,0.786979147250590;1.00025749090262,0.0228188330518345,0.0180767933306410,0.109921954480969,0.792187457157798;1.00025622869231,0.0224439903407963,0.0177486755545104,0.108081801096367,0.790798573917080;1.00026758858508,0.0223270955459156,0.0179703687283357,0.107866311359993,0.804868178728384;1.00027263742630,0.0224301432367855,0.0176183494896739,0.107883089031751,0.785476459230974;1.00026885079538,0.0225566980179147,0.0173646957635154,0.108101300403050,0.769824366568382;1.00027516184692,0.0220463009331854,0.0174140314642296,0.106144390777121,0.789884503391542;1.00026380195415,0.0220167684544687,0.0171284458851174,0.105712145628001,0.777972749295133;1.00027011300569,0.0218293674174872,0.0172203485177271,0.105075242452923,0.788861545476216;1.00026885079538,0.0217846990926284,0.0175984217861159,0.105317353619493,0.807834054135317;1.00026127753354,0.0215499437082946,0.0171296135525168,0.103873680743473,0.794879735389915;1.00025875311293,0.0210952699393651,0.0171215373820181,0.102072879175550,0.811629215043519;1.00026885079538,0.0208224600398447,0.0174993770572482,0.101415626042345,0.840408723261436;1.00026885079538,0.0209857450398456,0.0170957055572482,0.101612671548348,0.814634196917414;1.00028021068814,0.0211712933812941,0.0171093437602381,0.102359001414504,0.808138806264667;1.00029030837060,0.0208637576765563,0.0169522023681400,0.100973204822471,0.812519136338921;1.00030419268398,0.0210088446967283,0.0169283397146584,0.101518600674218,0.805772043109761;1.00030924152520,0.0211640374214293,0.0173261677355076,0.102570212993324,0.818660796638183;1.00029409500152,0.0210679703576512,0.0171702532291896,0.102019171250987,0.814993230847884;1.00030545489428,0.0208462452643849,0.0172893368458633,0.101277059138466,0.829374145156083;1.00028273510876,0.0211486615292500,0.0172591269445202,0.102435469487414,0.816086016632761;1.00030924152520,0.0209043108960493,0.0171217906402398,0.101320589689436,0.819055491729966;1.00032312583858,0.0210750901581612,0.0170084937957397,0.101868324451401,0.807042516454110;1.00031555257674,0.0212532748763953,0.0171446844246877,0.102721177261578,0.806684359205709;1.00032565025919,0.0211013992356604,0.0172328528079440,0.102220149593324,0.816668724926128;1.00030924152520,0.0210818068288673,0.0171180929861939,0.102016011555297,0.811984149420919;1.00029409500152,0.0208589220148000,0.0168143270338089,0.100801657359719,0.806097602832913;1.00030419268398,0.0205877369434236,0.0169408076221340,0.0998728045241128,0.822859145164346;1.00028778394999,0.0203301155211971,0.0169270630010906,0.0988423169482438,0.832610271370158;1.00026885079538,0.0201827693047688,0.0167708534170728,0.0980888577093762,0.830949071647476;1.00028399731907,0.0203861706599521,0.0172102532333095,0.0993764386469114,0.844212163254300;1.00028273510876,0.0200986826759378,0.0171418386539247,0.0981677819771117,0.852883690454344;1.00026632637477,0.0204316262002711,0.0171269037677167,0.0994633944223632,0.838254556922612;1.00028021068814,0.0198565309547873,0.0171487014617683,0.0972210523095324,0.863630283699371;1.00027137521600,0.0200821591861766,0.0174436503118291,0.0984364665976051,0.868614283459930;1.00028021068814,0.0203064514950754,0.0173914793936373,0.0992627015514549,0.856450936189173;1.00027642405722,0.0203503689525837,0.0173869987521158,0.0994308246619722,0.854382482825126;1.00028021068814,0.0195891791917553,0.0173423420666712,0.0963815855204459,0.885302130166347;1.00026885079538,0.0198693981912210,0.0171800268844358,0.0973064080057880,0.864647571058622;1.00027642405722,0.0196968009234463,0.0171890334982051,0.0966361634883169,0.872681485943434;1.00028021068814,0.0196987547581082,0.0171711227887344,0.0966240543060447,0.871685697882329;1.00027263742630,0.0198352554728559,0.0168490911818832,0.0968058366656878,0.849451684902213;1.00028147289845,0.0199255039633812,0.0168202218630679,0.0971295765002382,0.844155404750607;1.00028021068814,0.0201823401396246,0.0166682834862829,0.0979737240260894,0.825884578843144;1.00027516184692,0.0204198955185603,0.0165167891363604,0.0987423770234609,0.808857671252416;1.00027389963661,0.0202222877317774,0.0164584353513312,0.0978990654495069,0.813876034681692;1.00028021068814,0.0201194505614286,0.0165566721157005,0.0976024340225547,0.822918700744328;1.00027516184692,0.0207024557868734,0.0163069730926437,0.0996238904965318,0.787683029516882;1.00028525952937,0.0207622330710526,0.0165022670032982,0.100075467838666,0.794821392613408;1.00030545489428,0.0204403568402648,0.0162498128161837,0.0985277392821826,0.794986748185028;1.00025875311293,0.0202569705518676,0.0162149073770879,0.0977664085039695,0.800460628383196;1.00026253974385,0.0201960151488368,0.0162091465457065,0.0975198117811172,0.802591324390055;1.00025622869231,0.0208365083920290,0.0161629007222052,0.0999928477717454,0.775701015645609;1.00028399731907,0.0206027015751622,0.0162569242289473,0.0991754051049300,0.789067597258506;1.00026253974385,0.0206433136507363,0.0159262362860686,0.0989697164299436,0.771496115184035;1.00027768626753,0.0204116130939197,0.0157340315318058,0.0978440060773147,0.770837241496251;1.00027389963661,0.0202927161063553,0.0158257211237282,0.0974768417379895,0.779872001401126;1.00026253974385,0.0194887536507363,0.0157633982860686,0.0942394966419436,0.808845889715121;1.00027011300569,0.0196390555387991,0.0157179825196810,0.0947816065451746,0.800343096368784;1.00028652173968,0.0200306366802126,0.0158138464996251,0.0964308533853033,0.789482968119876;1.00029661942213,0.0202580407739267,0.0157469786453896,0.0972530970718460,0.777319920574792;1.00030166826336,0.0200109547278988,0.0157318022825357,0.0962625459071335,0.786159505953148;1.00030545489428,0.0200642520052863,0.0156003063929122,0.0963271560233942,0.777517466826174;1.00029409500152,0.0199798782367835,0.0156840640457652,0.0960872749657802,0.784992974426161;1.00032060141797,0.0197520868427259,0.0154981173974107,0.0949838920887190,0.784631898432453;1.00031429036643,0.0206038591948389,0.0153940221938395,0.0982255976332467,0.747142661394987;1.00032438804889,0.0203378802632116,0.0152050470664175,0.0969683681727746,0.747622017124437;1.00032943689012,0.0204774935810238,0.0152118465700849,0.0975261045093288,0.742856859404972;1.00032565025919,0.0200064169562987,0.0153025737008599,0.0957699357379244,0.764883273915880;1.00035468109626,0.0203622465177349,0.0154480555921950,0.0973331630113609,0.758661652521504;1.00033196131073,0.0204154113396348,0.0155772169946078,0.0976855380855368,0.763012644490097;1.00035594330656,0.0206248925128308,0.0153158938688273,0.0982220800119892,0.742592663661120;1.00035720551687,0.0205353321109784,0.0154115771486177,0.0979749481757371,0.750490767099817;1.00034458341380,0.0200678701134849,0.0153062608836520,0.0960162006545632,0.762724733471674;1.00030797931490,0.0197855489675140,0.0153417524156206,0.0949428266526491,0.775401907766638;1.00030797931490,0.0196786109675139,0.0153077214156206,0.0944837457086488,0.777886276673241;1.00031176594582,0.0197976274061259,0.0149782031220015,0.0945883422604759,0.756565562869761;1.00032312583858,0.0197119135334286,0.0149401461508802,0.0942084528781157,0.757924699981249;1.00031302815613,0.0199365902634394,0.0151290053354538,0.0953027821292268,0.758856210392108;1.00032438804889,0.0195278373760353,0.0151611475820468,0.0937274363246989,0.776386411362310;1.00031176594582,0.0198288533275168,0.0149549789793364,0.0946857177148897,0.754202914930190;1.00032943689012,0.0197254190809565,0.0150713175893740,0.0944067538518972,0.764055634383163;1.00033322352104,0.0196788487069596,0.0151547705969283,0.0943155190343306,0.770104533176712;1.00032817467981,0.0196785085021074,0.0151826645703121,0.0943450290215705,0.771535330977249;1.00033069910042,0.0191986771904632,0.0153070978770727,0.0925916370596580,0.797299612114754;1.00031050373551,0.0194661282181842,0.0152248720873235,0.0935547198364437,0.782121227019416;1.00030924152520,0.0195019171845946,0.0153806212042092,0.0938680226763426,0.788672265327793;1.00031050373551,0.0195536031814859,0.0151184593062286,0.0937817661309246,0.773180224938972;1.00032943689012,0.0197254539271208,0.0153183876248679,0.0946801506398872,0.776579726959107;1.00031429036643,0.0202338110572656,0.0154162024606096,0.0967917692981180,0.761903055088274;1.00032312583858,0.0203023139238872,0.0155548309289174,0.0972150621814221,0.766160497135055;1.00032691246950,0.0204628275001769,0.0156639217835032,0.0979683006707517,0.765481788055328;1.00033069910042,0.0207082871369850,0.0156896216776441,0.0989640811823323,0.757649417059822;1.00035468109626,0.0205081135983142,0.0156048773437504,0.0980814700331443,0.760912371044847;1.00035972993748,0.0205812497722345,0.0157139907910689,0.0984903791672984,0.763510037775650;1.00034584562411,0.0206368454552988,0.0156068673171000,0.0985910031920454,0.756262256792389;1.00035215667564,0.0208488397243975,0.0158818309954674,0.0997305824348377,0.761760903983655;1.00036730319932,0.0208486863868730,0.0158463525150803,0.0996907389323453,0.760064793581318;1.00035972993748,0.0208829034787169,0.0157919285230208,0.0997653955560845,0.756213260244935;1.00035972993748,0.0208004645026070,0.0158998707621920,0.0995598876677586,0.764399793100737;1.00035341888595,0.0213213179907070,0.0157787702964137,0.101478634149210,0.740046666124999;1.00035846772718,0.0209086002642612,0.0158016309918019,0.0998773975183862,0.755747911963838;1.00035972993748,0.0211787587483445,0.0153437400518977,0.100435664724624,0.724487220153877;1.00037613867147,0.0211827104611509,0.0159104779386944,0.101078050527592,0.751106803252315;1.00038497414362,0.0211750532603501,0.0154457343765596,0.100533867119515,0.729430721455680;1.00037613867147,0.0211356470900278,0.0157067508556498,0.100667251628148,0.743140287531606;1.00036099214779,0.0210122507476510,0.0158929160813368,0.100386845382451,0.756364288252821;1.00035341888595,0.0211729086115388,0.0159930365455740,0.101130731257479,0.755353779634138;1.00035720551687,0.0209892056594156,0.0160882011632568,0.100512009990319,0.766498810117657;1.00036730319932,0.0209657545619737,0.0160842019613877,0.100415166098033,0.767165422729892;0.627200000000000,0,0,0,0;0.626600000000000,0,0,0,0;0.626300000000000,0,0,0,0;0.626300000000000,0,0,0,0;0.626000000000000,0,0,0,0;0.625800000000000,0,0,0,0;0.625900000000000,0,0,0,0;0.625700000000000,0,0,0,0;0.625300000000000,0,0,0,0;0.624800000000000,0,0,0,0;0.624600000000000,0,0,0,0;0.625000000000000,0,0,0,0;0.625700000000000,0,0,0,0;0.626400000000000,0,0,0,0;0.625800000000000,0,0,0,0;0.625800000000000,0,0,0,0;0.625400000000000,0,0,0,0;0.625100000000000,0,0,0,0;0.625000000000000,0,0,0,0;0.624400000000000,0,0,0,0;0.623900000000000,0,0,0,0;0.623700000000000,0,0,0,0;0.623400000000000,0,0,0,0;0.623100000000000,0,0,0,0;0.622400000000000,0,0,0,0;0.622000000000000,0,0,0,0;0.621700000000000,0,0,0,0;0.621400000000000,0,0,0,0;0.620800000000000,0,0,0,0;0.620400000000000,0,0,0,0;0.619600000000000,0,0,0,0;0.619200000000000,0,0,0,0];
%     XRH = [0.501100000000000;0.512000000000000;0.515200000000000;0.518000000000000;0.519900000000000;0.522000000000000;0.524200000000000;0.526300000000000;0.528500000000000;0.532300000000000;0.536300000000000;0.540100000000000;0.545100000000000;0.548200000000000;0.551600000000000;0.554900000000000;0.558700000000000;0.561100000000000;0.564100000000000;0.567500000000000;0.570700000000000;0.575700000000000;0.580100000000000;0.584300000000000;0.589300000000000;0.592700000000000;0.596700000000000;0.600400000000000;0.604000000000000;0.609100000000000;0.613400000000000;0.617900000000000;0.622300000000000;0.626100000000000;0.629700000000000;0.632900000000000;0.636200000000000;0.639100000000000;0.642900000000000;0.645300000000000;0.648000000000000;0.650800000000000;0.652800000000000;0.656200000000000;0.661000000000000;0.664700000000000;0.667600000000000;0.670800000000000;0.674300000000000;0.678000000000000;0.678400000000000;0.680300000000000;0.681900000000000;0.684400000000000;0.686000000000000;0.687200000000000;0.688200000000000;0.689000000000000;0.689400000000000;0.690000000000000;0.690300000000000;0.690500000000000;0.690700000000000;0.690600000000000;0.690800000000000;0.690900000000000;0.690900000000000;0.691000000000000;0.691000000000000;0.692700000000000;0.690900000000000;0.690100000000000;0.688900000000000;0.687600000000000;0.686600000000000;0.685600000000000;0.684800000000000;0.684200000000000;0.683200000000000;0.683700000000000;0.683200000000000;0.683100000000000;0.681800000000000;0.680900000000000;0.680000000000000;0.679200000000000;0.678100000000000;0.677300000000000;0.675900000000000;0.674700000000000;0.673700000000000;0.672900000000000;0.671800000000000;0.670800000000000;0.669700000000000;0.668700000000000;0.667500000000000;0.666500000000000;0.665500000000000;0.664300000000000;0.663100000000000;0.662200000000000;0.661500000000000;0.660700000000000;0.659900000000000;0.658900000000000;0.658100000000000;0.657000000000000;0.656500000000000;0.655600000000000;0.655100000000000;0.654400000000000;0.653400000000000;0.653200000000000;0.653000000000000;0.652500000000000;0.651900000000000;0.651700000000000;0.651000000000000;0.650400000000000;0.650000000000000;0.649700000000000;0.649400000000000;0.648800000000000;0.648700000000000;0.648300000000000;0.647900000000000;0.647300000000000;0.646900000000000;0.646400000000000;0.645600000000000;0.645100000000000;0.644500000000000;0.644100000000000;0.643400000000000;0.642800000000000;0.642300000000000;0.641600000000000;0.640800000000000;0.640000000000000;0.639300000000000;0.638600000000000;0.638000000000000;0.637400000000000;0.636900000000000;0.636300000000000;0.636000000000000;0.635500000000000;0.634800000000000;0.634400000000000;0.634000000000000;0.633500000000000;0.633100000000000;0.632900000000000;0.632900000000000;0.632400000000000;0.632100000000000;0.631900000000000;0.632500000000000;0.632800000000000;0.632800000000000;0.632800000000000;0.632500000000000;0.632900000000000;0.633100000000000;0.632900000000000;0.633400000000000;0.632800000000000;0.632600000000000;0.632500000000000;0.632700000000000;0.632200000000000;0.632000000000000;0.631600000000000;0.631000000000000;0.630400000000000;0.629900000000000;0.629500000000000;0.629300000000000;0.628600000000000;0.628300000000000;0.627700000000000;0.627100000000000;0.626600000000000;0.626200000000000;0.625600000000000;0.626200000000000;0.626100000000000;0.625500000000000;0.624900000000000;0.624300000000000;0.623600000000000;0.623300000000000;0.623500000000000;0.623800000000000;0.624000000000000;0.624300000000000;0.624800000000000;0.625100000000000;0.625400000000000;0.625600000000000;0.625600000000000;0.625500000000000;0.625900000000000;0.626900000000000;0.627300000000000;0.627600000000000;0.628200000000000;0.629000000000000;0.629700000000000;0.630600000000000;0.631500000000000;0.632500000000000;0.633000000000000;0.633400000000000;0.634100000000000;0.635500000000000;0.635700000000000;0.637500000000000;0.638800000000000;0.638400000000000;0.638500000000000;0.638700000000000;0.639600000000000;0.639800000000000;0.640900000000000;0.641200000000000;0.641500000000000;0.641300000000000;0.641600000000000;0.642200000000000;0.642400000000000;0.643300000000000;0.643600000000000;0.643700000000000;0.644500000000000;0.644800000000000;0.644100000000000;0.643100000000000;0.643100000000000;0.643700000000000;0.643200000000000;0.641800000000000;0.641700000000000;0.641000000000000;0.640200000000000;0.640900000000000;0.640500000000000;0.641100000000000;0.640600000000000;0.640500000000000;0.640600000000000;0.641400000000000;0.641600000000000;0.641800000000000;0.641800000000000;0.642300000000000;0.642600000000000;0.642300000000000;0.642200000000000;0.642700000000000;0.642800000000000;0.643000000000000;0.643100000000000;0.643900000000000;0.644300000000000;0.644400000000000;0.644800000000000;0.645400000000000;0.646000000000000;0.646400000000000;0.646900000000000;0.647200000000000;0.647400000000000;0.646900000000000;0.647400000000000;0.647300000000000;0.647500000000000;0.647600000000000;0.647900000000000;0.647200000000000;0.646600000000000;0.646600000000000;0.646400000000000;0.646300000000000;0.645500000000000;0.645100000000000;0.644600000000000;0.643900000000000;0.644000000000000;0.643500000000000;0.643200000000000;0.642700000000000;0.641400000000000;0.640700000000000;0.639600000000000;0.638600000000000;0.637600000000000;0.636700000000000;0.635800000000000;0.635100000000000;0.634200000000000;0.633400000000000;0.632600000000000;0.631900000000000;0.631200000000000;0.630500000000000;0.629500000000000;0.629100000000000;0.628500000000000;0.628200000000000;0.628200000000000;0.628800000000000;0.628700000000000;0.628900000000000;0.628300000000000;0.627500000000000;0.627100000000000;0.626800000000000;0.626200000000000;0.626100000000000;0.627200000000000;0.626600000000000;0.626300000000000;0.626300000000000;0.626000000000000;0.625800000000000;0.625900000000000;0.625700000000000;0.625300000000000;0.624800000000000;0.624600000000000;0.625000000000000;0.625700000000000;0.626400000000000;0.625800000000000;0.625800000000000;0.625400000000000;0.625100000000000;0.625000000000000;0.624400000000000;0.623900000000000;0.623700000000000;0.623400000000000;0.623100000000000;0.622400000000000;0.622000000000000;0.621700000000000;0.621400000000000;0.620800000000000;0.620400000000000;0.619600000000000;0.619200000000000];
%     XWVP_Calcs = [1.00053072171789,0.0110963929954605,0.0238803272355700,2.15208016202557,0.0701425267176502;1.00050807935883,0.0123251545501423,0.0204523821803254,1.65940168110016,0.0711937687735506;1.00050301846464,0.0126808480435919,0.0203322367655964,1.60338146910222,0.0724626760025455;1.00048153400848,0.0129095631933970,0.0201851806991695,1.56358355405037,0.0732013983984591;1.00046085912072,0.0129224913979662,0.0200178858214555,1.54907325568860,0.0730673203179148;1.00044680900005,0.0124943598063455,0.0197474471709974,1.58050892379203,0.0710809485679307;1.00040412294709,0.0118930578906780,0.0200352233760287,1.68461497120372,0.0690294982010496;1.00037398244756,0.0110032781944394,0.0198561709868700,1.80456865999303,0.0653248444757637;1.00035189300403,0.00985997716547104,0.0197635502259769,2.00442150060828,0.0607166565590518;1.00031821198328,0.00920120648673944,0.0192856227824748,2.09598847827932,0.0575918535616573;1.00027800271890,0.00864845184778051,0.0191069149840269,2.20928731758279,0.0552157967044368;1.00026395538744,0.00807448205248378,0.0191802773434222,2.37541890845150,0.0530349205106636;1.00023263025177,0.00775082013153327,0.0191699733956754,2.47328322298239,0.0517479727139896;1.00021272994547,0.00792261649702320,0.0196348380066838,2.47832745836698,0.0529391624501607;1.00017430434951,0.00745151918073440,0.0196449908061118,2.63637391646298,0.0510937969228339;1.00014192334854,0.00667859669521552,0.0197376509599625,2.95535901637875,0.0481501915375629;1.00011086597807,0.00603562670027170,0.0195889860288287,3.24555957510541,0.0454518233736553;1.00007759650690,0.00530279025805556,0.0197762487930986,3.72940430051070,0.0427708275721641;1.00004309511556,0.00500798954967328,0.0192579486806316,3.84544506125976,0.0410357780560409;1.00000715032660,0.00480528894727694,0.0194646246389816,4.05066684907924,0.0404655185919321;0.999989902419389,0.00505605868610218,0.0196455666569873,3.88554957065431,0.0416539240045567;0.999964551261468,0.00516832032277012,0.0195095334427992,3.77483054926876,0.0419458943797730;0.999945285136706,0.00541610569534849,0.0194816103624229,3.59697750713290,0.0428915336062081;0.999903182438863,0.00531632900987517,0.0193348044825725,3.63687131602610,0.0423359463856432;0.999892271251321,0.00553024982616866,0.0191050187305791,3.45463936189208,0.0429248652809511;0.999870627375329,0.00585576044466380,0.0184719256563299,3.15448793216309,0.0435075016883209;0.999866762311856,0.00643088906205644,0.0182296131175192,2.83469562942357,0.0455060859015407;0.999871945914209,0.00668088699867440,0.0180833927015027,2.70673530402336,0.0463296079896378;0.999833398954346,0.00681029416479356,0.0179467096693425,2.63523266911431,0.0466884301977442;0.999798295995362,0.00698403693208124,0.0174562361471286,2.49944785757693,0.0468306867280564;0.999761115616466,0.00692301280201143,0.0170968873408503,2.46957326669726,0.0461927508517075;0.999726514981370,0.00697741515893080,0.0166570901706505,2.38728666579774,0.0459207348700858;0.999692023080315,0.00697958805972046,0.0164981266950577,2.36376796938334,0.0457534846680921;0.999663518060808,0.00712486355994933,0.0164636896685700,2.31073753624092,0.0462879280631988;0.999628769657879,0.00755363152905859,0.0159068361491575,2.10585280576162,0.0473618226369881;0.999644928642037,0.00744901849164183,0.0155104067902831,2.08220812012839,0.0465110917856136;0.999615197432459,0.00768043156195762,0.0153406840489641,1.99737266392020,0.0472353773438292;0.999621573787089,0.00776720477275594,0.0151271887543363,1.94757177091507,0.0473412247717271;0.999607454020441,0.00818371826648775,0.0142691949803412,1.74360779729838,0.0480337633364856;0.999619004192536,0.00839448757583963,0.0141792388650338,1.68911309200616,0.0487649137211113;0.999611829399144,0.00857033822434984,0.0137914025555297,1.60920166678439,0.0490289941685785;0.999617176859357,0.00886637777445335,0.0136092660182289,1.53492963693034,0.0499942430252818;0.999637851062129,0.00888421432086633,0.0134259786192515,1.51121732708743,0.0498618209914263;0.999669040867710,0.00948757821159141,0.0129569806776689,1.36567840482609,0.0517209663613835;0.999680989175961,0.00999714949395866,0.0124941338705277,1.24976963464215,0.0532172782164947;0.999701342852209,0.0102912257768797,0.0120136671504661,1.16736989460050,0.0538448366550985;0.999728206768908,0.0104615976570521,0.0114737220313665,1.09674663540823,0.0539190929331336;0.999736425057559,0.0109003272406987,0.0111489150264171,1.02280553420363,0.0552888896748108;0.999758737798345,0.0111954783355822,0.0108419232037792,0.968419827969364,0.0561125471839091;0.999755299120288,0.0114073762234986,0.0105665715631449,0.926292896466263,0.0566430978456464;0.999754486710255,0.0113600879983403,0.0105541094565480,0.929051734290262,0.0564429518604012;0.999773393285640,0.0115671221790227,0.0101076919499436,0.873829444654275,0.0567651358041661;0.999786306195760,0.0115628238593041,0.00993529763941143,0.859244918049747,0.0565575280187066;0.999785233863297,0.0116955968966953,0.00971969694550598,0.831056083016371,0.0568423321916057;0.999789999972075,0.0118335501729672,0.00956388252689039,0.808200614954783,0.0572136753064046;0.999817211996375,0.0121643560681305,0.00944380345112576,0.776350461810934,0.0583845738814475;0.999826849940472,0.0126681664645432,0.00936078594714876,0.738921924759083,0.0602782732943114;0.999835477711469,0.0123515786432763,0.00944576608188070,0.764741605480738,0.0591245887197119;0.999847289772508,0.0123929823348486,0.00986033511904624,0.795638600348794,0.0597462740233033;0.999844469379754,0.0125874622641601,0.00995537988791944,0.790896503123198,0.0606178389390939;0.999856438055055,0.0120902912452424,0.00975351774539513,0.806723142358806,0.0584352284239074;0.999864932262099,0.0117438409910654,0.0100717806889414,0.857622365340597,0.0574218667877580;0.999854786014139,0.0119847006061765,0.0100593024055929,0.839345323354070,0.0583572935495273;0.999852476235846,0.0114831098593072,0.0102773844860352,0.895000101188204,0.0566217231970847;0.999848981781575,0.0115598470762907,0.0101307477304263,0.876373853699544,0.0567619643175131;0.999854099680911,0.0120279905037750,0.0103433611768919,0.859940916451970,0.0588420680370199;0.999848433672483,0.0118916569411128,0.0105387101555986,0.886227227020264,0.0585208334370175;0.999852451281528,0.0122269418812634,0.0108088315318128,0.884017576658010,0.0601409456282442;0.999850651950133,0.0121552995141436,0.0107109078130178,0.881171854346730,0.0597502994264375;0.999864975257760,0.0126449380740983,0.0108379844411176,0.857100634072534,0.0618205117418975;0.999868844980590,0.0127556181432658,0.0110761684854039,0.868336474250085,0.0625201334474673;0.999881608436063,0.0128491346326434,0.0110234667195424,0.857915107491921,0.0628303937790616;0.999891255574452,0.0127914114259035,0.0109679564634029,0.857446930460863,0.0625415122780092;0.999924566772109,0.0132041694796165,0.0111011622671533,0.840731579846077,0.0643155173866402;0.999914160042363,0.0135660602848450,0.0110406975488026,0.813847006203891,0.0656748550715499;0.999925443859614,0.0139249404035667,0.0110891582560981,0.796352295573033,0.0671427991617010;0.999937088737360,0.0141595859303090,0.0111462785854614,0.787189585932908,0.0681307122668682;0.999933661619020,0.0144687609797149,0.0110320955826806,0.762476869867953,0.0692228847355014;0.999926312957771,0.0145844515686669,0.0110250613878923,0.755946244257719,0.0696710415271250;0.999952041340458,0.0143592262681261,0.0110467061413958,0.769310681169268,0.0688073677150689;0.999934886168201,0.0144197199627173,0.0110618634394885,0.767134415098862,0.0690625373371430;0.999942123694829,0.0143602213798916,0.0108195866520220,0.753441494096497,0.0685600952952893;0.999958522378735,0.0145970760045252,0.0110041351757186,0.753858866824234,0.0696976500381786;0.999956918838793,0.0147114411790582,0.0107152158563657,0.728359358267279,0.0698288184238088;0.999973883131049,0.0145068718583239,0.0106221776847124,0.732216965066626,0.0689197105129464;0.999966680262498,0.0146384121374787,0.0106047955147208,0.724449852560810,0.0694188860730848;0.999988213937454,0.0146417400639366,0.0106153701598371,0.725007418072073,0.0694436969887542;1.00000036096543,0.0145995940414241,0.0102873632809737,0.704633515958378,0.0689148239060095;1.00001125646243,0.0142220425125485,0.0105789689746490,0.743843155110450,0.0677494092279153;0.999999629616834,0.0145391265924032,0.0104408062077022,0.718117841628642,0.0688462295663797;1.00002843942019,0.0141090344424945,0.0104089176307791,0.737748403209562,0.0671159676375126;1.00004527588156,0.0141157784847182,0.0103231238323645,0.731318066767645,0.0670476579668697;1.00006713095415,0.0144048816310143,0.0104152376492549,0.723035281791585,0.0682888913479034;1.00008601874686,0.0148487313450968,0.0103345630706756,0.695989632413153,0.0699488769871938;1.00010495217239,0.0144514180962889,0.0104346820504316,0.722052464395252,0.0684937970652521;1.00009666081276,0.0147356882388752,0.0102562035433342,0.696011165347310,0.0694167084683348;1.00008447058466,0.0146796517480319,0.0103399678359500,0.704374191801673,0.0692885119655543;1.00009082160628,0.0145430582711221,0.0103802312691029,0.713758487079350,0.0687947284301199;1.00008551896298,0.0147196203555639,0.0101034853715936,0.686395785185763,0.0691844786422598;1.00009101753452,0.0145125364379578,0.0102328298592009,0.705102784957477,0.0685114159262681;1.00010340270229,0.0148744091859038,0.0100605127541850,0.676363856099853,0.0697469737077756;1.00011270820229,0.0143956989802358,0.0102151792944985,0.709599395522455,0.0680314379808245;1.00011432397362,0.0147697118013800,0.0103902920209817,0.703486443114678,0.0696990971844445;1.00011666726506,0.0148573940740852,0.0103379675485962,0.695812973462693,0.0699867821547171;1.00013500892146,0.0154322257175960,0.0103353770311446,0.669726922109497,0.0722493285494920;1.00013435601691,0.0152326550682199,0.0104008501496809,0.682799558126954,0.0715352338894017;1.00013604167917,0.0149113439138847,0.0105146125498792,0.705141844397304,0.0703947678447859;1.00011052165945,0.0146475555227332,0.0105217837988028,0.718330357749651,0.0693631091965674;1.00011281194079,0.0142773566106166,0.0105172883558834,0.736641147428004,0.0678991833240471;1.00010715141296,0.0141489906977287,0.0105973397122566,0.748982025548848,0.0674818300615046;1.00011684108019,0.0142775497644768,0.0106055793850807,0.742815088024966,0.0679975944217024;1.00011543818687,0.0148604334855859,0.0105399041942951,0.709259538392233,0.0702221024055845;1.00013320204027,0.0149211632638295,0.0107869141074392,0.722927154988505,0.0707346314255798;1.00013125024718,0.0152150433198709,0.0108629950494057,0.713964122285382,0.0719769582482537;1.00013915592160,0.0151763341031419,0.0107545759490444,0.708641222310595,0.0717044937001252;1.00016240823663,0.0152914715142320,0.0110056467261066,0.719724502371366,0.0724359345166623;1.00015220947908,0.0154027058632350,0.0110916689689769,0.720111717217935,0.0729694496866975;1.00016867808374,0.0152967803166613,0.0110795451565873,0.724305698795933,0.0725385881711478;1.00015197417142,0.0155483771430395,0.0111106305002174,0.714584576769882,0.0735645116539592;1.00017234586977,0.0157651018684446,0.0112124299323383,0.711218362298125,0.0745312139687062;1.00018105760817,0.0159979197741243,0.0111660247045960,0.697967289638269,0.0753974251531071;1.00020031175717,0.0161997394167874,0.0111787153185120,0.690055255267120,0.0762068321838333;1.00021292298174,0.0166734138972439,0.0110533379289935,0.662931898477046,0.0779349159185050;1.00021857993967,0.0165921559912891,0.0112423395134875,0.677569540654618,0.0778237142635877;1.00022709970548,0.0166611097754628,0.0110528325083947,0.663391134045130,0.0778858663793835;1.00022756839749,0.0167739455349533,0.0110399003326110,0.658157635578714,0.0783162491211186;1.00023011790871,0.0169903606695865,0.0113071722586872,0.665505134268722,0.0794647439169483;1.00022798751417,0.0167671490103066,0.0114451852482749,0.682595785439712,0.0787377091342102;1.00024395671441,0.0165697397445506,0.0114189976821755,0.689147678733512,0.0779307557697601;1.00023793008660,0.0167749680783117,0.0117180470737126,0.698543628757352,0.0790703092601526;1.00024097234731,0.0163372944285154,0.0117535005050006,0.719427599008427,0.0773846489013100;1.00023642421507,0.0164491832474486,0.0119706404313840,0.727734638936603,0.0780657594953057;1.00024304295750,0.0166861197873026,0.0121950725530844,0.730851312859707,0.0792477483254709;1.00024610352788,0.0168660146679419,0.0121725001112444,0.721717628669046,0.0799317489293952;1.00024932981031,0.0165201701263595,0.0123593010501496,0.748134005619541,0.0787753774294483;1.00025562417335,0.0168189623721574,0.0123532740712723,0.734484910420051,0.0799462518314995;1.00027258143643,0.0165646454407661,0.0125085226898177,0.755133741591227,0.0791156937769975;1.00027628175155,0.0167587238077835,0.0126377690363668,0.754100919695166,0.0800235030806965;1.00027918534157,0.0165820784391506,0.0128934658164636,0.777554265213332,0.0796101443217014;1.00028353715328,0.0162562015075725,0.0129833312480984,0.798669433449779,0.0784252545017400;1.00026429427846,0.0165506555052313,0.0131102927246474,0.792131328001091,0.0797261170995764;1.00027234817002,0.0170829045947123,0.0132408517293608,0.775093700017461,0.0819681090204342;1.00028784756405,0.0175433413795613,0.0134423235230723,0.766235076445194,0.0840055181933692;1.00028431704014,0.0173176979571041,0.0134894166677368,0.778938211138116,0.0831683424834640;1.00027253180509,0.0177528105197046,0.0134894877320672,0.759850825709798,0.0848831996898223;1.00026136486658,0.0179921937422296,0.0138726409591215,0.771036659446421,0.0862503764389153;1.00026312236000,0.0179815945632291,0.0141042188380487,0.784369750327409,0.0864647302085675;1.00026115354933,0.0180836234080556,0.0142702351338597,0.789124768408021,0.0870504399091959;1.00024160439610,0.0182704004439620,0.0144861501231562,0.792875348714293,0.0880253301858651;1.00025647287697,0.0186309543340739,0.0146518988545591,0.786427715501530,0.0896295911637275;1.00024902785846,0.0185251954988172,0.0146604337724142,0.791378086852051,0.0892222352131285;1.00023464520539,0.0185887125308165,0.0150753810831947,0.810996515127264,0.0899314875619611;1.00025108448773,0.0188535422280240,0.0153812580093485,0.815828549527723,0.0913134812789822;1.00024184876548,0.0190894900309535,0.0156001693891905,0.817212474712258,0.0924854675564323;1.00025557516258,0.0189435954047385,0.0158429256037980,0.836320944641538,0.0921789852078752;1.00023375136382,0.0192215089506988,0.0159726783162848,0.830979417758148,0.0934177489925151;1.00022825054766,0.0194262439879518,0.0161752227184649,0.832647975002103,0.0944486238831403;1.00023631539850,0.0193357594954640,0.0161921772783387,0.837421321988270,0.0941107762414661;1.00025244481125,0.0195668451627677,0.0160336255068638,0.819428240653378,0.0948461265970587;1.00026500598652,0.0201582458318788,0.0159966494022907,0.793553642301214,0.0971359410623677;1.00027239692814,0.0207700385755361,0.0159261595570346,0.766785266147416,0.0994690544962680;1.00029966547866,0.0207294754882558,0.0160078365258048,0.772225835375043,0.0993995300967561;1.00029467014316,0.0208599528321184,0.0162431179145262,0.778674719221626,0.100173962524845;1.00027688663971,0.0211441400687679,0.0158696040544024,0.750543838755753,0.100880838095183;1.00029110162643,0.0211710906836962,0.0159394068167282,0.752885482135464,0.101064252323748;1.00028660335400,0.0212332792825644,0.0161708361529135,0.761579779445189,0.101565298437709;1.00030304892714,0.0216165970491643,0.0160224270896985,0.741209499962344,0.102911813331963;1.00031179655035,0.0214829267871169,0.0164257021151442,0.764593310674712,0.102831041007377;1.00030134699963,0.0217540765389130,0.0165117461321196,0.759018481091760,0.103994806861980;1.00030541596919,0.0217163537363321,0.0166873039196225,0.768421076679374,0.104040308209987;1.00030284720566,0.0218715357622719,0.0166842397941287,0.762828910391779,0.104648491651420;1.00029499981043,0.0220950607182970,0.0169933541023917,0.769101941789161,0.105871283928054;1.00029063475703,0.0218698795324146,0.0170614396403999,0.780134139061541,0.105059147479528;1.00029502487338,0.0218188575913020,0.0171845120086173,0.787599072806991,0.104994188048852;1.00029424965787,0.0217122441107091,0.0172860214989443,0.796141633762232,0.104686293818137;1.00030381757530,0.0216831735356570,0.0173251899737792,0.799015418351409,0.104615047015024;1.00032238218899,0.0215107649951642,0.0176034447018095,0.818355121529471,0.104243334686143;1.00033470772910,0.0215693644928275,0.0176111454761688,0.816488843796259,0.104482792362876;1.00032792576070,0.0214849682731477,0.0176037843826624,0.819353520045173,0.104142045491700;1.00033024162956,0.0215178396920112,0.0179239382427831,0.832980378110987,0.104625681922734;1.00034364239267,0.0216334115936200,0.0179492150950116,0.829698774848119,0.105109106985539;1.00035673055447,0.0217441906936331,0.0182132824259034,0.837616018113583,0.105837745886657;1.00033122021805,0.0215748366904484,0.0181581356170107,0.841634904474141,0.105109329389471;1.00034043152644,0.0217498489582641,0.0182896286625786,0.840908306888689,0.105944484045331;1.00032976113931,0.0216323108878376,0.0184752836641485,0.854059640689425,0.105686600941516;1.00033103332467,0.0219860570397415,0.0183934144988064,0.836594504669887,0.106990167229301;1.00033342301946,0.0218117707492364,0.0184636443968803,0.846499104045767,0.106380979225690;1.00032518316870,0.0217262987008743,0.0185403306066020,0.853358911329703,0.106128948831047;1.00031852306778,0.0215471078485687,0.0184297065585062,0.855321590629637,0.105300407484917;1.00030786901765,0.0218522215185344,0.0188304510156114,0.861717926465278,0.106946083827810;1.00031334505875,0.0219509221604733,0.0188569171704065,0.859048974460028,0.107364334624895;1.00030883789693,0.0217917702583903,0.0188718287827025,0.866007146685866,0.106753609221985;1.00030057675684,0.0215645342481339,0.0191926073235088,0.890007968763324,0.106212853171697;1.00029200145229,0.0215517835930869,0.0193008522936590,0.895557075835248,0.106282321777142;1.00029248989997,0.0216110441186615,0.0196436679994381,0.908964318964833,0.106895021679024;1.00026973530197,0.0214110667585129,0.0197373706125474,0.921830324250423,0.106210545992777;1.00025778600987,0.0211781532534965,0.0198229079582646,0.936007390304055,0.105387238173870;1.00025020983745,0.0214843404599902,0.0193764898136052,0.901888975818902,0.106100183486669;1.00026992655383,0.0215188144029496,0.0195606746384189,0.909003361994597,0.106439753712116;1.00027106029792,0.0214833635332124,0.0194710212166361,0.906330202276505,0.106200885149990;1.00026720339167,0.0213834125232601,0.0195979622814164,0.916503025889738,0.105947375037415;1.00025385872497,0.0211794495145561,0.0195131532956554,0.921324857015029,0.105049758081860;1.00027470615279,0.0211077872807146,0.0193768432817635,0.917995004595645,0.104616578342927;1.00025718932427,0.0208614088258592,0.0193094216197377,0.925604870741148,0.103571032494141;1.00024905139081,0.0209950379066502,0.0194261410795527,0.925272970019239,0.104226756424094;1.00025613464399,0.0210244482825365,0.0195987605506184,0.932189053774014,0.104533579850460;1.00024886962283,0.0212535843593421,0.0192987768731901,0.908024573497753,0.105104823181916;1.00026456061409,0.0214674123312217,0.0192511230633689,0.896760297251592,0.105894814105431;1.00027803853850,0.0216161078239790,0.0192748069900520,0.891687215247428,0.106507017465299;1.00026480198578,0.0213204915416516,0.0189530636656708,0.888959976773712,0.104986145579881;1.00025211501012,0.0218965749188757,0.0188018577702729,0.858666610642605,0.107089256449211;1.00025050120574,0.0220676050534023,0.0186557428838792,0.845390464381314,0.107601683145029;1.00025714851846,0.0217730988039914,0.0184350080089505,0.846687381291405,0.106196901244429;1.00025745742876,0.0214413368564545,0.0181001698420611,0.844171702689911,0.104519096396607;1.00026618595596,0.0211416025883146,0.0183276560020178,0.866900033971305,0.103589443338780;1.00026295545272,0.0212563178446214,0.0179687407118028,0.845336470933015,0.103644575852907;1.00025747361928,0.0212867055771157,0.0177111572996610,0.832029044395737,0.103479446652838;1.00025362584381,0.0207624341665607,0.0177612990837825,0.855453601504409,0.101468749837079;1.00023958277571,0.0209038477201891,0.0174687927611775,0.835673556132253,0.101702548659128;1.00024214348007,0.0207237704962722,0.0175623928669167,0.847451619389237,0.101096386036618;1.00023182990269,0.0204504881640613,0.0179495903521372,0.877709627669474,0.100447620784029;1.00021956908493,0.0201570825157586,0.0174722223744552,0.866803137844756,0.0987633401407522;1.00021949871468,0.0197239761720045,0.0174637824712728,0.885408820157686,0.0970471335070977;1.00023788184813,0.0195607391379837,0.0178480613337866,0.912443093682931,0.0968288287779617;1.00023477692255,0.0196034527762189,0.0174376979267325,0.889521765670092,0.0965433012980449;1.00023847866969,0.0199435464559853,0.0174502182225756,0.874980699199496,0.0978974579372066;1.00024973862651,0.0197920162544964,0.0172886917716015,0.873518470745688,0.0971216291583615;1.00027213224063,0.0199862491127481,0.0172641052075955,0.863799160623072,0.0978599081129410;1.00027500577218,0.0201082251693961,0.0176698739383202,0.878738615142081,0.0987893959683721;1.00026203019927,0.0201327145567300,0.0175098872902787,0.869723118605752,0.0987089634111213;1.00027702028113,0.0199781788319257,0.0176307381920599,0.882499768391575,0.0982335992170376;1.00024809583671,0.0203381036202635,0.0175993810676395,0.865340318657076,0.0996173818282678;1.00027537468945,0.0201348574122474,0.0174590403599546,0.867105239560069,0.0986611716997766;1.00028164464361,0.0203679149969737,0.0173429356191266,0.851483110652390,0.0994512397978273;1.00027792683142,0.0206428208121113,0.0174809967936328,0.846831784897178,0.100687339274288;1.00028597281128,0.0205738784894540,0.0175701113457532,0.854000929127652,0.100514198275341;1.00026835441063,0.0205373061360085,0.0174532794053142,0.849832947404580,0.100240850504287;1.00024636807970,0.0201753622801474,0.0171447091720407,0.849784451648294,0.0984731510903379;1.00025198147712,0.0197422135746107,0.0172749187983287,0.875024410664106,0.0969101238884924;1.00023355244350,0.0195117966645714,0.0172606028672031,0.884623961797642,0.0959862174262025;1.00021415556640,0.0194702034521054,0.0171004177411526,0.878286546066035,0.0956451338264620;1.00022562665368,0.0196848416955674,0.0175481926391816,0.891457137962813,0.0969862621811661;1.00022502486703,0.0193389106687178,0.0174788982160531,0.903820205567554,0.0955463083723717;1.00021013045239,0.0197193508541017,0.0174633564718733,0.885594896154552,0.0970284339739066;1.00022465365933,0.0191359872776579,0.0174855623771853,0.913752822024524,0.0947539578504168;1.00021416523784,0.0192991012011428,0.0177867485311624,0.921636108634383,0.0957299017091694;1.00022552648972,0.0196003537200896,0.0177329929395760,0.904728210154718,0.0968576842020442;1.00022003094422,0.0196641681875407,0.0177282244651590,0.901549676349477,0.0971039030855636;1.00022621993023,0.0190954885798123,0.0176809327273055,0.925921986934531,0.0948104320894402;1.00021124088412,0.0193829244308643,0.0175153852198346,0.903650286741256,0.0957601212351731;1.00021889151425,0.0192677492263251,0.0175240310305525,0.909500680370584,0.0953157780207383;1.00022508338500,0.0192874017548610,0.0175056709285498,0.907622040077938,0.0953729223628833;1.00021409995520,0.0195260624491201,0.0171764925821253,0.879670062865098,0.0959494129078127;1.00022143738111,0.0197353940694760,0.0171460117771884,0.868795004387955,0.0967406770533751;1.00021843378362,0.0200788549580711,0.0169903793627133,0.846182683135707,0.0979221269649190;1.00021367512194,0.0203821518335006,0.0168354140434664,0.825988059601996,0.0989460283078996;1.00021148316968,0.0202885237167650,0.0167749755401022,0.826820904974992,0.0985101949151237;1.00021866075667,0.0201818966271276,0.0168751198181256,0.836151335521300,0.0982007371263567;1.00021500436000,0.0207998547394609,0.0166204082458445,0.799063669147304,0.100354399048119;1.00022936535655,0.0208697903546715,0.0168194711364249,0.805924297780980,0.100850178864646;1.00024967179092,0.0206228453120938,0.0165614151435805,0.803061599548943,0.0995915585237618;1.00020523815117,0.0205658808485969,0.0165247571850327,0.803503497209072,0.0993265178709664;1.00020751303417,0.0205640428402986,0.0165183235519977,0.803262455747628,0.0993121586821263;1.00020024514179,0.0212758025049558,0.0164706651916265,0.774150126078208,0.102064493373970;1.00022889820404,0.0212338166296287,0.0165647755945632,0.780112962426617,0.102003113144954;1.00021252778473,0.0214217281356220,0.0162265262736323,0.757479796723277,0.102369568641124;1.00023285548867,0.0212215376617553,0.0160303907670545,0.755383093466592,0.101363692113340;1.00022897625273,0.0212426437126812,0.0161225948807098,0.758973087285039,0.101548848809742;1.00021894209330,0.0205072519598004,0.0160583475763913,0.783057018457170,0.0985796123930622;1.00022750226265,0.0208397353538502,0.0160105166860255,0.768268714269802,0.0998370284842680;1.00024761633009,0.0213291070472131,0.0161075104022486,0.755189158486279,0.101872917377954;1.00026116918968,0.0216724959953693,0.0160384605980316,0.740037538890698,0.103149844139174;1.00027035171029,0.0214821251569019,0.0160225349084054,0.745854276119308,0.102381978852047;1.00027623479806,0.0216097513905498,0.0158878891896024,0.735218508647461,0.102736035673857;1.00026430275993,0.0215069445635465,0.0159734122363600,0.742709508975736,0.102425462458351;1.00029236608752,0.0214270239081122,0.0157826191516533,0.736575420802046,0.101899478003599;1.00028622241985,0.0223062664487796,0.0156764556190268,0.702782586006652,0.105247155989284;1.00029798900205,0.0221968270145788,0.0154824493882358,0.697507322919035,0.104601284287844;1.00031360795417,0.0224453594306402,0.0154886102345314,0.690058463193418,0.105587564435545;1.00031226193292,0.0220228223536914,0.0155805911810475,0.707474770073507,0.104024076742136;1.00034775472698,0.0222701985126921,0.0157299619358805,0.706323382205855,0.105164190239603;1.00032944209484,0.0223669408768924,0.0158613330955660,0.709141817062366,0.105690748399529;1.00035897390244,0.0226104545722444,0.0155949269222999,0.689721954614906,0.106355790645279;1.00036393212530,0.0226154129623042,0.0156915665771709,0.693843910934806,0.106482215118792;1.00035518045531,0.0222968207534452,0.0155829849730557,0.698888202285426,0.105106551969527;1.00032025910423,0.0220677657090975,0.0156187131736760,0.707761419056442,0.104243361429639;1.00032701881896,0.0220553631330585,0.0155833101590957,0.706554231960847,0.104155327143344;1.00033428454925,0.0222792543378317,0.0152467178054754,0.684345964828160,0.104665411238250;1.00034881077309,0.0222560203337691,0.0152075014968753,0.683298328668445,0.104530472790928;1.00034106024055,0.0223977067719579,0.0154006367186065,0.687598818727648,0.105302466599065;1.00035835355234,0.0221402457820091,0.0154321768061742,0.697019218219983,0.104322696174527;1.00034802636329,0.0226169431721442,0.0152206188571516,0.672974183173339,0.105967377497430;1.00037421206904,0.0225921945905105,0.0153386237368727,0.678934650435218,0.106000356734183;1.00038132505223,0.0224844418664916,0.0154243307827965,0.686000162885220,0.105670495241616;1.00037795667625,0.0225478974887270,0.0154522123838650,0.685306130719746,0.105951410899628;1.00038296959740,0.0220131408998751,0.0155794707723722,0.707735022604639,0.103984682960651;1.00036228772722,0.0221722483340963,0.0154966892513610,0.698922771288392,0.104520168996679;1.00035613934058,0.0222631249655607,0.0156549036492411,0.703176381278818,0.105053298925335;1.00036129280851,0.0223722489871162,0.0153873957758527,0.687789403055277,0.105187492986318;1.00037956412721,0.0225867749059912,0.0155907680351594,0.690260920385933,0.106257869351398;1.00036840577593,0.0230911395982241,0.0156905529560177,0.679505352660221,0.108355932725957;1.00038547275687,0.0230484012747783,0.0158329097178820,0.686941776530408,0.108344947571879;1.00039208605663,0.0231229491628491,0.0159448829071286,0.689569604414767,0.108762583146072;1.00040192630753,0.0234964692945316,0.0159701282443947,0.679682042616992,0.110262547328050;1.00043436542632,0.0232968754870844,0.0158838898953419,0.681803442017268,0.109380568518848;1.00044337478564,0.0232978777953185,0.0159957782284738,0.686576621656419,0.109508267112042;1.00042028257211,0.0233951034606537,0.0158861364229567,0.679036809974971,0.109770169622227;1.00043461911879,0.0235575105427387,0.0161668766509413,0.686272712119173,0.110720714624874;1.00045557729404,0.0235775008996856,0.0161306897169628,0.684156042898421,0.110759473872622;1.00045085079435,0.0237002743018260,0.0160745341590714,0.678242536536086,0.111181215803429;1.00045629157135,0.0236605367440358,0.0161841989012867,0.684016557881607,0.111145899293068;1.00045446149354,0.0242173398582997,0.0160606471894290,0.663187917558369,0.113203612173067;1.00046234219282,0.0239301907358961,0.0160827814809590,0.672070760256594,0.112096438008107;1.00046474786228,0.0242587677275472,0.0156158869685925,0.643721360622114,0.112874974601527;1.00048827298883,0.0244500356612539,0.0161918247920987,0.662241356881045,0.114265748761063;1.00050434631199,0.0244390991160350,0.0157184572710099,0.643168440717878,0.113699103358031;1.00049942243062,0.0242394391675150,0.0159858501539302,0.659497525642175,0.113207980029423;1.00048070636340,0.0240637922121136,0.0161758698047855,0.672207840817486,0.112725917112032;1.00047035069549,0.0241198951790325,0.0162787415321457,0.674909298374434,0.113060795035120;1.00046861537446,0.0238907005498551,0.0163760182781048,0.685455758985856,0.112265127082563;1.00048376437783,0.0238130124887796,0.0163725263494522,0.687545364416481,0.111955096360775];
%     XWVP_Corr = [2.97911356520264,1.49283380752305,1.01486928231282,21.0302227550145,0.0483077778380902;2.98448751731340,1.52805760886446,1.01522546866330,21.0374006390941,0.0655835652756494;2.98807485272167,1.53945616412221,1.01534078546341,21.0402978926869,0.0687385711758725;2.99166595254119,1.54968296341634,1.01544427015166,21.0414268995206,0.0717919098997225;2.99346291514439,1.55630136958357,1.01550970704514,21.0429859455066,0.0739291066728862;2.99526082009774,1.56352614809102,1.01558282933481,21.0432824569490,0.0764733870489113;2.99705966781735,1.57105867786985,1.01565751698362,21.0421893053633,0.0786118918145323;2.99885945871943,1.57829973312403,1.01573081816540,21.0385277174146,0.0811568923714158;2.99885945871943,1.58489722393322,1.01579761375845,21.0341211880962,0.0842096221805756;3.00066019322036,1.59725142085120,1.01592271614002,21.0322416231604,0.0876741304028839;3.00066019322036,1.60925406162408,1.01604428807152,21.0294750479316,0.0894118973502941;3.00066019322036,1.62065657035831,1.01615980835985,21.0289191541029,0.0915559987332226;3.00066019322036,1.63565987132442,1.01631184876635,21.0288133563792,0.0942121083806406;3.00066019322036,1.64496191792340,1.01640613666926,21.0314757799604,0.0950339737785761;3.00066019322036,1.65516416258035,1.01650956932656,21.0308714326679,0.0979915224830800;3.00066019322036,1.66506634121798,1.01660997998049,21.0298990288704,0.0994244560420920;2.99885945871943,1.67546277958654,1.01671542390526,21.0292334703444,0.101874885475307;2.99885945871943,1.68266004228747,1.01678843360502,21.0280999165420,0.103407383697630;2.99885945871943,1.69165662066363,1.01687971047636,21.0275470930854,0.105653801918494;2.99705966781735,1.70083136148634,1.01697281181547,21.0275400407838,0.107290631646532;2.99705966781735,1.71042195242336,1.01707015124965,21.0283322051470,0.107606022002213;2.99705966781735,1.72540725076245,1.01722228142486,21.0301551684057,0.109147950796888;2.99705966781735,1.73859431330084,1.01735619363013,21.0310924415802,0.110586618247595;2.99705966781735,1.75118196390568,1.01748405181134,21.0310901057249,0.112330239319972;2.99705966781735,1.76616726224476,1.01763630584092,21.0319983509672,0.114077029884767;2.99705966781735,1.77635726511534,1.01773986461092,21.0327138160358,0.116531214497951;2.99705966781735,1.78834550378661,1.01786172544576,21.0329929084386,0.117359456943896;2.99885945871943,1.80051521901514,1.01798546084773,21.0341245847663,0.118697104734846;2.99885945871943,1.81131111306653,1.01809525312677,21.0339497391243,0.120440668444897;2.99885945871943,1.82660529630600,1.01825083273518,21.0345165772270,0.122902875511136;3.00066019322036,1.84060496252137,1.01839328559778,21.0352188320078,0.124753177485728;3.00066019322036,1.85410793339086,1.01853072213035,21.0359187103026,0.126501515688590;3.00246187173665,1.86843202278172,1.01867655676096,21.0370970442932,0.127945775529176;3.00246187173665,1.87984137789432,1.01879274614565,21.0390890006538,0.128673523838196;3.00426449468498,1.89178535230313,1.01891440833019,21.0404806405776,0.130115369943765;3.00606806248216,1.90254047674496,1.01902398566881,21.0403996464954,0.131555996549844;3.00606806248216,1.91246050135115,1.01912507558625,21.0411620480765,0.132791997348889;3.00787257554512,1.92233136303089,1.01922760741712,21.0421578006480,0.133314971050160;3.00967803429098,1.93492200824567,1.01935791604710,21.0428093325435,0.135982346000683;3.01148443913698,1.94331090857509,1.01944347457871,21.0429444248638,0.136707369941005;3.01329179050050,1.95261308024432,1.01954031963042,21.0429043810439,0.138453575405811;3.01510008879908,1.96222713779044,1.01963841948816,21.0432977013966,0.138364933524543;3.01690933445040,1.96943841352922,1.01971201424811,21.0423692412183,0.138884776340593;3.01871952787228,1.98088375418979,1.01982884162174,21.0436582324438,0.140634397259638;3.01871952787228,1.99537360792357,1.01997678401570,21.0447729938824,0.142286761370190;3.02053066948268,2.00774673600514,1.02010314847606,21.0460540871542,0.143936554249973;3.02234275969974,2.01771602637554,1.02020498576728,21.0468288563791,0.145889312964722;3.02415579894169,2.02860370993009,1.02031622776748,21.0487156523520,0.146721473552964;3.02415579894169,2.03918825522638,1.02042439579156,21.0499266910259,0.147757452510619;3.02596978762696,2.05160751601108,1.02055134280901,21.0507084378529,0.149714881990082;3.02596978762696,2.05281790392613,1.02056371682365,21.0503513359479,0.148798189912887;3.02596978762696,2.05856724652262,1.02062249749116,21.0508493220039,0.150643880629695;3.02596978762696,2.06340879818282,1.02067200225272,21.0499311056592,0.151059456333403;3.02778472617408,2.07221586659354,1.02075998665552,21.0503165968076,0.151787010015676;3.02778472617408,2.07706032215542,1.02080952959465,21.0495008240536,0.151692296097765;3.02596978762696,2.07944643805725,1.02083184638690,21.0494505893131,0.152308111480925;3.02596978762696,2.08247240784487,1.02086070303527,21.0492289219545,0.152108244752255;3.02596978762696,2.08489318367498,1.02088545908106,21.0480038640579,0.151703579219446;3.02415579894169,2.08485300779040,1.02088504821288,21.0461577999375,0.151090987135507;3.02415579894169,2.08666750126977,1.02090360488913,21.0455194533475,0.150787462442125;3.02234275969974,2.08632320702073,1.02090008376818,21.0437113367051,0.150991122389313;3.02234275969974,2.08692767557267,1.02090626572572,21.0427157678855,0.149869039808536;3.02053066948268,2.08628053341169,1.02089964734394,21.0425793511237,0.149357618406418;3.01871952787228,2.08472770594859,1.02088376678611,21.0417415823585,0.148436499690700;3.01690933445040,2.08408096823833,1.02087715283217,21.0418094356004,0.148639713452365;3.01690933445040,2.08438265917178,1.02088023810617,21.0423834678444,0.148129722549205;3.01510008879908,2.08313265135128,1.02086745489144,21.0418137199858,0.147209086995345;3.01329179050050,2.08218462723584,1.02085776012889,21.0420222375526,0.145982659698431;3.01148443913698,2.08093574744365,1.02084707728955,21.0419041265077,0.146185301467864;3.00967803429098,2.08480397435336,1.02089291856297,21.0423385695443,0.145375151603366;3.00787257554512,2.07813916244413,1.02082891052646,21.0413255037714,0.144243125057389;3.00606806248216,2.07448756991894,1.02078738331418,21.0407757810868,0.144033099785631;3.00426449468498,2.06963781038849,1.02073985668532,21.0398982219404,0.144230541749635;3.00426449468498,2.06573226654539,1.02069990905753,21.0396872254029,0.143510407213489;3.00246187173665,2.06149032113439,1.02065652410810,21.0400177192693,0.143402241637189;3.00246187173665,2.05848785926265,1.02062581833790,21.0391806192175,0.143295864894641;3.00066019322036,2.05485210031730,1.02058863839752,21.0391286039733,0.142678291647973;3.00066019322036,2.05305170420137,1.02056816742300,21.0398292259592,0.142777486622478;2.99885945871943,2.04882078219711,1.02052285466575,21.0401196946437,0.142669095082271;2.99885945871943,2.05032021192647,1.02053612567948,21.0405974103589,0.142466843144855;2.99885945871943,2.04882078219711,1.02051668925047,21.0407069439594,0.141953871474740;2.99885945871943,2.04852089625124,1.02051362461919,21.0401335014987,0.142973958809148;2.99885945871943,2.04462237895490,1.02047378608744,21.0403326163081,0.142458140537807;2.99885945871943,2.04192340544206,1.02044620738749,21.0399680823982,0.142964513654987;3.00066019322036,2.04044893138984,1.02043114151968,21.0391472327386,0.142656273584452;3.00066019322036,2.03804840323527,1.02040661437622,21.0387435752088,0.142754885351233;3.00066019322036,2.03474767702272,1.02037289147909,21.0378442019376,0.142648130228777;3.00246187173665,2.03356742572724,1.02036083361523,21.0368813427285,0.142850516706132;3.00246187173665,2.02936397910680,1.02031789203547,21.0349756939925,0.142130282360541;3.00426449468498,2.02697725456396,1.02029351133806,21.0353913232567,0.142535003533927;3.00606806248216,2.02518805369423,1.02027523518573,21.0340962761126,0.142940560449521;3.00606806248216,2.02278319924424,1.02025067134746,21.0330797402306,0.143039144122913;3.00787257554512,2.02068879625121,1.02022927950849,21.0336589639147,0.142730076203238;3.00967803429098,2.01889202540239,1.02021295184186,21.0339344707140,0.143033855848229;3.00967803429098,2.01558137956467,1.02017913712072,21.0324211625355,0.142519025455764;3.01148443913698,2.01377964445090,1.02016073525740,21.0335720234636,0.142720486862511;3.01329179050050,2.01137227015908,1.02013816484944,21.0332086828657,0.142513301629466;3.01329179050050,2.00835897836858,1.02010537576346,21.0320225848031,0.142406710456579;3.01510008879908,2.00654910909579,1.02008689349702,21.0319475527429,0.142608147710884;3.01510008879908,2.00293098898923,1.02005195476072,21.0308191720836,0.142399252884596;3.01690933445040,2.00051257967406,1.02002525369582,21.0314926958526,0.142293522890566;3.01690933445040,1.99779736127305,1.01999753067005,21.0301050878489,0.141983656269270;3.01690933445040,1.99568552473894,1.01997596935849,21.0291505530548,0.141980654934702;3.01690933445040,1.99327199727138,1.01994933218006,21.0289073511557,0.141364977440157;3.01690933445040,1.99085846980382,1.01992469550193,21.0294193266762,0.141769532674769;3.01690933445040,1.98784156046937,1.01989390132793,21.0274585318482,0.141459284114183;3.01690933445040,1.98542803300181,1.01986926732754,21.0266446844918,0.140945932744665;3.01690933445040,1.98210943273391,1.01983539751997,21.0249265552717,0.140941251937260;3.01510008879908,1.97941320829660,1.01980788136892,21.0235434359966,0.140835468417048;3.01510008879908,1.97669961821668,1.01978018949304,21.0225646503611,0.140321754074242;3.01329179050050,1.97400745195688,1.01975271773088,21.0232220287398,0.140317973959769;3.01329179050050,1.97189814770353,1.01973514419458,21.0242873619173,0.140213582326754;3.01148443913698,1.96770393253210,1.01969628336873,21.0241999401249,0.139800360449854;3.00967803429098,1.96592169199887,1.01968203266527,21.0246198951188,0.139798406678409;3.00967803429098,1.96531975639201,1.01967588774974,21.0239833563905,0.140001499388039;3.00787257554512,1.96263685554319,1.01964850000800,21.0237245622650,0.139283985101093;3.00606806248216,1.95965576993212,1.01961807004507,21.0236069480664,0.138668057526130;3.00606806248216,1.95905455631962,1.01961193327001,21.0233784520943,0.138769184118048;3.00426449468498,1.95577618603992,1.01957847122054,21.0231982873320,0.138764629933116;3.00246187173665,1.95280120137752,1.01954810770334,21.0226741615998,0.137842904161492;3.00246187173665,1.95160021662882,1.01953585063285,21.0224214257091,0.138147107760751;3.00066019322036,1.94952892753527,1.01951471205898,21.0222914111849,0.138144243483991;3.00066019322036,1.94862872947730,1.01950357306378,21.0237948822921,0.138652485936674;2.99885945871943,1.94566001681716,1.01947523017663,21.0239240392716,0.138342788734969;2.99885945871943,1.94536013087129,1.01947216999550,21.0240648257323,0.138648215119389;2.99885945871943,1.94416058708780,1.01945992945470,21.0230987732289,0.138850442391730;2.99705966781735,1.94179495877886,1.01943579066382,21.0233145929646,0.138745211109345;2.99705966781735,1.93999672297817,1.01941744229153,21.0224264949359,0.138233005174732;2.99705966781735,1.93879789911104,1.01940521041027,21.0216645464754,0.139148811221002;2.99705966781735,1.93729936927713,1.01938992097148,21.0211453773292,0.139044785220510;2.99705966781735,1.93490172154288,1.01936545882335,21.0198254436670,0.138531765854094;2.99705966781735,1.93340319170897,1.01935017057695,21.0199179324503,0.139243233300812;2.99705966781735,1.93160495590828,1.01933182528658,21.0194377028696,0.138425261873918;2.99885945871943,1.93156537736118,1.01933142152052,21.0199390426012,0.139240672179704;2.99885945871943,1.92946617574008,1.01930807433825,21.0186421468919,0.138931690532304;2.99885945871943,1.92766686006485,1.01928972134940,21.0181617701132,0.138725331075653;3.00066019322036,1.92732404210544,1.01928043665935,21.0165433234792,0.138825995473004;3.00066019322036,1.92522357997018,1.01925709312799,21.0155523746594,0.138822816084032;3.00066019322036,1.92282305181560,1.01923069648033,21.0153138845886,0.138615374721325;3.00246187173665,1.92157559791146,1.01921798057527,21.0145420888951,0.138715567156295;3.00246187173665,1.91947387460124,1.01919655740379,21.0148138171087,0.138406892495435;3.00246187173665,1.91737215129103,1.01917705297957,21.0147174085016,0.138302326089327;3.00426449468498,1.91672074760902,1.01917041291245,21.0148862460895,0.138301425032219;3.00426449468498,1.91491818891221,1.01915395470774,21.0136296459325,0.138299191653840;3.00426449468498,1.91341605666487,1.01914247147291,21.0139024477942,0.138501461873169;3.00426449468498,1.91161349796806,1.01912600658070,21.0133591296874,0.138804962096291;3.00426449468498,1.91071221861965,1.01911872959110,21.0137186448038,0.138803970970308;3.00426449468498,1.90921008637231,1.01910341201047,21.0131989832676,0.138801884715827;3.00426449468498,1.90710710122603,1.01908196817114,21.0127568263112,0.139002780458543;3.00426449468498,1.90590539542815,1.01906971495383,21.0128098944621,0.138695388205217;3.00246187173665,1.90356082668104,1.01904580935975,21.0120112569315,0.138997848396670;3.00246187173665,1.90205959574517,1.01903050316047,21.0110842355147,0.138588148429823;3.00066019322036,1.89971796832781,1.01900662939326,21.0106938901338,0.138686802260423;3.00066019322036,1.89911783628916,1.01900051100278,21.0103639361619,0.138787869598579;2.99885945871943,1.89797815142352,1.01898889203361,21.0099205715058,0.138888185984181;2.99885945871943,1.89647872169417,1.01897360590643,21.0110319590693,0.139293691927408;2.99705966781735,1.89444141602735,1.01895283706944,21.0107056050882,0.138985166976272;2.99526082009774,1.89270531221976,1.01893324529919,21.0092826914994,0.139186281307869;2.99526082009774,1.89450246871182,1.01895156344437,21.0084376496269,0.140309630286289;2.99346291514439,1.89426333270337,1.01894723055662,21.0092653679548,0.140410928370703;2.99166595254119,1.89312621476807,1.01893564124474,21.0095358803895,0.141020692748272;2.98986993187222,1.89198969288874,1.01892405827118,21.0082781258411,0.142139906128830;2.98986993187222,1.89109273190918,1.01891680907182,21.0087400112092,0.141833219822798;2.98807485272167,1.89115257428755,1.01891741900588,21.0086506955147,0.143463572596029;2.98628071467390,1.89061432046005,1.01891004138113,21.0072758871713,0.143666315834739;2.98628071467390,1.89001706431711,1.01890395465993,21.0070485044103,0.144480580770779;2.98448751731340,1.89037439346631,1.01890948757682,21.0077739239102,0.144888929133424;2.98448751731340,1.88858370095592,1.01889123682420,21.0063787404808,0.144988223000084;2.98448751731340,1.88798680345246,1.01888704261828,21.0063941576611,0.145700847094414;2.98448751731340,1.88768835470073,1.01888400061614,21.0049050031021,0.146107965688355;2.98269526022482,1.88715129114424,1.01887852652780,21.0056072543077,0.147126059230614;2.98448751731340,1.88679300844553,1.01887487471870,21.0057357421256,0.147431194371797;2.98448751731340,1.88619611094207,1.01886879087790,21.0047952189806,0.147735974677296;2.98448751731340,1.88500231593515,1.01885662341425,21.0031179777108,0.148141753044432;2.98448751731340,1.88321162342476,1.01883837276367,21.0018247969639,0.148444750911667;2.98448751731340,1.88142093091437,1.01882012276692,21.0010410726067,0.148645855911693;2.98448751731340,1.87992868715571,1.01880491493572,20.9989956237061,0.148541756597628;2.98628071467390,1.87986370988722,1.01880425274636,20.9980650512288,0.149866105578989;2.98628071467390,1.87926645374429,1.01879816609403,20.9982452417308,0.151087768031744;2.98807485272167,1.87830385242084,1.01878835635286,20.9972280244325,0.150984434411494;2.98986993187222,1.87853527819532,1.01879071476469,20.9966653568713,0.151901695571415;2.98986993187222,1.87674135623619,1.01877243356570,20.9953716971386,0.151898969844645;2.99166595254119,1.87607371883858,1.01876375322132,20.9945815500097,0.151999551980621;2.99346291514439,1.87570386262947,1.01875435747759,20.9939804217194,0.153424406236125;2.99526082009774,1.87563232554521,1.01875362879512,20.9925391503151,0.154544925488219;2.99705966781735,1.87496052818653,1.01874866044841,20.9919273977357,0.155359170718382;2.99885945871943,1.87788579305010,1.01877846091498,20.9918283093070,0.156076860212174;2.99885945871943,1.87758590710423,1.01877540581530,20.9913578491214,0.156891412495557;3.00066019322036,1.87691295085933,1.01876855011423,20.9906053296985,0.157297864137637;3.00246187173665,1.87623842364823,1.01876167850162,20.9905656238474,0.157398679328500;3.00426449468498,1.87556232403183,1.01875479096347,20.9896087091785,0.157601366162048;3.00426449468498,1.87345933888556,1.01873336810273,20.9883523429997,0.157394305371872;3.00606806248216,1.87368222334513,1.01873563855765,20.9869728899262,0.157802150412580;3.00606806248216,1.87428343695762,1.01874176298488,20.9867934367226,0.158516218320447;3.00787257554512,1.87631091262505,1.01876241696430,20.9866076657062,0.158519432079644;3.00787257554512,1.87691248714016,1.01877042237443,20.9855500534487,0.158520677721462;3.00787257554512,1.87781484891282,1.01877961608775,20.9844150203291,0.158623986224863;3.00787257554512,1.87931878520059,1.01879305983090,20.9844881705610,0.160561786229350;3.00787257554512,1.88022114697326,1.01880225305035,20.9840662456274,0.160257594404819;3.00787257554512,1.88112350874592,1.01881332778962,20.9838868244862,0.161278149789097;3.00787257554512,1.88172508326103,1.01882322251563,20.9831736793206,0.161891010057733;3.00787257554512,1.88172508326103,1.01882887297013,20.9821693414960,0.162706971013329;3.00787257554512,1.88142429600347,1.01882580657919,20.9823099561759,0.163215894213987;3.00606806248216,1.88149800030758,1.01882655795975,20.9815103693115,0.164540489110499;3.00606806248216,1.88450406837006,1.01885720434769,20.9819377234545,0.164952981383890;3.00426449468498,1.88457511751589,1.01885604188218,20.9806911568545,0.165767878014230;3.00426449468498,1.88547639686430,1.01886334233707,20.9803320590706,0.166482270137877;3.00246187173665,1.88614654782497,1.01887017341185,20.9804727238794,0.166992821422202;3.00066019322036,1.88741526153560,1.01888310608949,20.9802295907312,0.167911935883549;2.99885945871943,1.88838180115562,1.01889106874400,20.9790689945458,0.169034028304629;2.99885945871943,1.89108077466847,1.01891857964576,20.9797373386221,0.170159402800842;2.99705966781735,1.89264318022666,1.01893450607782,20.9797595866917,0.171079103570466;2.99526082009774,1.89450246871182,1.01895345944448,20.9791308811564,0.172305029992061;2.99346291514439,1.89486202528640,1.01895712480299,20.9774741197441,0.172407545516665;2.99166595254119,1.89492121433959,1.01895772818511,20.9772827501468,0.172509543381739;2.98986993187222,1.89587652380017,1.01896746685245,20.9762604791311,0.173835849845027;2.98807485272167,1.89892156890462,1.01899851005824,20.9758805298468,0.175267743730016;2.98628071467390,1.89837865031820,1.01899297504817,20.9743400026064,0.175164892410780;2.98628071467390,1.90375395560461,1.01904968448343,20.9748958457856,0.175989880510289;2.98448751731340,1.90649062605980,1.01907568223292,20.9749214144226,0.176605815730964;2.98448751731340,1.90529683105288,1.01906350982735,20.9747727846705,0.176196080849149;2.98448751731340,1.90559527980461,1.01906655290148,20.9737144452312,0.177827113481308;2.98269526022482,1.90504746270559,1.01906096720587,20.9724785172902,0.177826138777424;2.98269526022482,1.90773188843979,1.01908833894294,20.9719208359407,0.177321370976072;2.98269526022482,1.90832842749184,1.01909442175086,20.9715364674423,0.178749161575102;2.98269526022482,1.91160939227808,1.01912787849248,20.9719192219817,0.179366506614676;2.98269526022482,1.91250420085615,1.01913891852849,20.9711272682364,0.180285674687690;2.98269526022482,1.91339900943422,1.01914804456938,20.9706016538863,0.180287289084324;2.98269526022482,1.91280247038217,1.01914196052396,20.9708841217016,0.179980470228532;2.98269526022482,1.91369727896024,1.01915300333223,20.9701941118643,0.179982420388472;2.98448751731340,1.91663788361867,1.01918491873563,20.9700354584611,0.180395730616206;2.98448751731340,1.91723478112213,1.01919100814599,20.9705684263094,0.180294889341025;2.98628071467390,1.92107438374972,1.01923018062406,20.9704571203038,0.180709511024645;2.98628071467390,1.92197026796412,1.01923932106689,20.9710528788154,0.181220751285693;2.98807485272167,1.92342378269694,1.01925415119847,20.9712560863235,0.180815686422608;2.98986993187222,1.92697117109165,1.01928841591371,20.9715533708999,0.181331409191050;2.99166595254119,1.92902620619856,1.01930551848083,20.9712936677764,0.182557618359916;2.99346291514439,1.92808946364450,1.01929596275026,20.9706893488351,0.183167484506222;2.99346291514439,1.92509600072936,1.01926542757292,20.9699592007143,0.182448511535553;2.99526082009774,1.92625223340486,1.01927722164609,20.9696922086472,0.182960261285474;2.99705966781735,1.92920730817403,1.01930736592657,20.9692930625780,0.183067602920412;2.99885945871943,1.92886640384833,1.01930388832101,20.9690176601509,0.182455396009460;3.00066019322036,1.92582371200882,1.01927285051076,20.9672579532866,0.182449840241425;3.00246187173665,1.92667978309341,1.01928158290688,20.9668260167112,0.182655259656914;3.00426449468498,1.92573354109307,1.01927193072651,20.9674428869750,0.183061238758481;3.00606806248216,1.92448477360108,1.01925919290224,20.9676904867885,0.181631988175179;3.00606806248216,1.92658902124481,1.01928065707899,20.9690493896919,0.182553165682848;3.00787257554512,1.92654238463665,1.01928018135694,20.9671029706029,0.182349224444756;3.00967803429098,1.92950458778395,1.01931039853059,20.9666033115351,0.182354630297123;3.00967803429098,1.92799974876680,1.01929504757630,20.9668991286445,0.182351884011400;3.01148443913698,1.92885578326723,1.01930377997958,20.9666710326679,0.181945724726354;3.01148443913698,1.92915693171115,1.01930685202879,20.9668361541766,0.183169441309573;3.01148443913698,1.93156611926246,1.01933142908913,20.9674436300776,0.184295122379315;3.01329179050050,1.93332801278512,1.01934940360136,20.9677114272589,0.183584827588605;3.01329179050050,1.93393067114322,1.01935555195609,20.9685514459576,0.184197548238466;3.01329179050050,1.93393067114322,1.01935555195609,20.9691630592888,0.185114968235226;3.01329179050050,1.93543731703847,1.01937092316742,20.9687657008309,0.184608074185621;3.01148443913698,1.93517990058942,1.01936829690194,20.9678961831245,0.185525030036153;3.01148443913698,1.93427645525768,1.01936101743351,20.9688677452179,0.185727577376386;3.01148443913698,1.93397530681377,1.01935988256543,20.9679269764062,0.185523498626909;3.00967803429098,1.93432007263881,1.01936533919622,20.9678353445967,0.186441920538989;3.00787257554512,1.93346049156040,1.01935656697164,20.9675529686664,0.185828702158930;3.00787257554512,1.93406206607551,1.01936270616345,20.9675773118879,0.186237566416063;3.00606806248216,1.93320237098227,1.01935393282065,20.9672949149746,0.186032092739769;3.00426449468498,1.93444590812766,1.01936662338929,20.9686772531047,0.185830535443867;3.00246187173665,1.93448618395993,1.01936703441825,20.9679721511697,0.185932547077889;3.00066019322036,1.93362542851120,1.01935825017983,20.9671798479489,0.186236752307855;3.00066019322036,1.93482569258849,1.01937049923579,20.9678395469807,0.186442864310226;2.99885945871943,1.93546389465752,1.01937701239976,20.9671580172457,0.186545993269156;2.99705966781735,1.93610054541001,1.01938350981471,20.9678013517298,0.186139428892167;2.99526082009774,1.93613659411118,1.01938193726920,20.9685845114338,0.185731388970449;2.99346291514439,1.93647115980690,1.01938535140654,20.9688586169678,0.185630072491132;2.99166595254119,1.93620620448466,1.01938264761921,20.9685991232624,0.185323765337173;2.98986993187222,1.93564179389407,1.01937688803106,20.9679709606660,0.186240157443274;2.98986993187222,1.93414685892814,1.01936163312202,20.9674533040134,0.185625753391519;2.98807485272167,1.93447965965201,1.01936309077879,20.9654445606655,0.186033764067128;2.98628071467390,1.93301950660842,1.01935012947400,20.9689495783966,0.186031398629004;2.98628071467390,1.93361676275135,1.01935622392013,20.9684633329043,0.186338317732600;2.98628071467390,1.93391539082282,1.01935927117053,20.9687298876133,0.186644682551323;2.98448751731340,1.93364946246736,1.01935849545070,20.9665732778281,0.186542604667477;2.98448751731340,1.93156032120524,1.01933717582752,20.9678676404896,0.186538703176436;2.98448751731340,1.92976962869485,1.01931890257457,20.9671859621784,0.185617972158830;2.98448751731340,1.92976962869485,1.01931890257457,20.9681033491908,0.185006380817285;2.98448751731340,1.92917273119138,1.01931281163585,20.9677741917552,0.186126519404706;2.98448751731340,1.92887428243965,1.01930976619378,20.9675076835359,0.185718239400507;2.98628071467390,1.92764420132200,1.01929721434548,20.9665359802008,0.185104374125139;2.98628071467390,1.92644968903614,1.01928502574029,20.9653679089444,0.185204089177011;2.98628071467390,1.92495654867880,1.01926979039372,20.9643410488181,0.185507101851658;2.98807485272167,1.92402139766749,1.01926217698009,20.9644902347796,0.184894158904188;2.98807485272167,1.92432020515276,1.01926329756306,20.9647171359259,0.185607846486234;2.98986993187222,1.92398130115977,1.01925983964346,20.9632190479310,0.184893734911324;2.99166595254119,1.92423954067449,1.01925861877874,20.9630920124224,0.185505068617732;2.99346291514439,1.92389861556330,1.01925321401424,20.9624712260239,0.185198308986388;2.99346291514439,1.92000711377361,1.01921352196992,20.9621645063554,0.184273804772162;2.99526082009774,1.91906360743662,1.01920389897977,20.9619665903169,0.184577826105236;2.99705966781735,1.91691936353598,1.01918203012783,20.9594784495789,0.184268111047113;2.99885945871943,1.91507165033823,1.01916318630497,20.9608235037784,0.184366620402569;3.00066019322036,1.91322093919730,1.01914431260621,20.9593142753342,0.183547890700378;3.00246187173665,1.91166747373473,1.01913038500099,20.9592316718534,0.183239643223179;3.00426449468498,1.91011136572071,1.01911451510480,20.9598224978059,0.183338701267353;3.00606806248216,1.90915382648242,1.01910474993044,20.9625770641692,0.183336944512486;3.00606806248216,1.90644836522618,1.01907906928883,20.9622526394574,0.183128508751203;3.00787257554512,1.90518648935028,1.01906620010001,20.9617841095772,0.183024289537962;3.00967803429098,1.90392232449247,1.01905521482414,20.9612524302822,0.182410883453521;3.01148443913698,1.90295701709066,1.01904536964146,20.9619670625987,0.182307216628856;3.01148443913698,1.90084897798326,1.01902387038461,20.9607095994892,0.182201468024769;3.01329179050050,1.89988047391056,1.01901399320699,20.9613216430664,0.182403504784051;3.01329179050050,1.89686718212006,1.01898326372110,20.9599762431111,0.181684715921472;3.01329179050050,1.89566186540386,1.01897097244568,20.9597234177213,0.181376833095330;3.01510008879908,1.89499040581022,1.01896412533265,20.9600920580926,0.181273717896678;3.01510008879908,1.89408587578358,1.01895490166274,20.9595966407320,0.181373972495967;3.01510008879908,1.89408587578358,1.01895490166274,20.9607174911238,0.181883449946798;3.01510008879908,1.89589493583686,1.01897334916955,20.9606893817573,0.182396229501349;3.01329179050050,1.89445654868766,1.01895868146677,20.9599800777715,0.182699291586992;3.01329179050050,1.89505920704576,1.01896292920183,20.9602712462675,0.180967816226245;3.01329179050050,1.89325123197146,1.01894639078438,20.9596253637956,0.182493298589482;3.01148443913698,1.88970648555845,1.01891592525987,20.9592024741881,0.181570817881309;3.01148443913698,1.88850189178280,1.01890553177746,20.9588867886623,0.181365184656388;3.00967803429098,1.88646619189359,1.01888287751179,20.9581151255543,0.181361152197099;3.00787257554512,1.88352980680636,1.01885293117817,20.9564802855245,0.180438854111654;3.00606806248216,1.88209921392008,1.01883834210419,20.9564858587412,0.179723083547180;3.00606806248216,1.88540588878881,1.01887206394823,20.9565681601128,0.181461114589180;3.00426449468498,1.88247213236961,1.01884214505701,20.9561565448197,0.180742596533114;3.00246187173665,1.88044187026867,1.01882144116609,20.9544062268953,0.180840805806981;3.00066019322036,1.87931347901391,1.01880993459713,20.9544752108199,0.181144406371369;2.99885945871943,1.87728602115836,1.01878926060957,20.9544575122177,0.180733214832139;2.99705966781735,1.87555994012010,1.01877166042262,20.9542992659045,0.181035724057099;2.99526082009774,1.87473374729918,1.01876135853927,20.9536798701640,0.181033893412429;2.99526082009774,1.87413469513516,1.01875712820398,20.9540003643251,0.180523763117746;2.99346291514439,1.87181236083979,1.01873157519477,20.9524560533458,0.180213615651954;2.99166595254119,1.86919288714774,1.01870487131198,20.9517030882734,0.179699539299432;2.98986993187222,1.86747275944739,1.01868920663858,20.9519921264596,0.179798644971709;2.98986993187222,1.86866870742014,1.01870139922324,20.9523447688038,0.180921368502047;2.98807485272167,1.86963843534795,1.01871128572867,20.9526499826101,0.181432479988276;2.98807485272167,1.87173008774486,1.01873261105690,20.9524773581295,0.181741897812551;2.98807485272167,1.86993724283322,1.01871433214947,20.9512864407188,0.181738636855465;2.98807485272167,1.86993724283322,1.01871620526731,20.9531586531791,0.181738971019689;2.98628071467390,1.86761995895706,1.01869444910311,20.9518962124834,0.181225742495444;2.98628071467390,1.86672407474266,1.01868718447215,20.9521542727863,0.181224450117595;2.98628071467390,1.86642544667119,1.01868413914525,20.9510729529726,0.181835118837428;2.98807485272167,1.86575393803941,1.01867729135152,20.9510339834975,0.181120822402300;2.98807485272167,1.86425990061305,1.01866392438759,20.9507590664871,0.181016579363674;2.98807485272167,1.86366228564251,1.01865782977220,20.9506337191418,0.181422959482428;2.98986993187222,1.86388491552914,1.01866010019464,20.9494580225728,0.181423363844665;2.98986993187222,1.86298795454958,1.01865282026761,20.9506325544439,0.182338854827902;2.99166595254119,1.86201288886164,1.01864100922156,20.9492691315497,0.180706915035905;2.99166595254119,1.86081622248062,1.01862321280190,20.9496161684115,0.181722381163858;2.99346291514439,1.86103589434527,1.01861986175643,20.9489360768827,0.181110611420293;2.99526082009774,1.86125507360874,1.01862023252672,20.9491474261911,0.180805091273493;2.99705966781735,1.86057464178101,1.01861329869708,20.9492085463236,0.181211305838211;2.99705966781735,1.85937581791388,1.01860108250752,20.9481424224166,0.181514712902840;2.99885945871943,1.85809332062256,1.01858801399800,20.9483829546842,0.180901231286044;3.00066019322036,1.85800879164204,1.01858715266855,20.9478559469203,0.180188067307067];
%     S_TT = [20, 50; 100, 120; 200, 300];
%%END OF TESTING CODE%%
%% 
 
%% BEGIN FUNCTION:
%get the index of chosen value and whether tag = LHS or RHS:
value = get(hObject,'Value');
tag = get(hObject,'Tag');
% topaxes.NextPlot = 'replacechildren';
%if they chose not the "Select Left/Right Activity" option -> retrieve data
if (value~=1) 
    contents = get(hObject,'String'); %name of variable chosen 
    varname = char(contents(value)); 
    %PLOT THE GRAPHS
    handles = guihandles;
    topaxes = handles.topg; %top graph
    botaxes = handles.botg; %bottom graph
     
    %X AXIS: integer time vector
    data = guidata(hObject);
    TT = data.UserData.TT;
    xdata = TT{1,1}; %integer vec
    xlabels = TT{1,2};
    lenx = length(xdata);
     
    %Y AXIS: retrieve data and save to global Plotted
    ydata = retrieveYData(data,value);
    if (strcmp(tag, 'lhs'))
        yyaxis (topaxes, 'left');
        yyaxis(botaxes, 'left');
        data.UserData.Plotted{1,1} = ydata;
        leftSide = 1;
        plot(topaxes, 1:lenx, ydata, '-');
        set(handles.lmax,'String',topaxes.YLim(1,2));
        set(handles.lmin,'String', topaxes.YLim(1,1));
    else
        yyaxis (topaxes, 'right');
        yyaxis(botaxes, 'right');
        data.UserData.Plotted{1,2} = ydata;
        leftSide = 0;
        plot(topaxes, 1:lenx, ydata, '-');
        set(handles.rmax,'String', topaxes.YLim(1,2));
        set(handles.rmin,'String', topaxes.YLim(1,1));
    end
     
%     topaxes.NextPlot = 'addchildren';
    
    topaxes.YLabel.String = varname; %add ylabel

    topaxes.XTickLabelMode = 'manual';
    topaxes.XTickMode   =  'manual';
    indecesForGraph = [1:floor(lenx/5):lenx lenx];
    topaxes.XTick    = indecesForGraph;
    topaxes.XTickLabel = xlabels(indecesForGraph);    
    %enable zoom on graph
    h = zoom;
    h.Enable='on';
 
%     botaxes.NextPlot = 'addchildren';
    plot(botaxes,  1:lenx, ydata, '--');
    botaxes.YLabel.String = varname; %add ylabel
    botaxes.XTickLabelMode = 'manual';
    botaxes.XTickMode   =  'manual';    
    botaxes.XTick    = indecesForGraph;
    botaxes.XTickLabel = xlabels(indecesForGraph);   
    %enable zoom on graph
    h = zoom;
    h.Enable='on';
     
    %highlight selected interval
    try
    S_TT = data.UserData.S_TT;
    nrow = data.UserData.Selected_Act;
    starti = S_TT(nrow, 1); %S_TT(N,1) = index in TT of start time
    endi = S_TT(nrow, 2); %S_TT(N,2) = index in TT of end time

    catch
    end
    
    yldata = data.UserData.Plotted{1,1};
    yrdata = data.UserData.Plotted{1,2};
    

     
    %HIGHLIGHT LHS
    try
    if  (~isempty(yldata)&&leftSide)
        yyaxis (botaxes, 'left')
        data.UserData.botPlotL = plot(botaxes, 1:lenx, yldata, '--');
        hlydata = yldata(starti:endi);
        hold on
        data.UserData.botPlotLH = plot(botaxes, starti:endi, hlydata, '-', 'LineWidth', 4);
        botaxes.XTickLabelMode = 'manual';
        botaxes.XTickMode   =  'manual';    
        indecesForGraph = [1:floor(lenx):lenx lenx];
        botaxes.XTick    = indecesForGraph;
        botaxes.XTickLabel = xlabels(indecesForGraph); 
        botaxes.YLabel.String = varname;
        hold off
    end
    catch
    end
    %HIGHLIGHT RHS
    try
    if  (~isempty(yrdata)&&~leftSide) 
        yyaxis (botaxes, 'right')
        data.UserData.botPlotR = plot(botaxes, 1:lenx, yrdata, '--');
        hrydata = yrdata(starti:endi);
        hold on
        data.UserData.botPlotRH = plot(botaxes, starti:endi, hrydata,...
            '-', 'LineWidth', 4);
        botaxes.XTickLabelMode = 'manual';
        botaxes.XTickMode   =  'manual';    
        indecesForGraph = [1:floor(lenx/5):lenx lenx];
        botaxes.XTick    = indecesForGraph;
        botaxes.XTickLabel = xlabels(indecesForGraph);
        botaxes.YLabel.String = varname;
        hold off        
    end
    catch
    end
   
        OutAxes = data.UserData.OutAxes;
    try
    if(strcmp(tag,'lhs'))
        yyaxis(botaxes, 'left')
        a = botaxes.Children;
        Hlght = a(1,1);
        Line = a(2,1);
        b = cell(1,4);
        b{1,1} = Hlght.YData;
        b{1,2} = Hlght.XData;
        b{1,3} = Line.YData;
        b{1,4} = Line.XData;
        OutAxes{1,1} = b;
        OutAxes{1,3} = varname;
    else
        yyaxis(botaxes,'right')
        a = botaxes.Children;
        Hlght = a(1,1);
        Line = a(2,1);
        b = cell(1,5);
        b{1,1} = Hlght.YData;
        b{1,2} = Hlght.XData;
        b{1,3} = Line.YData;
        b{1,4} = Line.XData;
        b{1,5} = botaxes.XTickLabel;
        OutAxes{1,2} = b;
        OutAxes{1,4} = varname;
    end
    catch
    end
       
     
    data.UserData.OutAxes = OutAxes;
    guidata(hObject, data);
end
 
function AdjustYAxisCallback(hObject, ~, ~)
tag = get(hObject,'Tag');
ftag = tag(1); %should be either 'l' or 'r'
% extract guidata
data = guidata(hObject);
% get all handles
handles = guihandles;
topaxes = handles.topg; %top graph
botaxes = handles.botg; %bottom graph
if (strcmp(ftag, 'l')) 
    yyaxis (topaxes, 'left');
    yyaxis(botaxes, 'left');
    try
        lmin = str2double(handles.lmin.String);
        lmax = str2double(handles.lmax.String);
        topaxes.YLim = [lmin lmax];
        botaxes.YLim = [lmin lmax];
        data.UserData.OutAxes{1,1}{2,1} = lmin;
        data.UserData.OutAxes{1,1}{2,2} = lmax;
    catch
         disp('lmin lmax error');
    end
else  %ftag must be 'r'
    yyaxis (topaxes, 'right');
    yyaxis(botaxes, 'right');
    try
        rmin = str2double(handles.rmin.String);
        rmax = str2double(handles.rmax.String);
        topaxes.YLim = [rmin rmax];
        botaxes.YLim = [rmin rmax];
        data.UserData.OutAxes{1,2}{2,1} = rmin;
        data.UserData.OutAxes{1,2}{2,2} = rmax;
    catch
         disp('rmin rmax error');
    end
 
end
     guidata(hObject, data);
     
function AddGraph_button_Callback(hObject, ~)
try
    % extract guidata
    data      = guidata(hObject);
    % get all handles
    handles   = guihandles;
    axesData = handles.botg;
    axesDataOut = data.UserData.OutAxes;
    yyaxis left
    varnameL = axesData.YLabel.String;
    yyaxis right
    varnameR = axesData.YLabel.String;
     
    if (~isempty(varnameR))
        graphName = [varnameL,' vs ',varnameR];
    else
        graphName = varnameL;
    end
    
    Activities = data.UserData.Activity;
 
    SelAct = data.UserData.Selected_Act;
     
    ActivityName = Activities(SelAct,3);
    ActivityName = ActivityName{1,1};
     
    TableVect_tmp = data.UserData.TableVect; %Fetch TableVect from struct
     
    TableVect_tmp = [TableVect_tmp; 1]; %increase the size by one and set it to 1
     
    data.UserData.TableVect = TableVect_tmp; %update the struct
    
    if (isempty(handles.GraphTbl.Data))
        handles.GraphTbl.Data = logical(TableVect_tmp);
        handles.GraphTbl.Data = {handles.GraphTbl.Data graphName ActivityName};
    else
        handles.GraphTbl.Data = [handles.GraphTbl.Data; {true} {graphName} {ActivityName}];
    end
     
    %%
    GraphCell_tmp = data.UserData.GraphCell;
    if (isempty(GraphCell_tmp))
        GraphCell_tmp = {axesDataOut ActivityName};
    else
        GraphCell_tmp = [GraphCell_tmp; {axesDataOut} {ActivityName}];
    end
     
    data.UserData.GraphCell = GraphCell_tmp;
    %%
    guidata(hObject, data);
catch
   uiwait(msgbox('Please Select Data to Highlight','Error','error', 'modal'));
end
 
function cellEditCallback2(hObject, eventdata)
    %extract guidata
    data      = guidata(hObject);
    % get all handles
%     handles   = guihandles;
     
    TableVect_tmp = data.UserData.TableVect; %retrieve TableVect
     
    select   = eventdata.Indices(1,1);       %Get indices of what box user clicked
     
    if TableVect_tmp(select, 1) == 1 
        TableVect_tmp(select, 1) = 0;
    else
        TableVect_tmp(select, 1) = 1;
    end
    data.UserData.TableVect = TableVect_tmp;
     
    guidata(hObject, data);
 

function updateData(hObject,n)
data = guidata(hObject);
% get all handles
handles = guihandles;
Activities = data.UserData.Activity;
 
%*              This box is code for tab 4                     *
%Get the necessary data structures from the global struct      *                
S_TT      = data.UserData.S_TT(n,:);            %              *                      
TotMatrix = data.UserData.TotMatrix;            %              *
stringTT  = data.UserData.TT{1,2};              %              *                                                
%Just some labels to make the code more readable               *
startIdx  = S_TT(1,1);                          %              *
endIdx    = S_TT(1,2);                          %              *
 
%                                                              *
%Get the requested data                                        *
selectedData = TotMatrix(startIdx:endIdx, :);%                 *
selectedTime = stringTT(startIdx:endIdx);    %                 *
%Set the data of the uitable                                   *
set(handles.TableTag4, 'Data', selectedData);%                 *
set(handles.TableTag4, 'RowName', selectedTime);%                  *
%***************************************************************
 
%                 This box is for Tab 2                        *               
[~,SelectedMeans] = IMCA_Calculations(selectedData,0);%        *
handles.StatsTable.Data(3:4,:) = SelectedMeans;       %        *
%                                                              *
nameRow = Activities(n,3);%                                    *
stringRaw = ' Raw';%                                           *
stringWVP = ' WVP';%                                           *
nameRaw = strcat(nameRow,stringRaw);%                          *
nameWVP = strcat(nameRow,stringWVP);%                          *
 %                                                             *
set(handles.StatsTable, 'RowName', ['Overall Raw',...
    'Overall WVP',nameRaw,nameWVP]);%                          *
%***************************************************************