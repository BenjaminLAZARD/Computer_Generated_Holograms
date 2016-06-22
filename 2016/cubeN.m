function cubepoints = cubeN(N)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%%%%construit un petit cube plein NxN
cubepoints = [];

for x=0:N-1
    for y=0:N-1
        for z=0:N-1
            cubepoints = [cubepoints ; 0.0001*[x y z]]; %pas de 0.1 mm
        end
    end
end

end

