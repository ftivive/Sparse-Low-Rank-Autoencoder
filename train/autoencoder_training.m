% Load training and validation datas
load ('train_valid_data.mat');
% Normalise each radar signal
Train_Tg_sig = normalize_atoms(Train_sig);    % Training data (target signals)
Train_Bk_sig = normalize_atoms(X_hat);        % Training data (background + target signals)
%
load('model_hyperparameters', 'lambda',  'beta', 'gamma', 'no_elements');
tfc       = 1;    % Transfer function 'tansig'
iter_ct   = 50;   % Number of iterations
tol       = 1e-5; % Error tolerance
%%
n         = size(Train_Tg_sig,1);
Ds        = conj(dftmtx(n)) / sqrt(n);

lambda       = 1e-1;
beta         = 1e-3;
gamma        = 1e-1;


[P, V, W] = SLRAE(Train_Tg_sig, Train_Bk_sig, Ds, lambda, beta, gamma, no_elements, iter_ct, tol, tfc, 'yes');
save('autoencoder_weight', 'P', 'V', 'W');