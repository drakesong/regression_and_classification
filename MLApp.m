function MLApp(data)
%MLAPP This function uses Machine Learning Toolbox included in MatLab

fprintf('Running Machine Learning Toolbox\n')

% Separate data
data_rating = data;
data_ranking = data;
data_rev = data;

% Rating
fprintf('Predicting Rating\n')
for i = 1:1000
    if data_rating(i,11) >= 7.5
        data_rating(i,11) = 1;
    else
        data_rating(i,11) = 0;
    end
end

test_index = sort(randperm(1000, 100));
data_rating_test = data_rating(test_index, :);
data_rating(test_index, :) = [];
Y_test_rating = data_rating_test(:,11);
data_rating_test(:,11) = [];

load('ratingMdl.mat', 'ratingMdl')
Yfit_rating = ratingMdl.predictFcn(data_rating_test);
Yfit_rating = round(Yfit_rating);
error_rating = 0;
for i = 1:100
    if Yfit_rating(i) ~= Y_test_rating(i)
        error_rating = error_rating + 1;
    end
end
fprintf('Error: %g\n\n', error_rating)

% Ranking
fprintf('Predicting Ranking\n')
for i = 1:1000
    if data_ranking(i,13) == 1000
        data_ranking(i,13) = 10;
    else
        data_ranking(i,13) = floor(data_ranking(i,13)/100)+1;
    end
end

data_ranking_test = data_ranking(test_index, :);
data_ranking(test_index, :) = [];
Y_test_ranking = data_ranking_test(:,13);
data_ranking_test(:,13) = [];

load('rankMdl.mat', 'rankMdl')
Yfit_ranking = rankMdl.predictFcn(data_ranking_test);
Yfit_ranking = round(Yfit_ranking);
error_ranking = 0;
for i = 1:100
    if Yfit_ranking(i) ~= Y_test_ranking(i)
        error_ranking = error_ranking + 1;
    end
end
fprintf('Error: %g\n\n', error_ranking)

% Revenue
fprintf('Predicting Revenue\n')
data_rev_test = data_rev(test_index, :);
data_rev(test_index, :) = [];
Y_test_rev = data_rev_test(:,12);
data_rev_test(:,12) = [];

load('revMdl.mat', 'revMdl')
Yfit_rev = revMdl.predictFcn(data_rev_test);
Yfit_rev = round(Yfit_rev);
RMSE = sqrt(mean((Y_test_rev - Yfit_rev).^2));
fprintf('RMSE: %g\n\n', RMSE)

end

