function [path,min_len] = my_search_old(map,W,t)
%MY_SEARCH: Use the Symmetric Polyline Segment Method to Calculate 
%           the Shortest Path of Message Forwarding Between Satellites


size_map = size(map,1);
[max_x,max_y] = size(W);

% Define the 2D grid map array.
% Source=1, Destination=0, Obstacle=-1;
% There are no obstacles if you don't consider the problem of solar transit
MAP = 2*ones(max_x,max_y);

%Initialize MAP with location of the destination
xDestination = map(size_map,1);
yDestination = map(size_map,2);
MAP(xDestination,yDestination)=0;

%Initialize MAP with location of the obstacle
for i = 2: size_map-1
    xObstacle = map(i,1);
    yObstacle = map(i,2);
    MAP(xObstacle,yObstacle)=-1;
end

%Initialize MAP with location of the source
xSource = map(1,1);
ySource = map(1,2);
MAP(xSource,ySource) = 1;

min_len = 0;
path = [];

% Determine the relative position of the source node and the destination node
if xSource==xDestination || ySource==yDestination
    [path,min_len] = path_generate(xSource,ySource,xDestination,yDestination,W,1);
    return
end

dx = xDestination-xSource;
dy = yDestination-ySource;
k_l = dy/dx; % slope

if k_l>0
    % Calculate the intersection of rectangle and valley
    inter = inter_square(xSource,ySource,xDestination,yDestination,t,1); 
    num_inter = 2*size(inter,1); % number of intersections
    if num_inter==0 
        if (W(xDestination,ySource)<=W(xSource,yDestination) && dy>0) || (W(xDestination,ySource)>=W(xSource,yDestination) && dy<0)
            [path,min_len] = path_generate(xSource,ySource,xDestination,yDestination,W,1);
            return
        else
            [path,min_len] = path_generate(xSource,ySource,xDestination,yDestination,W,2);
            return
        end
    elseif num_inter==2
        inter = inter+1;
        [path1,len1] = path_generate(xSource,ySource,inter(1,1),inter(1,2),W,1);
        [path2,len2] = path_generate(inter(1,1),inter(1,2),inter(1,3),inter(1,4),W,3);
        [path3,len3] = path_generate(inter(1,3),inter(1,4),xDestination,yDestination,W,1);
        path = [path1;path2;path3];
        min_len = len1+len2+len3;
        return
    end
elseif k_l<0
    inter_valley = inter_square(xSource,ySource,xDestination,yDestination,t,1);
    inter_peak = inter_square(xSource,ySource,xDestination,yDestination,t,2);
    num_inter_valley = 2*size(inter_valley,1);
    num_inter_peak = 2*size(inter_peak,1);
    if (num_inter_valley==0) && (num_inter_peak==0)
        if (W(xSource,ySource)<=W(xDestination,yDestination) && dy<0) || (W(xSource,ySource)>=W(xDestination,yDestination) && dy>0)
            [path,min_len] = path_generate(xSource,ySource,xDestination,yDestination,W,2);
            return
        else
            [path,min_len] = path_generate(xSource,ySource,xDestination,yDestination,W,1);
            return
        end
    end

    if num_inter_valley==2
        x_middle = (xSource+xDestination)/2;
        fx = @(x) 5/8*(x-inter_valley(1,1))+inter_valley(1,2);
        y = fx(x_middle);
        if y>=min(ySource,yDestination) && y<=max(ySource,yDestination)
            [path1,len1] = path_generate(xSource,ySource,xSource,y,W,1);
            path1(size(path1,1),:) = [];
            if dy<0
                [path2,len2] = path_generate(xSource,y,xDestination,yDestination,W,2);
            else
                [path2,len2] = path_generate(xSource,y,xDestination,yDestination,W,1);
            end
            path = [path1;path2];
            min_len = len1+len2;
            return
        elseif y<min(ySource,yDestination) && num_inter_peak==0
            [path,min_len] = path_generate(xSource,ySource,xDestination,yDestination,W,1);
            return
        elseif y>max(ySource,yDestination) && num_inter_peak==0
            [path,min_len] = path_generate(xSource,ySource,xDestination,yDestination,W,2);
            return
        elseif num_inter_peak==2
            y_middle = (ySource+yDestination)/2;
            fy = @(y) 8/5*(y-inter_peak(1,2))+inter_peak(1,1);
            x = fy(y_middle);
            if x<min(xSource,xDestination)
                [path,min_len] = path_generate(xSource,ySource,xDestination,yDestination,W,1);
                return
            elseif x>max(xSource,xDestination)
                [path,min_len] = path_generate(xSource,ySource,xDestination,yDestination,W,2);
                return
            end
        end
    elseif num_inter_peak==2
        y_middle = (ySource+yDestination)/2;
        fy = @(y) 8/5*(y-inter_peak(1,2))+inter_peak(1,1);
        x = fy(y_middle);
        if x>=min(xSource,xDestination) && x<=max(xSource,xDestination)
            [path1,len1] = path_generate(xSource,ySource,x,ySource,W,1);
            path1(size(path1,1),:) = [];
            if dy<0
                [path2,len2] = path_generate(x,ySource,xDestination,yDestination,W,1);
            else
                [path2,len2] = path_generate(x,ySource,xDestination,yDestination,W,2);
            end
            path = [path1;path2];
            min_len = len1+len2;
            return
        elseif x<min(xSource,xDestination) && num_inter_valley==0
            [path,min_len] = path_generate(xSource,ySource,xDestination,yDestination,W,1);
            return
        elseif x>max(xSource,xDestination) && num_inter_valley==0
            [path,min_len] = path_generate(xSource,ySource,xDestination,yDestination,W,2);
            return
        end
    end
end