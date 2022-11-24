function [point_sy_end,point_ver,point_hor] = symmetric_dividing(x1,y1,x2,y2,t)
%SYMMETRIC_DIVIDING: Calculate symmetrical dividing line in rectangular area


global T_x T_y k_T

% if it is forward, hor = left, ver = top
% if it is reverse, hor = right, ver = bottom

dx = x2-x1;

% Calculate the intersection of the peak line with the rectangle boundary
y_ver = fx_peak(x1,t);
x_hor = fy_peak(y1,t);

% Determine if there is a symmetrical dividing line
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

if isempty(k_y_ver)==1 && isempty(k_x_hor)==1
    return
elseif isempty(k_y_ver)==0
    dy = y_ver(k_y_ver)-y1;
    y_symmetric = y1+2*dy;
    if dx>0 && y_symmetric<y2 % forward
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
