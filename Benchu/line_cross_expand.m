function [cross_point1,cross_point2] = line_cross_expand(S1,S2,D1,D2,delta1,delta2)
%LINE_CROSS_EXPAND: Calculate the intersection of line segments with peaks and valleys
%                   on extended map


cross_point1 = [];
cross_point2 = [];

delta1_x = delta1(1);
delta1_y = delta1(2);
delta2_x = delta2(1);
delta2_y = delta2(2);

num_segment1 = round(abs(D1(1)-S1(1))/delta1_x)-1;
num_segment2 = round(abs(D2(1)-S2(1))/delta2_x)-1;

% num_segment = num_inter_square(ceil(S(1)),fix(S(2)),fix(D(1)),ceil(D(2)),t);
% 
% delta_x = (D(1)-S(1))/(num_segment+1);
% delta_y = (D(2)-S(2))/(num_segment+1);

% if Source(1)<=S(1)+1 && Source(2)>=S(2)+1
%     cross_point = [cross_point;S];
% end
% 
% if Destination(1)>=D(1)+1 && Destination(2)<=D(2)+1
%     num_segment = num_segment+1;
% end

for i = 1:num_segment1
    S1(1) = S1(1)+delta1_x;
    S1(2) = S1(2)-delta1_y;
    cross_point1 = [cross_point1;S1];
end

for i = 1:num_segment2
    S2(1) = S2(1)-delta2_x;
    S2(2) = S2(2)+delta2_y;
    cross_point2 = [cross_point2;S2];
end

end
