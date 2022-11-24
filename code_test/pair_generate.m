function [source,destination] = pair_generate(max_x,max_y,dx,dy,n)
%PAIR_GENERATE: Generate multiple pairs of source and destination nodes spaced within a certain range.   


xSource = randi([0,max_x-1],n,1);
ySource = randi([0,max_y-1],n,1);

if dx == max_x-1 && dy == max_y-1
    xDestination = randi([0,max_x-1],n,1);
    yDestination = randi([0,max_y-1],n,1);
    source = [xSource,ySource];
    destination = [xDestination,yDestination];
else
    for i = 1:n
        p_x = rand;
        p_y = rand;
        if p_x>0.5
            x_gap = max_x-1-xSource(i);
            if x_gap==0
                xDestination(i) = xSource(i)-round(rand*dx);
            elseif x_gap<=dx
                xDestination(i) = xSource(i)+round(rand*x_gap);
            else
                xDestination(i) = xSource(i)+round(rand*dx);
            end
        elseif p_x<=0.5
            x_gap = xSource(i);
            if x_gap==0
                xDestination(i) = xSource(i)+round(rand*dx);
            elseif x_gap<=dx
                xDestination(i) = xSource(i)-round(rand*x_gap);
            else
                xDestination(i) = xSource(i)-round(rand*dx);
            end
        end
        if p_y>0.5
            y_gap = max_y-1-ySource(i);
            if y_gap==0
                yDestination(i) = ySource(i)-round(rand*dy);
            elseif y_gap<=dy
                yDestination(i) = ySource(i)+round(rand*y_gap);
            else
                yDestination(i) = ySource(i)+round(rand*dy);
            end
        elseif p_y<=0.5
            y_gap = ySource(i);
            if y_gap==0
                yDestination(i) = ySource(i)+round(rand*dy);
            elseif y_gap<=dy
                yDestination(i) = ySource(i)-round(rand*y_gap);
            else
                yDestination(i) = ySource(i)-round(rand*dy);
            end
        end
    end
    source = [xSource,ySource];
    destination = [xDestination',yDestination'];
end

end

