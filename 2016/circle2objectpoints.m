function objectpoints = circle2objectpoints(radius, depth, numpoints)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

objectpoints=zeros(numpoints, 3);

row = 1;
for theta = 0:2*pi/numpoints:2*pi-2*pi/numpoints
    objectpoints(row,:)=[radius*cos(theta) radius*sin(theta) depth];
    row=row+1;
end

