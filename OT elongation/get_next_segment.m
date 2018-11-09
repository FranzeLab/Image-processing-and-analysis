function [node,neigh] = get_next_segment(r,im)

    dx = [-1,0,1,0,-1,1,1,-1];
    dy = [0,1,0,-1,1,1,-1,-1];

    node = 0; neigh = 0;
    for i = 1 : length(r)
        x = r(i,1);
        y = r(i,2);
        for k = 1 : length(dx)
            if (im(y+dy(k),x+dx(k))==-1)
                node = i;
                neigh = k;
                break;
            end
        end
        if (node)
            break;
        end
    end
    
end