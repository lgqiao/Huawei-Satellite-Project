function MAP = map_label(xSource,ySource,xDestination,yDestination,area_inner,area_outer,max_x,max_y)
%MAP_LABEL: Mark points within the sub-area on the expanded map


% Mark the entire expanded map
MAP = -2*ones(3*max_x,3*max_y);

x_s = xSource+max_x;
y_s = ySource+max_y;

% dx = mod(area_inner(2,1),max_x)-mod(area_inner(1,1),max_x);
% dy = mod(area_inner(2,2),max_y)-mod(area_inner(1,2),max_y);

% area 1
MAP(x_s+1:area_outer(1,1)+1,y_s+1:area_outer(1,2)+1) = 1;
% area 2
MAP(area_outer(2,1)+1:x_s+1,area_outer(2,2)+1:y_s+1) = 1;
% area 3
MAP(x_s+1:area_outer(3,1)+1,area_outer(3,2)+1:y_s+1) = 1;
% area 4
MAP(area_outer(4,1)+1:x_s+1,y_s+1:area_outer(4,2)+1) = 1;

% subarea 1
MAP(area_inner(1,1)+1:area_outer(1,1)+1,area_inner(1,2)+1:area_outer(1,2)+1) = 2;
% subarea 2
MAP(area_outer(2,1)+1:area_inner(2,1)+1,area_outer(2,2)+1:area_inner(2,2)+1) = 2;
% subarea 3
MAP(area_inner(3,1)+1:area_outer(3,1)+1,area_outer(3,2)+1:area_inner(3,2)+1) = 2;
% subarea 4
MAP(area_outer(4,1)+1:area_inner(4,1)+1,area_inner(4,2)+1:area_outer(4,2)+1) = 2;

if xDestination>=xSource && yDestination>=ySource
    MAP(x_s+1,y_s+1) = 1;
    MAP(x_s-max_x+1,y_s-max_y+1) = 1;
    MAP(x_s+1,y_s-max_y+1) = 1;
    MAP(x_s-max_x+1,y_s+1) = 1;
elseif xDestination<=xSource && yDestination<=ySource
    MAP(x_s+max_x+1,y_s+max_y+1) = 1;
    MAP(x_s+1,y_s+1) = 1;
    MAP(x_s+max_x+1,y_s+1) = 1;
    MAP(x_s+1,y_s+max_y+1) = 1;
elseif xDestination>=xSource && yDestination<=ySource
    MAP(x_s+1,y_s+max_y+1) = 1;
    MAP(x_s-max_x+1,y_s+1) = 1;
    MAP(x_s+1,y_s+1) = 1;
    MAP(x_s-max_x+1,y_s+max_y+1) = 1;
elseif xDestination<=xSource && yDestination>=ySource
    MAP(x_s+max_x+1,y_s+1) = 1;
    MAP(x_s+1,y_s-max_y+1) = 1;
    MAP(x_s+max_x+1,y_s-max_y+1) = 1;
    MAP(x_s+1,y_s+1) = 1;
end

end
