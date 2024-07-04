function A = norm_fcn(A, type)

switch type
    case 1
        A = A / 1;
    case 2
        A = A / norm(A(:));         
end
    