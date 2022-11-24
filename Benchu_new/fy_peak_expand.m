function x = fy_peak_expand(y,t)
%FY_PEAK_EXPAND: Compute the x value over the peak for a given value of y at a certain time


global T T_x k_T gap_x
k_t = 2*T_x/T;

x1 = 1/k_T*y+3*T_x+k_t*t+gap_x;

x = x1:-T_x:x1-11*T_x;

% x = [];
% 
% x(1) = k_T1*y+3*T_x+k_t*t;
% x(2) = k_T1*y+2*T_x+k_t*t;
% x(3) = k_T1*y+T_x+k_t*t;
% x(4) = k_T1*y+k_t*t;
% x(5) = k_T1*y-T_x+k_t*t;
% x(6) = k_T1*y-2*T_x+k_t*t;
% x(7) = k_T1*y-3*T_x+k_t*t;
% x(8) = k_T1*y-4*T_x+k_t*t;
% x(9) = k_T1*y-5*T_x+k_t*t;
% x(10) = k_T1*y-6*T_x+k_t*t;
% x(11) = k_T1*y-7*T_x+k_t*t;
% x(12) = k_T1*y-8*T_x+k_t*t;
% 
% x = x+gap_x;

end
