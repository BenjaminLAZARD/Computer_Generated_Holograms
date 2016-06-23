function [ Uf ] = DFFT( Img, Lo, lambda, zo)
%S-FFT
%* *Img* est la matrice 2D qui correspond � l'image. Les coeffs de la matrice
%correspondent � l'intensit� lumineuse sur  1 octet.(pas de couleur !)
%* *Lo* est la taille d�sir�e de Img en m (ind�pendamment du nb de pixels)

% Toutes les unit�s sont en m (U.S.I)
tic;
k=2*pi/lambda; % vecteur d'onde

% On fait un 0-padding de l'image li�e � la matrice Img. Le but est juste d'en faire un carr�. 
%Pour cela on commence par s'assurer que que les nombres de pixels en largeur
%et hauteur sont pairs.
[M,N] = size(Img);
if mod(M,2)==1
    Img=[Img,zeros(M,1)];
end
if mod(N,2)==1
    Img=[Img;zeros(N,1)];
end
%Ensuite on fait le padding proprement dit.
[M,N] = size(Img);
Max=max(M,N);
Z1 = zeros(Max, (Max-N)/2);
Z2 = zeros((Max-M)/2,N);
Img_padd = [Z1,[Z2;Img;Z2],Z1]; %[;] fait une concat�nation sur les lignes. [,] fait une concat�nation sur les colonnes.

%zmax est la distance minimale entre le CCD et l'image reconstitu�e pour que le th�or�me de Shannon soit v�rifi�. 
%Le calcul est optimis� par rapport � lambda et � l'�chantillonage (nb de pixels maximal du CCD), (p.89 du livre en Anglais)
zmax= Lo^2/(Max*lambda);
fprintf('La valeur de z doit �tre inf�rieure � %f \n', zmax);

Uo = Img_padd;%Uo = Champ des amplitudes complexes li�es � Img_padd, la pr�cision de chaque coef passe de 1o � un double

%Affichage de l'image avec padding
figure(3), imagesc(real(Img_padd)), colormap(gray); 
axis equal;
axis tight;
ylabel('pixels');
xlabel(['C�t� de l''image d''origine = ', num2str(Lo),'m']);
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


%Affichage de l'image apr�s propagation
Intensite=abs(Uf);
figure(4), imagesc(Intensite), colormap(gray); 
axis equal;
axis tight;
ylabel('pixels');
xlabel(['C�t� de l''image d''origine = ', num2str(Lo),'m']);
title(['Champ des amplitudes de l''image diffract�e apr�s calcul par D-FFT sur la distance ',num2str(zo),'m']);
toc;

imwrite(Intensite, 'outDFFT.png');

end

