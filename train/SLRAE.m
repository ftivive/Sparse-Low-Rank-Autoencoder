function [P, V, W] = SLRAE(X, X_hat, D, lambda, beta, gamma, no_elements, iter_count, tol, tfc, disp)
%% Objective function: Auto-encoder with low-rank and sparsity constraints
%% Min(W, V, D):  lambda||P||_* + beta||D*S||_1 + 0.5||Q_f(W * S) - Z|| + gamma ( ||W||^_(2,1) +||V^T||^_(2,1))      
%%                s.t.  X_hat = VZ + S, X = P * X
%%  
    %%
    [r,~]   = size(X);        
    %% 
    W       = randn(no_elements, r);
    V       = randn(size(X_hat,1), no_elements);
    %%
    I0      = eye(r);
    I1      = eye(no_elements);    
    %%  
    [P,~,~] = Fast_SVD(X * X');
    P       =  P(:,1);
    P       = (P * P');   
    %%   
    S       = X - P * X;
    Z       = W * S;
    A       = zeros(size(P));
    B       = zeros(size(X_hat));
    mu      = 1;   
    U1      = I1;
    U2      = I1;
    pho     = 1e-10;   
    X_inv   = I0 / (X * X' + I0); 
    for n = 1 : iter_count 
        thr_A = lambda / mu;
        J     = nuclear_norm(P + A /mu, thr_A);
        P     = ((J - A / mu) + (X - S + B / mu) * X') * X_inv;        
        %%        
        G     = (I0 + (W' * W)/mu) \ ((X - P * X + B / mu) + W' * Q_finv(Z, tfc) / mu);
        thr_B = beta / mu;
        S     = D' * soft_threshold(D * G, thr_B);          
        %%
        W     = lyap_local(2 * gamma * U1, S * S', -Q_finv(Z, tfc) * S');
        Z     = ((V' * V)  + I1) \ (V' * X_hat + Q_f(W * S, tfc));       
        V     = (X_hat * Z') / (2 * gamma * U2 + Z * Z');        
        for m = 1:no_elements
            U1(m,m) = 1/(2 * norm(W(m,:)) + pho);            
            U2(m,m) = 1/(2 * norm(V(:,m)) + pho);
        end       
        %%     
        A  = A + mu * (P - J);
        B  = B + mu * (X - P * X - S);    
        mu = min(1.1 * mu, 1e5);
        %%        
        X_hat_estimated = V * Q_f((W * (X - P * X)), tfc);
        Error           = norm((X_hat_estimated - X_hat), 'fro');
        if strcmp(disp, 'yes')
            fprintf('Iter %2d: -- Error: %3.5f - Mu: %3.3f - Thr_A: %1.3f - Thr_B: %1.3f \n', n, Error, mu, thr_A, thr_B); 
        end
        if (Error <= tol) && (n > 2) 
            break;
        end         
    end   
end 
%%
%%
function Q = nuclear_norm(Q, thr)
    [U,S,V] = Fast_SVD(Q); 
    Q       = (U * soft_threshold(S, thr) * V');    
end
function A = soft_threshold(A, thr)
    A = sign(A) .* max(abs(A) - thr, 0);      
end