function theta_out = theta(x,y,z)
global kg kgx kgy kgz ref_4 ref_4_2
wrap = @(x, N) (1 + mod(x-1, N));

w_2d = [.25 .5 .5 .5 .25; .5 1 1 1 .5 ; .5 1 1 1 .5 ; .5 1 1 1 .5 ; .25 .5 .5 .5 .25]*(25/16); % 2D stencil
w_3d_4c = cat(3,w_2d,w_2d,w_2d,w_2d,w_2d,w_2d,w_2d,w_2d);                                      % 3D stencil is just an array of 2D stencils

rms4 = zeros(9,9,17);

for i = -4:4
    for j = -4:4
        for k = -7:9
            dev_4c = reshape(sum(sum(kg(wrap(x+i-2:x+i+2,kgx),wrap(y+j-2:y+j+2,kgy),wrap(z+k-4:z+k+3,kgz)).*w_3d_4c,1),2),size(ref_4))/25;  % dev_4c is the 1D average of stencil*kg
            rms4(i+5,j+5,k+8) = min(sum(abs(dev_4c - ref_4)),sum(abs(dev_4c - ref_4_2)));
        end
    end
end

theta_arr = 1-rms4;

for i = 1:9
    for j = 1:9
        for k = 1:17
            
            if (rms4(i,j,k)<0.05)
                loop_i = i-2:i+2 ; loop_i = loop_i(loop_i>0);
                loop_j = j-2:j+2 ; loop_j = loop_j(loop_j>0);
                loop_k = k-4:k+3 ; loop_k = loop_k(loop_k>0);
                theta_arr(loop_i,loop_j,loop_k) = 1-rms4(i,j,k);
            end
            
        end
    end
end

theta_out = mean(mean(mean(theta_arr(3:7,3:7,5:12))));


end
