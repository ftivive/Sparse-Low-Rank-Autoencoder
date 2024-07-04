function [lambda, beta, gamma, no_elements] = train(TWI, X, X_hat, Tg_sg, Bk_sg, tfc, iter_ct, tol)
   
    
    %% Define behind-the-wall-radar image
    TWI.num_receiver = 41;  % Number of transceivers
    TWI.No_R_px      = 100; % Number of row pixels 
    TWI.No_C_px      = 100; % Number of column pixels
    TWI.Z            = 3.0; % Downrange  (meter)
    TWI.X            = 3.0; % Crossrange (meter)
    TWI.Zoff         = 1.5; % Standoff distance between the wall and the radar (meter)
    scene            = scene_design(TWI);  % Define the TWRI scene    
    %% Create beamformed image and the target masks
    S              = ds_2dbeamforming(TWI, Tg_sg - Bk_sg);
    TWI_image      = abs(reshape(S, size(scene{1})));
    abs_U          = TWI_image / max(TWI_image(:));
    abs_U          = abs_U .* double(20*log10(abs_U) >= -30);
    G              = abs_U(:);
    G(G==0)        = [];
    abs_U          = (abs_U - min(G)) / (max(G) - min(G));
    abs_U          = imfilter(abs_U, fspecial('gaussian', [9,9], 9/6), 'same', 'replicate');
    Mask           = double(abs_U >= 0.2);
    Mask           = double(imfilter(Mask, fspecial('gaussian', [3,3], 3/6), 'same', 'replicate') > 0);
    %% Create DFT dictionary for low-rank
    n       = size(X,1);
    Ds      = conj(dftmtx(n)) / sqrt(n);
    %% Initialise Bayesian Optimisation
    fcn     = BOfcn(TWI, Mask, X, X_hat, Ds, scene, Tg_sg, iter_ct, tol, tfc);
    %%
    hyper0  = optimizableVariable('lambda',      [1,    10],   'Type', 'integer');
    hyper1  = optimizableVariable('beta'  ,      [1,    10],   'Type', 'integer');
    hyper2  = optimizableVariable('gamma' ,      [1,    10],   'Type', 'integer');
    hyper3  = optimizableVariable('no_elements', [100, 400],   'Type', 'integer');
    hypers  = [hyper0, hyper1, hyper2, hyper3];
    %% Run Bayesian Optimisation
    rng default;
    disp('Bayesian Optimization running...');
    BayesObject = bayesopt(fcn, hypers, 'AcquisitionFunctionName', 'expected-improvement-plus', ...
                  'MaxObjectiveEvaluations', 30 ,'Verbose', 1, 'PlotFcn', []);
    Best_result  = bestPoint(BayesObject);
    X1           = table2cell(Best_result);
    lambda       = X1{1,1};
    beta         = X1{1,2};
    gamma        = X1{1,3};
    no_elements  = X1{1,4};
    
    
    






















