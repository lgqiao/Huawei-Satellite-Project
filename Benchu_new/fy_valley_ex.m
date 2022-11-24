function x = fy_valley_ex(y,t)
%FY_VALLEY_EX: Compute the y value over the valley for a given value of x at a certain time


global T T_x k_T gap_x
k_t = 2*T_x/T;

x1 = 1/k_T*y+7/2*T_x+k_t*t+gap_x;

x = x1:-T_x:x1-11*T_x;

end
