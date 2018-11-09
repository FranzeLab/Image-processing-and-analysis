function skeleton = trackskeleton(r,im)

    edge = 0;

    dx = [-1,0,1,0,-1,1,1,-1];
    dy = [0,1,0,-1,1,1,-1,-1];

    i = 1;
    while (i~=0)

        [i,k] = get_next_segment(r,im);            

        disp([i k]);
        
        if (i)

            x = r(i,1);
            y = r(i,2);
            im(y,x) = 0;
            segment = [x y];
            x = r(i,1)+dx(k);
            y = r(i,2)+dy(k);
            j = im(y,x);
            im(y,x) = 0;
            segment = [segment;[x y]];
            while (j==-1)
                k = 1;
                while (im(y+dy(k),x+dx(k))==0)
                    k = k + 1;
                end
                x=x+dx(k);
                y=y+dy(k);
                j = im(y,x);
                im(y,x) = 0;
                segment = [segment;[x y]];
            end        

            edge = edge + 1;

            im(r(i,2),r(i,1)) = i;
            im(r(j,2),r(j,1)) = j;    

            skeleton.list(edge,1:2) = [i j];
            skeleton.paths{edge} = segment;

        end
        
    end

end