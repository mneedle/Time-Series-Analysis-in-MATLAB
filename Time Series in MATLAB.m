%% Time Series Analysis in MATLAB
%This is a MATLAB script where I analyze time series data over a period of one year from of an individual suffering from bipolar disorder.
%Author: Max Needle
%Version 1: 3/29/18
%Dependencies and Assumptions: none


%% Clearing all and starting the assignment

clear all %Clears the Workspace
close all %Closes all figuresg
clc %Clears the Command Window

%% Loading in the data (see other files for supporting data)

data = xlsread('timeseries2015.xlsx'); %Loading the data
[numData,textData,rawData] = xlsread('timeseries2015.xlsx'); %Loading all the data, including text data
headerInfo= rawData(1,:); %Specifying a header row
numData(:,9) = numData(:,1) + datenum('01-Jan-1990')-2; %Converting Excel dates to Matlab dates

%% Imputing (interpolating) missing data from neighboring points

fullData = fillmissing(numData,'spline'); %This function uses Piecewise cubic spline interpolation

%% Graphing the smoothed time series

figure
screenSize = get(0,'ScreenSize'); %Identifying the size of the screen
set(gcf,'Position',screenSize) %Makes the figure the same size as the screen
set(gcf, 'MenuBar', 'none') %Turns off the menubar in the figure
set(gcf, 'ToolBar', 'none') %Turns off the toolbar in the figure
set(gcf, 'color', 'w') %Making the figure white

kernelLength = 7; %Determining the kernel length for convulation
kernel = ones(kernelLength, 1); %Creating a new matrix to convulate
kernelWeight = sum(kernel);
smoothedSleep = conv(fullData(:,2), kernel, 'valid')./kernelLength; %Smoothing each time course with a 7 day kernel
smoothedMood = conv(fullData(:,3), kernel, 'valid')./kernelLength;
smoothedEnergy = conv(fullData(:,4), kernel, 'valid')./kernelLength;
smoothedInspiration = conv(fullData(:,5), kernel, 'valid')./kernelLength;
smoothedWork = conv(fullData(:,6), kernel, 'valid')./kernelLength;
smoothedSleepREM = conv(fullData(:,7), kernel, 'valid')./kernelLength;
smoothedSleepDeep = conv(fullData(:,8), kernel, 'valid')./kernelLength;

subplot(2,3,1) %Sleep and work
plot(smoothedSleep, 'color', 'k', 'linewidth', 2)
hold on
plot(smoothedWork, 'color', 'r', 'linewidth', 2)
xlim([0 366])
title('Smoothed Sleep and Work Time Series')
xlabel('Day')
ylabel('Number of Hours')
legend('Sleep','Work', 'Location', 'SouthEast') %Adding a legend
box off
set(gca, 'tickdir', 'out') %Putting the ticks on the outside instead of the inside

subplot(2,3,2) %Mood
plot(smoothedMood, 'color', 'b', 'linewidth', 2)
xlim([0 366])
title('Smoothed Mood Time Series')
xlabel('Day')
ylabel('Mood Level')
box off
set(gca, 'tickdir', 'out') %Putting the ticks on the outside instead of the inside

subplot(2,3,3) %Energy
plot(smoothedEnergy, 'color', 'g', 'linewidth', 2)
xlim([0 366])
title('Smoothed Energy Time Series')
xlabel('Day')
ylabel('Energy Level')
box off
set(gca, 'tickdir', 'out') %Putting the ticks on the outside instead of the inside

subplot(2,3,4) %Inspiration
plot(smoothedInspiration, 'color', 'y', 'linewidth', 2)
xlim([0 366])
title('Smoothed Inspiration Time Series')
xlabel('Day')
ylabel('Level of Inspiration')
box off
set(gca, 'tickdir', 'out') %Putting the ticks on the outside instead of the inside

subplot(2,3,5) %REM Sleep
plot(smoothedSleepREM, 'color', 'm', 'linewidth', 2)
xlim([0 366])
title('Smoothed REM Sleep Time Series')
xlabel('Day')
ylabel('Number of Minutes')
box off
set(gca, 'tickdir', 'out') %Putting the ticks on the outside instead of the inside

subplot(2,3,6) %Deep Sleep
plot(smoothedSleepDeep, 'color', 'c', 'linewidth', 2)
xlim([0 366])
title('Smoothed Deep Sleep Time Series')
xlabel('Day')
ylabel('Number of Minutes')
box off
set(gca, 'tickdir', 'out') %Putting the ticks on the outside instead of the inside

%% Correlating the smoothed time series

X = [smoothedSleep, smoothedMood, smoothedEnergy, smoothedInspiration, smoothedWork, smoothedSleepREM, smoothedSleepDeep];
corr(X); %Correlating each variable with all of the others

%Results:
%The highest positive correlation is between hours of (overall) sleep and minutes of REM sleep (r = 0.8649)
%The highest negative correlation is between hours of (overall) sleep and hours of work (r = -0.6252)
%REM sleep is associated with decreased mood level (r = -0.4525)
%Deep sleep is associated with increased mood level (r = 0.2015)

