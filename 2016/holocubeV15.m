function [ CCD ] = holocubeV15( Img_o_e, shape, method )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{ 
%%  Ce programme reprend holocubeV14. Le but est de produire l'image qui sera affichée sur le capteur LCD qu'on va diffracter avec le laser (= onde de référence)
%
% * *Img_o_e* est l'objet d'origine : c'est une matrice de points en 3 dimensions de côté N.
    On pourra utiliser la fonction ?????? pour la générer.
% * *shape* remplace l'image si Img_o_e n'est pas une matrice 3D.
% * *method* Calcul par S-FFT, D-FFT, IMG4FFT, DBFT


%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


lambda = 633*10^-9;		%longeur d'onde du laser (en m)
k = 2*pi/lambda;		%vecteur d'onde (en m^-1)

%Choix de N
%Choix du padding
padding= ;
%Points à retirer (car non visibles)

%Si on a spécifié une forme, on utilise la génération de cette forme plutôt
%que l'image.
if(shape != 'null')
    Img_o_e = 3Dshape(shape, (N-padding));
   
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

