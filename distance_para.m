function [A,B,Psi] = distance_para(theta,phi,epsilon)
%DISTANCE_PARA: Calculate the parameters of the fitting function from the known parameters


theta = deg2rad(theta);
phi = deg2rad(phi);
epsilon = deg2rad(epsilon);

a = 1-cos(phi)*cos(epsilon)-sin(phi)*cos(theta)*sin(epsilon);
b = cos(theta)-sin(phi)*sin(epsilon)-cos(phi)*cos(theta)*cos(epsilon);
c = sin(theta)-sin(theta)*cos(epsilon);

a1 = cos(phi)*sin(epsilon)-sin(phi)*cos(theta)*cos(epsilon);
b1 = -sin(phi)*cos(epsilon)+cos(phi)*cos(theta)*sin(epsilon);
c1 = sin(theta)*sin(epsilon);

% alpha = atan(-a/a1);
% beta = atan(b1/b);
% gamma = atan(c1/c);

A = a+b*cos(theta)+c*sin(theta); % A = 0.5*(a^2+b^2+c^2+a1^2+b1^2+c1^2)
B = 0.5*sqrt((a1^2-a^2+b^2-b1^2+c^2-c1^2)^2+(-2*a*a1+2*b*b1+2*c*c1)^2);
Psi = atan((a1^2-a^2+b^2-b1^2+c^2-c1^2)/(-2*a*a1+2*b*b1+2*c*c1));

end
