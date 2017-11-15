function error = predictRank_SVM(X, Y, X_test, Y_test)
%PREDICTRANK_SVM This function uses SVM to predict rank

fprintf('Creating model...')
mdl = fitrsvm(X, Y, 'KernelFunction', 'gaussian', ...
    'PolynomialOrder', [], 'KernelScale', 0.9, ...
    'Standardize', true);
fprintf('DONE\n')

Yhat = predict(mdl, X_test);
Yhat = round(Yhat);
error = 0;
for i = 1:100
    if Y_test(i) ~= Yhat(i)
        error = error + 1;
    end
end

% =============================== TESTING ===============================
% mdl = fitrsvm(X, Y, 'KernelFunction', 'gaussian', ...
%     'PolynomialOrder', [], 'KernelScale', 0.9, ...
%     'Standardize', true);
% Yhat = predict(mdl, X_test);
% Yhat = round(Yhat);
% error = 0;
% for i = 1:100
%     if Y_test(i) ~= Yhat(i)
%         error = error + 1;
%     end
% end
% fprintf('DONE\n')

% t = templateSVM('KernelFunction', 'gaussian', 'BoxConstraint', 1/100);
% mdl = fitcecoc(X, Y, 'Learners', t);

% figure
% h = gscatter(X(:,2), X(:,7), Y);
% gu = unique(Y);
% for k = 1:numel(gu)
%       set(h(k), 'ZData', X(Y == gu(k), 8));
% end
% grid on
% rotate3d on
% view(3)
% fprintf('\nPress ENTER to continue\n\n')
% pause
% close
% ========================================================================

end
