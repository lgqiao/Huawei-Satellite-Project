function y = fx_peak_expand(x,t)
%FX_PEAK_EXPAND: Compute the y value over the peak for a given value of x at a certain time


global T T_y k_T gap_y
k_t = 2*T_y/T;

y1 = k_T*x-3*T_y-k_t*t-gap_y;

y = y1:T_y:y1+11*T_y;


% y = [];
% 
% y(1) = k_T*x-3*T_y-k_t*t;
% y(2) = k_T*x-2*T_y-k_t*t;
% y(3) = k_T*x-T_y-k_t*t;
% y(4) = k_T*x-k_t*t;
% y(5) = k_T*x+T_y-k_t*t;
% y(6) = k_T*x+2*T_y-k_t*t;
% y(7) = k_T*x+3*T_y-k_t*t;
% y(8) = k_T*x+4*T_y-k_t*t;
% y(9) = k_T*x+5*T_y-k_t*t;
% y(10) = k_T*x+6*T_y-k_t*t;
% y(11) = k_T*x+7*T_y-k_t*t;
% y(12) = k_T*x+8*T_y-k_t*t;
% 
% y = y-gap_y;

end
