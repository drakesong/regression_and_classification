function RMSE = predictRev_SVM(X, Y, X_test, Y_test)
%PREDICTREV_SVM This function uses SVM to predict rev

fprintf('Creating model...')
mdl = fitrsvm(X, Y, 'KernelFunction', 'gaussian', ...
    'KernelScale', 'auto', 'Standardize', true);
fprintf('DONE\n')

Yhat = predict(mdl, X_test);
RMSE = sqrt(mean((Y_test - Yhat).^2));

end
