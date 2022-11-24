function distance = distance_satellite(W,x1,y1,x2,y2)
%DISTANCE_SATELLITE:Calculate the distance between two satellites
   

global V

max_x = size(W,1);

if x2-x1==0
    distance = V;
elseif x2-x1==1 || x2-x1==1-max_x
    distance = W(x1,y1);
elseif x2-x1==-1 || x2-x1==max_x-1
    distance = W(x2,y2);
end

end

