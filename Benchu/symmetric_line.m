function [point_sy_end,point_ver,point_hor] = symmetric_line(x1,y1,x2,y2,sy_source)
%SYMMETRIC_LINE: Calculate symmetrical dividing line in rectangular area


global k_T

dx = x2-x1;

if sy_source(1)==x1
    y_symmetric = sy_source(2);
    if dx>0
        f_x2 = k_T*(x2-x1)+y_symmetric;
        if round(f_x2)<=y2
            sy_destination = [x2,f_x2];
        else
            f_y2 = 1/k_T*(y2-y_symmetric)+x1;
            sy_destination = [f_y2,y2];
        end
        path_sy = path_generate_or(sy_source(1),sy_source(2),sy_destination(1),sy_destination(2),3);
        sy_source = round(sy_source);
        sy_destination = round(sy_destination);
        point_sy_end = [sy_source,sy_destination];
        path_sy = [sy_source;path_sy;sy_destination];

        y_s = sy_source(2);
        y_d = sy_destination(2);
        dy = y_d-y_s;
        point_hor = [];
        row_hor = [];
        for i = 1:dy
            row = find(path_sy(:,2)==y_s+i);
            min_row = min(row);
            row_hor = [row_hor;min_row];
            point_hor = [point_hor;path_sy(min_row,:)];
        end
        path_sy(row_hor,:) = [];
        point_ver = path_sy;
    elseif dx<0
        f_x2 = k_T*(x2-x1)+y_symmetric;
        if round(f_x2)>=y2
            sy_destination = [x2,f_x2];
        else
            f_y2 = 1/k_T*(y-y_symmetric)+x1;
            sy_destination = [f_y2,y2];
        end
        path_sy = path_generate_or(sy_source(1),sy_source(2),sy_destination(1),sy_destination(2),3);
        sy_source = round(sy_source);
        sy_destination = round(sy_destination);
        point_sy_end = [sy_source,sy_destination];
        path_sy = [sy_source;path_sy;sy_destination];

        y_s = sy_source(2);
        y_d = sy_destination(2);
        dy = y_d-y_s;
        point_hor = [];
        row_hor = [];
        for i = 1:-dy
            row = find(path_sy(:,2)==y_s-i);
            min_row = min(row);
            row_hor = [row_hor;min_row];
            point_hor = [point_hor;path_sy(min_row,:)];
        end
        path_sy(row_hor,:) = [];
        point_ver = path_sy;
    end
elseif sy_source(2)==y1
    x_symmetric = sy_source(1);
    if dx>0
        f_x2 = k_T*(x2-x_symmetric)+y1;
        if round(f_x2)<=y2
            sy_destination = [x2,f_x2];
        else
            f_y2 = 1/k_T*(y2-y1)+x_symmetric;
            sy_destination = [f_y2,y2];
        end
        path_sy = path_generate_or(sy_source(1),sy_source(2),sy_destination(1),sy_destination(2),3);
        sy_source = round(sy_source);
        sy_destination = round(sy_destination);
        point_sy_end = [sy_source,sy_destination];
        path_sy = [sy_source;path_sy;sy_destination];

        y_s = sy_source(2);
        y_d = sy_destination(2);
        dy = y_d-y_s;
        point_hor = [];
        row_hor = [];
        for i = 0:dy
            row = find(path_sy(:,2)==y_s+i);
            min_row = min(row);
            row_hor = [row_hor;min_row];
            point_hor = [point_hor;path_sy(min_row,:)];
        end
        path_sy(row_hor,:) = [];
        point_ver = path_sy;
    elseif dx<0
        f_x2 = k_T*(x2-x_symmetric)+y1;
        if round(f_x2)>=y2
            sy_destination = [x2,f_x2];
        else
            f_y2 = 1/k_T*(y2-y1)+x_symmetric;
            sy_destination = [f_y2,y2];
        end
        path_sy = path_generate_or(sy_source(1),sy_source(2),sy_destination(1),sy_destination(2),3);
        sy_source = round(sy_source);
        sy_destination = round(sy_destination);
        point_sy_end = [sy_source,sy_destination];
        path_sy = [sy_source;path_sy;sy_destination];

        y_s = sy_source(2);
        y_d = sy_destination(2);
        dy = y_d-y_s;
        point_hor = [];
        row_hor = [];
        for i = 0:-dy
            row = find(path_sy(:,2)==y_s-i);
            min_row = min(row);
            row_hor = [row_hor;min_row];
            point_hor = [point_hor;path_sy(min_row,:)];
        end
        path_sy(row_hor,:) = [];
        point_ver = path_sy;
    end
end

end
