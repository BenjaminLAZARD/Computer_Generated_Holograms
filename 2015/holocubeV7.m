%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cette fonction génère des hologrammes numériques d'un cube
%%Pour le faire fonctionner, il faut se mettre sous Matlab dans le 'current
%%folder' qui contient le fichier holocube

%Dernière version du code pour générer un cube avec les masques.
%Il faut améliorer le masque pour que les sommets de la face de derrière soient bien cachés.
%Dans cette version les masques sont calculés à la main et adaptés à des configurations proches de celle ci : holocubeV7(0.8,32,46,400).

function [ image ] = holocubeV7(R,N,alpha,alpha_z)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Signification des arguments de la fonction :
%%    R : distance virtuelle entre l'objet et le SLM. Plus R est grand plus l'objet apparait petit.
%%    N : nombre de point sur les arêtes du cube, changer N modifie significativement le temps de calcul
%%    alpha : coefficient multiplicateur entre le pas du pixel sur le SLM et le pas entre chaque point du cube. Il faut bien faire attention à ne pas avoir un alpha trop grand 
%%            et un N trop grand en même temps sans changer la valeur de R, sinon le cube sort de la zone d'observation à cause de sa taille.
%%    alpha_z : idem pour le pas entre chaque point en profondeur (sur les arêtes qui joignent la face avant et la face arrière). Il faut avoir un pas_réseau_z plus grand (x10 par exemple) que pas_réseau sinon on perçoit mal la profondeur.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic;   %toc en bas du code pour avoir le temps de calcul
R=-R;  %pour observer le cube en bonne profondeur (laisser R renvoie une profondeur inversée)
pas_pixel = 8*10^-6;		%pas de la plaque SLM
pas_reseau = alpha*pas_pixel;    	%on prend des multiples du pas car on pense que ça réduit les problème d'échantillonnage, dans la pratique la différence est minime.
pas_reseau_z = alpha_z*pas_pixel;	%idem	
lambda = 633*10^-9;		%longeur d'onde du laser

k = 2*pi/lambda;		%vecteur d'onde

[X, Y] = meshgrid(pas_pixel*[-960:959], pas_pixel*[-540:539]);    %Représentation mathématique de la matrice SLM

amplitude = zeros(1080, 1920);   %la matrice qui portera la figure de diffraction , initialisée à 0. On ajoute l'onde plane plus tard (en fin de programme) car cela diminue l'effet d'aliasing (empirique).
amplitude_tampon = zeros(1080,1920);  %sert à diminuer les manipulations sur la matrice amplitude. On fait les additions pour chaque élément du cube individuellement dans cette matrice puis on additionne à amplitude après avoir appliquer le masque ad hoc.

r2 = X.^2 + Y.^2 + R^2;
r = r2.^0.5;
scalkr = (X.^2+Y.^2)./r*k;  
a = exp(-i*scalkr);

