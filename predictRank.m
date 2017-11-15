function predictRank(data)
%PREDICTRANK This function predicts ranks of movies using classification

% Separate X and Y
X = data;
X(:, 13) = [];
Y = data(:, 13);

% 1 for 1-99, 2 for 100-199, 3 for 200-299, ... , 10 for 900-1000
for i = 1:1000
    if Y(i) == 1000
        Y(i) = 10;
    else
        Y(i) = floor(Y(i)/100)+1;
    end
end

% Separate Test Data
test_index = sort(randperm(1000, 100));
X_test = X(test_index, :);
Y_test = Y(test_index, :);
X(test_index, :) = [];
Y(test_index, :) = [];

% Predict Ranking using Logistic Regression
fprintf('Predicting Rank using Logistic Regression\n\n')
error_LR = predictRank_LR(X, Y, X_test, Y_test);

% Predict Ranking using Decision Tree
fprintf('Predicting Rank using Decision Trees\n\n')
error_DT = predictRank_DT(X, Y, X_test, Y_test);

% Predict Ranking using SVM
fprintf('Predicting Rank using Support Vector Machine\n\n')
error_SVM = predictRank_SVM(X, Y, X_test, Y_test);

fprintf('Error_LR: %g\n', error_LR)
fprintf('Error_DT: %g\n', error_DT)
fprintf('Error_SVM: %g\n', error_SVM)

error = min([error_LR, error_DT, error_SVM]);
if error == error_LR
    fprintf('\nLogistic Regression is the best to predict rank.\n\n')
elseif error == error_DT
    fprintf('\nDecision Tree is the best to predict rank.\n\n')
else 
    fprintf('\nSupport Vector Machine is the best to predict rank.\n\n')
end

end