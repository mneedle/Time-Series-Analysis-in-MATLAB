# Time-Series-Analysis-in-MATLAB
This is a time series analysis project that I completed in MATLAB as part of an NYU course I took in Spring 2018. After loading the supporting data ("timeseries2015.xlsx"), I imputed the missing data and plotted figures of all courses (sleep, mood, energy,inspiration, work, REM and Deep) smoothed with a 7 day kernel. I then correlated all variables with all others to investigate whether REM sleep and deep sleep is associated with good or bad mood. I also created a multiple linear regression model to predict mood from the other variables. I then plotted all 7 courses smoothed (again, using a 7 day kernel) but also normalized (z-scored). Finally, I calculated average sleep, mood, and work values per weekday and investigated whether there is a difference between mood based on weekday using a Kruskall-Wallis test.

# About the supporting data
The supporting data ("timeseries2015.xlsx") contains data from a quantitative diary of an individual suffering from bipolar disorder, from each day in 2015.There are 8 columns, which represent – in order: The date, the number of hours slept that day, daily mood on a scale from -2.5 to 2.5, energy levels on a scale from 0 to 2, inspiration (the individual is an artist) on a scale from 0 to 2, number of hours worked that day, minutes of REM sleep that night and minutes of deep sleep that night. 

## Instructions to Run 
There are no dependencies or assumptions to run this script, but you will need to copy the MATLAB script to a M-File (.m) and download the supporting data ("timeseries2015.xlsx"). 
