function y = fx_peak(x,t)
%FX_PEAK: Compute the y value over the peak for a given value of x at a certain time


global T T_y k_T gap_y
k_t = 2*T_y/T;

y = [];
y(1) = k_T*x-T_y-k_t*t;
y(2) = k_T*x-k_t*t;
y(3) = k_T*x+T_y-k_t*t;
y(4) = k_T*x+2*T_y-k_t*t;
y(5) = k_T*x+3*T_y-k_t*t;
y(6) = k_T*x+4*T_y-k_t*t;

y = y-gap_y;

% if t==0
%     y(1) = 5/8*x-75/2-15/19*t;
%     y(2) = 5/8*x-15/19*t;
%     y(3) = 5/8*x+75/2-15/19*t;
% elseif t>0 && t<1/8*T
%     y(1) = 5/8*x-75/2-15/19*t;
%     y(2) = 5/8*x-15/19*t;
%     y(3) = 5/8*x+75/2-15/19*t;
%     y(4) = 5/8*x+75-15/19*t;
% elseif t>=1/8*T && t<=1/2*T
%     y(1) = 5/8*x-15/19*t;
%     y(2) = 5/8*x+75/2-15/19*t;
%     y(3) = 5/8*x+75-15/19*t;
% elseif t>1/2*T && t<5/8*T
%     y(1) = 5/8*x-15/19*t;
%     y(2) = 5/8*x+75/2-15/19*t;
%     y(3) = 5/8*x+75-15/19*t;
%     y(4) = 5/8*x+225/2-15/19*t;
% elseif t>=5/8*T && t<=T
%     y(1) = 5/8*x+75/2-15/19*t;
%     y(2) = 5/8*x+75-15/19*t;
%     y(3) = 5/8*x+225/2-15/19*t;
% end

end
