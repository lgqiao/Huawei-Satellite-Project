function [Count_Index,min_xNode,min_yNode,gn] = min_OPEN(OPEN,OPEN_COUNT)
%MIN_OPEN: this function takes the list OPEN as its input and returns the index of the
%          node that has the least cost


% initialization
temp_array = [];
k = 1;
Count_Index = 0;
min_xNode = 0;
min_yNode = 0;
 
for j = 1:OPEN_COUNT
    if OPEN(j,1)==1
        temp_array(k,:) = [OPEN(j,:) j];
        k = k+1;
    end
end

if size(temp_array)~=0
  [~,temp_min] = min(temp_array(:,6)); % Index of the smallest node in temp array
  min_xNode = temp_array(temp_min,2);
  min_yNode = temp_array(temp_min,3);
  gn = temp_array(temp_min,6);
  Count_Index = temp_array(temp_min,9);
end

end

