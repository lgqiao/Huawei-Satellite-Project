function x = fy_peak(y,t)
%FY_PEAK: Compute the x value over the peak for a given value of y at a certain time
  

global T T_x k_T gap_x
k_t = 2*T_x/T;

x = [];
x(1) = 1/k_T*y+T_x+k_t*t;
x(2) = 1/k_T*y+k_t*t;
x(3) = 1/k_T*y-T_x+k_t*t;
x(4) = 1/k_T*y-2*T_x+k_t*t;
x(5) = 1/k_T*y-3*T_x+k_t*t;
x(6) = 1/k_T*y-4*T_x+k_t*t;

x = x+gap_x;

% if t==0
%     x(1) = 8/5*y+60+24/19*t;
%     x(2) = 8/5*y+24/19*t;
%     x(3) = 8/5*y-60+24/19*t;
% elseif t>0 && t<1/8*T
%     x(1) = 8/5*y+60+24/19*t;
%     x(2) = 8/5*y+24/19*t;
%     x(3) = 8/5*y-60+24/19*t;
%     x(4) = 8/5*y-120+24/19*t;
% elseif t>=1/8*T && t<=1/2*T
%     x(1) = 8/5*y+24/19*t;
%     x(2) = 8/5*y-60+24/19*t;
%     x(3) = 8/5*y-120+24/19*t;
% elseif t>1/2*T && t<5/8*T
%     x(1) = 8/5*y+24/19*t;
%     x(2) = 8/5*y-60+24/19*t;
%     x(3) = 8/5*y-120+24/19*t;
%     x(4) = 8/5*y-180+24/19*t;
% elseif t>=5/8*T && t<=T
%     x(1) = 8/5*y-90+24/19*t;
%     x(2) = 8/5*y-150+24/19*t;
%     x(3) = 8/5*y-210+24/19*t;
% end

end