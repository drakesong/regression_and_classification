function RMSE = predictRev_DT(X, Y, X_test, Y_test)
%PRECITRANK_DT This function uses decision trees to predict rev

% Decision Tree
fprintf('Creating Decision Tree...')
mdl = fitrtree(X, Y, 'MinLeafSize', 4, 'Surrogate', 'off');
Yhat = predict(mdl, X_test);
RMSE_regular = sqrt(mean((Y_test - Yhat).^2));
fprintf('DONE\n')

view(mdl, 'Mode', 'graph')

% Bagging
fprintf('Creating Bagging Decision Tree...')
bagmdl = TreeBagger(500, X, Y, 'Method', 'regression', ...
    'NumPredictorsToSample', 'all', 'OOBPrediction', 'on');
Yhat_bag = predict(bagmdl, X_test);
RMSE_bag = sqrt(mean((Y_test - Yhat_bag).^2));
ooberror_bag = oobError(bagmdl);
fprintf('DONE\n')

% Random Forest
fprintf('Creating Random Forest...')
rfmdl = TreeBagger(500, X, Y, 'Method', 'regression', ...
    'OOBPrediction', 'on');
Yhat_rf = predict(rfmdl, X_test);
RMSE_rf = sqrt(mean((Y_test - Yhat_rf).^2));
ooberror_rf = oobError(rfmdl);
fprintf('DONE\n')

% OOB Analysis
figure
hold on
plot(ooberror_bag)
plot(ooberror_rf)
xlabel 'number of trees';
ylabel 'out-of-bag error';
legend('mdl\_bag', 'mdl\_rf')
hold off
fprintf('\nPress ENTER to continue\n\n')
pause
close

% Error comparison
fprintf('RMSE produced by Regular Decision Tree: %g\n', RMSE_regular)
fprintf('RMSE produced by Bagging Decision Tree: %g\n', RMSE_bag)
fprintf('RMSE produced by Random Forest: %g\n\n', RMSE_rf)

RMSE = min([RMSE_regular, RMSE_bag, RMSE_rf]);

end

