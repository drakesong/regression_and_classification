function error = predictRank_LR(X, Y, X_test, Y_test)
%PREDICTRANK_LR This function uses logistric regression to predict rank

% =============================== TESTING ===============================
% t = templateLinear('Learner', 'logistic', 'Regularization', 'lasso', ...
%     'TruncationPeriod', 10);
% mdl = fitcecoc(X, Y, 'Learners', t, 'CrossVal', 'on', 'Holdout', 0.1);
% Yhat = kfoldPredict(mdl);
% error = 0;
% for i = 1:100
%     if Y_test(i) ~= Yhat(i)
%         error = error + 1;
%     end
% end
% 
% [mdl, test] = fitcecoc(X, Y, 'OptimizeHyperparameters', 'auto', ...
%     'Learners', 'linear');
% Yhat = predict(mdl, X);
% error = 0;
% for i = 1:1000
%     if Y(i) ~= Yhat(i)
%         error = error + 1;
%     end
% end
% fprintf('')
% 
% mdl_1 = fitcecoc(X, Y, 'OptimizeHyperparameters', 'auto', 'Learners', ...
%     'tree');
% 
% mdl_2 = fitcecoc(X, Y, 'OptimizeHyperparameters', 'auto', 'Learners', ...
%     'svm');
% 
% Y = ordinal(Y, {'1','2','3','4','5','6','7','8','9','10'}, [], ...
%     [1,99,199,299,399,499,599,699,799,899,1000]);
% 
% 
% % Fit logistic regression
% [~, ~, stats] = mnrfit(X, Y, 'Model', 'ordinal');
% ========================================================================

% Check for correlation
fprintf('Checking for correlation...\n')
figure
plotmatrix(X)
fprintf('No correlation is observed.\n\nPress ENTER to continue\n\n')
pause
close

% Fit logistic regression
fprintf('Creating model...')
[~, ~, stats] = mnrfit(X, Y);
fprintf('DONE\n')

% Check for p-values
bad = 0;
remove = [];
[~,n] = size(X);
fprintf('The following features have p-value greater than 0.05:\n')
for j = 2:n
    if min(stats.p(j,:)) > 0.05
        fprintf('Column %d: %f\n', j-1, min(stats.p(j,:)))
        remove(end+1) = j-1;
        bad = bad + 1;
    end
end

while bad > 0
    % Remove features
    fprintf('\nRemoving features...')
    remove = sort(remove, 'descend');
    X(:, remove) = [];
    X_test(:, remove) = [];
    bad = 0;
    fprintf('DONE\n')
    
    % New model
    fprintf('Generating new model...')
    [~, ~, stats] = mnrfit(X, Y);
    fprintf('DONE\n')

    % Check for p-values
    remove = [];
    [~,n] = size(X);
    fprintf('\nThe following features have p-value greater than 0.05:\n')
    for j = 2:n
        if min(stats.p(j,:)) > 0.05
            fprintf('Column %d: %f\n', j-1, min(stats.p(j,:)))
            remove(end+1) = j-1;
            bad = bad + 1;
        end
    end
    
    if isempty(remove)
        fprintf('None\n\n')
    end
end

B = mnrfit(X, Y);

% ======================== CONFIDENCE INTERVAL ===========================
% % Calculate confidence intervals for betas
% [~,n] = size(X);
% ci = zeros(n,2);
% for i = 1:n
%     ci(i,1) = stats.beta(i) - 2*stats.se(i);
%     ci(i,2) = stats.beta(i) + 2*stats.se(i);
% end
% 
% LL = stats.beta - 1.96.*stats.se;
% UL = stats.beta + 1.96.*stats.se;
% 
% [LL(:,1) UL(:,1)]
% [LL(:,2) UL(:,2)]
% [LL(:,3) UL(:,3)]
% [LL(:,4) UL(:,4)]
% [LL(:,5) UL(:,5)]
% [LL(:,6) UL(:,6)]
% [LL(:,7) UL(:,7)]
% [LL(:,8) UL(:,8)]
% [LL(:,9) UL(:,9)]
% 
% fprintf('Calulating confidence intervals...')
% bad = 0;
% for i = 1:n
%     if ci(i,1) < 0 && ci(i,2) > 0
%         fprintf('\nBeta%g contains 0\n',i-1)
%         bad = bad + 1;         
%     end
% end
% fprintf('DONE\n')
% 
% if bad == 0
%     fprintf('No confidence intervals have 0.\n')
% end
% fprintf('\nPress ENTER to continue.\n\n')
% 
% ========================================================================

% Predict using test data
pihat = mnrval(B, X_test);

% Calculate Yhat
Yhat = zeros(100,1);
for i = 1:100
    [~, index] = max(pihat(i, :));
    Yhat(i) = index;
end

% Error analysis
error = 0;
for i = 1:100
    if Y_test(i) ~= Yhat(i)
        error = error + 1;
    end
end
fprintf('Error: %g\n\n',error)

end