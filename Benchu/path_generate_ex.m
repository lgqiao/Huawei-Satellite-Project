function [path,len] = path_generate_ex(x1,y1,x2,y2,W_expand,type)
%PATH_GENERATE_EX: Generate a path based on the start and end points of the path on the extended map


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
len = [];
x_val = x1_int;
y_val = y1_int;
path = [x_val,y_val];

if type==1 % Vertical calculation first, then horizontal calculation
    if dx>0 || (dy<0 && dx==0) % forward
        path1(:,2) = y1_int:e_dy:y2_int;
        path1(:,1) = x1_int;
        len1 = V*ones(abs(dy),1);
        path2(:,1) = x1_int+1:x2_int;
        path2(:,2) = y2_int;
        len2 = W_expand(x1_int+1:x2_int,y2_int+1);
        path = [path1;path2];
        len = [len1;len2];
    elseif dx<0 || (dy>0 && dx==0) % reverse
        path1(:,2) = y1_int:e_dy:y2_int;
        path1(:,1) = x1_int;
        len1 = V*ones(abs(dy),1);
        path2(:,1) = x1_int-1:-1:x2_int;
        path2(:,2) = y2_int;
        len2 = W_expand(x1_int:-1:x2_int+1,y2_int+1);
        path = [path1;path2];
        len = [len1;len2];
    end
elseif type==2 % Horizontal calculation first, then vertical calculation
    if dx>0 || (dy<0 && dx==0) % forward
        path1(:,1) = x1_int:x2_int;
        path1(:,2) = y1_int;
        len1 = W_expand(x1_int+1:x2_int,y1_int+1);
        path2(:,2) = y1_int+e_dy:e_dy:y2_int;
        path2(:,1) = x2_int;
        len2 = V*ones(abs(dy),1);
        path = [path1;path2];
        len = [len1;len2];
    elseif dx<0 || (dy>0 && dx==0) % reverse
        path1(:,1) = x1_int:-1:x2_int;
        path1(:,2) = y1_int;
        len1 = W_expand(x1_int:-1:x2_int+1,y1_int+1);
        path2(:,2) = y1_int+e_dy:e_dy:y2_int;
        path2(:,1) = x2_int;
        len2 = V*ones(abs(dy),1);
        path = [path1;path2];
        len = [len1;len2];
    end
elseif type==3 % valley line or peak line
    f = @(x) k_T*(x-x1)+y1;
    if dx>0 % forward
        x_val = x_val+1;
        path = [x_val,y_val];
        len = [len;W_expand(x_val,y_val+1)];
        len_path = 1;
        for x_val = x1_int+1:x2_int-1
            y_val = round(f(x_val));
            if y_val==path(len_path,2)
                path = [path;x_val+1,y_val];
                len = [len;W_expand(x_val+1,y_val+1)];
                len_path = len_path+1;
            else
                path = [path;x_val,y_val;x_val+1,y_val];
                len = [len;V;W_expand(x_val+1,y_val+1)];
                len_path = len_path+2;
            end
        end
    elseif dx<0 % reverse
        x_val = x_val-1;
        path = [x_val,y_val];
        len = [len;W_expand(x_val+1,y_val+1)];
        len_path = 1;
        for x_val = x1_int-1:-1:x2_int+1
            y_val = round(f(x_val));
            if y_val == path(len_path,2)
                path = [path;x_val-1,y_val];
                len = [len;W_expand(x_val,y_val+1)];
                len_path = len_path+1;
            else
                path = [path;x_val,y_val;x_val-1,y_val];
                len = [len;V;W_expand(x_val,y_val+1)];
                len_path = len_path+2;
            end
        end
    end
    if path(end,2)==y2_int
        path(end,:) = [];
    else
        len = [len;V];
    end
end
