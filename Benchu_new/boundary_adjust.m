function boundary_new = boundary_adjust(boundary,area_inner,area_outer)
%BOUNDARY_ADJUST: Adjust the boundary to remove boundary nodes that do not belong to the subarea


len_boundary = size(boundary,1);
x_in = area_inner(1);
y_in = area_inner(2);
x_out = area_outer(1);
y_out = area_outer(2);

node_index = [];
for i = 1:len_boundary
    x_node = boundary(i,1);
    y_node = boundary(i,2);
    if x_node<min(x_in,x_out) || x_node>max(x_in,x_out) || y_node<min(y_in,y_out) || y_node>max(y_in,y_out) 
        node_index = [node_index,i];
    end
end

boundary(node_index,:) = [];
boundary_new = boundary;

end
