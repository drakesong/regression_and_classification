function [data, header] = cleanData(raw_data)
%CLEANDATA This function cleans the IMDBMovieData by removing unnecessary
%features and converting certain features to usable forms

% Determine number of words in title
num_words_title = zeros(1000, 1);
for i = 1:1000
    num = numel(strsplit(raw_data.Title(i)));
    if num < 6
        num_words_title(i) = 1;
    else
        num_words_title(i) = 0;
    end
end

% Determine number of words > 4 letters in description
num_words_descript = zeros(1000, 1);
for i = 1:1000
    words = strsplit(raw_data.Description(i));
    [~,n] = size(words);
    for j = 1:n
        if strlength(words(1,j)) > 7
            num_words_descript(i) = num_words_descript(i) + 1;
        end
    end
end

% Separate genres
genre_cell = cell.empty(1000, 0);
for i = 1:1000
    genre_cell(i) = textscan(string(raw_data.Genre(i)), ...
        '%s', 'Delimiter', ',');
end

genre_cell = genre_cell';

genre = string.empty(1000, 0);
for i = 1:1000
    for k = 1:3
        try
            genre(i, k) = genre_cell{i}{k};
        catch ME
            if (strcmp(ME.identifier,'MATLAB:badsubscript'))
                break
            end
        end
    end
end

genre_num = zeros(1000, 1);
for i = 1:1000
    for k = 1:3
        if genre(i,k) == "Action"
            genre_num(i,k) = 19;
        elseif genre(i,k) == "Adventure"
            genre_num(i,k) = 20;
        elseif genre(i,k) == "Animation"
            genre_num(i,k) = 3;
        elseif genre(i,k) == "Biography"
            genre_num(i,k) = 12;
        elseif genre(i,k) == "Comedy"
            genre_num(i,k) = 18;
        elseif genre(i,k) == "Crime"
            genre_num(i,k) = 10;
        elseif genre(i,k) == "Drama"
            genre_num(i,k) = 17;
        elseif genre(i,k) == "Family"
            genre_num(i,k) = 5;
        elseif genre(i,k) == "Fantasy"
            genre_num(i,k) = 8;
        elseif genre(i,k) == "History"
            genre_num(i,k) = 7;
        elseif genre(i,k) == "Horror"
            genre_num(i,k) = 15;
        elseif genre(i,k) == "Music"
            genre_num(i,k) = 1;
        elseif genre(i,k) == "Musical"
            genre_num(i,k) = 13;
        elseif genre(i,k) == "Mystery"
            genre_num(i,k) = 9;
        elseif genre(i,k) == "Romance"
            genre_num(i,k) = 14;
        elseif genre(i,k) == "Sci-Fi"
            genre_num(i,k) = 4;
        elseif genre(i,k) == "Sport"
            genre_num(i,k) = 2;
        elseif genre(i,k) == "Thriller"
            genre_num(i,k) = 16;
        elseif genre(i,k) == "War"
            genre_num(i,k) = 6;
        elseif genre(i,k) == "Western"
            genre_num(i,k) = 11;
        else
            genre_num(i,k) = 0;
        end
    end
end

% =============================== TESTING ===============================
% ave_gen = zeros(1000,1);
% for i = 1:1000
%     count_gen = 0;
%     for k = 1:3
%         if genre_num(i,k) ~= 0
%             count_gen = count_gen + 1;
%         end
%     end
%     ave_gen(i) = sum(genre_num(i))/count_gen;
% end
% ========================================================================

% Determine number of top actors in the movie
actor_cell = cell.empty(1000, 0);
for i = 1:1000
    actor_cell(i) = textscan(string(raw_data.Actors(i)), '%s', ...
        'Delimiter', ',');
end

actor_cell = actor_cell';

actors = string.empty(1000, 0);
for i = 1:1000
    for k = 1:3
        try
            actors(i, k) = actor_cell{i}{k};
        catch ME
            if (strcmp(ME.identifier,'MATLAB:badsubscript'))
                break
            end
        end
    end
end

load topactors.mat
top_actors = topactors{1, :}';

top_actors_count = zeros(1000, 1);
for i = 1:1000
    for k = 1:3
        top_actors_count(i) = top_actors_count(i) + sum(actors(i,k) == ...
            top_actors);
    end
end

load topdirectors.mat
top_directors = topdirectors{1, :}';
directors = string(raw_data.Director);
top_directors_count = zeros(1000, 1);
for i = 1:1000
    for k = 1:100
        top_directors_count(i) = top_directors_count(i) + ...
            double(strcmpi(directors(i), top_directors(k)));
    end
end

% Votes
num_votes = zeros(1000,1);
for i = 1:1000
    if raw_data.Votes(i) > 295000
        num_votes(i) = 1;
    end
end

% RunTime
run_time = zeros(1000,1);
for i = 1:1000
    if raw_data.RuntimeMinutes(i) >= 140
        run_time(i) = 1;
    end
end

% Compile into new data and header 
data = [num_words_title num_words_descript genre_num top_actors_count ...
    top_directors_count raw_data.Year run_time raw_data.Metascore ...
    raw_data.Rating raw_data.RevenueMillions raw_data.Rank num_votes];

header = ["num_words_title", "num_words_descript", "genre_1", ...
    "genre_2", "genre_3", "top_actors_count", "top_directors_count", ...
    "year", "runtime", "metascore", "rating", "revenue", "rank", "votes"];

end