p = floor((N*pas_reseau)/(2*pas_pixel));   %demi-cote du cube en pixel sur le SLM (conversion entre la taille en points et l'étendue en pixel sur le SLM)
strp=num2str(p);
fprintf(strcat(strp,'\n'));   %affiche p

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  face avant  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for m=-N/2-2:1:N/2+1   %on calcule point par point la figure d'interférence
	scalkrp1=((m*pas_reseau*X + (-N/2-2)*pas_reseau*Y  + (100)*pas_reseau_z*R)./r*k);     %arête avant, verticale, gauche.
	scalkrp2=((m*pas_reseau*X + (N/2+1)*pas_reseau*Y + (100)*pas_reseau_z*R)./r*k); 		%arête avant, verticale, droite.
	amplitude = amplitude +  a.*exp(-i*scalkrp1) + a.*exp(-i*scalkrp2);            %on ajoute à la matrice amplitude les figures d'interférence de tous les points de ces deux arêtes
end;
for m=-N/2-1:1:N/2
	scalkrp1=(((-N/2-2)*pas_reseau*X  + m*pas_reseau*Y  + (100)*pas_reseau_z*R)./r*k);    %arête avant, horizontale basse
	scalkrp2=(((N/2+1)*pas_reseau*X + m*pas_reseau*Y + (100)*pas_reseau_z*R)./r*k);        %arête avant horizontale haute
	amplitude = amplitude +  a.*exp(-i*scalkrp1) + a.*exp(-i*scalkrp2);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  face du dessus  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
amplitude_tampon(1:1080,1:1920) = 0;   %on initialise la matrice tampon.
for m=-N/2+1:1:N/2-1
	scalkrp1=(((N/2-1)*pas_reseau*X + (N/2-1)*pas_reseau*Y  + m*pas_reseau_z*R)./r*k);    %arête dessus, profondeur, droite.
	M = a.*exp(i*scalkrp1);
	amplitude_tampon = amplitude_tampon + M;    %la matrice tampon est remplie avec les figures d'interférence des points de cette arête
end;
amplitude_tampon(270:1080,1:1440) = 0 ;  %on met à 0 des points dans la matrice tampon pour traduire mathématiquement le fait que les faces se cachent entre-elles, on appelle cela un masque
										 %ainsi ici on met à zéro le rectangle inférieur gauche
amplitude = amplitude + amplitude_tampon; %on somme la figure d'interférence de cette arête avec la figure totale

amplitude_tampon(1:1080,1:1920) = 0;  %on initialise la matrice tampon
for m=-N/2+1:1:N/2-1
	scalkrp2=(((-N/2)*pas_reseau*X + (N/2-1)*pas_reseau*Y + m*pas_reseau_z*R)./r*k);    %arête dessus, profondeur, gauche
	M = a.*exp(i*scalkrp2);
	amplitude_tampon = amplitude_tampon + M;
end;
amplitude_tampon(270:1080,480:1920) = 0;  %on crée le masque pour cette arête : rectangle inférieur droit inactif.
amplitude = amplitude + amplitude_tampon;

amplitude_tampon(1:1080,1:1920) = 0; %idem
for m=-N/2:1:N/2-1
	scalkrp=((m*pas_reseau*X + (N/2-1)*pas_reseau*Y  + (-100)*pas_reseau_z*R)./r*k);  % arête horizontale haute arrière
	M = a.*exp(-i*scalkrp);
	amplitude_tampon = amplitude_tampon + M;
end;
amplitude_tampon(270:1080,1:1920) = 0;  %ici le masque est le 3/4 droit de la matrice.
amplitude = amplitude + amplitude_tampon;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  face du dessous  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
amplitude_tampon(1:1080,1:1920) = 0;
for m=-N/2+1:1:N/2-1
	scalkrp1=(((N/2-1)*pas_reseau*X + (-N/2)*pas_reseau*Y  + m*pas_reseau_z*R)./r*k);   %arête en profondeur, à droite
	M = a.*exp(i*scalkrp1) ;
	amplitude_tampon = amplitude_tampon + M;
end;
amplitude_tampon(1:810,1:1440) = 0;   %le masque ici est le rectangle supérieur gauche
amplitude = amplitude + amplitude_tampon;

amplitude_tampon(1:1080,1:1920) = 0;
for m=-N/2+1:1:N/2-1
	scalkrp2=(((-N/2)*pas_reseau*X + (-N/2)*pas_reseau*Y + m*pas_reseau_z*R)./r*k);   %arête en profondeur à gauche
	M = a.*exp(i*scalkrp2);
	amplitude_tampon = amplitude_tampon + M;
end;
amplitude_tampon(1:810,480:1920) = 0;   %ici le masque est le rectangle supérieur droit
amplitude = amplitude + amplitude_tampon;

amplitude_tampon(1:1080,1:1920) = 0;
for m=-N/2:1:N/2-1
	scalkrp=((m*pas_reseau*X  + (-N/2)*pas_reseau*Y  + (-100)*pas_reseau_z*R)./r*k);   % arrête horizontale basse arrière
	M = a.*exp(-i*scalkrp);
	amplitude_tampon = amplitude_tampon + M;
end;
amplitude_tampon(1:810,1:1920) = 0;    %ici le masque est le 3/4 haut de la matrice
amplitude = amplitude + amplitude_tampon;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  face cote (pas les aretes de devant) inutile de recalculer ces arêtes qui ont été calculées lors des faces précédentes  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% amplitude_tampon(1:1080,1:1920) = 0;
 % for m=-N/2+1:1:N/2-1
	% scalkrp1=(((N/2-1)*pas_reseau*X + (N/2-1)*pas_reseau*Y  + m*pas_reseau_z*R)./r*k);   %arête en profondeur haute à droite
	% M = a.*exp(i*scalkrp1) ;
	% amplitude_tampon = amplitude_tampon + M;
% end;
% amplitude_tampon(270:1080,1:1440) = 0;    %masque = rectangle inférieur gauche
% amplitude = amplitude + amplitude_tampon;

% amplitude_tampon(1:1080,1:1920) = 0;
% for m=-N/2+1:1:N/2-1
	% scalkrp1=(((-N/2)*pas_reseau*X + (N/2-1)*pas_reseau*Y  + m*pas_reseau_z*R)./r*k);    %arête en profondeur haute à gauche
	% M = a.*exp(i*scalkrp1) ;
	% amplitude_tampon = amplitude_tampon + M;
% end;
% amplitude_tampon(270:1080,480:1920) = 0;   %masque = rectangle inférieur droit
% amplitude = amplitude + amplitude_tampon;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  aretes verticales arrière  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
amplitude_tampon(1:1080,1:1920) = 0;
 for m=-N/2+1:1:N/2-2
	scalkrp=(((-N/2)*pas_reseau*X + m*pas_reseau*Y  + (-100)*pas_reseau_z*R)./r*k);    %arête de gauche %on force -100 pour profondeur afin d'avoir une bonne impression de 3D
	M = a.*exp(-i*scalkrp);
	amplitude_tampon = amplitude_tampon + M;
end;
amplitude_tampon(1:1080,1:1440) = 0;%	%masque = rectangle 3/4 droit
amplitude = amplitude + amplitude_tampon;

amplitude_tampon(1:1080,1:1920) = 0;
for m=-N/2+1:1:N/2-2
	scalkrp=(((N/2-1)*pas_reseau*X + m*pas_reseau*Y  + (-100)*pas_reseau_z*R)./r*k);    %arête de droite   %idem pour le -100
	M = a.*exp(-i*scalkrp);
	amplitude_tampon = amplitude_tampon + M;
end;
amplitude_tampon(1:1080,480:1920) = 0  ;   %masque = rectangle 3/4 gauche
amplitude = amplitude + amplitude_tampon;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ajout de l'onde plane %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ù
for m=-960:1:959
	%amplitude(1:1080,m+961)=amplitude(1:1080,m+961) + exp(i*2*pi*m*pas_pixel*sin(pi/9)/lambda);  %angle d'attaque de pi/9 à peu près. Cela pourrait être bien de déterminer l'angle exact.
	amplitude(1:1080,m+961)=amplitude(1:1080,m+961) + 1;  %angle d'attaque de pi/9 à peu près. Cela pourrait être bien de déterminer l'angle exact.
end;

phase = angle(amplitude)+pi;

image = ceil(255/(2*pi)*phase);
%image = ceil(255/(2*pi)*phase.*abs(amplitude));    %pour générer l'image de Said
image = uint8(image);
toc;
strR = num2str(R);
strN = int2str(N);
strAlpha = num2str(alpha);
strAlphaZ = num2str(alpha_z);
str = strcat('V7,R=',strR,',N=',strN,',Alpha=',strAlpha,',Alpha_Z=',strAlphaZ,'MasqueTotalFinalSaid.bmp');   %nom de l'image créée actualisé en fonction des constantes

imwrite(image, str, 'JPG');
%imshow(image, [0,255]);


end

% Notes pour l'utilisation de matlab : 
%1) lors du calcul des masques et lors de l'initialisation de la matrice tampon on utilise la syntaxe suivante : amplitude_tampon(1:1080,1:1920) = 0. On pourrait écrire : amplitude_tampon = zeros(1080,1920) ; le programme compile mais le résultat est différent : dans le premier cas on a bien ce qu'on veut, dans le deuxième il ne se passe rien.
%2) matlab est adapté au calcul matriciel donc il faut utiliser la syntaxe n:m pour parler de vecteur (colonne, ligne,...) pour gagner du temps de calcul.
