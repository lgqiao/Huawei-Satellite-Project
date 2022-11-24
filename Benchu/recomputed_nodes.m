function [nodes,nodes_index] = recomputed_nodes(node)
%RECOMPUTED_NODES: Find the node that is being recomputed and the index of the node   


num_node = size(node,1);
nodes = [];
nodes_index = [];

for i = 1:num_node
    node_val = node(i,:);
    for j = 1:num_node
        if node(j,1)==node_val(1) && node(j,2)==node_val(2) && j~=i
            nodes = [nodes;node_val];
            nodes_index = [nodes_index,j];
        end
    end
end

end

