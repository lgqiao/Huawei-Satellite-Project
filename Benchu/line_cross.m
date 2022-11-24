function cross_point = line_cross(S,D,delta_x,delta_y)
%LINE_CROSS: Calculate the intersection of line segments with peaks and valleys


cross_point = [];

num_segment = round(abs(D(1)-S(1))/delta_x)-1;

if S(1)<D(1)
    for i = 1:num_segment
        S(1) = S(1)+delta_x;
        S(2) = S(2)-delta_y;
        cross_point = [cross_point;S];
    end
else
    for i = 1:num_segment
        S(1) = S(1)-delta_x;
        S(2) = S(2)+delta_y;
        cross_point = [cross_point;S];
    end
end

end
