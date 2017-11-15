function error = predictRating_LR(X, Y, X_test, Y_test)
%PREDICTRATING_LR This function uses logistric regression to predict rating

% Check for correlation
fprintf('Checking for correlation...\n')
figure
plotmatrix(X)
fprintf('No correlation is observed.\n\nPress ENTER to continue\n\n')
pause
close

% Adjust Y to not have 0
Y = Y + 1;
Y_test = Y_test + 1;

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
    if stats.p(j) > 0.05
        fprintf('Column %d: %f\n', j-1, stats.p(j))
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
        if stats.p(j) > 0.05
            fprintf('Column %d: %f\n', j-1, stats.p(j))
            remove(end+1) = j-1;
            bad = bad + 1;
        end
    end

    if isempty(remove)
        fprintf('None\n\n')
    end
end

[B, ~, stats] = mnrfit(X, Y);

% =============================== TESTING ===============================
% % Visualizing model
% [pihat, ~, ~] = mnrval(B, X, stats);
% figure
% rotate3d on
% scatter3(X(:,10), X(:,12), pihat(:,2), 'r.')
% fprintf('\nPress ENTER to continue\n\n')
% pause
% close
% =======================================================================

% Calculate confidence intervals for betas
[~,n] = size(X);
ci = zeros(n,2);
for i = 1:n
    ci(i,1) = stats.beta(i) - 2*stats.se(i);
    ci(i,2) = stats.beta(i) + 2*stats.se(i);
end

fprintf('Calulating confidence intervals...')
for i = 1:n
    if ci(i,1) < 0 && ci(i,2) > 0
        fprintf('\nBeta%g contains 0\n',i-1)
    end
end
fprintf('DONE\n')
fprintf('No confidence intervals have 0.\n')
fprintf('\nPress ENTER to continue.\n\n')
pause

% Predict using test data
pihat = mnrval(B, X_test, stats);

% Calculate Yhat
Yhat = zeros(100,1);
for i = 1:100
    if pihat(i,2) >= 0.5
        Yhat(i) = 2;
    else
        Yhat(i) = 1;
    end
end

% Create Confusion Matrix
C = confusionmat(Y_test-1, Yhat-1);
fprintf('The confusion matrix is:')
C

% Error analysis
error = sum(abs(Y_test - Yhat));
fprintf('Error: %g\n\n',error)

end

