function [ object ] = shape3D( shape, N, padding, pas_pixel)
%Sert � g�n�rer un objet 3D comme une matrice de points. Cela sert dans HolocubeV15 pour calculer les amplitudes complexes du plan objet.
%* *shape* soit _'cube'_, soit  _'sphere'_, soit'Z= f(X,Y)' (en rempla�ant * par .* et ^ par .^ dans ce dernier cas).
%* *N* la matrice 3Dobject est de taille N^3. N doit �tre pair.
%* *padding* d�crit le nombre de pixels laiss�s libres au bord du cube N^3 pour que la shape soit inscrit dedans avec des "marges"
%* *pas_pixel* influe sur la fen�tre dans laquelle on �value la fonction.

%Attention on devra peut-�tre modifier le fen�trage des fonctions pour
%obtenir

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
        dim_side = (N-2*padding); % Taille d'une ar�te en points=pixels.
        for m = 1 : 1 : dim_side
            %on remplit les coordonn�es des ar�tes qui sont sur l'axe Z
            object(m,                     :) = [padding+1, padding+1, m+padding];%coordonn�es en pixels des points de l'arr�te 0 (cf. sch�ma correspondant dans le rapport)
            object(m+1*dim_side,:) = [N-padding, padding+1, m+padding];%coordonn�es en pixels des points de l'ar�te 1 (cf. sch�ma correspondant dans le rapport)
            object(m+2*dim_side,:) = [padding+1,N-padding, m+padding];%coordonn�es en pixels des points de l'ar�te 2 (cf. sch�ma correspondant dans le rapport)
            object(m+3*dim_side,:) = [N-padding, N-padding, m+padding];%coordonn�es en pixels des points de l'arr�te 3 (cf. sch�ma correspondant dans le rapport)
        end
        dim_side2 = dim_side-2;%(en effet, les 1�re ar�tes trac�es contiennent les 8 sommets du cube. On ne veut pas les r�p�ter : toutes les autres arr�tes n'ont ps de sommets).
        last = 4*dim_side;
        for m = 1 : 1 : dim_side2
            %on remplit les coordonn�es des arr�tes qui sont sur l'axe X
            object(m+last,:) = [m+padding+1, padding+1, padding+1];%coordonn�es en pixels des points de l'ar�te 4 (cf. sch�ma correspondant dans le rapport)
            object(m+last+1*dim_side2,:) = [m+padding+1, padding+1, N-padding];%coordonn�es en pixels des points de l'ar�te 5 (cf. sch�ma correspondant dans le rapport)
            object(m+last+2*dim_side2,:) = [m+padding+1, N-padding, padding+1];%coordonn�es en pixels des points de l'ar�te 6 (cf. sch�ma correspondant dans le rapport)
            object(m+last+3*dim_side2,:) = [m+padding+1, N-padding, N-padding];%coordonn�es en pixels des points de l'ar�te 7 (cf. sch�ma correspondant dans le rapport)
             %on remplit les coordonn�es des ar�tes qui sont sur l'axe Y
            object(m+last+4*dim_side2,:) = [padding+1, m+padding+1, padding+1];%coordonn�es en pixels des points de l'ar�te 8 (cf. sch�ma correspondant dans le rapport)
            object(m+last+5*dim_side2,:) = [N-padding, m+padding+1, padding+1];%coordonn�es en pixels des points de l'ar�te 9 (cf. sch�ma correspondant dans le rapport)
            object(m+last+6*dim_side2,:) = [padding+1, m+padding+1, N-padding];%coordonn�es en pixels des points de l'ar�te 10 (cf. sch�ma correspondant dans le rapport)
            object(m+last+7*dim_side2,:) = [N-padding, m+padding+1, N-padding];%coordonn�es en pixels des points de l'ar�te 11 (cf. sch�ma correspondant dans le rapport)
        end
        object= pas_pixel*object;%On retourne les coordonn�es en m et non plus en pixels.
        figure(5),scatter3(object(:,1), object(:,2), object(:,3));% On trace le cube � partir des coordonn�es ainsi trouv�es.
        
    case 'sphere'
        object = zeros(N^3,3);
        % On place l'origine de la fonction au centre du cube de c�t� N
        xx = (-N/2+1 : 1 : N/2);
        yy = (-N/2+1 : 1 : N/2);
        [X, Y] = meshgrid(xx, yy);
        R=(N/2-padding);% Rayon de la sph�re dont on veut g�n�rer les coordonn�es.
        Z= ( R^2    -   (X.^2  + Y.^2) ).^(1/2); %Equation de la sph�re : Z(k,l) est la valeur en Z  pour (x=k, y=l) qui permet de tracer la demi-sph�re (Z>0).
        m=1;
        for k=xx+N/2
            for l=yy+N/2
                    coef = Z(k,l);
                    if imag(coef)==0
                        object(m,:)=(pas_pixel*[k, l, coef + N/2]);%On remet l'origine en haut � gauche par l'ajout du N/2 aux coordonn�es.
                        object(m+1,:)=(pas_pixel*[k, l, -coef + N/2]);%On remet l'origine en haut � gauche par l'ajout du N/2 aux coordonn�es.
                        m = m+2;
                    %else
                    %    Z(k,l)=0;
                    end
            end
        end
     %figure(4),surf(X,Y,Z);%trace la surface correspondant � la demi-sph�re.
     object = object(1:m-1,:);%On avait allou� trop de m�moire avec la matrice Z�ros au d�but. On retire les points non n�cessaires.
     figure(5),scatter3(object(:,1), object(:,2), object(:,3));% On trace la sphere � partir des coordonn�es ainsi trouv�es.
     
    case 'tube'
        
    otherwise
        %expression = input('Quelle fonction voulez-vous tracer ?\n   Z=f(X,Y) =  ','s');
        
        %tester cette fonction en tapant lors de l'input :'(12*cos((X.^2+Y.^2)/4))./(3+X.^2+Y.^2)' et
        %en r�glant N=50 pour les valeurs de pas_pixel dans {0.5;1;5}
        %Attention, si Z=f(X,Y), les produits se notent .* et les exposants .^ dans l'espace es matrices pour faire du calcul point � point.
        
        object = zeros(N^3,3);
        % On place l'origine de la fonction au centre du cube de c�t� N
        xx = (-N/2+1 : 1 : N/2);
        yy = (-N/2+1 : 1 : N/2);
        [X, Y] = meshgrid(xx, yy);
        X = pas_pixel*X;%ignorer le warning
        Y=pas_pixel*Y;%ignorer le warning
        Z=eval(shape);%dans "expression" rentr�e en param�tre de la fonction shape3D doivent appara�tre X et Y (c'est pour �a qu'on a un warning au-dessus)
        m=1;
        for k=xx+N/2
            for l=yy+N/2
                    coef = Z(k,l)/pas_pixel;
                    if imag(coef)==0
                        object(m,:)=(pas_pixel*[k, l, coef + N/2]);%On remet l'origine en haut � gauche par l'ajout du N/2 aux coordonn�es.
                        m = m+1;
                   % else
                    %    Z(k,l)=0;
                    end
            end
        end
     %figure(4),surf(X,Y,Z);
     object = object(1:m-1,:);%On avait allou� trop de m�moire avec la matrice Z�ros au d�but. On retire les points non n�cessaires.
     figure(5),scatter3(object(:,1), object(:,2), object(:,3));% On trace la fonction � partir des coordonn�es ainsi trouv�es.

end

