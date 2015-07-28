pause(1)
rng('shuffle')
clear ALL
global kg kgx kgy kgz pl ref_4 ref_4_2 T dG
wrap = @(x, N) (1 + mod(x-1, N));                                            % Inline function that imposes a periodic boundary


%% Simulation parameters

kgx = 20; kgy = 20; kgz = 44;                                                % Cell sizes in x, y, and z directions
no_mc_steps = 20001;                                                         % Number of Monte Carlo steps
write_freq = 100;                                                            % How often magnetic moment statistics are written out
T = 463;                                                                     % Temperature in Kelvin

%% Variable preallocation and initialization

pl = cell(kgx*kgy*kgz,10);                                                   % Initialize empty process list
moments = zeros(1,no_mc_steps);                                              % Initialize magnetic moments
time = zeros(1,no_mc_steps);                                                 % Initialize array that stores timing information

ref_4 = [0.75 1.00 0.75 1.00 0.75 1.00 0.75 1.00];                           % Reference 4C structure to compare against
ref_4_2 = [1.00 0.75 1.00 0.75 1.00 0.75 1.00 0.75];                         % Reference 4C structure to compare against (just an offset from the last line)


%% Calculate phase stabilities and driving force
H_4C = -755.4e3+(140.5*(T-298))-(0.7*(T^2-298^2)/2)+(3.1e-7*(T^3-298^3)/3);  % Enthalpy (J/mol)
S_4C = 486.3+(140.5*log(T/298))-(0.7*(T-298))+(3.1e-7*(T^2-298^2)/2);        % Entropy (J/mol-K)
G_4C = H_4C - (T*S_4C);                                                      % Gibbs Free Energy (J/mol)

H_5C = -950.8e3+(170.6*(T-298))-(0.5*(T^2-298^2)/2)+(5e-4*(T^3-298^3)/3);    % Enthalpy (J/mol)
S_5C = 623.5+(170.6*log(T/298))-(0.5*(T-298))+(5e-4*(T^2-298^2)/2);          % Entropy (J/mol-K)
G_5C = H_5C - (T*S_5C);                                                      % Gibbs Free Energy (J/mol)

dG = (G_5C/9)-(G_4C/7);                                                      % Difference in free energies = Driving force

%% Set-up KMC cell

% Random distribution of vacancies
c_v = (1/11);
kg = double((random('unif',0,1,[kgx, kgy, kgz])>c_v));                       % Initialize the kMC grid with a given fraction of vacancies

while sum(sum(sum(kg)))/numel(kg)~=(1-c_v)
    kg = double((random('unif',0,1,[kgx, kgy, kgz])>c_v));
end                                                                          % Ensure that the kMC grid has the required number of vacancies

%make_ordered(1,1,1,kgx,kgy,8,'4C',0);                                       % (Optionally) Create 4C or 5C ordered vacancy structures
%make_ordered(1,1,(kgz/2)+1,kgx,kgy,kgz,'4C',1);                             % (Optionally) Create 4C or 5C ordered vacancy structures


%% Initialize process-list based on existing geometry

fprintf('%s :: %s \n',datestr(now), 'Initializing process list')

for x = 1:kgx
    for y = 1:kgy
        for z = 1:kgz
            add_to_plist(x,y,z);
        end
    end
end

fprintf('%s :: %s \n',datestr(now), 'Process list initialized. Starting KMC loop.')


%% Start KMC time loop

time_of_exp = 0.0;

for t=1:no_mc_steps
    
    sum_prob = 0.0;
    tripper = 0.0;
    
    nonempty = find(cellfun(@isempty,pl(:,1))==0);                           % If the first element (to_x) in the processlist is 0, ignore it
    for i = 1:size(nonempty,1)
        plrow = pl(nonempty(i),:);
        plrowmat = cell2mat(plrow);
        sum_prob = sum_prob + sum(plrowmat(4:4:size(plrowmat,2)));
    end
    
    time_of_exp = time_of_exp - log(rand)/sum_prob;
    
    cutoff = rand*sum_prob;                                                  % Generate random number between 0,sum_of_probabilities
    
    for i = 1:size(nonempty,1)
        plrow = pl(nonempty(i),:);
        plrowmat = cell2mat(plrow);
        
        for j = 4:4:size(plrowmat,2)
            tripper = tripper + plrowmat(j);                                 % Cumulative sum of every fourth element (probability) in the non-empty process list
            if (tripper>cutoff)
                
                [x,y,z] = ind2sub([kgx,kgy,kgz],nonempty(i));                % Randomly selected event is executed
                kg(x,y,z)=1;
                kg(plrowmat(j-3),plrowmat(j-2),plrowmat(j-1))=0;
                
                for p=x-1:x+1
                    for q=y-1:y+1
                        for r=z-1:z+1
                            linindex = sub2ind(size(kg),wrap(p,kgx),wrap(q,kgy),wrap(r,kgz));
                            pl(linindex,:)={[]};
                            add_to_plist(wrap(p,kgx),wrap(q,kgy),wrap(r,kgz));  % Recreate process lists for all neighbors (of the from_site)
                        end
                    end
                end
                
                for p=plrowmat(j-3)-1:plrowmat(j-3)+1
                    for q=plrowmat(j-2)-1:plrowmat(j-2)+1
                        for r=plrowmat(j-1)-1:plrowmat(j-1)+1
                            linindex = sub2ind(size(kg),wrap(p,kgx),wrap(q,kgy),wrap(r,kgz));
                            pl(linindex,:)={[]};
                            add_to_plist(wrap(p,kgx),wrap(q,kgy),wrap(r,kgz));  % Recreate process lists for all neighbors (of the to_site)
                        end
                    end
                end
                
                break
                
            end
        end
        if tripper>cutoff
            break
        end
    end
    
    
    
    %% Display output(s)
    
    moments(t) = calc_moment();
    time(t) = time_of_exp;
    
    
    if (mod(t,write_freq)==1)
        fprintf('%s :: Time = %s, Moment = %s \n',datestr(now), num2str(time_of_exp), num2str(calc_moment()) )
        mom = moments(1:t); 
        tim = time(1:t); 
        eval(sprintf('save svd_%s.mat kg mom tim', num2str(t)))
    end
    
end

fprintf('%s :: %s \n',datestr(now), 'Ending KMC loop.')
