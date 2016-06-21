function [ object ] = shape3D( shape, N, padding, pas_pixel )
%Sert � g�n�rer un objet 3D comme une matrice de points. Cela sert dans HolocubeV15 pour calculer les amplitudes complexes du plan objet.
%* *shape* soit _'cube'_, soit  _'sphere'_, soit'Z= f(X,Y)
%* *N* la matrice 3Dobject est de taille N^3. N doit �tre pair.
%* *padding* d�crit le nombre de pixels laiss�s libres au bord du cube N^3 pour que la shape soit inscrit dedans avec des "marges"

if mod(N,2)~=0;
    fprintf('La valeur du param�tre N dans la fonction shape3D doit �tre paire ! \n')
    return
end
%{
minInputs = 3;
maxInputs = 4;
narginchk(minInputs,maxInputs);
%}

switch shape %le switch en matlab ne marche pas comme le switch en C. Notamment les breaks sont inutiles.
    case 'cube'
        object = zeros((N-2*padding)*4+(N-2*padding-2)*8,3);% Nombre de points=pixels qui repr�sentent le cube (12 arr�tes. Il y a 8 points qu'on compte 2 fois car il  y a 8 sommets)       
        dim_side = (N-2*padding); % Taille d'une arr�te en points=pixels.
        for m = 1 : 1 : dim_side
            %on remplit les coordonn�es des arr�tes qui sont sur l'axe Z
            object(m,                     :) = [padding+1, padding+1, m+padding];%coordonn�es en pixels des points de l'arr�te 0 (cf. sch�ma correspondant dans le rapport)
            object(m+1*dim_side,:) = [N-padding, padding+1, m+padding];%coordonn�es en pixels des points de l'arr�te 1 (cf. sch�ma correspondant dans le rapport)
            object(m+2*dim_side,:) = [padding+1,N-padding, m+padding];%coordonn�es en pixels des points de l'arr�te 2 (cf. sch�ma correspondant dans le rapport)
            object(m+3*dim_side,:) = [N-padding, N-padding, m+padding];%coordonn�es en pixels des points de l'arr�te 3 (cf. sch�ma correspondant dans le rapport)
        end
        dim_side2 = dim_side-2;%(en effet, les 1�re arr�tes trac�es contiennent les 8 sommets du cube. On ne veut pas les r�p�ter : toutes les autres arr�tes n'ont ps de sommets).
        last = 4*dim_side;
        for m = 1 : 1 : dim_side2
            %on remplit les coordonn�es des arr�tes qui sont sur l'axe X
            object(m+last,:) = [m+padding+1, padding+1, padding+1];%coordonn�es en pixels des points de l'arr�te 4 (cf. sch�ma correspondant dans le rapport)
            object(m+last+1*dim_side2,:) = [m+padding+1, padding+1, N-padding];%coordonn�es en pixels des points de l'arr�te 5 (cf. sch�ma correspondant dans le rapport)
            object(m+last+2*dim_side2,:) = [m+padding+1, N-padding, padding+1];%coordonn�es en pixels des points de l'arr�te 6 (cf. sch�ma correspondant dans le rapport)
            object(m+last+3*dim_side2,:) = [m+padding+1, N-padding, N-padding];%coordonn�es en pixels des points de l'arr�te 7 (cf. sch�ma correspondant dans le rapport)
             %on remplit les coordonn�es des arr�tes qui sont sur l'axe Y
            object(m+last+4*dim_side2,:) = [padding+1, m+padding+1, padding+1];%coordonn�es en pixels des points de l'arr�te 8 (cf. sch�ma correspondant dans le rapport)
            object(m+last+5*dim_side2,:) = [N-padding, m+padding+1, padding+1];%coordonn�es en pixels des points de l'arr�te 9 (cf. sch�ma correspondant dans le rapport)
            object(m+last+6*dim_side2,:) = [padding+1, m+padding+1, N-padding];%coordonn�es en pixels des points de l'arr�te 10 (cf. sch�ma correspondant dans le rapport)
            object(m+last+7*dim_side2,:) = [N-padding, m+padding+1, N-padding];%coordonn�es en pixels des points de l'arr�te 11 (cf. sch�ma correspondant dans le rapport)
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

