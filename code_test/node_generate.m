function Source = node_generate(vertex,pos_node,num_node)
%NODE_GENERATE: Generate a certain position and a certain number of source nodes
%               according to a given rectangular area
% vertex is the vertex of the rectangle
% if pos_node = -1, the source node is randomly generated within the rectangular area
% if pos_node = 0, the source node is the center point of the rectangle
% if pos_node = 1, the source node is in the upper right area of the rectangle
% if pos_node = 2, the source node is in the upper left area of the rectangle
% if pos_node = 3, the source node is in the lower left area of the rectangle
% if pos_node = 4, the source node is in the lower right area of the rectangle
% if pos_node = (x_s,y_s), the pos_node of the source node is given by (x_s, y_s)
% num_node is the number of nodes in each rectangular area

num_area = size(vertex,1);

if pos_node==-1 % random
    if num_area==1
        x_s = randi([vertex(1),vertex(3)],num_node,1);
        y_s = randi([vertex(2),vertex(4)],num_node,1);
    else
        for i = 1:num_area
            x_s(i) = randi([vertex(i,1),vertex(i,3)],num_node,1);
            y_s(i) = randi([vertex(i,2),vertex(i,4)],num_node,1);
        end
        x_s = x_s';
        y_s = y_s';
    end
elseif pos_node==0 % center
    for i = 1:num_area
        x1 = vertex(i,1);
        y1 = vertex(i,2);
        x2 = vertex(i,3);
        y2 = vertex(i,4);
        x_s(i) = round(0.5*(x1+x2));
        y_s(i) = round(0.5*(y1+y2));
    end
    x_s = x_s';
    y_s = y_s';
elseif pos_node==1 % first quadrant
    if num_area==1
        x_s = randi([ceil(0.5*(vertex(1)+vertex(3))),vertex(3)],num_node,1);
        y_s = randi([vertex(2),fix(0.5*(vertex(2)+vertex(4)))],num_node,1);
    else
        for i = 1:num_area
            x_s(i) = randi([ceil(0.5*(vertex(i,1)+vertex(i,3))),vertex(i,3)],num_node,1);
            y_s(i) = randi([vertex(i,2),fix(0.5*(vertex(i,2)+vertex(i,4)))],num_node,1);
        end
        x_s = x_s';
        y_s = y_s';
    end
elseif pos_node==2 % second quadrant
    if num_area==1
        x_s = randi([vertex(1),fix(0.5*(vertex(1)+vertex(3)))],num_node,1);
        y_s = randi([vertex(2),fix(0.5*(vertex(2)+vertex(4)))],num_node,1);
    else
        for i = 1:num_area
            x_s(i) = randi([vertex(i,1),fix(0.5*(vertex(i,1)+vertex(i,3)))],num_node,1);
            y_s(i) = randi([vertex(i,2),fix(0.5*(vertex(i,2)+vertex(i,4)))],num_node,1);
        end
        x_s = x_s';
        y_s = y_s';
    end
elseif pos_node==3 % third quadrant
    if num_area==1
        x_s = randi([vertex(1),fix(0.5*(vertex(1)+vertex(3)))],num_node,1);
        y_s = randi([ceil(0.5*(vertex(2)+vertex(4))),vertex(4)],num_node,1);
    else
        for i = 1:num_area
            x_s(i) = randi([vertex(i,1),fix(0.5*(vertex(i,1)+vertex(i,3)))],num_node,1);
            y_s(i) = randi([ceil(0.5*(vertex(i,2)+vertex(i,4))),vertex(i,4)],num_node,1);
        end
        x_s = x_s';
        y_s = y_s';
    end
elseif pos_node==4 % fourth quadrant
    if num_area==1
        x_s = randi([ceil(0.5*(vertex(1)+vertex(3))),vertex(3)],num_node,1);
        y_s = randi([ceil(0.5*(vertex(2)+vertex(4))),vertex(4)],num_node,1);
    else
        for i = 1:num_area
            x_s(i) = randi([ceil(0.5*(vertex(i,1)+vertex(i,3))),vertex(i,3)],num_node,1);
            y_s(i) = randi([ceil(0.5*(vertex(i,2)+vertex(i,4))),vertex(i,4)],num_node,1);
        end
        x_s = x_s';
        y_s = y_s';
    end
else % (x_s,y_s)
    for i = 1:num_area
        x_s = pos_node(1);
        y_s = pos_node(2);
    end
end

Source = [x_s,y_s];

end
