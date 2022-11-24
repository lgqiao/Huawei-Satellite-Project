function [sy_source,flag] = symmetric_end(x1,y1,x2,y2,t)
%SYMMETRIC_END: Determine and calculate the symmetry point of the source node about the peak line


global T_x T_y 

% if it is forward, hor = left, ver = top
% if it is reverse, hor = right, ver = bottom

dx = x2-x1;

% Calculate the intersection of the peak line with the rectangle boundary
y_ver = fx_peak_ex(x1,t);
x_hor = fy_peak_ex(y1,t);

% Determine if there is a symmetrical dividing line
if dx>0 % forward
    k_y_ver = find(y_ver>y1 & y_ver<y1+T_y/2);
    k_x_hor = find(x_hor>x1 & x_hor<x1+T_x/2);
elseif dx<0 % reverse
    k_y_ver = find(y_ver>y1-T_y/2 & y_ver<y1);
    k_x_hor = find(x_hor>x1-T_x/2 & x_hor<x1);
end

x_symmetric = [];
y_symmetric = [];
sy_source = [];
flag = 0;

if isempty(k_y_ver)==0
    dy = y_ver(k_y_ver)-y1;
    y_symmetric = y1+2*dy;
    if (dx>0 && y_symmetric<y2) || (dx<0 && y_symmetric>y2)
        sy_source = [x1,y_symmetric];
    end
elseif isempty(k_x_hor)==0
    dx = x_hor(k_x_hor)-x1;
    x_symmetric = x1+2*dx;
    if (dx>0 && x_symmetric<x2) || (dx<0 && x_symmetric>x2)
        sy_source = [x_symmetric,y1];
    end
end

if isempty(sy_source)==1
    if isempty(y_symmetric)==0
        if dx>0 && y_symmetric-1<y2
            sy_source = [x1,y_symmetric-1];
        elseif dx<0 && y_symmetric+1>y2
            sy_source = [x1,y_symmetric+1];
        end
    elseif isempty(x_symmetric)==0
        if dx>0 && x_symmetric-1<x2
            sy_source = [x_symmetric-1,y1];
        elseif dx<0 && x_symmetric+1>x2
            sy_source = [x_symmetric+1,y1];
        end
    end
end

if isempty(sy_source)==1
    if isempty(k_y_ver)==1
        if dx>0 
            k_y_ver = find(y_ver>y1 & y_ver<y1+T_y/2+0.5);
        elseif dx<0
            k_y_ver = find(y_ver>y1-T_y/2-0.5 & y_ver<y1);
        end
        if isempty(k_y_ver)==0
            dy = y_ver(k_y_ver)-y1;
            y_symmetric = y1+2*dy;
            if dx>0 && y_symmetric>y2 && y_symmetric-1<y2
                sy_source = [x1,y_symmetric-1];
                flag = 1;
            elseif dx<0 && y_symmetric<y2 && y_symmetric+1>y2
                sy_source = [x1,y_symmetric+1];
                flag = 1;
            end
        end
    elseif isempty(k_x_hor)==1
        if dx>0
            k_x_hor = find(x_hor>x1 & x_hor<x1+T_x/2+0.5);
        elseif dx<0
            k_x_hor = find(x_hor>x1-T_x/2-0.5 & x_hor<x1);
        end
        if isempty(k_x_hor)==0
            dx = x_hor(k_x_hor)-x1;
            x_symmetric = x1+2*dx;
            if dx>0 && x_symmetric>x2 && x_symmetric-1<x2
                sy_source = [x_symmetric-1,y1];
                flag = 1;
            elseif dx<0 && x_symmetric<x2 && x_symmetric+1>x2
                sy_source = [x_symmetric+1,y1];
                flag = 1;
            end
        end
    end
end

if isempty(sy_source)==0
    if sy_source(1)==x1
        if dx>0 && y2-sy_source(2)<0.5
            sy_source = [x1,sy_source(2)-1];
        elseif dx<0 && sy_source(2)-y2<0.5
            sy_source = [x1,sy_source(2)+1];
        end
    elseif sy_source(2)==y1
        if dx>0 && x2-sy_source(1)<0.5
            sy_source = [sy_source(1)-1,y1];
        elseif dx<0 && sy_source(1)-x2<0.5
            sy_source = [sy_source(1)+1,y1];
        end
    end
end

end
