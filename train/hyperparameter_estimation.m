% Load training and validation datas
load ('train_valid_data.mat');
% Normalise each radar signal
Train_Tg_sig = normalize_atoms(Train_sig);    % Training data (target signals)
Train_Bk_sig = normalize_atoms(X_hat);        % Training data (background + target signals)
Bk_sig       = normalize_atoms(Bk_sig);       % Validation data (background) of  a single scene
Tg_sig       = normalize_atoms(Tg_sig);       % Validation data (background + target) of a single scene
%
tfc     = 1;    % Transfer function 'tansig'
iter_ct = 50;   % Number of iterations
tol     = 1e-5; % Error tolerance
[lambda, beta, gamma, no_elements] = train(TWI, Train_sig, Train_Bk_sig, Tg_sig, Bk_sig, tfc, iter_ct, tol);
save ('model_hyperparameters', 'lambda',  'beta', 'gamma', 'no_elements');