function err = make_ordered(fromx,fromy,fromz,tox,toy,toz,type,zoffset)
global kg

kg(fromx:tox,fromy:toy,fromz:toz) = 1;                                       % Initialize a kMC grid with no vacancies

if (strcmp(type,'4C'))                                                       % If you want a 4C structure
    
    for z = fromz:toz
        for x = fromx:tox
            for y = fromy:toy
                if ((mod(x,2)==0) && (mod(y,2)==0) && (mod(z+zoffset,4)==1))
                    kg(x,y,z)=0;
                end
                if ((mod(x,2)==0) && (mod(y,2)==1) && (mod(z+zoffset,4)==3))
                    kg(x,y,z)=0;
                end
                
            end
        end
    end
    
    
elseif (strcmp(type,'5C'))                                                   % If you want a 4C structure
    
    for z = fromz:toz
        for x = fromx:tox
            for y = fromy:toy
                
                if ((mod(x,2)==0) && (mod(y,2)==0) && (mod(z+zoffset,10)==1))
                    kg(x,y,z)=0;
                end
                
                if ((mod(x,2)==0) && (mod(y,2)==1) && (mod(z+zoffset,10)==4))
                    kg(x,y,z)=0;
                end
                
                if ((mod(x,2)==0) && (mod(y,2)==0) && (mod(z+zoffset,10)==6))
                    kg(x,y,z)=0;
                end
                
                if ((mod(x,2)==0) && (mod(y,2)==1) && (mod(z+zoffset,10)==9))
                    kg(x,y,z)=0;
                end
                
            end
        end
    end
    
    
end

err=[];

end