%% Creating a multiple linear regression model predicting mood from the other variables

Y = smoothedMood;
Sleep = [ones(length(smoothedSleep),1) smoothedSleep]; %Need a column of ones to perform the regression
Energy = [ones(length(smoothedEnergy),1) smoothedEnergy];
Inspiration = [ones(length(smoothedInspiration),1) smoothedInspiration];
Work = [ones(length(smoothedWork),1) smoothedWork];
SleepREM = [ones(length(smoothedSleepREM),1) smoothedSleepREM];
SleepDeep = [ones(length(smoothedSleepDeep),1) smoothedSleepDeep];

[B,~,~,~,STATS] = regress(Y,Sleep); %Seeing how well hours of (overall) sleep predicts mood level
%Beta weights = 2.0769 and -0.2044. R^2= 0.2748
[B,~,~,~,STATS] = regress(Y,Energy); %Seeing how well energy level predicts mood level
%Beta weights = -0.0287 and 1.1632. R^2= 0.2739
[B,~,~,~,STATS] = regress(Y,Inspiration); %Seeing how well level of inspiration predicts mood level
%Beta weights = 0.4140 and 0.4191. R^2= 0.0599
[B,~,~,~,STATS] = regress(Y,Work); %Seeing how well hours of work predicts mood level
%Beta weights = 0.3768 and 0.0615. R^2= 0.1234
[B,~,~,~,STATS] = regress(Y,SleepREM); %Seeing how well minutes of REM sleep predicts mood level
%Beta weights = 1.6145 and -0.0045. R^2= 0.2047
[B,~,~,~,STATS] = regress(Y,SleepDeep); %Seeing how well minutes of deep sleep predicts mood level
%Beta weights = 0.2217 and 0.0079. R^2= 0.0406

%% Graphing the normalized time series

figure
screenSize = get(0,'ScreenSize'); %Identifying the size of the screen
set(gcf,'Position',screenSize) %Makes the figure the same size as the screen
set(gcf, 'MenuBar', 'none') %Turns off the menubar in the figure
set(gcf, 'ToolBar', 'none') %Turns off the toolbar in the figure
set(gcf, 'color', 'w') %Making the figure white

normalizedSleep = (smoothedSleep-mean(smoothedSleep))./std(smoothedSleep); %Turning each value into a z-score for each variable
normalizedWork = (smoothedWork-mean(smoothedWork))./std(smoothedWork);
normalizedMood = (smoothedMood-mean(smoothedMood))./std(smoothedMood);
normalizedEnergy = (smoothedEnergy-mean(smoothedEnergy))./std(smoothedEnergy);
normalizedInspiration = (smoothedInspiration-mean(smoothedInspiration))./std(smoothedInspiration);
normalizedSleepREM = (smoothedSleepREM-mean(smoothedSleepREM))./std(smoothedSleepREM);
normalizedSleepDeep = (smoothedSleepDeep-mean(smoothedSleepDeep))./std(smoothedSleepDeep);

plot(normalizedSleep, 'color', 'k', 'linewidth', 2) %Plotting all of the normalized time series
hold on
plot(normalizedWork, 'color', 'r', 'linewidth', 2)
plot(normalizedMood, 'color', 'b', 'linewidth', 2)
plot(normalizedEnergy, 'color', 'g', 'linewidth', 2)
plot(normalizedInspiration, 'color', 'y', 'linewidth', 2)
plot(normalizedSleepREM, 'color', 'm', 'linewidth', 2)
plot(normalizedSleepDeep, 'color', 'c', 'linewidth', 2)
xlim([0 366])
title('Normalized Time Courses for All Measures')
xlabel('Day')
legend('Sleep','Work','Mood','Energy','Inspiration','REM Sleep', 'Deep Sleep','Location', 'SouthEast') %Adding a legend
box off
set(gca, 'tickdir', 'out') %Putting the ticks on the outside instead of the inside

%% Graphing Smoothed Variable Averages By Weekday

days = 1:7;
weeks = nearest(length(smoothedSleep)/7);
dayMatrix = repmat(days,weeks);
allDays = [dayMatrix(1,:) 1 2]; %Creating a repeated vector of the weekdays (1-7) the same length as as smoothedSleep (359 units)

