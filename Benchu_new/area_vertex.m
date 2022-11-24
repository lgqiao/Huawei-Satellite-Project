function [area_inner,area_outer] = area_vertex(x1,y1,x2,y2,max_x,max_y)
%AREA_VERTEX: Divide the rectangular area into 4 sub-areas on the expanded map


global T_x T_y

% The inner boundary point of a subarea
if x2>=x1 && y2>=y1
    x_inner = [x1+max_x;x2;x1+max_x;x2];
    y_inner = [y1+max_y;y2;y2;y1+max_y];   
elseif x2<=x1 && y2<=y1
    x_inner = [x2+2*max_x;x1+max_x;x2+2*max_x;x1+max_x];
    y_inner = [y2+2*max_y;y1+max_y;y1+max_y;y2+2*max_y];
elseif x2>=x1 && y2<=y1
    x_inner = [x1+max_x;x2;x1+max_x;x2];
    y_inner = [y2+2*max_y;y1+max_y;y1+max_y;y2+2*max_y];
elseif x2<=x1 && y2>=y1
    x_inner = [x2+2*max_x;x1+max_x;x2+2*max_x;x1+max_x];
    y_inner = [y1+max_y;y2;y2;y1+max_y];
end

area_inner = [x_inner,y_inner];

dx = abs(x2-x1);
dy = abs(y2-y1);

% scale T_x and T_y
% along the peak valley
alpha_x1 = 1.5;
alpha_y1 = 1.1;
% not along the peak valley
alpha_x2 = 1.3;
alpha_y2 = 1;

% Source node on the expanded map
x_s = x1+max_x;
y_s = y1+max_y;

x_outer = [min(x_s+alpha_x1*T_x,x_inner(1)+dx);max(x_s-alpha_x1*T_x,x_inner(2)-dx);
           min(x_s+alpha_x2*T_x,x_inner(3)+dx);max(x_s-alpha_x2*T_x,x_inner(4)-dx)];
y_outer = [min(y_s+alpha_y1*T_y,y_inner(1)+dy);max(y_s-alpha_y1*T_y,y_inner(2)-dy);
           max(y_s-alpha_y2*T_y,y_inner(3)-dy);min(y_s+alpha_y2*T_y,y_inner(4)+dy)];

area_outer = round([x_outer,y_outer]);

end