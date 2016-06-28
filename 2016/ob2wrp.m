function WRP = ob2wrp(M, N, Lw, Lo, d, k)
%* *M* est une matrice de taille    Nbpoints x 3    représentant un objet 3D. (coordonnées en x y et z de chaque point) l'unité est le m.
%* *N* la largeur totale en pixel du WRP.
%* *Lw* la largeur utile en m du WRP.
%* *Lo* la largeur totale en m du WRP
%* *d* la distance entre le 1er plan de l'objet (+ éventuel padding dans la fonction shape3D)  WRP. (cf. schéma du rapport)

sampling = Lo/N;
Nw= floor((N - (Lo-Lw)/sampling)/2)*2; %Taille utile en pixels (N inclut les pixels du 0-padding)
%fprintf('Taille utile du WRP Nw=%d px \n', Nw);
a0 = 10; %amplitude de l'onde emise par chaque point, supposee constante
WRP = zeros(Nw, Nw); %WRP carre

range=Lw/2;
ipx=(-1*range):sampling:range;
ipy=(-1*range):sampling:range;

theta=1;
tng = tand(theta);%tangeante avec l'argument en degré (inclinaison de l'onde de référence par rapport aux axes y et z (cf. schéma));

avancement=0;
fprintf('\n Avancement (pourcent) = \n 0 ');
for xWRP = 1:Nw
    if floor(xWRP/Nw*10^2) > avancement
        avancement = avancement+1;
        fprintf('%d ', avancement);
        if mod(avancement,20)==0 && avancement~=0
            fprintf('\n');
        end
    end
    for yWRP = 1:Nw
        for j=1:size(M,1)
            xj = M(j, 1);
            yj = M(j, 2);
            zj = M(j, 3);
            Rwj = sqrt((ipx(xWRP)-xj)^2+(ipy(yWRP)-yj)^2+(zj+d)^2); %distance objet-point du WRP
            WRP(xWRP, yWRP) = WRP(xWRP, yWRP) + (a0/Rwj)*exp(1i*k*Rwj);
            a=WRP(xWRP, yWRP) + (a0/Rwj)*exp(1i*k*Rwj);%varibale tamporaire pour clarifeir la ligne suivante.
            WRP(xWRP, yWRP) = sqrt  (abs(a+exp( 1i*k*tng*ipx(xWRP) + 1i*k*ipy(yWRP)))^2   - 1 - abs(a)^2); %amplitude complexe sur le WRP
        end
    end
end

%WRP = sqrt(abs(WRP+1).^2 -1-abs(WRP).^2);% On enlève l'ordre 0 (dans le cas où l'onde de référence est 1 i.e onde de référence de direction z)

%matriceLCD=[zeros(290,1080);zeros(Nw,290),WRP,zeros(Nw,);zeros(290,1080)];
WRP = [zeros((N-Nw)/2,Nw);WRP;zeros((N-Nw)/2,Nw)]; %ajout d'un padding pour atteindre 1080 x 1080
WRP = [zeros(N,(N-Nw)/2),WRP,zeros(N,(N-Nw)/2)];

figure(2), imagesc(real(WRP)); colormap(gray);

end

