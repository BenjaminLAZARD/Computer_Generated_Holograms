function [ Uf ] = DFFT( Img, Lo, lambda, zo)
%S-FFT
%* *Img* est la matrice 2D qui correspond à l'image. Les coefs de la matrice
%correspondent à l'intensité lumineuse sur  1 octet.(pasde couleur !)
%* *Lo* est la taille désirée de Img en m (indépendamment du nb de pixels)

% Toutes les unités sont en m (U.S.I)
tic;
k=2*pi/lambda; % vecteur d'onde

% On fait un 0-padding de l'image liée à la matrice Img. Le but est juste d'en faire un carré. 
[M,N] = size(Img);
Img=[Img,zeros(M,1)];
[M,N] = size(Img);
Max=max(M,N);
Z1 = zeros(Max, (Max-N)/2);
Z2 = zeros((Max-M)/2,N);
Img_padd = [Z1,[Z2;Img;Z2],Z1]; %[;] fait une concaténation sur les lignes. [,] fait une concaténation sur les colonnes.

%zmin est la distance minimale entre le CCD et l'image reconstituée pour que lthéorème de Shannon soit vérifié. 
%Le calcul est optimisé par rapport à lambda et à l'échantillonage (nb de pixels maximal du CCD), (p.85 du livre en Anglais)
zmax= Lo^2/(Max*lambda);
fprintf('La valeur de z doit être inférieure à %f \n', zmax);

Uo = Img_padd;%Uo = Champ des amplitudes complexes liées à Img_padd, la précision de chaque coef passe de 1o à un double

%affichage de l'image avec padding
figure(1), imagesc(Img_padd), colormap(gray); 
axis equal;
axis tight;
ylabel('pixels');
xlabel(['Côté de l''image d''origine', num2str(Lo),'m']);
title('Champ des amplitudes de l''image originale');

%%%%%%%%%%%%%%%%%%%%%
%Calcul de la D-FFT
Uf=fft2(Uo,Max,Max);
Uf= fftshift(Uf);
fex=Max/Lo;
fey=fex;
fx=[-fex/2 : fex/Max : fex/2-fex/Max];
fy=[-fey/2 : fey/Max : fey/2-fey/Max];
[FX,FY]=meshgrid(fx,fy);
G=exp(1i*k*zo*sqrt(1-(lambda*FX).^2-(lambda*FY).^2));
result=Uf.*G;
Uf=ifft2(result,Max,Max);
%Fin de calcul de la D-FFFT
%%%%%%%%%%%%%%%%%%%%%%%


%affichage de l'image après propagation
Intensite=abs(Uf);
figure(3), imagesc(Intensite), colormap(gray); 
axis equal;
axis tight;
ylabel('pixels');
xlabel(['Côté de l''image d''origine', num2str(Lo),'m']);
title(['Champ des amplitudes de l''image dffraactée après calcul par D-FFT sur la distance',num2str(zo),' m']);
toc;
end