weekMatrix = [allDays' normalizedSleep normalizedMood normalizedWork]; %Putting the weekdays into a matrix with the normalized time series
[row1,~] = find(weekMatrix(:,1) == 5); %Mondays
[row2,~] = find(weekMatrix(:,1) == 6); %Tuesdays
[row3,~] = find(weekMatrix(:,1) == 7); %Wednesdays
[row4,~] = find(weekMatrix(:,1) == 1); %Thursdays
[row5,~] = find(weekMatrix(:,1) == 2); %Fridays
[row6,~] = find(weekMatrix(:,1) == 3); %Saturdays
[row7,~] = find(weekMatrix(:,1) == 4); %Sundays
%These labels are assumed because I don't know the day of the week that data was initially recorded. Using domain knowledge of the American workweek, I assigned these labels to reflect a decrease in the average number of hours worked on Saturdays and Sundays

%Sleep
sM = fullData(row1,2); %Isolating the values for each weekday
sTu = fullData(row2,2);
sW = fullData(row3,2);
sTh = fullData(row4,2);
sF = fullData(row5,2);
sSa = fullData(row6,2);
sSu = fullData(row7,2);
sleepMonday = sum(sM)/length(sM); %Averaging the values for each weekday
sleepTuesday = sum(sTu)/length(sTu);
sleepWednesday = sum(sW)/length(sW);
sleepThursday = sum(sTh)/length(sTh);
sleepFriday = sum(sF)/length(sF);
sleepSaturday = sum(sSa)/length(sSa);
sleepSunday = sum(sSu)/length(sSu);
sleepAverages= [sleepMonday sleepTuesday sleepWednesday sleepThursday sleepFriday sleepSaturday sleepSunday]; %Creating a vector of the averages

%Mood
mM = fullData(row1,3); %Isolating the values for each weekday
mTu = fullData(row2,3);
mW = fullData(row3,3);
mTh = fullData(row4,3);
mF = fullData(row5,3);
mSa = fullData(row6,3);
mSu = fullData(row7,3);
moodMonday = sum(mM)/length(mM); %Averaging the values for each weekday
moodTuesday = sum(mTu)/length(mTu);
moodWednesday = sum(mW)/length(mW);
moodThursday = sum(mTh)/length(mTh);
moodFriday = sum(mF)/length(mF);
moodSaturday = sum(mSa)/length(mSa);
moodSunday = sum(mSu)/length(mSu);
moodAverages= [moodMonday moodTuesday moodWednesday moodThursday moodFriday moodSaturday moodSunday]; %Creating a vector of the averages

%Work
wM = fullData(row1,6); %Isolating the values for each weekday
wTu = fullData(row2,6);
wW = fullData(row3,6);
wTh = fullData(row4,6);
wF = fullData(row5,6);
wSa = fullData(row6,6);
wSu = fullData(row7,6);
workMonday = sum(wM)/length(wM); %Averaging the values for each weekday
workTuesday = sum(wTu)/length(wTu);
workWednesday = sum(wW)/length(wW);
workThursday = sum(wTh)/length(wTh);
workFriday = sum(wF)/length(wF);
workSaturday = sum(wSa)/length(wSa);
workSunday = sum(wSu)/length(wSu);
workAverages= [workMonday workTuesday workWednesday workThursday workFriday workSaturday workSunday]; %Creating a vector of the averages

figure %Graphing the averages
screenSize = get(0,'ScreenSize'); %Identifying the size of the screen
set(gcf,'Position',screenSize) %Makes the figure the same size as the screen
set(gcf, 'MenuBar', 'none') %Turns off the menubar in the figure
set(gcf, 'ToolBar', 'none') %Turns off the toolbar in the figure
set(gcf, 'color', 'w') %Making the figure white

%Sleep
subplot(1,3,1)
a = bar(sleepAverages);
xlabels = {'Monday';'Tuesday';'Wednesday';'Thursday';'Friday';'Saturday';'Sunday'}; %Specifying bar labels
xtickangle(45);
set(gca,'xticklabel', xlabels);
box off
set(gca, 'tickdir', 'out') %Putting the ticks on the outside instead of the inside
xlabel('Weekdays') %Labeling the x-axis
ylabel('Average Hours of Sleep') %Labeling the y-axis
title('Average Sleep by Weekday') %Adding a title
set(a, 'FaceColor', 'k', 'EdgeColor','k')

%Mood
subplot(1,3,2)
c = bar(moodAverages);
xlabels = {'Monday';'Tuesday';'Wednesday';'Thursday';'Friday';'Saturday';'Sunday'}; %Specifying bar labels
xtickangle(45);
set(gca,'xticklabel', xlabels);
box off
set(gca, 'tickdir', 'out') %Putting the ticks on the outside instead of the inside
xlabel('Weekdays') %Labeling the x-axis
ylabel('Average Mood Level') %Labeling the y-axis
title('Average Mood by Weekday') %Adding a title
set(c, 'FaceColor', 'b', 'EdgeColor','b')

%Work
subplot(1,3,3)
d = bar(workAverages);
xlabels = {'Monday';'Tuesday';'Wednesday';'Thursday';'Friday';'Saturday';'Sunday'}; %Specifying bar labels
xtickangle(45);
set(gca,'xticklabel', xlabels);
box off
set(gca, 'tickdir', 'out') %Putting the ticks on the outside instead of the inside
xlabel('Weekdays') %Labeling the x-axis
ylabel('Average Hours of Work') %Labeling the y-axis
title('Average Work by Weekday') %Adding a title
set(d, 'FaceColor', 'r', 'EdgeColor','r')

% Investigating if ther is such a thing as a Monday mood or Friday mood?
mood= [mM mTu mW mTh(1:51) mF(1:51) mSa mSu]; %Creating a matrix that includes the samples of mood levels from each weekday
p = kruskalwallis(mood); %Used for nominal data with more than 2 groups (we are comparing samples from 7 groups)
%p = 0.03. There is a significant difference in mood between weekdays.
