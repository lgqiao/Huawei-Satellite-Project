function distance_imagesc(distance)
%DISTANCE_GIF: Draw the thermal diagram of the time-varying distance matrix
% usage:  distance_gif(Distance,Var)
%
% where,
%    Distance is the time-varying distance matrix
%    Var represents the change of satellite distance with time, 
%    when Var = 0, the distance between satellites is constant; 
%    when Var = 1, the distance between satellites is time-varying. 

 
rmdir time_varying_distance s
mkdir time_varying_distance

t_len = size(distance, 3);

% Draw the thermal diagram of the distance matrix
for i = 1:t_len
    imagesc(distance(:,:,i));
    colorbar
    saveas(gcf,num2str(i),'jpg')
    movefile *.jpg time_varying_distance
end

end

