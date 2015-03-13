% Homework 1
% Lizzy Burl, Ethan Hill, Jorge Chang, James Burgess
% Part 2

clear;
    
lower = 30;
upper = 8000;
M = 24;

% 16,000 Hz means that 1 ms = 16 samples
% 25 ms = 400 samples
cep_matrix_a = cell(1,9);
cep_matrix_b = cell(1,9);
for soundFile = 1:9
    cep_matrix_a{soundFile} = GetMFCC(sprintf('%da.wav',soundFile), lower, upper, M);
    fprintf('Done with a');
    cep_matrix_b{soundFile} = GetMFCC(sprintf('%db.wav',soundFile), lower, upper, M);
    fprintf('Done with b');
end

% Four each test file
for i = 1:9
    best_index = 1;
    best_score = dtw(cell_matrix_b{i}, cep_matrix_a{1});
    for j=2:1:9
        score = dtw(cell_matrix_b{i}, cep_matrix_a{j});
        if score < best_score
            best_score = score;
            best_index = j;
        end
    end
    if i == best_index
        fprintf('You have correctly matched %d', i);
    else
        fprintf('Incorrect match: %d matched to template of %d', i, best_index);
    end
end
