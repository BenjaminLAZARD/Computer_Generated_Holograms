function [ CCD ] = holocubeV15( M, L, z0 )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{ 
%%  Ce programme reprend holocubeV14. Le but est de produire l'image qui sera affichée sur le capteur LCD qu'on va diffracter avec le laser (= onde de référence)
%
% * *M* est l'objet d'origine. On entre une matrice de taille Nombredepointsdel'objet:::3 Où les colonnes sont les coordonnées  des points (x,y,z), l'origine étant prise en haut à gauche de l'image (considérer "dans un coin" pour les images symétriques)
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

Lo=L;                               %taille de l'objet original. Ce paramètre est optimal d'après le livre (p.85)
Nm= 350 ;                       % Nombre de points utilisés pour générer l'objet 3D Si M n'est pas déjà une matrice.
pm= Lo/Nm;                    % Nombre de points utilisés pour générer l'objet 3D Si M n'est pas déjà une matrice.
padding = N*0.05;            % Espace entre les bord de l'objets 3D et celui-ci, si M n'est pas déjà une matrice.
 

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

if size(M,2) ~= 3 %Si la matrice M ne colle pas avec notre représentation de l'objet 3D à ce stade
    fprintf('Le 1er paramètre de la fonction ne correspond à aucun objet.\n');
    return
end

% A ce stade on soit l'objet M entré comme matrice, soit une forme de  taille Lo^2 (m) ou Nm^2 (px).

%Est-ce qu'on retire des points ? (car non visibles)
WRP = ob2wrp(); %On récupère l'objet 2D qui contient la somme des ondes émises pour tous les points de l'objet à la distance d.

   
%Création du LUT pour les calculs
%Calcul de l'image CCD complète. (threads ? GPU?)
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
%Retirer mathématiquement l'ordre 0
%Fenêtre de choix de l'ordre 1 dans le domaine fréquentiel

CCD = Img_o_e;

end

