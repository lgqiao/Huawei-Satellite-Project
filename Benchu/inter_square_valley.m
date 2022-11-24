function inter = inter_square_valley(x1,y1,x2,y2,t)
%INTER_SQUARE_VALLEY: Calculate the intersection of valleys with square
                                

dx = x2-x1;

y_1 = fx_valley_ex(x1,t);
y_2 = fx_valley_ex(x2,t);
x_1 = fy_valley_ex(y1,t);
x_2 = fy_valley_ex(y2,t);

if dx>0 % forward
    y_1 = flip(y_1(y_1>=y1 & y_1<=y2));
    y_2 = flip(y_2(y_2>=y1 & y_2<=y2));
    x_1 = flip(x_1(x_1>x1 & x_1<=x2));
    x_2 = flip(x_2(x_2>=x1 & x_2<x2));
   
    inter_l(:,2) = y_1;
    inter_l(:,1) = x1;
    inter_r(:,2) = y_2;
    inter_r(:,1) = x2;
    inter_t(:,1) = x_1;
    inter_t(:,2) = y1;
    inter_b(:,1) = x_2;
    inter_b(:,2) = y2;

    inter = [[inter_l;inter_t],[inter_b;inter_r]];

else
    y_1 = y_1(y_1>y1 & y_1<y2);
    y_2 = y_2(y_2>y1 & y_2<y2);
    x_1 = x_1(x_1>x1 & x_1<x2);
    x_2 = x_2(x_2>x1 & x_2<x2);
    
    inter_r(:,2) = y_1;
    inter_r(:,1) = x1;
    inter_l(:,2) = y_2;
    inter_l(:,1) = x2;
    inter_b(:,1) = x_1;
    inter_b(:,2) = y1;
    inter_t(:,1) = x_2;
    inter_t(:,2) = y2;

    inter = [[inter_r;inter_b],[inter_t;inter_l]];

end

end