function [path,len] = path_generate(x1,y1,x2,y2,W,type)
%PATH_GENERATE: Generate a path based on the start and end points of the path


global V k_T

% Convert source and sink nodes from decimals to integers
x1_int = round(x1);
y1_int = round(y1);
x2_int = round(x2);
y2_int = round(y2);

dx = x2_int-x1_int;
dy = y2_int-y1_int;

% Determine the incremental value of y
if y2>=y1
    e_dy = 1;
else
    e_dy = -1;
end

% Initialize path length and path start point
len = 0;
x_val = x1_int;
y_val = y1_int;
path = [x_val,y_val];

if type==1 % Vertical calculation first, then horizontal calculation
    if dx>0 || (dy<0 && dx==0) % forward
        for i = 1:abs(dy)
            y_val = y_val+e_dy;
            path = [path;x_val,y_val];
            len = len+V;
        end
        for j = 1:dx
            x_val = x_val+1;
            path = [path;x_val,y_val];
            len = len+W(x_val,y_val+1);
        end
    elseif dx<0 || (dy>0 && dx==0) % reverse
        for i = 1:abs(dy)
            y_val = y_val+e_dy;
            path = [path;x_val,y_val];
            len = len+V;
        end
        for j = 1:-dx
            x_val = x_val-1;
            path = [path;x_val,y_val];
            len = len+W(x_val+1,y_val+1);
        end
    end
elseif type==2 % Horizontal calculation first, then vertical calculation
    if dx>0 || (dy<0 && dx==0) % forward
        for i = 1:dx
            x_val = x_val+1;
            path = [path;x_val,y_val];
            len = len+W(x_val,y_val+1);
        end
        for j = 1:abs(dy)
            y_val = y_val+e_dy;
            path = [path;x_val,y_val];
            len = len+V;
        end
    elseif dx<0 || (dy>0 && dx==0) % reverse
        for i = 1:-dx
            x_val = x_val-1;
            path = [path;x_val,y_val];
            len = len+W(x_val+1,y_val+1);
        end
        for j = 1:abs(dy)
            y_val = y_val+e_dy;
            path = [path;x_val,y_val];
            len = len+V;
        end
    end
elseif type==3 % valley line or peak line
    f = @(x) k_T*(x-x1)+y1;
    if dx>0 % forward
        x_val = x_val+1;
        path = [x_val,y_val];
        len = len+W(x_val,y_val+1);
        len_path = 1;
        for x_val = x1_int+1:x2_int-1
            y_val = round(f(x_val));
            if y_val==path(len_path,2)
                path = [path;x_val+1,y_val];
                len = len+W(x_val+1,y_val+1);
                len_path = len_path+1;
            else
                path = [path;x_val,y_val;x_val+1,y_val];
                len = len+V+W(x_val+1,y_val+1);
                len_path = len_path+2;
            end
        end
    elseif dx<0 % reverse
        x_val = x_val-1;
        path = [x_val,y_val];
        len = len+W(x_val+1,y_val+1);
        len_path = 1;
        for x_val = x1_int-1:-1:x2_int+1
            y_val = round(f(x_val));
            if y_val == path(len_path,2)
                path = [path;x_val-1,y_val];
                len = len+W(x_val,y_val+1);
                len_path = len_path+1;
            else
                path = [path;x_val,y_val;x_val-1,y_val];
                len = len+V+W(x_val,y_val+1);
                len_path = len_path+2;
            end
        end
    end
    if path(end,2)==y2_int
        path(end,:) = [];
    else
        len = len+V;
    end
end
