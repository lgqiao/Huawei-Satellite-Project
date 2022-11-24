function Inter = inter_expand(x1,y1,x2,y2,max_x,max_y,t)
%INTER_EXPAND: Calculate the intersection of the valley line and the rectangle 
%              in the direction of the peak and valley


x_s = x1;
y_s = y1;
x_d = x2;
y_d = y2;

ys = fx_valley(x_s,t);
xs = fy_valley(y_s,t);
yd = fx_valley(x_d,t);
xd = fy_valley(y_d,t);

if x_d>=x_s && y_d>=y_s % Along the peak-to-valley direction (forward)
    % Make a vertical line through the source node
    ys_in = ys(ys>=y_s & ys<=y_d);
    ys_out1 = ys(ys>=0 & ys<y_s);
    ys_out2 = ys(ys>y_d & ys<=max_y);

    % Make a horizontal line through the source node
    xs_in = xs(xs>=x_s & xs<=x_d);
    xs_out1 = xs(xs>=0 & xs<x_s);
    xs_out2 = xs(xs>x_d & xs<=max_x);

    % Make a vertical line through the destination node
    yd_in = yd(yd>=y_s & yd<=y_d);
    yd_out1 = yd(yd>=0 & yd<y_s);
    yd_out2 = yd(yd>y_d & yd<=max_y);

    % Make a horizontal line through the destination node
    xd_in = xd(xd>=x_s & xd<=x_d);
    xd_out1 = xd(xd>=0 & xd<x_s);
    xd_out2 = xd(xd>x_d & xd<=max_x);

    % square 1
    inter1_l(:,2) = flip(ys_in)+max_y;
    inter1_l(:,1) = x_s+max_x;
    inter1_t(:,1) = flip(xs_in)+max_x;
    inter1_t(:,2) = y_s+max_y;
    inter1_b(:,1) = flip(xd_in)+max_x;
    inter1_b(:,2) = y_d+max_y;
    inter1_r(:,2) = flip(yd_in)+max_y;
    inter1_r(:,1) = x_d+max_x;

    % square 4
    inter4_l(:,2) = [yd_out2,yd_out1+max_y];
    inter4_l(:,1) = x_d;
    inter4_t(:,1) = [xd_out1+max_x,xd_out2];
    inter4_t(:,2) = y_d;
    inter4_b(:,1) = [xs_out1+max_x,xs_out2];
    inter4_b(:,2) = y_s+max_y;
    inter4_r(:,2) = [ys_out2,ys_out1+max_y];
    inter4_r(:,1) = x_s+max_x;

    inter1 = [[inter1_l;inter1_t],[inter1_b;inter1_r]];
    inter4 = [[inter4_r;inter4_b],[inter4_t;inter4_l]];
    
    Inter = {inter1,inter4};

elseif x_d<=x_s && y_d<=y_s % Along the peak-to-valley direction (reverse)
    % Make a vertical line through the source node
    ys_in = ys(ys>=y_d & ys<=y_s);
    ys_out1 = ys(ys>y_s & ys<=max_y);
    ys_out2 = ys(ys>=0 & ys<y_d);

    % Make a horizontal line through the source node
    xs_in = xs(xs>=x_d & xs<=x_s);
    xs_out1 = xs(xs>x_s & xs<=max_x);
    xs_out2 = xs(xs>=0 & xs<x_d);

    % Make a vertical line through the destination node
    yd_in = yd(yd>=y_d & yd<=y_s);
    yd_out1 = yd(yd>y_s & yd<=max_y);
    yd_out2 = yd(yd>=0 & yd<y_d);

    % Make a horizontal line through the destination node
    xd_in = xd(xd>=x_d & xd<=x_s);
    xd_out1 = xd(xd>x_s & xd<=max_x);
    xd_out2 = xd(xd>=0 & xd<x_d);

    % square 1
    inter1_l(:,2) = yd_in+max_y;
    inter1_l(:,1) = x_d+max_x;
    inter1_t(:,1) = xd_in+max_x;
    inter1_t(:,2) = y_d+max_y;
    inter1_b(:,1) = xs_in+max_x;
    inter1_b(:,2) = y_s+max_y;
    inter1_r(:,2) = ys_in+max_y;
    inter1_r(:,1) = x_s+max_x;

    % square 4
    inter4_l(:,2) = flip([ys_out1+max_y,ys_out2+2*max_y]);
    inter4_l(:,1) = x_s+max_x;
    inter4_t(:,1) = flip([xs_out2+2*max_x,xs_out1+max_x]);
    inter4_t(:,2) = y_s+max_y;
    inter4_b(:,1) = flip([xd_out2+2*max_x,xd_out1+max_x]);
    inter4_b(:,2) = y_d+2*max_y;
    inter4_r(:,2) = flip([yd_out1+max_y,yd_out2+2*max_y]);
    inter4_r(:,1) = x_d+2*max_x;

    inter1 = [[inter1_r;inter1_b],[inter1_t;inter1_l]];
    inter4 = [[inter4_l;inter4_t],[inter4_b;inter4_r]];

    Inter = {inter4,inter1};

