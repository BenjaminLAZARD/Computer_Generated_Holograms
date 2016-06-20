%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Fonction permettant d'obtenir la figure d'interference d'un cube, elle
%doit etre appele par le programe architecte ou un equivalent.

function out=constructeur(R,d,v,w,x0,y0)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Signification des arguments de la fonction :
%%    R : distance virtuelle entre l'objet et le SLM. Plus R est grand plus l'objet apparait loin. Pour R<=0.3 on ne voit plus que la face arrière de l'objet.
%%    d : taille de l'image en pixel.
%%    v : densité lumineuse.
%%    w : profondeur de l'objet.
%%    x0 : abscise du centre de l'objet.
%%    y0 : origine du centre de l'objet.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic;   %toc en bas du code pour avoir le temps de calcul
N = floor(sqrt(d*v));
alpha = d/N;
alpha_z = w/N;
R=-R;  %pour observer le cube en bonne profondeur (laisser R renvoie une profondeur inversee)
pas_pixel = 8*10^-6;		%pas de la plaque SLM
pas_reseau = alpha*pas_pixel;    	%on prend des multiples du pas car on pense que a§a reduit les probla¨me d'echantillonnage, dans la pratique la difference est minime.
pas_reseau_z = alpha_z*pas_pixel;	%idem	
lambda = 633*10^-9;		%longeur d'onde du laser

k = 2*pi/lambda;		%vecteur d'onde

[X, Y] = meshgrid(pas_pixel*[-960:959], pas_pixel*[-540:539]);    %Representation mathematique de la matrice SLM

amplitude = zeros(1080, 1920);   %la matrice qui portera la figure de diffraction , initialisee a  0. On ajoute l'onde plane plus tard (en fin de programme) car cela diminue l'effet d'aliasing (empirique).
amplitude_tampon = zeros(1080,1920);  %sert a  diminuer les manipulations sur la matrice amplitude. On fait les additions pour chaque element du cube individuellement dans cette matrice puis on additionne a  amplitude apra¨s avoir appliquer le masque ad hoc.

%r2 = X.^2 + Y.^2 + R^2;
r = (X.^2 + Y.^2 + R^2).^0.5;
scalkr = (X.^2+Y.^2)./r*k;  
a = exp(-1i*scalkr);

