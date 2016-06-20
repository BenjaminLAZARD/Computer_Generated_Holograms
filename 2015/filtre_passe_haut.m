function out=filtre_passe_haut(im,N,m)

%on calcul la taille de l'image

[dy,dx]=size(im);
out=zeros(dy,dx);

%creation du masque
[xx,yy]=meshgrid(1:N,1:N);
fq=xx.^2+yy.^2;
tmp=fq(:);
tmp=sort(tmp);
seuil=tmp(m);
mask=(fq>=seuil);



%parcours des blocs NxN et calcul de la dct2D 
for k=1:N:dy-N+1
    for l=1:N:dx-N+1
        out(k:k+N-1,l:l+N-1)=imadct2(madct2(im(k:k+N-1,l:l+N-1)).*mask);
    end
end


