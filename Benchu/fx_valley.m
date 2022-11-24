function y = fx_valley(x,t)
%FX_VALLEY: Compute the y value over the valley for a given value of x at a certain time


global T T_y k_T gap_y
k_t = 2*T_y/T;

y = [];
y(1) = k_T*x-3*T_y/2-k_t*t;
y(2) = k_T*x-T_y/2-k_t*t;
y(3) = k_T*x+T_y/2-k_t*t;
y(4) = k_T*x+3*T_y/2-k_t*t;
y(5) = k_T*x+5*T_y/2-k_t*t;
y(6) = k_T*x+7*T_y/2-k_t*t;

y = y-gap_y;

% if t>=0 && t<=T/4
%     y(1) = 5/8*x-75/4-15/19*t;
%     y(2) = 5/8*x+75/4-15/19*t;
%     y(3) = 5/8*x+225/4-15/19*t;
% elseif t>T/4 && t<3/8*T
%     y(1) = 5/8*x-75/4-15/19*t;
%     y(2) = 5/8*x+75/4-15/19*t;
%     y(3) = 5/8*x+225/4-15/19*t;
%     y(4) = 5/8*x+375/4-15/19*t;
% elseif t>=3/8*T && t<=3/4*T
%     y(1) = 5/8*x+75/4-15/19*t;
%     y(2) = 5/8*x+225/4-15/19*t;
%     y(3) = 5/8*x+375/4-15/19*t;
% elseif t>3/4*T && t<T
%     y(1) = 5/8*x+75/4-15/19*t;
%     y(2) = 5/8*x+225/4-15/19*t;
%     y(3) = 5/8*x+375/4-15/19*t;
%     y(4) = 5/8*x+525/4-15/19*t;
% elseif t==T
%     y(1) = 5/8*x+225/4-15/19*t;
%     y(2) = 5/8*x+375/4-15/19*t;
%     y(3) = 5/8*x+525/4-15/19*t;
% end

end
