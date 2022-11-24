function [point_sy_end,point_ver,point_hor] = symmetric_expand(x1,y1,x2,y2,max_x,max_y,t)
%SYMMETRIC_EXPAND: Calculate symmetrical dividing line in rectangular area


global T_x T_y k_T

% if it is forward, hor = left, ver = top
% if it is reverse, hor = right, ver = bottom

dx = x2-x1;

x_s = x1-max_x;
y_s = y1-max_y;
x_d = mod(x2,max_x);
y_d = mod(y2,max_y);

% Calculate the intersection of the peak line with the rectangle boundary
y_ver = fx_peak(x_s,t);
x_hor = fy_peak(y_s,t);

if dx>0
    if x2>=max_x && x2<2*max_x && y2>=2*max_y && y2<3*max_y
        y_ver_in = y_ver(y_ver>=y_s & y_ver<max_y);
        y_ver_out = y_ver(y_ver>=0 & y_ver<=y_d);
        y_ver = [y_ver_in+max_y,y_ver_out+2*max_y];
        x_hor = x_hor+max_x;
    elseif x2>=2*max_x && x2<3*max_x && y2>=2*max_y && y2<3*max_y
        y_ver_in = y_ver(y_ver>=y_s & y_ver<max_y);
        y_ver_out = y_ver(y_ver>=0 & y_ver<=y_d);
        y_ver = [y_ver_in+max_y,y_ver_out+2*max_y];
        x_hor_in = x_hor(x_hor>=x_s & x_hor<max_x);
        x_hor_out = x_hor(x_hor>=0 & x_hor<=x_d);
        x_hor = [x_hor_out+2*max_x,x_hor_in+max_x];
    elseif x2>=2*max_x && x2<3*max_x && y2>=max_y && y2<2*max_y
        y_ver = y_ver+max_y;
        x_hor_in = x_hor(x_hor>=x_s & x_hor<max_x);
        x_hor_out = x_hor(x_hor>=0 & x_hor<=x_d);
        x_hor = [x_hor_out+2*max_x,x_hor_in+max_x];        
    elseif x2>=max_x && x2<2*max_x && y2>=max_y && y2<2*max_y
        y_ver = y_ver+max_y;
        x_hor = x_hor+max_x;
    end
elseif dx<0
    if x2>=0 && x2<max_x && y2>=max_y && y2<2*max_y
        y_ver = y_ver+max_y;
        x_hor_in = x_hor(x_hor>=0 & x_hor<=x_s);
        x_hor_out = x_hor(x_hor>=x_d & x_hor<max_x);
        x_hor = [x_hor_in+max_x,x_hor_out];
    elseif x2>=max_x && x2<2*max_x && y2>=max_y && y2<2*max_y
        y_ver = y_ver+max_y;
        x_hor = x_hor+max_x;
    elseif x2>=max_x && x2<2*max_x && y2>=0 && y2<max_y
        y_ver_in = y_ver(y_ver>=0 & y_ver<=y_s);
        y_ver_out = y_ver(y_ver>=y_d & y_ver<max_y);
        y_ver = [y_ver_out,y_ver_in+max_y];
        x_hor = x_hor+max_x;
    elseif x2>=0 && x2<max_x && y2>=0 && y2<max_y
        y_ver_in = y_ver(y_ver>=0 & y_ver<=y_s);
        y_ver_out = y_ver(y_ver>=y_d & y_ver<max_y);
        y_ver = [y_ver_out,y_ver_in+max_y,];
        x_hor_in = x_hor(x_hor>=0 & x_hor<=x_s);
        x_hor_out = x_hor(x_hor>=x_d & x_hor<max_x);
        x_hor = [x_hor_in+max_x,x_hor_out];
    end
end

% Determine if there is a symmetrical dividing line, 1 is the deviation
if dx>0 % forward
    k_y_ver = find(y_ver>y1 & y_ver<y1+T_y/2);
    k_x_hor = find(x_hor>x1 & x_hor<x1+T_x/2);
elseif dx<0 % reverse
    k_y_ver = find(y_ver>y1-T_y/2 & y_ver<y1);
    k_x_hor = find(x_hor>x1-T_x/2 & x_hor<x1);
end

point_sy_end = [];
point_ver = [];
point_hor = [];

