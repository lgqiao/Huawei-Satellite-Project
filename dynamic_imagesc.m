function dynamic_imagesc(t)
%DYNAMIC_IMAGESC: Plot a heatmap of a dynamically changing distance matrix


for i = 1:length(t)
    str = strcat('time_varying_distance\',num2str(i),'.jpg');
    A = imread(str);
    [I,map] = rgb2ind(A,256);
    if(i == 1)
        imwrite(I,map,'Distance.gif','DelayTime',0.1,'LoopCount',Inf)
    else
        imwrite(I,map,'Distance.gif','WriteMode','append','DelayTime',0.1)
    end
end

end
