function [mean_T,mean_ratio_T,mean_ratio_len] = mean_test(area_T,node_T,Min_len)
%MEAN_TEST：Compute statistics related to the mean
% Min_len = {Min_len1,Min_len2}, the length of the shortest path calculated by the two methods
% area_T = [area_T1,area_T2], total computation time for all points for both methods
% node_T = [node_T1,node_T2], average computation time per point for both methods
% mean_T = [mean_areaT,mean_nodeT],
% mean calculation time at the area level and node level
% mean_ratio_T = [mean_ratio_areaT,mean_ratio_nodeT]
% mean of calculation time ratio at area level and node level
% mean_ratio_len = [mean_ratio_arealen,mean_ratio_nodelen]
% the mean of the ratio of the shortest path lengths at the area level and the node level 


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
    mean_ratio_len(i,:) = mean(ratio_len);
    sum_min_len1(i,:) = sum(min_len1);
    sum_min_len2(i,:) = sum(min_len2);
end

mean_areaT1 = mean(area_T1);
mean_areaT2 = mean(area_T2);
mean_areaT = [mean_areaT1,mean_areaT2];
mean_nodeT1 = mean(node_T1);
mean_nodeT2 = mean(node_T2);
mean_nodeT = [mean_nodeT1,mean_nodeT2];
mean_T = [mean_areaT;mean_nodeT];

ratio_areaT = area_T1./area_T2;
ratio_nodeT = node_T1./node_T2;
mean_ratio_areaT = mean(ratio_areaT);
mean_ratio_nodeT = mean(ratio_nodeT);
mean_ratio_T = [mean_ratio_areaT,mean_ratio_nodeT];

mean_ratio_arealen = mean(sum_min_len2./sum_min_len1);
mean_ratio_nodelen = mean(mean_ratio_len);
mean_ratio_len = [mean_ratio_arealen,mean_ratio_nodelen];

end