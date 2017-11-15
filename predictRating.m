function predictRating(data)
%PREDICTRATING This function predicts ratings of movies using 
%classification

% Separate X and Y
X = data;
X(:, 11) = [];
Y = data(:, 11);

% 1 if rating is greater or equal to 7.5; 0 if rating is lower than 7.5
for i = 1:1000
    if Y(i) >= 7.5
        Y(i) = 1;
    else
        Y(i) = 0;
    end
end

% Separate Test Data
test_index = sort(randperm(1000, 100));
X_test = X(test_index, :);
Y_test = Y(test_index, :);
X(test_index, :) = [];
Y(test_index, :) = [];

% Predict Rating using Logistic Regression
fprintf('Predicting Rating using Logistic Regression\n\n')
error_LR = predictRating_LR(X, Y, X_test, Y_test);

% Predict Rating using Decision Tree
fprintf('Predicting Rating using Decision Trees\n\n')
error_DT = predictRating_DT(X, Y, X_test, Y_test);

% Predict Rating using SVM
fprintf('Predicting Rating using Support Vector Machine\n\n')
error_SVM = predictRating_SVM(X, Y, X_test, Y_test);

fprintf('Error_LR: %g\n', error_LR)
fprintf('Error_DT: %g\n', error_DT)
fprintf('Error_SVM: %g\n', error_SVM)

error = min([error_LR, error_DT, error_SVM]);
if error == error_LR
    fprintf('\nLogistic Regression is the best to predict ratings.\n\n')
elseif error == error_DT
    fprintf('\nDecision Tree is the best to predict ratings.\n\n')
else 
    fprintf('\nSupport Vector Machine is the best to predict ratings.\n\n')
end

end