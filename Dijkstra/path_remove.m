function Path = path_remove(Path,vertex)
%PATH_REMOVE: Remove the destination nodes and corresponding paths that do 
%             not belong to the rectangular area


x1 = vertex(1);
y1 = vertex(2);
x2 = vertex(3);
y2 = vertex(4);

node = [];
index_out = [];
num_path = length(Path);

for i = 1:num_path
    path = Path{i};
    sz_path = size(path,1);
    node = [node;path(sz_path,:)];
    if node(i,1)<x1 || node(i,1)>x2 || node(i,2)<y1 || node(i,2)>y2
        index_out = [index_out,i];
    end
end

Path(index_out) = [];

end