p = floor(((N)*pas_reseau)/(pas_pixel));   %cote du cube en pixel sur le SLM (conversion entre la taille en points et l'etendue en pixel sur le SLM)
strp=num2str(p);
fprintf(strcat('taille en pixel du coté du cube : ',strp,'\n'));   %affiche p
xd=x0*pas_reseau/pas_pixel;
yd=y0*pas_reseau/pas_pixel;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% face avant %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Pour l'objet, le systeme d'axe direct est le systeme standard, x à
%l'horizontale, y a la verticale et, z en profondeur.

for m=-N/2:1:N/2   %on calcule point par point la figure d'interference
	for l=-N/2:1:N/2
        scalkrp1=(((x0+(l))*pas_reseau*X  + (y0+m)*pas_reseau*Y  + (N/2)*pas_reseau_z*R)./r*k);    %arete avant, verticale gauche
        scalkrp2=(((x0+(l))*pas_reseau*X + (y0+m)*pas_reseau*Y + (N/2)*pas_reseau_z*R)./r*k);        %arete avant verticale droite
        amplitude = amplitude +  a.*exp(-1i*scalkrp1) + a.*exp(-1i*scalkrp2);
    end;
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% autres aretes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% On utilise un masque pour traduire que certains points de l'objet ne sont
% pas visibles dans certaines zones de la matrice.
% Les axes utilisé pour ce masque sont quelque peu contre intuitif :
% l'origine y est en haut à droite, avec X à l'horizontale et Y à la
% verticale. Le point le plus en bas à gauche correspond donc à (1080,1920)


amplitude_tampon(1:1080,1:1920) = 0;   %on initialise la matrice tampon.
for m=-N/2:1:N/2
	scalkrp1=(((x0+(-N/2))*pas_reseau*X + (y0+(-N/2))*pas_reseau*Y  + m*pas_reseau_z*R)./r*k);    %arete dessous, profondeur, gauche.
	M = a.*exp(-1i*scalkrp1);
	amplitude_tampon = amplitude_tampon + M;    %la matrice tampon est remplie avec les figures d'interference des points de cette arete
end;
amplitude_tampon(1:540+p/2+xd,1:960+p/2+yd) = 0 ;  %on met a  0 des points dans la matrice tampon pour traduire mathematiquement le fait que les faces se cachent entre-elles, on appelle cela un masque
								 %ainsi ici on met a  zero le rectangle superieur droit
amplitude = amplitude + amplitude_tampon; %on somme la figure d'interference de cette arete avec la figure totale


amplitude_tampon(1:1080,1:1920) = 0;  %on initialise la matrice tampon
for m=-N/2:1:N/2
	scalkrp2=(((x0+(N/2))*pas_reseau*X + (y0+(-N/2))*pas_reseau*Y + m*pas_reseau_z*R)./r*k);    %arete dessous, profondeur, droite
	M = a.*exp(-1i*scalkrp2);
	amplitude_tampon = amplitude_tampon + M;
end;
amplitude_tampon(1:540+p/2+xd,960-p/2+yd:1920) = 0;  %on cree le masque pour cette arete : rectangle superieur gauche inactif.
amplitude = amplitude + amplitude_tampon;


amplitude_tampon(1:1080,1:1920) = 0;
for m=-N/2:1:N/2
	scalkrp1=(((x0+(-N/2))*pas_reseau*X + (y0+(N/2))*pas_reseau*Y  + m*pas_reseau_z*R)./r*k);   %arete en profondeur, haute gauche
	M = a.*exp(-1i*scalkrp1) ;
	amplitude_tampon = amplitude_tampon + M;
end;
amplitude_tampon(540-p/2+xd:1080,1:960+p/2+yd) = 0;   %le masque ici est le rectangle inferieur droit
amplitude = amplitude + amplitude_tampon;


amplitude_tampon(1:1080,1:1920) = 0;
for m=-N/2:1:N/2
	scalkrp2=(((x0+(N/2))*pas_reseau*X + (y0+(N/2))*pas_reseau*Y + m*pas_reseau_z*R)./r*k);   %arete en profondeur haut droite
	M = a.*exp(-1i*scalkrp2);
	amplitude_tampon = amplitude_tampon + M;
end;
amplitude_tampon(540-p/2+xd:1080,960-p/2+yd:1920) = 0;   %ici le masque est le rectangle inferieur gauche
amplitude = amplitude + amplitude_tampon;


amplitude_tampon(1:1080,1:1920) = 0; %idem
for m=-N/2:1:N/2
	scalkrp=(((x0+m)*pas_reseau*X + (y0+(N/2))*pas_reseau*Y  + (-N/2)*pas_reseau_z*R)./r*k);  % arete horizontale haute arriere
	M = a.*exp(-1i*scalkrp);
	amplitude_tampon = amplitude_tampon + M;
end;
amplitude_tampon(540-p/2+xd:1080,1:1920) = 0;  %ici le masque est la partie basse de la matrice.
amplitude = amplitude + amplitude_tampon;


amplitude_tampon(1:1080,1:1920) = 0;
for m=-N/2-1:1:N/2+1
	scalkrp=(((x0+m)*pas_reseau*X  + (y0+(-N/2))*pas_reseau*Y  + (-N/2)*pas_reseau_z*R)./r*k);   % arete horizontale basse arriere
	M = a.*exp(-1i*scalkrp);
	amplitude_tampon = amplitude_tampon + M;
end;
amplitude_tampon(1:540+p/2+xd,1:1920) = 0;    %ici le masque est la partie haute de la matrice
amplitude = amplitude + amplitude_tampon;


amplitude_tampon(1:1080,1:1920) = 0;
 for m=-N/2:1:N/2
	scalkrp=(((x0+(-N/2))*pas_reseau*X + (y0+m)*pas_reseau*Y  + (-N/2)*pas_reseau_z*R)./r*k);    %arete verticale gauche arriere
	M = a.*exp(-1i*scalkrp);
	amplitude_tampon = amplitude_tampon + M;
end;
amplitude_tampon(1:1080,1:960+p/2+yd) = 0;%	%masque = rectangle de la partie droite
amplitude = amplitude + amplitude_tampon;


amplitude_tampon(1:1080,1:1920) = 0;
for m=-N/2:1:N/2
	scalkrp=(((x0+(N/2))*pas_reseau*X + (y0+m)*pas_reseau*Y  + (-N/2)*pas_reseau_z*R)./r*k);    %arete verticale droite arriere
	M = a.*exp(-1i*scalkrp);
	amplitude_tampon = amplitude_tampon + M;
end;
amplitude_tampon(1:1080,960-p/2+yd:1920) = 0  ;   %masque = rectangle de gauche
amplitude = amplitude + amplitude_tampon;

out = amplitude;
