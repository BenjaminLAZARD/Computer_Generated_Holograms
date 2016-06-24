function [ SLM ] = holocubeV15( M, rho)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{ 
%%  Ce programme reprend holocubeV14. Le but est de produire l'image qui sera affichée sur le capteur LCD qu'on va diffracter avec le laser (= onde de référence)
%
% * *M* est l'objet d'origine. On entre une matrice de taille Nombredepointsdel'objet:::3 Où les colonnes sont les coordonnées  des points (x,y,z), l'origine étant prise en haut à gauche de l'image (considérer "dans un coin" pour les images symétriques)
On pourra aussi tester directement avec les arguments 'cube', 'tube', 'sphere'.
% on pourra aussi tester un point avec  holocubeV15([Lm,Lm, 5],1);
% * *method* Calcul par S-FFT, D-FFT, IMG4FFT, DBFT
%* *z0* est la distance entre l'image et le SLM
% * *Li* est la largeur de l'image obtenue en sortie.
%* *rho* est un paramètre >=1

Toutes les unités sont celles du Système International ( en gros pas de mm).

%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lambda = 633*10^-9;		%longeur d'onde du laser (en m)
k = 2*pi/lambda;		    %vecteur d'onde (en m^-1)
pas_pixel = 8*10^-6;	  %pas de la plaque SLM (en m)
w=1920;                          %largeur de la plaque SLM (en pixels)
h=1080;                           %longueur de la plaque SLM (en pixels)
L=h*pas_pixel;               %On calcule la largeur en mètres du SLM. A partir de maintenant, pour utiliser les calculs du livre, on considère le SLM carré de taille L^2.
Lo=L;                               % taille totale (en m) du WRP. Ce paramètre est optimal d'après le livre (p.85)


z0=rho*4*Lo*L/(lambda*h);%distance entre le plan du WRP et le plan du SLM (Equation 5.20 p.173 du livre anglais).
zr=inf;                                 %distance entre le point source de l'onde sphérique de référence et le plan du SLM.          Cette onde est virtuelle zr=inf correspond en fait à une onde plane.
zc=inf;                                  %distance entre le point source de l'onde sphérique de reconstruction et le plan du SLM. Cette onde est réelle zc=inf correspond en fait à une onde plane.
zi=-1/(1/z0 + 1/zc - 1/zr);%distance entre le plan du SLM et le plan de l'image reconstruite.                                          Ce calcul permet d'avoir une image nette dans le plan de reconstruction
Gi= -zi/z0;                       %Grossissement de l'image recosntruite(Gy dans le livre)

d=z0/5;         %!!!!!!      % Distance entre le 1er plan de l'objet3D M et le WRP.                                                          %%%%Comment le choisir ???
N=closerp2(Lo^2/(lambda*z0)); % Largeur totale en pixels du plan WRP   en px                                                              N doit être une puissance de 2 pour améliorer l'algorithme de la FFT.
pas_px_wrp = Lo/N;         % taille d'un pixel sur le plan WRP.

Li=rho*4*Gi*Lo;%Largeur du plan de l'image reconstruite (Equation 5.19 p.173 du livre anglais). L'image reconstruite en elle-même est plus petite.
%Li=lambda*z0*w/L;%même résultat que ci-dessus. Quelles expression est la meilleure?
%Calcul de Lw, la largeur de la partie utile du WRP. (On complète le pland du WRP avec des zéros (0-padding) pour occuper toute la longueur Lo)
Lw= d*lambda/sqrt((L/h)^2-(lambda^2)/4); %calcul qui tient compte de la diffraction angulaire
%ou bien : il faudra choisir.
%Lw= L*(d+Nm*pm)/(d+Nm*pm+z0);%Calcul qui tient compte de la profondeur du cube (puis th de Thalès, cf. schéma dans le rapport)

Nm= 20 ;                       % Nombre de points utilisés pour générer l'objet 3D Si M n'est pas déjà une matrice. (arbitraire. Plus c'est élevé, plus l'image 3D est continue. influe seulement sur le temps de calcul).
Lm=Lo;                            %Largeur du cube contenant l'objet 3D Si M n'est pas déjà une matrice. (arbitraire. Plus c'est élevé, plus l'image 3D est continue. influe seulement sur le temps de calcul).
pm= Lm/Nm;                   % Nombre de points utilisés pour générer l'objet 3D Si M n'est pas déjà une matrice. (le choix de pm donc de Lw est un peu arbitraire).
paddm = floor(Nm*0.05);            % Espace entre les bord du cube de côté Nm contenant l'objet 3D et celui-ci, si M n'est pas déjà une matrice. (arbitraire, mais peut permettre de centrer et rétrécir l'objet en même temps sur l'image recostruite. A tester).
if isa(M,'char')
    switch M
         case 'cube'
             M=shape3D( 'cube', Nm, paddm, pm);
        case 'tube'
              M=shape3D( 'tube', Nm, paddm*2, pm);
        case 'sphere'
            M=shape3D( 'sphere', Nm, paddm*2, pm);
        otherwise
            M=shape3D( M, N, paddm, pm);
     end
 end

if size(M,2) ~= 3 %Si la matrice M ne colle pas avec notre représentation de l'objet 3D à ce stade
    fprintf('Le 1er paramètre de la fonction ne correspond à aucun objet.\n');
    return
end


%recentrage des points.
M(:,1)=M(:,1)-Lm/2;
M(:,2)=M(:,2)-Lm/2;

figure(1),scatter3(M(:,1), M(:,2), M(:,3));% On trace la fonction à partir des coordonnées de M dans le plan 3D pour bien voir l'objet tracé.
set(gca,'DataAspectRatio',[1,1,1]);

% A ce stade on soit l'objet M entré comme matrice, soit une forme de  taille Lo^2 (m) ou Nm^2 (px).


%Est-ce qu'on retire des points ? (car non visibles)

%L=0.0086 m = 8.6 mm et N=512. condition d'échantillonage respectée pour la DFFT avec z0>4*(0.0086^2)/((633*10^-9)*1080) = 43.27cm.
fprintf('Largeur du SLM L=%f m \n',L);
fprintf('Distance entre le SLM et le WRP z0=%f m \n',z0);
fprintf('Distance entre le SLM et le  plan de l''image reconstruite=%f m \n',zi);
fprintf('Taille minimale du plan de l''image reconstruite Li=%f m \n',Li);
fprintf('Taille totale en m du plan du WRP Lw=%f m \n',Lw);
fprintf('Taille totale en pixels du plan du WRP N=%d pixels\n',N);


%On récupère l'objet 2D qui contient la somme des ondes émises pour tous les points de l'objet à la distance d.
WRP = ob2wrp(M, N, Lw, Lo, d, lambda); 
%On fait la propragation de Fresnel sur la distance z0
SLM = DFFT( WRP, Lo, lambda, z0);% Ou plutôt que z0, mettre la vraie valeur du polycopié.

%for m 1:1:5
%    SLM=DFFT(WRP, Lo, lambda, z0);
%end

%Faire un switch case  en fonction de z pour utiliser soit la DFFT soit la SFFT


%Création du LUT pour les calculs+ (threads ? GPU?)
%Retirer mathématiquement l'ordre 0
%Fenêtre de choix de l'ordre 1 dans le domaine fréquentiel

end

