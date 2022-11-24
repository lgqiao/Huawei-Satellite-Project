function [S,D,delta_x,delta_y] = inter_sd_expand1(x1,y1,x2,y2,max_x,max_y,t)
%INTER_SD_EXPAND1: Compute the two intersections from the source node and the 
%                  two intersections from the destination node 


global T_x T_y

dx = x2-x1;

x_s = x1-max_x;
y_s = y1-max_y;
if x2>0
    x_d = mod(x2,max_x);
else
    x_d = x2;
end
if y2>0
    y_d = mod(y2,max_y);
else
    y_d = y2;
end

ys_peak = fx_peak(x_s,t);
xs_valley = fy_valley(y_s,t);
yd_peak = fx_peak(x_d,t);
xd_valley = fy_valley(y_d,t);

k_ys = find(ys_peak>=y_s-T_y/2 & ys_peak<=y_s+T_y/2);
k_xs = find(xs_valley>=x_s-T_x/2 & xs_valley<=x_s+T_x/2);
S = [x_s+max_x,ys_peak(k_ys(1))+max_y;xs_valley(k_xs(1))+max_x,y_s+max_y];

k_yd = find(yd_peak>=y_d-T_y/2 & yd_peak<=y_d+T_y/2);
k_xd = find(xd_valley>=x_d-T_x/2 & xd_valley<=x_d+T_x/2);

% Check whether the node is beyond the boundaries of the extended map
x2 = min(max(0,x2),3*max_x-1);
y2 = min(max(0,y2),3*max_y-1);

if dx>0
    if x2>=max_x && x2<2*max_x && y2>=max_y && y2<2*max_y
        D = [x_d+max_x,yd_peak(k_yd(1))+max_y;xd_valley(k_xd(1))+max_x,y_d+max_y];
    elseif x2>=2*max_x && x2<3*max_x && y2>=max_y && y2<2*max_y
        D = [x_d+2*max_x,yd_peak(k_yd(1))+max_y;xd_valley(k_xd(1))+2*max_x,y_d+max_y];
    elseif x2>=2*max_x && x2<3*max_x && y2>=0 && y2<max_y
        D = [x_d+2*max_x,yd_peak(k_yd(1));xd_valley(k_xd(1))+2*max_x,y_d];
    elseif x2>=max_x && x2<2*max_x && y2>=0 && y2<max_y
        D = [x_d+max_x,yd_peak(k_yd(1));xd_valley(k_xd(1))+max_x,y_d];
    end
elseif dx<0
    if x2>=0 && x2<max_x && y2>=2*max_y && y2<3*max_y
        D = [x_d,yd_peak(k_yd(1))+2*max_y;xd_valley(k_xd(1)),y_d+2*max_y];
    elseif x2>=max_x && x2<2*max_x && y2>=2*max_y && y2<3*max_y
        D = [x_d+max_x,yd_peak(k_yd(1))+2*max_y;xd_valley(k_xd(1))+max_x,y_d+2*max_y];
    elseif x2>=max_x && x2<2*max_x && y2>=max_y && y2<2*max_y
        D = [x_d+max_x,yd_peak(k_yd(1))+max_y;xd_valley(k_xd(1))+max_x,y_d+max_y];
    elseif x2>=0 && x2<max_x && y2>=max_y && y2<2*max_y
        D = [x_d,yd_peak(k_yd(1))+max_y;xd_valley(k_xd(1)),y_d+max_y];
    end
end

k_d(1) = -(D(1,2)-S(1,2))/(D(1,1)-S(1,1));
k_d(2) = -(D(2,2)-S(1,2))/(D(2,1)-S(1,1));
k_d(3) = -(D(1,2)-S(2,2))/(D(1,1)-S(2,1));
k_d(4) = -(D(2,2)-S(2,2))/(D(2,1)-S(2,1));

dx1 = abs(S(1,1)-S(2,1));
dy1 = abs(S(1,2)-S(2,2));
dx2 = abs(D(1,1)-D(2,1));
dy2 = abs(D(1,2)-D(2,2));

A = [dy1,dy2;dy1,dx2;dx1,dy2;dx1,dx2];

lambda = atan(T_y/T_x);

for i = 1:4
    if k_d(i)<0
        continue
    end
    sigma = atan(k_d(i));
    l = (T_y*cos(lambda))/(2*sin(lambda+sigma));
    delta_x = l*cos(sigma);
    delta_y = l*sin(sigma);   
    if i==1
        if A(1,:)<=delta_y
            break
        end
    elseif i==2
        if A(2,:)<=[delta_y,delta_x]
            break
        end
    elseif i==3
        if A(3,:)<=[delta_x,delta_y]
            break
        end
    elseif i==4
        if A(4,:)<=delta_x
            break
        end
    end
end

S = S(ceil(i/2),:);
a = mod(i,2);
if a==0
    D = D(2,:);
else
    D = D(1,:);
end

end
