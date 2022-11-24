function [duplicate_hor,duplicate_ver] = duplicate_path_end(x1,y1,x2,y2,t)
%DUPLICATE_EXPAND_NEW: Find the endpoints of the duplicate path at the upper(lower) and right(left) 
%                      boundaries of a rectangular area 


global T_x T_y

dx = x2-x1;

% if it is forward, hor = top, ver = right
% if it is reverse, hor = bottom, ver = left
duplicate_hor = [];
duplicate_ver = [];

if dx>0 % forward
    xt = fy_valley_ex(y2,t);
    yr = fx_peak_ex(x2,t);
    
    x_hor = xt(xt>=x1 & xt<=T_x/2+x2);
    y_ver = yr(yr>=y2-T_y/2 & yr<=y1);

    for i = 1:length(x_hor)
        [~,~,delta_x,~] = inter_sd_pair(x1,y1,x_hor(i),y2,t);
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
        [~,~,~,delta_y] = inter_sd_pair(x1,y1,x2,y_ver(i),t);
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
    xb = fy_valley_ex(y2,t);
    yl = fx_peak_ex(x2,t);

    x_hor = xb(xb>=x2-T_x/2 & xb<=x1);
    y_ver = yl(yl>=y1 & yl<=y2+T_y/2);

    for i = 1:length(x_hor)
        [~,~,delta_x,~] = inter_sd_pair(x1,y1,x_hor(i),y2,t);
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
        [~,~,~,delta_y] = inter_sd_pair(x1,y1,x2,y_ver(i),t);
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

end
