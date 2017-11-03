Getting and Cleaning Data Course Project

This repository contains files that are part of the project for the "Getting and
Cleaning Data" course from John Hopkins University studied through coursera.org.

This project involves tidying, merging and summarizing data collected by Jorge 
L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio and Luca Oneto from the 
accelerometers from the Samsung Galaxy S smartphone.

The data is available from 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

A full description of the data collection is available from 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The R script "cleaningfinalscript3.R" contains the code that performs these tasks. 

It produces three tables:

alldata - a table containing all accelerometer data

subdata - a subset of alldata containing the mean and standard deviation variables.

avdata - a table of the averages of the variables found in subdata grouped by 
     individual and activity.

For details on how the data has been treated and descriptions of the variables see the CodeBook.md file.
