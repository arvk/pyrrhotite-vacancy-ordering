function prob = calc_prob(fromx,fromy,fromz,tox,toy,toz)
global kg T dG

kB = 1.3806488e-23;                                                          % kB in Joule/Kelvin
Prefactor = 1e13;                                                            % Diffusion prefactor
Barrier = 1.68*1.6e-19;                                                      % Migration barrier for Fe hopping in pyrrhotite


%% Phase stability (Structural energy)
dG_local = dG*(20*8)/6.022e23;                                               % Stability of 4C in Joule/4C_unitcell

kg(fromx,fromy,fromz) = 1; kg(tox,toy,toz) = 0;
theta_to = theta(tox,toy,toz);
moment_to = calc_moment();

kg(fromx,fromy,fromz) = 0; kg(tox,toy,toz) = 1;
theta_from = theta(fromx,fromy,fromz);
moment_from = calc_moment();

if (theta_from < theta_to)
    
    gfrom = dG_local*(0-theta_from);
    gto = dG_local*(0-theta_to);
    
    crys_E = (gfrom-gto);
    
    %% Magnetic energy
    
    BM = 9.27400968e-24;                                                     % 1 Bohr magneton in Joule/Tesla
    mu_0 = 1.2566e-6;                                                        % Free space permeability in Newton/Ampere^2
    mu_r = 1.00;                                                             % Relative permeability of pyrrhotite
    H = 1e4*79.5774715;                                                      % Applied field in Ampere/meter
    
    mag_E = (moment_to - moment_from)*3*BM*mu_0*mu_r*H;
    
    
    %% Calculation of jump probability
    prob = Prefactor*exp(-Barrier/(kB*T))*exp(crys_E/(kB*T))*exp(mag_E/(kB*T));
    
    
else
    prob = 0.0;
end

end