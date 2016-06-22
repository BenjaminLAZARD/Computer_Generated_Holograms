function [ CCD ] = holocubeV15( M, L, z0 )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{ 
%%  Ce programme reprend holocubeV14. Le but est de produire l'image qui sera affich�e sur le capteur LCD qu'on va diffracter avec le laser (= onde de r�f�rence)
%
% * *M* est l'objet d'origine. On entre une matrice de taille Nombredepointsdel'objet:::3 O� les colonnes sont les coordonn�es  des points (x,y,z), l'origine �tant prise en haut � gauche de l'image (consid�rer "dans un coin" pour les images sym�triques)
On pourra aussi tester directement avec les arguments 'cube', 'tube', 'sphere'.
% * *method* Calcul par S-FFT, D-FFT, IMG4FFT, DBFT
%* *z0* est la disance entre l'image et le SLM
% * *L* est la largeur de l'image obtenu en sortie.

%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lambda = 633*10^-9;		%longeur d'onde du laser (en m)
k = 2*pi/lambda;		    %vecteur d'onde (en m^-1)
N=L^2/(lambda*z0);      %Largeur en pixels du plan WRP

pas_px_wrp = L/N;         % taille d'un pixel sur le plan WRP.
d=z0/10;                         % Distance entre le 1er plan de l'obet 3D M et le WRP.

Lo=L;                               %taille de l'objet original. Ce param�tre est optimal d'apr�s le livre (p.85)
Nm= 350 ;                       % Nombre de points utilis�s pour g�n�rer l'objet 3D Si M n'est pas d�j� une matrice.
pm= Lo/Nm;                    % Nombre de points utilis�s pour g�n�rer l'objet 3D Si M n'est pas d�j� une matrice.
padding = N*0.05;            % Espace entre les bord de l'objets 3D et celui-ci, si M n'est pas d�j� une matrice.
 

switch M
     case 'cube'
         M=shape3D( 'cube', Nm, padding, pm);
     case 'tube'
          M=shape3D( 'tube', Nm, padding*2, pm);
     case 'sphere'
          M=shape3D( 'sphere', Nm, padding*2, pm);
    otherwise
        if isa(M,'char')
            M=shape3D( M, Nm, padding, pm);
        end
 end

if size(M,2) ~= 3 %Si la matrice M ne colle pas avec notre repr�sentation de l'objet 3D � ce stade
    fprintf('Le 1er param�tre de la fonction ne correspond � aucun objet.\n');
    return
end

% A ce stade on soit l'objet M entr� comme matrice, soit une forme de  taille Lo^2 (m) ou Nm^2 (px).

%Est-ce qu'on retire des points ? (car non visibles)
WRP = ob2wrp(); %On r�cup�re l'objet 2D qui contient la somme des ondes �mises pour tous les points de l'objet � la distance d.

   
%Cr�ation du LUT pour les calculs
%Calcul de l'image CCD compl�te. (threads ? GPU?)
CCD = zeros(1080, 1920); %matrice aux dimensions du capteur avec 1pt/px.
switch (method)
    case S-FFT:
        ;
    case D-FFT:
        ;
    case IMG4FFT:
        ;
    case DBFT:
        ;
%Retirer math�matiquement l'ordre 0
%Fen�tre de choix de l'ordre 1 dans le domaine fr�quentiel

CCD = Img_o_e;

end

