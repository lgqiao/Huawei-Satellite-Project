function [S,D,delta_x,delta_y] = inter_sd(x1,y1,x2,y2,t)
%INTER_SD: Compute the two intersections from the source node and the 
%          two intersections from the destination node 


global T_x T_y

y1_peak = fx_peak(x1,t);
x1_valley = fy_valley(y1,t);
y2_peak = fx_peak(x2,t);
x2_valley = fy_valley(y2,t);

k_y1 = find(y1_peak>=y1-T_y/2 & y1_peak<y1+T_y/2);
k_x1 = find(x1_valley>=x1-T_x/2 & x1_valley<x1+T_x/2);
S = [x1,y1_peak(k_y1(1));x1_valley(k_x1(1)),y1];

k_y2 = find(y2_peak>y2-T_y/2 & y2_peak<=y2+T_y/2);
k_x2 = find(x2_valley>x2-T_x/2 & x2_valley<=x2+T_x/2);
D = [x2,y2_peak(k_y2(1));x2_valley(k_x2(1)),y2];

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
