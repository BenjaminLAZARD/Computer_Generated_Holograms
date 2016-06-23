function WRP = ob2wrp(M, N, Lw, Lo, d, lambda)
%* *M* est une matrice de taille    Nbpoints x 3    représentant un objet 3D. (coordonnées en x y et z de chaque point) l'unité est le m.
%* *N* la largeur totale en pixel du WRP.
%* *Lw* la largeur utile en m du WRP.
%* *Lo* la largeur totale en m du WRP
%* *d* la distance entre le 1er plan de l'objet (+ éventuel padding dans la fonction shape3D)  WRP. (cf. schéma du rapport)

WRP = zeros(N, N); %WRP carre
sampling = Lo/N;
Nw= N - (Lo-Lw)/sampling;%Taille utile en pixels (N inclut les pixels du 0-padding)
a0 = 10; %amplitude de l'onde emise par chaque point, supposee constante

range=Nw/2;
ipx=(-1*range):sampling:range;
ipy=(-1*range):sampling:range;

for xWRP = 1:Nw
    fprintf('Calcul pour xWRP = %d sur %d valeurs \n', xWRP, Nw);
    for yWRP = 1:Nw
        for pointnumber=1:size(M,1)
            xj = M(pointnumber, 1);
            yj = M(pointnumber, 2);
            zj = M(pointnumber, 3);
            Rwj = sqrt((ipx(xWRP)-xj)^2+(ipy(yWRP)-yj)^2+(zj+d)^2); %distance objet-point du WRP
            WRP(xWRP, yWRP) = WRP(xWRP, yWRP) + (a0/Rwj)*exp(1i*2*pi*Rwj/lambda); %amplitude complexe sur le WRP
        end
    end
end
   
figure(2), imshow(real(WRP));
imwrite(real(WRP), 'outWRP.png');

end

