function Table = distance_matrix_fit1(W,dir,range)
%DISTANCE_MATRIX_FIT1: Fit the change in distance
% usage: Table = distance_matrix_fit(W,Dir,Range)
%
% where
%     W is a distance vector or distance matrix
%     dir represents the direction of fitting, 
%     dir=1 represents fitting along the row, and dir=2 represents fitting along the column
%     Table is a table that reflects changes in parameters
% fit: y = a*sin[1/2*b*|cos(w*x+c)|+d]


global Radius T_x T_y
[max_x,max_y] = size(W);
len = length(range);

% extract data
if dir == 1
    x0 = (1:max_x)';
    y0 = W(range,1:max_x,1);
elseif dir == 2
    x0 = (1:max_y)';
    y0 = W(1:max_y,range,1);
end

% fittype: y = a*sin[1/2*b*|cos(w*x+c)|+d]
ft = fittype('a*sin(1/2*b*abs(cos(c*x+d))+e)','dependent','y', ...
    'independent','x');

P = [];

if dir == 1
    omega = pi/T_x;
    for i = 1:len
        f = fit(x0,y0(i,:)',ft,'Lower',[2*Radius, 0.05, omega, -2*pi, -2*pi], ...
        'Upper',[2*Radius, 0.1, omega, 2*pi, 2*pi],'Startpoint', ...
        [2*Radius, 0.066, omega, 0, 0]);
        P = [P;f.a,f.b,f.c,f.d,f.e];
        plot(f,x0,y0(i,:),'x')
        hold on
    end
    xlabel('时间（分钟）')
    ylabel('两颗星直接的距离（千米）')

    R = P(:,1)/2;
    alpha = P(:,2)*180/pi;
    omega = P(:,3); 
    beta = P(:,4)*180/pi;
    gamma = P(:,5)*180/pi;
    index = (0:size(P,1)-1)';
    Table = table(index,R,alpha,omega,beta,gamma);

elseif dir == 2
    omega = pi/T_y;
    for i = 1:len
        f = fit(x0,y0(:,i),ft,'Lower',[2*Radius, 0.05, omega, -2*pi, -2*pi], ...
        'Upper',[2*Radius, 0.1, omega, 2*pi, 2*pi],'Startpoint', ...
        [2*Radius, 0.066, omega, 0, 0]);
        P = [P;f.a,f.b,f.c,f.d,f.e];
        plot(f,x0,y0(:,i),'x')
        hold on
    end
    xlabel('时间（分钟）')
    ylabel('两颗星直接的距离（千米）')

    R = P(:,1)/2;
    alpha = P(:,2)*180/pi;
    omega = P(:,3); 
    beta = P(:,4)*180/pi;
    gamma = P(:,5)*180/pi;
    index = (0:size(P,1)-1)';
    Table = table(index,R,alpha,omega,beta,gamma);
end
