function objectpoints = square2objectpoints( length, depth, sampling )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

row = 1;
for x=-length/2:sampling:length/2
    for y=-length/2:sampling:length/2
        objectpoints(row,:)= [x y depth];
        row = row + 1;
    end
end

