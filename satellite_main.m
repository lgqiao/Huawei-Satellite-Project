%% Extract the data
clc,clear

% Number of orbits and number of satellites per orbit
num_orbit = 60;
num_index = 30;

orbit = 0:num_orbit-1;
index = 0:num_index-1; 

t = 0;

% parameters
theta = 53;
phi = 360/num_orbit;
rho = 360/num_index;
epsilon = 3;

global Radius T T_x T_y k_T V 
Radius = 6921; % radius
T = 94; % period
T_x = 180/epsilon; % period of x 
T_y = 180/rho; % period of y
k_T = epsilon/rho; % slope
V = 1440; % longitudinal distance

% extract distance data
path = 'test_data_60_30\不考虑日凌\60_30\'; % data path
W = data_extract(path,orbit,index,t); % W is a three dimensional matrix
W(isnan(W)) = inf;
W = W';
W_expand = [W,W,W;W,W,W;W,W,W];

addpath('Dijkstra\','Dijkstra_search\','fitting\','code_test\','case_test\')
addpath('Benchu\','Benchu_new\','Benchu_search\','Benchu_search_new\','route_visualize\')

%% Fitting
% calculate fitting parameters(time)
[A,B,Psi] = distance_para(theta,phi,epsilon);

%% matrix fit
figure
Table1 = distance_matrix_fit(W',A,B,1,1);
figure
Table2 = distance_matrix_fit(W',A,B,2,1);

global gap_x gap_y
gap_x = abs(90-abs(Table1.Psi))/epsilon;
gap_y = abs(90-abs(Table2.Psi))/rho;

% inter_x = T_x/2+gap_x;
% inter_y = T_y/2-gap_y;

%% time fit
figure
Table = distance_time_fit(W',A,B,1,1);

%% thermal diagram
% draw the thermal diagram of distance matrix
distance_imagesc(W')

% Plot a heatmap of a dynamically changing distance matrix
dynamic_imagesc(t)

%% node_pair_test
max_x = num_orbit;
max_y = num_index;

dx = num_orbit-1;
dy = num_index-1;

% number of node pairs
num_pair = 1000;

% Generate source and Destination nodes
[Source,Destination] = pair_generate(max_x,max_y,dx,dy,num_pair);

% Find the shortest path, the length of the shortest path, and the computation time
% % don't expand
% [Path1,Min_len1,T1] = data_sta_node(Source,Destination,W,t,1); % type = 1: Dijkstra_search                                                                                                        
% [Path2,Min_len2,T2] = data_sta_node(Source,Destination,W,t,3); % type = 3: my_search
% expand
[Path1,Min_len1,T1] = data_sta_node(Source,Destination,W,t,2); % type = 2: Dijkstra_expand                                                                                                        
[Path2,Min_len2,T2] = data_sta_node(Source,Destination,W,t,4); % type = 4: my_expand

ratio_T = T1./T2;
ratio_len = Min_len2./Min_len1;
ratio_len(isnan(ratio_len)) = 1;

mean_ratio_len = sum(ratio_len)/num_pair;
mean_ratio_T = sum(ratio_T)/num_pair;

mean_T1 = sum(T1)/num_pair;
mean_T2 = sum(T2)/num_pair;

%% full map test, test 1
max_x = num_orbit;
max_y = num_index;

% Generate rectangular area
pos_area = []; % the location of the rectangular area
size_area = [59,59;29,29]; % the size of the rectangular area
num_area = 1; % number of rectangular area
vertex = area_generate(max_x,max_y,pos_area,size_area,num_area);

% Generates source nodes within a rectangular area
pos_node = -1; % The position of the source node in each area
num_node = 500; % Number of source nodes in each area
Source = node_generate(vertex,pos_node,num_node);

% % Source nodes cover the entire area of the map
% Source = [];
% for i = 0:num_index-1
%     for j = 0:num_orbit-1
%         Source = [Source;j,i];
%     end
% end

%% full map test, test 1
% [Path1,Min_len1,area_T1,node_T1] = data_sta_area(vertex,Source,W,t,1); % Dijkstra_search_spt
% [Path2,Min_len2,area_T2,node_T2] = data_sta_area(vertex,Source,W,t,2); % my_search_full
[Path1,Min_len1,area_T1,node_T1] = data_sta_area(vertex,Source,W,t,3); % Dijkstra_expand_spt
[Path2,Min_len2,area_T2,node_T2] = data_sta_area(vertex,Source,W,t,4); % my_expand_full_new

% Reorder the paths and path lengths computed by the two algorithms
[Path1_new,Min_len1_new] = path_sorting(Path1,Min_len1,vertex);
[Path2_new,Min_len2_new] = path_sorting(Path2,Min_len2,vertex);

Min_len = {Min_len1_new,Min_len2_new};
area_T = [area_T1,area_T2];
node_T = [node_T1,node_T2];
% mean_test
[mean_T,mean_ratio_T,mean_ratio_len] = mean_test(area_T,node_T,Min_len);
% variance_test
[var_T,var_ratio_len] = variance_test(area_T,node_T,Min_len);
