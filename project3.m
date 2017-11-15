% Starting project
close all
clear
fprintf('Starting project3\n\n')

% Import Data
fprintf('Loading data...')
load IMDBMovieData.mat
fprintf('DONE\n')

fprintf('Cleaning data...')
[data, header] = cleanData(IMDBMovieData);
fprintf('DONE\n')

% Fill missing data
fprintf('Filling missing data...')
data = fillmissing(data, 'linear');
fprintf('DONE\n\n')

% Predict Rating of movie
predictRating(data);
fprintf('Press ENTER to continue\n\n')
pause

% Predict Rank of movie
predictRank(data);
fprintf('Press ENTER to continue\n\n')
pause

% Predict Revenue
predictRev(data);
fprintf('Press ENTER to continue\n\n')
pause

% Use Machine Learning Toolbox
MLApp(data);

fprintf('Project 3 is done\n\n')
