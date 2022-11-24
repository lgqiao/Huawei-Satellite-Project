function num_inter = num_inter_square(x1,y1,x2,y2,t)
%NUM_INTER_SQUARE: Count the number of intersections of a square with peaks and valleys


x_min = min(x1,x2);
x_max = max(x1,x2);
y_min = min(y1,y2);
y_max = max(y1,y2);

yl_valley = fx_valley(x_min,t);
xt_valley = fy_valley(y_min,t);
yl_peak = fx_peak(x_min,t);
xt_peak = fy_peak(y_min,t);

k_yl_valley = find(yl_valley>=y_min & yl_valley<=y_max);
k_xt_valley = find(xt_valley>x_min & xt_valley<=x_max);
k_yl_peak = find(yl_peak>=y_min & yl_peak<=y_max);
k_xt_peak = find(xt_peak>x_min & xt_peak<=x_max);

num_inter = length(k_yl_valley)+length(k_xt_valley)+length(k_yl_peak)+length(k_xt_peak);

end

