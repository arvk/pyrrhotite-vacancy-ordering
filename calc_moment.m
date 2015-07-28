function moment = calc_moment()
global kg kgz

% Difference in 3d sum over alternating layers (1:2:kgz vs. 2:2:kgz)
moment = abs(double(sum(sum(sum(kg(:,:,2:2:kgz))))-sum(sum(sum(kg(:,:,1:2:kgz))))));

end
