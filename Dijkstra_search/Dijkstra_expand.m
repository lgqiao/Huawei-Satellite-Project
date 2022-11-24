function [path,min_len] = Dijkstra_expand(map,W)
%DIJKSTRA_EXPAND: Calculate the shortest path of message forwarding between
%                satellites, dijkstra algorithm


map = map+1;
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

% Openlist
OPEN = [];

xNode = xSource;
yNode = ySource;
OPEN_COUNT = 1;
hn = 0;
gn = 0;
OPEN(OPEN_COUNT,:) = insert_open(xNode,yNode,xNode,yNode,gn,hn,1,0);
OPEN(OPEN_COUNT,1) = 0;

% Expend selscted nodes

direction = [0,1;1,0;0,-1;-1,0];
while ~(xNode == xDestination && yNode == yDestination)
    parent_xval = xNode;
    parent_yval = yNode;
    for k = 1:4
        i = direction(k,1);
        j = direction(k,2);
        xval = parent_xval+i;
        yval = parent_yval+j;
        if xval < 1
            xval = xval+max_x;
        elseif yval < 1
            yval = yval+max_y;
        elseif xval > max_x
            xval = xval-max_x;
        elseif yval > max_y
            yval = yval-max_y;
        end
        dist = distance_satellite(W,parent_xval,parent_yval,xval,yval);
        if MAP(xval,yval) == 2 || MAP(xval,yval) == 0
            OPEN_COUNT = OPEN_COUNT+1;
            OPEN(OPEN_COUNT,:) = insert_open(xval,yval,parent_xval,parent_yval,dist+gn,0,1,0);
            MAP(xval,yval) = 1; 
        elseif MAP(xval,yval) == 1
            n_index = node_index(OPEN,xval,yval);
            if OPEN(n_index,6) > dist+gn
                OPEN(n_index,6) = dist+gn;
                OPEN(n_index,4) = parent_xval;
                OPEN(n_index,5) = parent_yval;
            end
        end
    end
    
    % Remove the node with the lowest g(n) from the OPEN
    [Count_Index,min_xNode,min_yNode,gn] = min_OPEN(OPEN,OPEN_COUNT);
    OPEN(Count_Index,1) = 0;

    xNode = min_xNode;
    yNode = min_yNode;

end % End of while loop

min_len = gn;
path = [xNode,yNode];
count_node = 1;

while ~(xNode == xSource && yNode == ySource)
    n_index = node_index(OPEN,xNode,yNode);
    xNode = OPEN(n_index,4);
    yNode = OPEN(n_index,5);
    count_node = count_node+1;
    path(count_node,:)= [xNode,yNode];
end

path = path-1;
path = flip(path);

end