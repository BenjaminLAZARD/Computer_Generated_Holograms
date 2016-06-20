function [ film ] = Computing(objectpoints)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

sampling = 0.0254/1200;
wavelength = 630e-9;

dimensions = 1;
range=dimensions*0.0254/2;
ipx=(-1*range):sampling:range;
ipy=(-1*range):sampling:range;

film = zeros(size(ipx,2), size(ipy,2));

offset = 0.04;
objectpoints(:,1)= objectpoints(:,1) + offset;

for o=1:size(objectpoints,1)
    fprintf('%d \n',o);
    for i=1:size(ipx,2)
        for j=1:size(ipy,2)
            dx = objectpoints(o,1) - ipx(i);
            dy = objectpoints(o,2) - ipx(j);
            dz = objectpoints(o,3) - 0;
            distance = sqrt(dx^2 + dy^2 + dz^2);
            complexwave = exp(2*pi*sqrt(-1)*distance/(wavelength));
            film(i,j)= film(i,j) + complexwave;
        end
    end
end

