function x = fy_valley(y,t)
%FY_VALLEY: Compute the x value over the valley for a given value of y at a certain time
   

global T T_x k_T gap_x
k_t = 2*T_x/T;

x = [];
x(1) = 1/k_T*y+3*T_x/2+k_t*t;
x(2) = 1/k_T*y+T_x/2+k_t*t;
x(3) = 1/k_T*y-T_x/2+k_t*t;
x(4) = 1/k_T*y-3*T_x/2+k_t*t;
x(5) = 1/k_T*y-5*T_x/2+k_t*t;
x(6) = 1/k_T*y-7*T_x/2+k_t*t;

x = x+gap_x;

% if t>=0 && t<=T/4
%     x(1) = 8/5*y+30+24/19*t;
%     x(2) = 8/5*y-30+24/19*t;
%     x(3) = 8/5*y-90+24/19*t;
% elseif t>T/4 && t<3/8*T
%     x(1) = 8/5*y+30+24/19*t;
%     x(2) = 8/5*y-30+24/19*t;
%     x(3) = 8/5*y-90+24/19*t;
%     x(4) = 8/5*y-150+24/19*t;
% elseif t>=3/8*T && t<=3/4*T
%     x(1) = 8/5*y-30+24/19*t;
%     x(2) = 8/5*y-90+24/19*t;
%     x(3) = 8/5*y-150+24/19*t;
% elseif t>3/4*T && t<T
%     x(1) = 8/5*y-30+24/19*t;
%     x(2) = 8/5*y-90+24/19*t;
%     x(3) = 8/5*y-150+24/19*t;
%     x(4) = 8/5*y-210+24/19*t;
% elseif t==T
%     x(1) = 8/5*y-90+24/19*t;
%     x(2) = 8/5*y-150+24/19*t;
%     x(3) = 8/5*y-210+24/19*t;
% end

end