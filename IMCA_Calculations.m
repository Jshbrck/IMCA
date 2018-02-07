%Callback handle: IMCA_Calculations
%Description: performs all analytic calculations and all mean calculations
%Passed Vars: ctrl - (1:toggle analysis) or (0:mean calculations)
%              numData - if ctrl is 1, numData is a matrix corresponding to
%                        raw Excel sheet; if ctrl is 0, numData is a matrix
%                         containing data specified in Selected-Act
%
%return: calcStruct - Structure containing calculated vectors(see
%                     declaration for details
%        SelectedMeans - Matrix containing means for activities specified
%        in Selected_Act
%Authors: Logan Hart, Matthew Cabrera, Joshua Brock
function [calcStruct,SelectedMeans] = IMCA_Calculations(numData,ctrl)%function overloading
SelectedMeans = 0;
calcStruct = 0;

if ctrl
%define return structure
calcStruct = struct(...
                    'Raw_Calcs',[],'WVP_Corr',[],'WVP_Calcs',[],...
                    'Avg_Uncorr',[],'Avg_Corr',[],'Sums',[],...
                    'AmbientO2_c',[],'AmbientCO2_c',[],'RH',[]);
                  %Raw_Calcs = [Haldane,VO2,VCO2,RQ,EE]
                  %WVP_Corr = [Buck,PressRH,WVP_c,O2_c,CO2_c];
                  %WVP_Calcs = [Haldane_c,VO2_c,VCO2_c,RQ_c,EE_c]
                  %Avg_Uncorr = [A_VO2,A_VCO2,A_RQ,A_EE]
                  %Avg_Corr = [A_WVP_c,A_VO2_c,A_VCO2_c,A_RQ_c,A_EE_c]
                  %Sums = [S_VO2,S_VCO2,S_VO2_c,S_VCO2_c]
                             
          
          
%RH Calculation
tmp = numData(5:end-4,11);
calcStruct.RH = tmp/100;
 
%Haldane Calculations
RawO2 = numData(5:end-4, 7);
RawCO2 = numData(5:end-4, 8);
AmbientO2 = numData(1,5);
AmbientCO2 = numData(1,6);
  
Haldane = (100 - RawO2(16:end-17) - RawCO2(16:end-17))...
    ./(100-AmbientO2 - AmbientCO2);
%VO2
RawO2Top = numData(5:end-36, 7);
RawO2Mid = numData(21:end-20, 7);
RawO2Bottom = numData(37:end-4, 7);
Flow = numData(21:end-20, 3); 
   
VO2 = (Flow*15.*((AmbientO2*Haldane) ...
                  -RawO2Mid)-700*(RawO2Bottom-RawO2Top)/32)/100;
  
%VCO2
RawCO2Top = numData(5:end-36, 8);
RawCO2Mid = numData(21:end-20, 8);
RawCO2Bottom = numData(37:end-4, 8);
  
VCO2 = (Flow*15.*(RawCO2Mid-(AmbientCO2*Haldane)) ...
                   +700*(RawCO2Bottom-RawCO2Top)/32)/100;
  
%RQ
  
RQ = VCO2 ./ VO2;
  
%EE
  
EE = 3.941 * VO2 + 1.106 * VCO2;
  
%WVP Correction Calculations
  
%Buck
Temp = numData(5:end-4, 9);
Buck = 6.1121*exp((18.678-(Temp/234.5)).*(Temp./(257.14+Temp)))/10;
  
%Pressure of Water Vapor * RH
  
 
PressRH = Buck.*calcStruct.RH;
  
%WVP Correction
  
Pressure = numData(5:end-4, 10);
WVP_c = Pressure./(Pressure-PressRH);
  
%O2 Correction
  
O2_c = WVP_c.*RawO2;
  
%CO2 Correction
  
CO2_c = WVP_c.*RawCO2;
  
%Haldane Corrected
  
  
AmbientO2_c = AmbientO2 * WVP_c(1,1);
AmbientCO2_c = AmbientCO2 * WVP_c(1,1);
Haldane_c = (100 - O2_c(16:end-17)...
- CO2_c(16:end-17))./(100-AmbientO2_c - AmbientCO2_c);
  
%VO2 Corrected
  
O2CorrTop = O2_c(1:end-32);
O2CorrMid = O2_c(17:end-16);
O2CorrBottom = O2_c(33:end);
  
  
VO2_c = (Flow*15.*((AmbientO2_c*Haldane_c) ...
                   -O2CorrMid)-700*(O2CorrBottom-O2CorrTop)/32)/100;
  
%VCO2 Corrected
  
CO2CorrTop = CO2_c(1:end-32);
CO2CorrMid = CO2_c(17:end-16);
CO2CorrBottom = CO2_c(33:end);
  
VCO2_c = (Flow*15.*(CO2CorrMid-(AmbientCO2_c*Haldane_c))...
                     +700*(CO2CorrBottom-CO2CorrTop)/32)/100;
  
%RQ Corrected
  
RQ_c = VCO2_c./VO2_c;
  
%EE Corrected
  
EE_c = 3.941*VO2_c + 1.106*VCO2_c;
 
%Average Calulations
A_VO2 = mean(VO2); %VO2 Average
A_VCO2 = mean(VCO2); %VCO2 Average
A_RQ = mean(RQ); %RQ Average
A_EE = mean(EE); %EE Average
A_WVP_c = mean(WVP_c); %WVP_c average
A_VO2_c = mean(VO2_c); %VO2_c average
A_VCO2_c = mean(VCO2_c); %VCO2_c average
A_RQ_c = mean(RQ_c); %RQ_c average
A_EE_c = mean(EE_c); %EE_c average
 
%Sum Calculations
S_VO2 = sum(VO2); %VO2 Sum
S_VCO2 = sum(VCO2); %VCO2 Sum
S_VO2_c = sum(VO2_c); %VO2_c Sum
S_VCO2_c = sum(VCO2_c); %VCO2_c Sum
 
calcStruct.AmbientO2_c = AmbientO2_c;
calcStruct.AmbientCO2_c = AmbientCO2_c;
 
calcStruct.Raw_Calcs = [Haldane,VO2,VCO2,RQ,EE];
calcStruct.WVP_Corr = [Buck,PressRH,WVP_c,O2_c,CO2_c];
calcStruct.WVP_Calcs = [Haldane_c,VO2_c,VCO2_c,RQ_c,EE_c];
calcStruct.Avg_Uncorr = [A_VO2,A_VCO2,A_RQ,A_EE];
calcStruct.Avg_Corr = [A_WVP_c,A_VO2_c,A_VCO2_c,A_RQ_c,A_EE_c];
calcStruct.Sums = [S_VO2,S_VCO2,S_VO2_c,S_VCO2_c];

else
%Selected Averages
A_VO2 = IMCA_Average(numData(:,2));
A_VCO2 = IMCA_Average(numData(:,3));
A_RQ = IMCA_Average(numData(:,4));
A_EE = IMCA_Average(numData(:,5));
A_VO2_c = IMCA_Average(numData(:,12));
A_VCO2_c = IMCA_Average(numData(:,13));
A_RQ_c = IMCA_Average(numData(:,14));
A_EE_c = IMCA_Average(numData(:,15));

SelectedMeans = [A_VO2, A_VCO2, A_RQ, A_EE; A_VO2_c, A_VCO2_c, A_RQ_c, A_EE_c];
end
end

%Callback handle: IMCA_Average
%Description: performs mean calculations by throwing out all 0 values
%Passed Vars: Vector - Vector to be averaged
%return: rtrn - Average value without 0's
%Author: Joshua Brock
function [rtrn]=IMCA_Average(Vector)
rtrn = (sum(Vector)/(length(find(Vector))));
end