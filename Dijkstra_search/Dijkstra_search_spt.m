function [Path,Min_len] = Dijkstra_search_spt(map,W)
%DIJKSTRA_SEARCH_SPT: Calculate the shortest path tree of message forwarding between
%                     satellites, dijkstra algorithm


Path = {};
Min_len = [];

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
    xObstacle = map(i, 1);
    yObstacle = map(i, 2);
    MAP(xObstacle,yObstacle)=-1;
end

%Initialize MAP with location of the source
xSource=map(1, 1);
ySource=map(1, 2);
MAP(xSource,ySource)=1;

% Openlist
OPEN = [];

xNode = xSource;
yNode = ySource;
OPEN_COUNT = 1;
hn = 0;
gn = 0;
OPEN(OPEN_COUNT,:) = insert_open(xNode,yNode,xNode,yNode,gn,hn,1,0);
OPEN(OPEN_COUNT,1) = 0;

num_node_spt = 0;

% Expend selscted nodes

direction = [0,1;1,0;0,-1;-1,0];
while ~(xNode == xDestination && yNode == yDestination)
    parent_xval = xNode;
    parent_yval = yNode;
    for k = 1:4
        i = direction(k,1);
        j = direction(k,2);
        if 1<=(parent_xval+i) && (parent_xval+i)<=max_x && 1<=(parent_yval+j) && (parent_yval+j)<=max_y
            dist = distance_satellite(W,parent_xval,parent_yval,parent_xval+i,parent_yval+j);
            if MAP(parent_xval+i,parent_yval+j) == 2 || MAP(parent_xval+i,parent_yval+j) == 0
                OPEN_COUNT = OPEN_COUNT+1;
                OPEN(OPEN_COUNT,:) = insert_open(parent_xval+i,parent_yval+j,parent_xval,parent_yval,dist+gn,0,1,0);
                MAP(parent_xval+i,parent_yval+j) = 1;
            elseif MAP(parent_xval+i,parent_yval+j) == 1
                n_index = node_index(OPEN,parent_xval+i,parent_yval+j);
                if OPEN(n_index,6) > dist+gn
                    OPEN(n_index,6) = dist+gn;
                    OPEN(n_index,4) = parent_xval;
                    OPEN(n_index,5) = parent_yval;
                end
            end
        end
    end

    % Remove the node with the lowest g(n) from the OPEN
    [Count_Index,min_xNode,min_yNode,gn] = min_OPEN(OPEN,OPEN_COUNT);
    OPEN(Count_Index,1) = 0;

    xNode = min_xNode;
    yNode = min_yNode;

    num_node_spt =  num_node_spt+1;

    min_len = gn;
    path = [xNode,yNode];
    count_node = 1;

    xNode_val = xNode;
    yNode_val = yNode;
    while ~(xNode_val == xSource && yNode_val == ySource)
        n_index = node_index(OPEN,xNode_val,yNode_val);
        xNode_val = OPEN(n_index,4);
        yNode_val = OPEN(n_index,5);
        count_node = count_node+1;
        path(count_node,:)= [xNode_val,yNode_val];
    end

    path = path-1;
    path = flip(path);

    Path(num_node_spt) = {path};
    Min_len = [Min_len,min_len];

end % End of while loop

end

