function inter = inter_square_expand_new(x1,y1,x2,y2,t)
%INTER_SQUARE_EXPAND_NEW: Calculate the intersection of valley and peak lines with square on extended map


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
yl = fx_valley_expand(x_min,t);
yr = fx_valley_expand(x_max,t);
xt = fy_valley_expand(y_min,t);
xb = fy_valley_expand(y_max,t);

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