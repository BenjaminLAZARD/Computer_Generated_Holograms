function [ image ] = architecte(a0)
%Ce programme permet de generer des figures d'interferences contenant
%plusieurs cubes. Il utilise pour cela le programme constructeur, similaire
%au programme de la V14 mais renvoyant uniquement la figure d'interférence
%du cube.

%modification manuelle de la construction que l'on souhaite faire
amplitude = constructeur(0.5,400,0.6,16000,-10,0) + constructeur(0.5,400,0.6,16000,10,0);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ajout de l'onde plane %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%a¹
for m=-960:1:959
	%amplitude(1:1080,m+961)=amplitude(1:1080,m+961) + a0*exp(i*2*pi*m*pas_pixel*sin(j)/lambda);  %angle d'attaque de j.
	amplitude(1:1080,m+961)=amplitude(1:1080,m+961) + a0;  %angle d'attaque normal.
end;

phase = angle(amplitude)+pi;
%for m=-960:1:959
%	phase(1:1080,m+961)=mod(phase(1:1080,m+961) + (2*pi*m*pas_pixel*j/lambda),2*pi);  %dephasage de la totalité de la figure;
%end;

image = ceil(255/(2*pi)*phase);
image = uint8(image);
stra0 = num2str(a0);

str = strcat('architecte,a0=',stra0,'.bmp');   %nom de l'image creee actualise en fonction des constantes


imwrite(image, str, 'JPG');
%imshow(image, [0,255]);


end



