function [Path_expand,Min_len] = path_vacancy(x_s,y_s,MAP,W,t)
%PATH_VACANCY_NEW: Calculate the shortest path from the source node to the vacant nodes


Path_expand = {};
Min_len = [];
W_expand = [W,W,W;W,W,W;W,W,W];

% Calculate the vacant nodes in a rectangular area
MAP = MAP';

[y_vacancy,x_vacancy] = find(MAP==2);
x_vacancy1 = [];
x_vacancy2 = [];
y_vacancy1 = [];
y_vacancy2 = [];

num_vacancy = length(x_vacancy);
for i = 1:num_vacancy
    if x_vacancy(i)>=x_s && y_vacancy(i)<=y_s
        x_vacancy1 = [x_vacancy1;x_vacancy(i)];
        y_vacancy1 = [y_vacancy1;y_vacancy(i)];
    else
        x_vacancy2 = [x_vacancy(i);x_vacancy2];
        y_vacancy2 = [y_vacancy(i);y_vacancy2];
    end
end

x_vacancy = [x_vacancy1;x_vacancy2];
y_vacancy = [y_vacancy1;y_vacancy2];

vacancy_node = [];
if isempty(x_vacancy)==0
    vacancy_node = [vacancy_node;x_vacancy(1),y_vacancy(1)];
    for i = 2:length(x_vacancy)
        if x_vacancy(i)~=x_vacancy(i-1) || y_vacancy(i)~=y_vacancy(i-1)-1
            vacancy_node = [vacancy_node;x_vacancy(i),y_vacancy(i)];
        end
    end
    vacancy_node = vacancy_node-1;
end

MAP = MAP';

k = 0;
% Calculate the shortest path from the source node to the vacant nodes
for i = 1:size(vacancy_node,1)
    x_d = vacancy_node(i,1);
    y_d = vacancy_node(i,2);
    if x_s==x_d || y_s==y_d
        [path,len] = path_generate_ex(x_s,y_s,x_d,y_d,W_expand,1);
    else
        [S,D,delta_x,delta_y] = inter_sd_pair(x_s,y_s,x_d,y_d,t);
        cross_point = line_cross(S,D,delta_x,delta_y);
        if isempty(cross_point)==1
            point = [x_s,y_s;x_d,y_d];
            if y_s==S(2) && x_d==D(1)
                flag = 1;
            else
                flag = 2;
            end
        else
            point = [x_s,y_s;cross_point;x_d,y_d];
            y_1 = fx_valley_ex(point(2,1),t);
            k_1 = find(y_1>point(2,2)-0.5 & y_1<point(2,2)+0.5,1);
            if isempty(k_1)==1
                flag = 1;
            else
                flag = 2;
            end
            point = round(point);
        end
        num_point = size(point,1);
        path = [];
        len = [];
        for j = 1:num_point-1
            [path_val,len_val] = path_generate_ex(point(j,1),point(j,2),point(j+1,1),point(j+1,2),W_expand,mod(flag,2)+1);
            path_val(end,:) = [];
            path = [path;path_val];
            len = [len;len_val];
            flag = flag+1;
        end
        path = [path;x_d,y_d];
    end

    len_path = size(path,1);
    row_index = [];
    for m = len_path:-1:2
        x_d = path(m,1);
        y_d = path(m,2);
        if MAP(x_d+1,y_d+1)~=1
            row_index = [row_index,m];
            MAP(x_d+1,y_d+1) = 1;
        else
            break
        end
    end

    num_index = length(row_index);
    for n = 1:num_index
        k = k+1;
        row = row_index(n);
        Path_expand(k) = {path(1:row,:)};
        min_len = sum(len(1:row-1));
        Min_len = [Min_len,min_len];
    end
end
