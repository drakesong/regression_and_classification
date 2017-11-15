function error = predictRating_DT(X, Y, X_test, Y_test)
%PRECITRATING_DT This function uses decision trees to predict rating

% Decision Tree
fprintf('Creating Decision Tree...')
mdl = fitctree(X, Y, 'SplitCriterion', 'deviance');
Yhat = predict(mdl, X_test);
error_regular = sum(abs(Yhat - Y_test));
fprintf('DONE\n')

view(mdl, 'Mode', 'graph')

% Bagging
fprintf('Creating Bagging Decision Tree...')
bagmdl = TreeBagger(500, X, Y, 'Method', 'classification', ...
    'NumPredictorsToSample', 'all', 'OOBPrediction', 'on');
Yhat_bag = str2num(cell2mat(predict(bagmdl, X_test)));
error_bag = sum(abs(Yhat_bag - Y_test));
oobpredictions_bag = str2num(cell2mat(oobPredict(bagmdl)));
error_bag_oob = sum(abs(oobpredictions_bag - Y));
ooberror_bag = oobError(bagmdl);
fprintf('DONE\n')

% Random Forest
fprintf('Creating Random Forest...')
rfmdl = TreeBagger(500, X, Y, 'Method', 'classification', ...
    'OOBPrediction', 'on');
Yhat_rf = str2num(cell2mat(predict(rfmdl, X_test)));
error_rf = sum(abs(Yhat_rf - Y_test));
oobpredictions_rf = str2num(cell2mat(oobPredict(rfmdl)));
error_rf_oob = sum(abs(oobpredictions_rf - Y));
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
fprintf('Error produced by Regular Decision Tree: %g\n', error_regular)
fprintf('Error produced by Bagging Decision Tree: %g\n', error_bag)
fprintf('Error produced by Random Forest: %g\n\n', error_rf)

error = min([error_regular, error_bag, error_rf]);

end

