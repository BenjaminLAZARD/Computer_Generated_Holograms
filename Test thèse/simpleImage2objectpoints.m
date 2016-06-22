function objectpoints = simpleImage2objectpoints( img, width, height, depth )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

obj = double(img);
thresh = 128;
row = 1;
for i=1:size(obj,1)
    for j=1:size(obj,2)
        if obj(i,j) < thresh
            objectpoints(row,:)=[(i*size(obj,1)/2)*(width/size(obj,1)), (j-size(obj,2)/2)*(height/size(obj,2)), depth];
            row = row + 1;
        end
    end     
end
       