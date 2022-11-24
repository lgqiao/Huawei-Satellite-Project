function [var_T,var_ratio_len] = variance_test(area_T,node_T,Min_len)
%VARIANCE_TEST: Compute statistics related to variance
% Min_len = {Min_len1,Min_len2}, the length of the shortest path calculated by the two methods
% area_T = [area_T1,area_T2], total computation time for all points for both methods
% node_T = [node_T1,node_T2], average computation time per point for both methods
% var_ratio_T = [var_ratio_areaT,var_ratio_nodeT]
% variance of calculation time ratio at area level and node level
% var_ratio_len = [var_ratio_arealen,var_ratio_nodelen]
% the variance of the ratio of the shortest path lengths at the area level and the node level 


% Dijkstra
Min_len1 = Min_len{1}; 
area_T1 = area_T(:,1);
node_T1 = node_T(:,1);
% Benchu
Min_len2 = Min_len{2}; 
area_T2 = area_T(:,2);
node_T2 = node_T(:,2);

num_Source = length(Min_len1);
for i = 1:num_Source
    min_len1 = Min_len1{i};
    min_len2 = Min_len2{i};
    ratio_len = min_len2./min_len1;
    var_ratio_len(i,:) = var(ratio_len);
    sum_min_len1(i,:) = sum(min_len1);
    sum_min_len2(i,:) = sum(min_len2);
end

var_areaT1 = var(area_T1);
var_areaT2 = var(area_T2);
var_areaT = [var_areaT1,var_areaT2];
var_nodeT1 = var(node_T1);
var_nodeT2 = var(node_T2);
var_nodeT = [var_nodeT1,var_nodeT2];
var_T = [var_areaT;var_nodeT];

var_ratio_arealen = var(sum_min_len2./sum_min_len1);
var_ratio_nodelen = var(var_ratio_len);
var_ratio_len = [var_ratio_arealen,var_ratio_nodelen];

end