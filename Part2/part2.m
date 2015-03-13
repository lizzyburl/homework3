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
    fprintf('Done with %da', soundFile);
    cep_matrix_b{soundFile} = GetMFCC(sprintf('%db.wav',soundFile), lower, upper, M);
    fprintf('Done with %db', soundFile);
end
cep_matrix_a{10} = GetMFCC(sprintf('%za.wav',soundFile), lower, upper, M);
fprintf('Done with za');
cep_matrix_b{10} = GetMFCC(sprintf('%zb.wav',soundFile), lower, upper, M);
fprintf('Done with zb');
cep_matrix_a{11} = GetMFCC(sprintf('%oa.wav',soundFile), lower, upper, M);
fprintf('Done with oa');
cep_matrix_b{11} = GetMFCC(sprintf('%ob.wav',soundFile), lower, upper, M);
fprintf('Done with ob');
% Four each test file

order = ['1', '2', '3', '4', '5', '6', '7', '8', '9', 'z', 'o'];
for i = 1:11
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
        fprintf('You have correctly matched %s', order(i));
    else
        fprintf('Incorrect match: %s matched to template of %s', order(i), order(best_index));
    end
end
