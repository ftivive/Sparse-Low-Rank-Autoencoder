function A = Q_f(B, tfc)
    switch tfc
        case 1
            A = tanh(B);
        case 2
            A = logsig(B);            
        case 3
            A = B;
        case 4
            n   = size(B,1);
            Ds  = dftmtx(n) / sqrt(n);
            B   = Ds * B * 10;
            B_r = tanh(real(B));
            B_i = tanh(imag(B));
            A   = (B_r + 1i .* B_i);            
    end
end
function y = logsig(x)
    y = 1 ./ (1 + exp(-x));    
end