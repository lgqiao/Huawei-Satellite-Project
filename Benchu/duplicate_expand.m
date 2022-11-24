function [duplicate_hor,duplicate_ver] = duplicate_expand(x1,y1,x2,y2,max_x,max_y,t)
%DUPLIACATE_EXPAND: Find the endpoints of the duplicate path at the upper(lower) and right(left) 
%                   boundaries of a rectangular area 


global T_x T_y

dx = x2-x1;

x_s = x1-max_x;
y_s = y1-max_y;
x_d = mod(x2,max_x);
y_d = mod(y2,max_y);

% if it is forward, hor = top, ver = right
% if it is reverse, hor = bottom, ver = left
duplicate_hor = [];
duplicate_ver = [];

if dx>0 % forward
    xt = fy_valley(y_d,t);
    yr = fx_peak(x_d,t);
    if x2>=max_x && x2<2*max_x && y2>=2*max_y && y2<3*max_y
        xt = xt+max_x;
        yr = yr+max_y;
    elseif x2>=2*max_x && x2<3*max_x && y2>=2*max_y && y2<3*max_y
        xt_in = xt(xt>=x_s & xt<max_x);
        xt_out = xt(xt>=0);
        xt = [xt_out+2*max_x,xt_in+max_x];
        yr = yr+max_y;
    elseif x2>=2*max_x && x2<3*max_x && y2>=max_y && y2<2*max_y
        xt_in = xt(xt>=x_s & xt<max_x);
        xt_out = xt(xt>=0);
        xt = [xt_out+2*max_x,xt_in+max_x];
        yr_in = yr(yr>=0 & yr<=y_s);
        yr_out = yr(yr<max_y);
        yr = [yr_out,yr_in+max_y];
    elseif x2>=max_x && x2<2*max_x && y2>=max_y && y2<2*max_y
        xt = xt+max_x;
        yr_in = yr(yr>=0 & yr<=y_s);
        yr_out = yr(yr<max_y);
        yr = [yr_out,yr_in+max_y];
    end
elseif dx<0
    xb = fy_valley(y_d,t);
    yl = fx_peak(x_d,t);
    if x2>=0 && x2<max_x && y2>=max_y && y2<2*max_y
        xb_in = xb(xb>=0 & xb<=x_s);
        xb_out = xb(xb<max_x);
        xb = [xb_in+max_x,xb_out];
        yl_in = yl(yl>=y_s & yl<max_y);
        yl_out = yl(yl>=0);
        yl = [yl_in+max_y,yl_out+2*max_y];
    elseif x2>=max_x && x2<2*max_x && y2>=max_y && y2<2*max_y
        xb = xb+max_x;
        yl_in = yl(yl>=y_s & yl<max_y);
        yl_out = yl(yl>=0);
        yl = [yl_in+max_y,yl_out+2*max_y];
    elseif x2>=max_x && x2<2*max_x && y2>=0 && y2<max_y
        xb = xb+max_x;
        yl = yl+max_y;
    elseif x2>=0 && x2<max_x && y2>=0 && y2<max_y
        xb_in = xb(xb>=0 & xb<=x_s);
        xb_out = xb(xb<max_x);
        xb = [xb_in+max_x,xb_out];
        yl = yl+max_y;
    end
end

if dx>0 % forward
    x_hor = xt(xt>=x1 & xt<=T_x/2+x2);
    y_ver = yr(yr>=y2-T_y/2 & yr<=y1);

    for i = 1:length(x_hor)
        [~,~,delta_x,~] = inter_sd_expand1(x1,y1,x_hor(i),y2,max_x,max_y,t);
        if x_hor(i)-delta_x>=x2
            continue
        end
        x_s = x_hor(i)-delta_x;
        x_d = x_hor(i)+delta_x;
        x_s = max(x_s,x1);
        x_d = min(x_d,x2);
        duplicate_hor = [duplicate_hor;fix(x_d),ceil(x_s)];
    end

    for i = 1:length(y_ver)
        [~,~,~,delta_y] = inter_sd_expand1(x1,y1,x2,y_ver(i),max_x,max_y,t);
        if y_ver(i)+delta_y<=y2
            continue
        end
        y_s = y_ver(i)+delta_y;
        y_d = y_ver(i)-delta_y;
        y_s = min(y_s,y1);
        y_d = max(y_d,y2);
        duplicate_ver = [duplicate_ver;ceil(y_d),fix(y_s)];
    end
elseif dx<0 % reverse
    x_hor = xb(xb>=x2-T_x/2 & xb<=x1);
    y_ver = yl(yl>=y1 & yl<=y2+T_y/2);

    for i = 1:length(x_hor)
        [~,~,delta_x,~] = inter_sd_expand1(x1,y1,x_hor(i),y2,max_x,max_y,t);
        if x_hor(i)+delta_x<=x2
            continue
        end
        x_s = x_hor(i)+delta_x;
        x_d = x_hor(i)-delta_x;
        x_s = min(x_s,x1);
        x_d = max(x_d,x2);
        duplicate_hor = [duplicate_hor;ceil(x_d),fix(x_s)];
    end

    for i = 1:length(y_ver)
        [~,~,~,delta_y] = inter_sd_expand1(x1,y1,x2,y_ver(i),max_x,max_y,t);
        if y_ver(i)+delta_y>=y2
            continue
        end
        y_s = y_ver(i)-delta_y;
        y_d = y_ver(i)+delta_y;
        y_s = max(y_s,y1);
        y_d = min(y_d,y2);
        duplicate_ver = [duplicate_ver;fix(y_d),ceil(y_s)];
    end
end
