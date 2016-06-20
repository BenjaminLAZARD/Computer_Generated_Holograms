function [ image ] = holotroisd(objet, nom)

tic;
R = 0.5;
lambda = 800*10^-9;
pas_pixel = 8*10^-6;
pas_reseau = 5*10^-4;
k = 2*pi/lambda;
[largeur_objet, hauteur_objet, profondeur_objet] = size(objet);

[X, Y] = meshgrid(pas_pixel*[-960:959], pas_pixel*[-540:539]);
amplitude = ones(1080, 1920);

nK = X.^2 + Y.^2 + R^2;
nK = nK.^0.5;

scalkr = (X.^2+Y.^2)./nK*k;
a = exp(-1i*scalkr);

for x=-largeur_objet/2:1:largeur_objet/2-1
    x_matrice_redim = x*pas_reseau;
	for y=-hauteur_objet/2:1:hauteur_objet/2-1
        y_matrice_redim = y*pas_reseau;
		for z=-profondeur_objet/2:1:profondeur_objet/2-1
            z_matrice_redim = z*pas_reseau;
            if ( objet(x+largeur_objet/2+1, y+hauteur_objet/2+1, z+profondeur_objet/2+1)==1)
                scalkrp=((x_matrice_redim*X + y_matrice_redim*Y + z_matrice_redim*R)./nK*k);
                amplitude = amplitude + objet(x+largeur_objet/2+1, y+hauteur_objet/2+1, z+profondeur_objet/2+1).*a.*exp(-1i*scalkrp);
            end;
        end;
    end;
end;

phase = angle(amplitude)+pi;

image = ceil(255/(2*pi)*phase);
image = uint8(image);
imwrite(image, nom, 'JPG');
imshow(image, [0,255]);

toc;

end