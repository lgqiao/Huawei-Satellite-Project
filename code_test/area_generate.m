function vertex = area_generate(max_x,max_y,pos_area,size_area,num_area)
%AREA_GENERATE: Generate rectangles of given position, given size and given number
% If pos_area is the empty set, the rectangle's position is random
% The elements in the first line of pos_area represent the range of the abscissa of the source node, 
% and the elements in the second line represent the range of the ordinate
% If size_area is the empty set, then the rectangles are randomly sized
% The elements in the first row of size_area represent the range of the length of the rectangle, 
% and the elements in the second row represent the range of widths
% num_area represents the number of generated rectangles


max_x = max_x-1;
max_y = max_y-1;

% Determine the center point of the rectangle
if isempty(pos_area)==1
    if isempty(size_area)==1
        x_c = 0.5*randi([0,2*max_x],num_area,1);
        y_c = 0.5*randi([0,2*max_y],num_area,1);
    else
        x_gap = 0.5*size_area(1,2);
        y_gap = 0.5*size_area(2,2);
        x_range = [x_gap,max_x-x_gap];
        y_range = [y_gap,max_y-y_gap];
        x_c = 0.5*randi(2*x_range,num_area,1);
        y_c = 0.5*randi(2*y_range,num_area,1);
    end    
else
    if isempty(size_area)==1
        x_c = 0.5*randi(2*pos_area(1,:),num_area,1);
        y_c = 0.5*randi(2*pos_area(2,:),num_area,1);
    else
        x_gap = 0.5*size_area(1,2);
        y_gap = 0.5*size_area(2,2);
        x_range = [max(x_gap,pos_area(1,1)),min(max_x-x_gap,pos_area(1,2))];
        y_range = [max(y_gap,pos_area(2,1)),min(max_y-y_gap,pos_area(2,2))];
        x_c = 0.5*randi(2*x_range,num_area,1);
        y_c = 0.5*randi(2*y_range,num_area,1);
    end
end

% Determine the length and width of a rectangle
if isempty(size_area)==1
    % The map's limit on the size of the rectangle
    max_dx = 2*min(x_c,max_x-x_c);
    max_dy = 2*min(y_c,max_y-y_c);
    for i = 1:num_area
        dx(i) = randi(max_dx(i));
        dy(i) = randi(max_dy(i));
    end
    dx = dx';
    dy = dy';
else
    max_dx = min(2*min(x_c,max_x-x_c),size_area(1,2));
    max_dy = min(2*min(y_c,max_y-y_c),size_area(2,2));
    for i = 1:num_area
        dx(i) = randi([size_area(1,1),max_dx(i)]);
        dy(i) = randi([size_area(2,1),max_dy(i)]);
    end
    dx = dx';
    dy = dy';
end

vertex1 = [ceil(x_c-0.5*dx),ceil(y_c-0.5*dy)]; % top left vertex of rectangle
vertex2 = [fix(x_c+0.5*dx),fix(y_c+0.5*dy)]; % lower right vertex of rectangle
vertex = [vertex1,vertex2];

end
