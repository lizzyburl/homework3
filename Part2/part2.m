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
    try
        cep_matrix_a{soundFile} = load(sprintf('cep_mat_a%d.mat',soundFile));
        disp('Found File');
    catch
        cep_matrix_a{soundFile} = GetMFCC(sprintf('%da.wav',soundFile), lower, upper, M);
        fprintf('Done with %da', soundFile);
        to_save = cep_matrix_a{soundFile};
        save(sprintf('cep_mat_a%d.mat',soundFile), 'to_save');
    end
    try
        cep_matrix_b{soundFile} = load(sprintf('cep_mat_b%d.mat',soundFile));
        disp('Found File');
    catch
        cep_matrix_b{soundFile} = GetMFCC(sprintf('%db.wav',soundFile), lower, upper, M);
        fprintf('Done with %db', soundFile);
        to_save = cep_matrix_b{soundFile};
        save(sprintf('cep_mat_b%d.mat',soundFile), 'to_save');
    end
end
%% For z a and b
try
     cep_matrix_a{10} = load('cep_mat_az.mat');
     disp('Found File');
catch
    cep_matrix_a{10} = GetMFCC('za.wav', lower, upper, M);
    fprintf('Done with za');
    to_save = cep_matrix_a{10};
    save('cep_mat_az.mat', 'to_save');
end
try
    cep_matrix_b{10} = load('cep_mat_bz.mat');
    disp('Found File');
catch
    cep_matrix_b{10} = GetMFCC('zb.wav', lower, upper, M);
    fprintf('Done with zb');
    to_save = cep_matrix_b{10};
    save('cep_mat_bz.mat', 'to_save');
end
%% For o a and b
try
     cep_matrix_a{11} = load('cep_mat_ao.mat');
     disp('Found File');
catch
    cep_matrix_a{11} = GetMFCC('oa.wav', lower, upper, M);
    fprintf('Done with oa');
    to_save = cep_matrix_a{11};
    save('cep_mat_ao.mat', 'to_save');
end
try
    cep_matrix_b{11} = load('cep_mat_bo.mat');
    disp('Found File');
catch
    cep_matrix_b{11} = GetMFCC('ob.wav', lower, upper, M);
    fprintf('Done with ob');
    to_save = cep_matrix_b{11};
    save('cep_mat_bo.mat', 'to_save');
end
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
