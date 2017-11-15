function error = predictRating_SVM(X, Y, X_test, Y_test)
%PREDICTRATING_SVM This function uses SVM to predict rating

fprintf('Creating model...')
mdl = fitcsvm(X, Y, 'BoxConstraint', 1/10);
Yhat = predict(mdl, X_test);
error = sum(abs(Yhat - Y_test));
fprintf('DONE\n\n')

sv = mdl.SupportVectors;

figure
gscatter(X(:,10), X(:,12), Y, 'br')
hold on
plot(sv(:,10), sv(:,12), 'ko', 'MarkerSize', 5)
legend('>7.5', '<7.5', 'SupportVectors')
hold off
fprintf('Press ENTER to continue\n\n')
pause
close

end

