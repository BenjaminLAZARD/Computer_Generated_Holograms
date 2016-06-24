function WRP = ob2wrp(M, N, Lw, Lo, d, lambda)
%* *M* est une matrice de taille    Nbpoints x 3    représentant un objet 3D. (coordonnées en x y et z de chaque point) l'unité est le m.
%* *N* la largeur totale en pixel du WRP.
%* *Lw* la largeur utile en m du WRP.
%* *Lo* la largeur totale en m du WRP
%* *d* la distance entre le 1er plan de l'objet (+ éventuel padding dans la fonction shape3D)  WRP. (cf. schéma du rapport)
tic;

sampling = Lo/N;
Nw= floor((N - (Lo-Lw)/sampling)/2)*2; %Taille utile en pixels (N inclut les pixels du 0-padding)
fprintf('A \n', Nw);
a0 = 10; %amplitude de l'onde emise par chaque point, supposee constante
WRP = zeros(Nw, Nw); %WRP carre

range=Lw/2;
ipx=(-1*range):sampling:range;
ipy=(-1*range):sampling:range;

for xWRP = 1:Nw
    fprintf('Calcul pour xWRP = %d sur %d valeurs \n', xWRP, Nw);
    for yWRP = 1:Nw
        for j=1:size(M,1)
            xj = M(j, 1);
            yj = M(j, 2);
            zj = M(j, 3);
            Rwj = sqrt((ipx(xWRP)-xj)^2+(ipy(yWRP)-yj)^2+(zj+d)^2); %distance objet-point du WRP
            WRP(xWRP, yWRP) = WRP(xWRP, yWRP) + (a0/Rwj)*exp(1i*2*pi*Rwj/lambda); %amplitude complexe sur le WRP
        end
    end
end

%matriceLCD=[zeros(290,1080);zeros(Nw,290),WRP,zeros(Nw,);zeros(290,1080)];
WRP = [zeros((N-Nw)/2,Nw);WRP;zeros((N-Nw)/2,Nw)]; %ajout d'un padding pour atteindre 1080 x 1080
WRP = [zeros(N,(N-Nw)/2),WRP,zeros(N,(N-Nw)/2)];

figure(2), imagesc(real(WRP)); colormap(gray); 
toc;
imwrite(real(WRP), 'outWRP.png');

end

