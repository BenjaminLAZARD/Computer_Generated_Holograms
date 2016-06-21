function [ object ] = shape3D( shape, N, padding, pas_pixel )
%Sert à générer un objet 3D comme une matrice de points. Cela sert dans HolocubeV15 pour calculer les amplitudes complexes du plan objet.
%* *shape* soit _'cube'_, soit  _'sphere'_, soit'Z= f(X,Y)
%* *N* la matrice 3Dobject est de taille N^3. N doit être pair.
%* *padding* décrit le nombre de pixels laissés libres au bord du cube N^3 pour que la shape soit inscrit dedans avec des "marges"

if mod(N,2)~=0;
    fprintf('La valeur du paramètre N dans la fonction shape3D doit être paire ! \n')
    return
end
%{
minInputs = 3;
maxInputs = 4;
narginchk(minInputs,maxInputs);
%}

switch shape %le switch en matlab ne marche pas comme le switch en C. Notamment les breaks sont inutiles.
    case 'cube'
        object = zeros((N-2*padding)*4+(N-2*padding-2)*8,3);% Nombre de points=pixels qui représentent le cube (12 arrêtes. Il y a 8 points qu'on compte 2 fois car il  y a 8 sommets)       
        dim_side = (N-2*padding); % Taille d'une arrête en points=pixels.
        for m = 1 : 1 : dim_side
            %on remplit les coordonnées des arrêtes qui sont sur l'axe Z
            object(m,                     :) = [padding+1, padding+1, m+padding];%coordonnées en pixels des points de l'arrête 0 (cf. schéma correspondant dans le rapport)
            object(m+1*dim_side,:) = [N-padding, padding+1, m+padding];%coordonnées en pixels des points de l'arrête 1 (cf. schéma correspondant dans le rapport)
            object(m+2*dim_side,:) = [padding+1,N-padding, m+padding];%coordonnées en pixels des points de l'arrête 2 (cf. schéma correspondant dans le rapport)
            object(m+3*dim_side,:) = [N-padding, N-padding, m+padding];%coordonnées en pixels des points de l'arrête 3 (cf. schéma correspondant dans le rapport)
        end
        dim_side2 = dim_side-2;%(en effet, les 1ère arrêtes tracées contiennent les 8 sommets du cube. On ne veut pas les répéter : toutes les autres arrêtes n'ont ps de sommets).
        last = 4*dim_side;
        for m = 1 : 1 : dim_side2
            %on remplit les coordonnées des arrêtes qui sont sur l'axe X
            object(m+last,:) = [m+padding+1, padding+1, padding+1];%coordonnées en pixels des points de l'arrête 4 (cf. schéma correspondant dans le rapport)
            object(m+last+1*dim_side2,:) = [m+padding+1, padding+1, N-padding];%coordonnées en pixels des points de l'arrête 5 (cf. schéma correspondant dans le rapport)
            object(m+last+2*dim_side2,:) = [m+padding+1, N-padding, padding+1];%coordonnées en pixels des points de l'arrête 6 (cf. schéma correspondant dans le rapport)
            object(m+last+3*dim_side2,:) = [m+padding+1, N-padding, N-padding];%coordonnées en pixels des points de l'arrête 7 (cf. schéma correspondant dans le rapport)
             %on remplit les coordonnées des arrêtes qui sont sur l'axe Y
            object(m+last+4*dim_side2,:) = [padding+1, m+padding+1, padding+1];%coordonnées en pixels des points de l'arrête 8 (cf. schéma correspondant dans le rapport)
            object(m+last+5*dim_side2,:) = [N-padding, m+padding+1, padding+1];%coordonnées en pixels des points de l'arrête 9 (cf. schéma correspondant dans le rapport)
            object(m+last+6*dim_side2,:) = [padding+1, m+padding+1, N-padding];%coordonnées en pixels des points de l'arrête 10 (cf. schéma correspondant dans le rapport)
            object(m+last+7*dim_side2,:) = [N-padding, m+padding+1, N-padding];%coordonnées en pixels des points de l'arrête 11 (cf. schéma correspondant dans le rapport)
        end
    case 'sphere'
        object = zeros(N^3,3);
        [X, Y] = meshgrid((-N/2 : 1 : N/2-1), (-N/2 : 1 : N/2-1));
        Z1= (X.^2 +Y.^2).^(1/2);
        Z2= -(X.^2 +Y.^2).^(1/2);
        for k = 1:N
           % object(m:
        end
    case 'cylinder'
    otherwise
        [X, Y] = meshgrid((-N/2 : 1 : N/2-1), (-N/2 : 1 : N/2-1));
        Z1= (X.^2 +Y.^2).^(1/2);
        Z2= -(X.^2 +Y.^2).^(1/2);
end

end

