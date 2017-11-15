function predictRev(data)
%PREDICTREV This function predicts revenue

% Separate X and Y
X = data;
X(:, 12) = [];
Y = data(:, 12);

% Separate Test Data
test_index = sort(randperm(1000, 100));
X_test = X(test_index, :);
Y_test = Y(test_index, :);
X(test_index, :) = [];
Y(test_index, :) = [];

% Predict Revenue using Decision Tree
fprintf('Predicting Rev using Decision Trees\n\n')
RMSE_DT = predictRev_DT(X, Y, X_test, Y_test);

% Predict Revenue using SVM
fprintf('Predicting Rev using SVM\n\n')
RMSE_SVM = predictRev_SVM(X, Y, X_test, Y_test);

fprintf('Error_DT: %g\n', RMSE_DT)
fprintf('Error_SVM: %g\n', RMSE_SVM)

RMSE = min([RMSE_DT, RMSE_SVM]);
if RMSE == RMSE_DT
    fprintf('\nDecision Tree is the best to predict rev.\n\n')
else
    fprintf('\nSVM is the best to predict rev.\n\n')
end

end