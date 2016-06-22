function WRP = objecttoWRP(M)

lambda = 633*10^-9;

tailleWRP = 500 ; %valeurs a tester ; WRP de 500x500 pixels pour le moment
WRP = zeros(tailleWRP, tailleWRP); %WRP carre

a0 = 10; %amplitude de l'onde emise par chaque point, supposee constante

sampling = 0.0254/tailleWRP;

dimensions = 1;
range=dimensions*0.0254/2;
ipx=(-1*range):sampling:range;
ipy=(-1*range):sampling:range;

for xWRP = 1:tailleWRP
    fprintf('Calcul pour xWRP = %d sur %d valeurs \n', xWRP, tailleWRP);
    for yWRP = 1:tailleWRP
        for pointnumber=1:size(M,1)
            xj = M(pointnumber, 1);
            yj = M(pointnumber, 2);
            zj = M(pointnumber, 3);
            Rwj = sqrt((ipx(xWRP)-xj)^2+(ipy(yWRP)-yj)^2+(zj)^2); %distance objet-point du WRP
            WRP(xWRP, yWRP) = WRP(xWRP, yWRP) + (a0/Rwj)*exp(1i*2*pi*Rwj/lambda); %amplitude complexe sur le WRP
        end
    end
end
   
imshow(real(WRP));
imwrite(real(WRP), 'outWRP.png');

end

