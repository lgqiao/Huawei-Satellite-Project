function x = fy_peak_ex(y,t)
%FY_PEAK_EX: Compute the x value over the peak for a given value of y at a certain time


global T T_x k_T gap_x
k_t = 2*T_x/T;

x1 = 1/k_T*y+3*T_x+k_t*t+gap_x;

x = x1:-T_x:x1-11*T_x;

end
