function [ CCD ] = holocubeV15( Img_o_e, shape, method )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{ 
%%  Ce programme reprend holocubeV14. Le but est de produire l'image qui sera affich�e sur le capteur LCD qu'on va diffracter avec le laser (= onde de r�f�rence)
%
% * *Img_o_e* est l'objet d'origine : c'est une matrice de points en 3 dimensions de c�t� N.
    On pourra utiliser la fonction ?????? pour la g�n�rer.
% * *shape* remplace l'image si Img_o_e n'est pas une matrice 3D.
% * *method* Calcul par S-FFT, D-FFT, IMG4FFT, DBFT


%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


lambda = 633*10^-9;		%longeur d'onde du laser (en m)
k = 2*pi/lambda;		%vecteur d'onde (en m^-1)

%Choix de N
%Choix du padding
padding= ;
%Points � retirer (car non visibles)

%Si on a sp�cifi� une forme, on utilise la g�n�ration de cette forme plut�t
%que l'image.
if(shape != 'null')
    Img_o_e = 3Dshape(shape, (N-padding));
   
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

