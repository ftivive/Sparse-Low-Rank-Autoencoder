function A = soft_threshold(A, thr)
    A = sign(A) .* max(abs(A) - thr, 0);      
end