if isempty(k_y_ver)==0
    dy = y_ver(k_y_ver)-y1;
    y_symmetric = y1+2*dy;
    if dx>0 && y_symmetric<y2 % forward
        if abs(dy)>T_y/2
            y_symmetric = y_symmetric-1;
        end
        sy_source = [x1,y_symmetric];
        f = @(x) k_T*(x-x1)+y_symmetric;
        if round(f(x2))<=y2
            sy_destination = [x2,f(x2)];
        else
            f = @(y) 1/k_T*(y-y_symmetric)+x1;
            sy_destination = [f(y2),y2];
        end
        path_sy = path_generate2(sy_source(1),sy_source(2),sy_destination(1),sy_destination(2),3);
        sy_source = round(sy_source);
        sy_destination = round(sy_destination);
        point_sy_end = [sy_source,sy_destination];
        path_sy = [sy_source;path_sy;sy_destination];

        y_s = sy_source(2);
        y_d = sy_destination(2);
        dy = y_d-y_s;
        point_hor = [];
        row_hor = [];
        for i = 1:dy
            row = find(path_sy(:,2)==y_s+i);
            min_row = min(row);
            row_hor = [row_hor;min_row];
            point_hor = [point_hor;path_sy(min_row,:)];
        end
        path_sy(row_hor,:) = [];
        point_ver = path_sy;
    elseif dx<0 && y_symmetric>y2 % reverse
        if abs(dy)>T_y/2
            y_symmetric = y_symmetric+1;
        end
        sy_source = [x1,y_symmetric];
        f = @(x) k_T*(x-x1)+y_symmetric;
        if round(f(x2))>=y2
            sy_destination = [x2,f(x2)];
        else
            f = @(y) 1/k_T*(y-y_symmetric)+x1;
            sy_destination = [f(y2),y2];
        end
        path_sy = path_generate2(sy_source(1),sy_source(2),sy_destination(1),sy_destination(2),3);
        sy_source = round(sy_source);
        sy_destination = round(sy_destination);
        point_sy_end = [sy_source,sy_destination];
        path_sy = [sy_source;path_sy;sy_destination];

        y_s = sy_source(2);
        y_d = sy_destination(2);
        dy = y_d-y_s;
        point_hor = [];
        row_hor = [];
        for i = 1:-dy
            row = find(path_sy(:,2)==y_s-i);
            min_row = min(row);
            row_hor = [row_hor;min_row];
            point_hor = [point_hor;path_sy(min_row,:)];
        end
        path_sy(row_hor,:) = [];
        point_ver = path_sy;
    end
elseif isempty(k_x_hor)==0
    dx = x_hor(k_x_hor)-x1;
    x_symmetric = x1+2*dx;
    if x_symmetric<x2 && dx>0 % forward
        if abs(dx)>T_x/2
            x_symmetric = x_symmetric-1;
        end
        sy_source = [x_symmetric,y1];
        f = @(x) k_T*(x-x_symmetric)+y1;
        if round(f(x2))<=y2
            sy_destination = [x2,f(x2)];
        else
            f = @(y) 1/k_T*(y-y1)+x_symmetric;
            sy_destination = [f(y2),y2];
        end
        path_sy = path_generate2(sy_source(1),sy_source(2),sy_destination(1),sy_destination(2),3);
        sy_source = round(sy_source);
        sy_destination = round(sy_destination);
        point_sy_end = [sy_source,sy_destination];
        path_sy = [sy_source;path_sy;sy_destination];

        y_s = sy_source(2);
        y_d = sy_destination(2);
        dy = y_d-y_s;
        point_hor = [];
        row_hor = [];
        for i = 0:dy
            row = find(path_sy(:,2)==y_s+i);
            min_row = min(row);
            row_hor = [row_hor;min_row];
            point_hor = [point_hor;path_sy(min_row,:)];
        end
        path_sy(row_hor,:) = [];
        point_ver = path_sy;
    elseif x_symmetric>x2 && dx<0 % reverse
        if abs(dx)>T_x/2
            x_symmetric = x_symmetric+1;
        end
        sy_source = [x_symmetric,y1];
        f = @(x) k_T*(x-x_symmetric)+y1;
        if round(f(x2))>=y2
            sy_destination = [x2,f(x2)];
        else
            f = @(y) 1/k_T*(y-y1)+x_symmetric;
            sy_destination = [f(y2),y2];
        end
        path_sy = path_generate2(sy_source(1),sy_source(2),sy_destination(1),sy_destination(2),3);
        sy_source = round(sy_source);
        sy_destination = round(sy_destination);
        point_sy_end = [sy_source,sy_destination];
        path_sy = [sy_source;path_sy;sy_destination];

        y_s = sy_source(2);
        y_d = sy_destination(2);
        dy = y_d-y_s;
        point_hor = [];
        row_hor = [];
        for i = 0:-dy
            row = find(path_sy(:,2)==y_s-i);
            min_row = min(row);
            row_hor = [row_hor;min_row];
            point_hor = [point_hor;path_sy(min_row,:)];
        end
        path_sy(row_hor,:) = [];
        point_ver = path_sy;
    end
end

end