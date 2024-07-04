function fcn = BOfcn(TWI, Mask, X, X_hat, Ds, scene, Tsignal, iter_ct, tol, tfc)
    fcn          = @hyper_obj_fcn;        
    Target_Mask  =  Mask;
    Clutter_Mask = abs(1 - Mask);
    function Result = hyper_obj_fcn(hypers)
        %
        lambda      = hypers.lambda;
        beta        = hypers.beta;
        gamma       = hypers.gamma;
        no_elements = hypers.no_elements;
        %%
        [P, V, W] = SLRAE(X, X_hat, Ds, 10^(-lambda), 10^(-beta), 10^(-gamma), no_elements, iter_ct, tol, tfc, 'no');
        Esignal   = V * Q_f((W * (Tsignal - P * Tsignal)), tfc); 
        S         = ds_2dbeamforming(TWI, Esignal);
        R         = abs(reshape(S, size(scene{1})));
        T_1       = (R .*  Target_Mask);
        C_1       = (R .*  Clutter_Mask);
        T_1       = sum(T_1(:)) / sum(Target_Mask(:));
        C_1       = sum(C_1(:)) / sum(Clutter_Mask(:));
        Result    = -log(T_1 / (eps +  C_1));  
        
    end
end