function [x_d,y_d] = destination_expand(x1,y1,x2,y2,max_x,max_y)
%DESTINATION_EXPAND: Calculate the coordinates of the destination node along the peak 
%                    and valley direction on the expand map


if x2>=x1 && y2>=y1
    x_d = [x2+max_x,x2,x2+max_x,x2];
    y_d = [y2+max_y,y2,y2,y2+max_y];
elseif x2<=x1 && y2<=y1
    x_d = [x2+2*max_x,x2+max_x,x2+2*max_x,x2+max_x];
    y_d = [y2+2*max_y,y2+max_y,y2+max_y,y2+2*max_y];
elseif x2>=x1 && y2<=y1
    x_d = [x2+max_x,x2,x2+max_x,x2];
    y_d = [y2+2*max_y,y2+max_y,y2+max_y,y2+2*max_y];
elseif x2<=x1 && y2>=y1
    x_d = [x2+2*max_x,x2+max_x,x2+2*max_x,x2+max_x];
    y_d = [y2+max_y,y2,y2,y2+max_y];
end
