function inter = inter_square(x1,y1,x2,y2,t,type)
%INTER_SQUARE: Calculate the intersection of peaks or valleys with square


dx = x2-x1;
if dx>0 % forward
    x_min = x1;
    y_min = y1;
    x_max = x2;
    y_max = y2;
elseif dx<0 % reverse
    x_min = x2;
    y_min = y2;
    x_max = x1;
    y_max = y1;
end

% Calculate the intersection of the four sides(lines) of the
% rectangle with valley or peak lines
if type==1
    yl = fx_valley(x_min,t);
    yr = fx_valley(x_max,t);
    xt = fy_valley(y_min,t);
    xb = fy_valley(y_max,t);
elseif type==2
    yl = fx_peak(x_min,t);
    yr = fx_peak(x_max,t);
    xt = fy_peak(y_min,t);
    xb = fy_peak(y_max,t);
end

inter_l = [];
inter_r = [];
inter_t = [];
inter_b = [];

% Constrain the intersection to the line segments 
% corresponding to the four sides of the rectangle
k_yl = find(yl>=y_min & yl<=y_max);
for i = length(k_yl):-1:1
    inter_l = [inter_l;x_min,yl(k_yl(i))];
end
k_yr = find(yr>=y_min & yr<=y_max);
for i = length(k_yr):-1:1
    inter_r = [inter_r;x_max,yr(k_yr(i))];
end
k_xt = find(xt>x_min & xt<=x_max);
for i = length(k_xt):-1:1
    inter_t = [inter_t;xt(k_xt(i)),y_min];
end
k_xb = find(xb>=x_min & xb<x_max);
for i = length(k_xb):-1:1
    inter_b = [inter_b;xb(k_xb(i)),y_max];
end

if dx>0 % forward
    inter = [[inter_l;inter_t],[inter_b;inter_r]];
elseif dx<0 % reverse
    inter = [[flipud(inter_r);flipud(inter_b)],[flipud(inter_t);flipud(inter_l)]];
end

end
