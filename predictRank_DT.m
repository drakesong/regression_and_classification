function error = predictRank_DT(X, Y, X_test, Y_test)
%PRECITRANK_DT This function uses decision trees to predict rank

% Decision Tree
fprintf('Creating Decision Tree...')
mdl = fitrtree(X, Y, 'MinLeafSize', 4, 'Surrogate', 'off');
Yhat = predict(mdl, X_test);
Yhat = round(Yhat);
error_regular = 0;
for i = 1:100
    if Y_test(i) ~= Yhat(i)
        error_regular = error_regular + 1;
    end
end
fprintf('DONE\n')

view(mdl, 'Mode', 'graph')

% Bagging
fprintf('Creating Bagging Decision Tree...')
bagmdl = TreeBagger(500, X, Y, 'Method', 'regression', ...
    'NumPredictorsToSample', 'all', 'OOBPrediction', 'on');
Yhat_bag = predict(bagmdl, X_test);
Yhat_bag = round(Yhat_bag);
error_bag = 0;
for i = 1:100
    if Y_test(i) ~= Yhat_bag(i)
        error_bag = error_bag + 1;
    end
end
ooberror_bag = oobError(bagmdl);
fprintf('DONE\n')

% Random Forest
fprintf('Creating Random Forest...')
rfmdl = TreeBagger(500, X, Y, 'Method', 'regression', ...
    'OOBPrediction', 'on');
Yhat_rf = predict(rfmdl, X_test);
Yhat_rf = round(Yhat_rf);
error_rf = 0;
for i = 1:100
    if Y_test(i) ~= Yhat_rf(i)
        error_rf = error_rf + 1;
    end
end
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

