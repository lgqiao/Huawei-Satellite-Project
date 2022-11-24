function distance = data_extract(path,orbit,index,t)
%DATA_EXTRACT: Extract starlink distance information from Excel in folder 75
% usage:  Distance = data_extract(Orbit, Index, T)
%  
% where,
%    Orbit is the number of the orbit the satellite is in
%    Index is an index of satellites in a certain orbit, it is a vector
%    T is time


files = dir([path,'*.csv']); % Extract files
Filename = {files.name}'; % Extract filename
[~,Index] = sort_nat(Filename); % sort
Filename = Filename(Index);

t = t+1;
len_t = length(t);
orbit_num = length(orbit);
index_num = length(index);

% Get the measurement between orbits at each time
for k = 1:len_t
    time = t(k);
    data = [];
    filename = Filename{time};                
    full_path = strcat(path,filename); 
    Data = readmatrix(full_path,'Range',[1,1,orbit_num*index_num,9]);
    if orbit_num==75
        for j = 1:orbit_num
            index_excel = 1+index_num*orbit(j):index_num*(orbit(j)+1);
            index_satellites = index_excel(index+1);
            data = [data, Data(index_satellites,3)]; % 3(75x75) or 7(60x30)
        end
    elseif orbit_num==60
        for j = 1:orbit_num
            index_excel = 1+index_num*orbit(j):index_num*(orbit(j)+1);
            index_satellites = index_excel(index+1);
            data = [data, Data(index_satellites,3)]; % 3(75x75) or 7(60x60) or 3(60x30)
        end
    end
    distance(:,:,k) = data;
end

end