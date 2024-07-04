function A = Q_finv(B, tfc)
    switch tfc
        case 1              
            A = atanh(B);
        case 2
            A = inv_logsig(B);
        case 3
            A = B;
        case 4
            n    = size(B,1);
            Ds   = dftmtx(n) / sqrt(n);
            B_r  = atanh(real(B));
            B_i  = atanh(imag(B));
            A    = Ds' * (B_r + 1i .* B_i) / 10;          
    end
end
%%
function y = inv_logsig(x)
    y = log(x ./ (1 - x));
end