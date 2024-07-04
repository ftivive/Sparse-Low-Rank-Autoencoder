function X = normalize_atoms(X)
[~,c] = size(X);
%% 
for m = 1:c
     G      = X(:,m);     
     X(:,m) = (G(:) - mean(G)) / norm(G);     
end