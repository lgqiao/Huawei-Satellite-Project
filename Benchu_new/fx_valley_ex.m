function y = fx_valley_ex(x,t)
%FX_VALLEY_EX: Compute the y value over the valley for a given value of x at a certain time


global T T_y k_T gap_y
k_t = 2*T_y/T;

y1 = k_T*x-7/2*T_y-k_t*t-gap_y;

y = y1:T_y:y1+11*T_y;

end