elseif x_d>=x_s && y_d<=y_s % Not along the peak-to-valley direction (forward)
    % Make a vertical line through the source node
    ys_in = ys(ys>=y_d & ys<=y_s);
    ys_out1 = ys(ys>y_s & ys<=max_y);
    ys_out2 = ys(ys>=0 & ys<y_d);

    % Make a horizontal line through the source node
    xs_in = xs(xs>=x_s & xs<=x_d);
    xs_out1 = xs(xs>=0 & xs<x_s);
    xs_out2 = xs(xs>x_d & xs<=max_x);

    % Make a vertical line through the destination node
    yd_in = yd(yd>=y_d & yd<=y_s);
    yd_out1 = yd(yd>y_s & yd<=max_y);
    yd_out2 = yd(yd>=0 & yd<y_d);

    % Make a horizontal line through the destination node
    xd_in = xd(xd>=x_s & xd<=x_d);
    xd_out1 = xd(xd>=0 & xd<x_s);
    xd_out2 = xd(xd>x_d & xd<=max_x);

    % square 2
    inter2_l(:,2) = flip([ys_out1+max_y,ys_out2+2*max_y]);
    inter2_l(:,1) = x_s+max_x;
    inter2_t(:,1) = flip(xs_in)+max_x;
    inter2_t(:,2) = y_s+max_y;
    inter2_b(:,1) = flip(xd_in)+max_x;
    inter2_b(:,2) = y_d+2*max_y;
    inter2_r(:,2) = flip([yd_out1+max_y,yd_out2+2*max_y]);
    inter2_r(:,1) = x_d+max_x;

    % square 3
    inter3_l(:,2) = yd_in+max_y;
    inter3_l(:,1) = x_d;
    inter3_t(:,1) = [xd_out1+max_x,xd_out2];
    inter3_t(:,2) = y_d+max_y;
    inter3_b(:,1) = [xs_out1+max_x,xs_out2];
    inter3_b(:,2) = y_s+max_y;
    inter3_r(:,2) = ys_in+max_y;
    inter3_r(:,1) = x_s+max_x;

    inter2 = [[inter2_l;inter2_t],[inter2_b;inter2_r]];
    inter3 = [[inter3_r;inter3_b],[inter3_t;inter3_l]];

    Inter = {inter2,inter3};

elseif x_d<=x_s && y_d>=y_s % Not along the peak-to-valley direction (reverse)
    % Make a vertical line through the source node
    ys_in = ys(ys>=y_s & ys<=y_d);
    ys_out1 = ys(ys>=0 & ys<y_s);
    ys_out2 = ys(ys>y_d & ys<=max_y);

    % Make a horizontal line through the source node
    xs_in = xs(xs>=x_d & xs<=x_s);
    xs_out1 = xs(xs>x_s & xs<=max_x);
    xs_out2 = xs(xs>=0 & xs<x_d);

    % Make a vertical line through the destination node
    yd_in = yd(yd>=y_s & yd<=y_d);
    yd_out1 = yd(yd>=0 & yd<y_s);
    yd_out2 = yd(yd>y_d & yd<=max_y);

    % Make a horizontal line through the destination node
    xd_in = xd(xd>=x_d & xd<=x_s);
    xd_out1 = xd(xd>x_s & xd<=max_x);
    xd_out2 = xd(xd>=0 & xd<x_d);

    % square 2
    inter2_l(:,2) = [yd_out2,yd_out1+max_y];
    inter2_l(:,1) = x_d+max_x;
    inter2_t(:,1) = xd_in+max_x;
    inter2_t(:,2) = y_d;
    inter2_b(:,1) = xs_in+max_x;
    inter2_b(:,2) = y_s+max_y;
    inter2_r(:,2) = [ys_out2,ys_out1+max_y];
    inter2_r(:,1) = x_s+max_x;

    % square 3
    inter3_l(:,2) = flip(ys_in)+max_y;
    inter3_l(:,1) = x_s+max_x;
    inter3_t(:,1) = flip([xs_out2+2*max_x,xs_out1+max_x]);
    inter3_t(:,2) = y_s+max_y;
    inter3_b(:,1) = flip([xd_out2+2*max_x,xd_out1+max_x]);
    inter3_b(:,2) = y_d+max_y;
    inter3_r(:,2) = flip(yd_in)+max_y;
    inter3_r(:,1) = x_d+2*max_x;

    inter2 = [[inter2_r;inter2_b],[inter2_t;inter2_l]];
    inter3 = [[inter3_l;inter3_t],[inter3_b;inter3_r]];

    Inter = {inter3,inter2};

end

end