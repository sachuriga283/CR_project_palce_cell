function h = subplottight(n,m,i)

[c,r] = ind2sub([m n], i);
ax = subplot('Position', [(c-1)/m, 1-(r)/n, 0.95/m, 0.95/n])
if(nargout > 0)
    h = ax;
end

% subplottight(1,3,1), imshow(I1, 'border', 'tight');