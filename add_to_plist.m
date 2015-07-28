function err = add_to_plist(x,y,z)
global kg kgx kgy kgz pl

wrap = @(x, N) (1 + mod(x-1, N));
linindex = sub2ind(size(kg),x,y,z);

if (kg(x,y,z)==0)                                                            % Events are defined only for vacant sites
    
    % Along x-axis
    
    if (kg(wrap(x-1,kgx),y,z)==1)
        prob = calc_prob(x,y,z,wrap(x-1,kgx),y,z);
        pl(linindex,find(cellfun(@isempty,pl(linindex,:))>0,1,'first')) = {[wrap(x-1,kgx),y,z,prob*2]};
    end                                                                      % Insert the identified process into the first non-empty slot of pl
    
    if kg(wrap(x+1,kgx),y,z)==1
        prob = calc_prob(x,y,z,wrap(x+1,kgx),y,z);
        pl(linindex,find(cellfun(@isempty,pl(linindex,:))>0,1,'first')) = {[wrap(x+1,kgx),y,z,prob*2]};
    end
    
    
    
    % Along y-axis
    
    if kg(x,wrap(y-1,kgy),z)==1
        prob = calc_prob(x,y,z,x,wrap(y-1,kgy),z);
        pl(linindex,find(cellfun(@isempty,pl(linindex,:))>0,1,'first')) = {[x,wrap(y-1,kgy),z,prob*2]};
    end
    
    if kg(x,wrap(y+1,kgy),z)==1
        prob = calc_prob(x,y,z,x,wrap(y+1,kgy),z);
        pl(linindex,find(cellfun(@isempty,pl(linindex,:))>0,1,'first')) = {[x,wrap(y+1,kgy),z,prob*2]};
    end
    
    
    
    % Along \-diagonal
    
    if kg(wrap(x-1,kgx),wrap(y+1,kgy),z)==1
        prob = calc_prob(x,y,z,wrap(x-1,kgx),wrap(y+1,kgy),z);
        pl(linindex,find(cellfun(@isempty,pl(linindex,:))>0,1,'first')) = {[wrap(x-1,kgx),wrap(y+1,kgy),z,prob*2]};
    end
    
    if kg(wrap(x+1,kgx),wrap(y-1,kgy),z)==1
        prob = calc_prob(x,y,z,wrap(x+1,kgx),wrap(y-1,kgy),z);
        pl(linindex,find(cellfun(@isempty,pl(linindex,:))>0,1,'first')) = {[wrap(x+1,kgx),wrap(y-1,kgy),z,prob*2]};
    end
    
    
    
    % Along /-diagonal
    
    if kg(wrap(x-1,kgx),wrap(y-1,kgy),z)==1
        prob = calc_prob(x,y,z,wrap(x-1,kgx),wrap(y-1,kgy),z);
        pl(linindex,find(cellfun(@isempty,pl(linindex,:))>0,1,'first')) = {[wrap(x-1,kgx),wrap(y-1,kgy),z,prob/5]};
    end
    
    if kg(wrap(x+1,kgx),wrap(y+1,kgy),z)==1
        prob = calc_prob(x,y,z,wrap(x+1,kgx),wrap(y+1,kgy),z);
        pl(linindex,find(cellfun(@isempty,pl(linindex,:))>0,1,'first')) = {[wrap(x+1,kgx),wrap(y+1,kgy),z,prob/5]};
    end
    
    
    
    % Along z-axis
    
    if kg(x,y,wrap(z-1,kgz))==1
        prob = calc_prob(x,y,z,x,y,wrap(z-1,kgz));
        pl(linindex,find(cellfun(@isempty,pl(linindex,:))>0,1,'first')) = {[x,y,wrap(z-1,kgz),prob]};
    end
    
    if kg(x,y,wrap(z+1,kgz))==1
        prob = calc_prob(x,y,z,x,y,wrap(z+1,kgz));
        pl(linindex,find(cellfun(@isempty,pl(linindex,:))>0,1,'first')) = {[x,y,wrap(z+1,kgz),prob]};
    end
    
end

err = [];

end
