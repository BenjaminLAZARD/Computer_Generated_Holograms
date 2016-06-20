function out=madct(v)
%fonction qui calcul la DCT de toutes les COLONNES de v
%v est suppos� r�el
%on mesure la taille de v
[n,m]=size(v);

%CAS particulier si v est une ligne on suppose que l'utilisateur veut une 
%une dct de la ligne
if (n==1)
    v=v';
    miseencolonne=1;
    n=m;
    m=1;
else
    miseencolonne=0;
end


%------ASTUCE  DEBUT1----
% if floor(m/2)*2 ==m
%     astuceactive=1;
%     v=v(:,1:m/2)+i*v(:,m/2+1:m);
%     m=m/2;
% else
%     astuceactive=0;
% end
%------ASTUCE FIN1

%On concatene v avec son symetrique
sym=flipud(v); %symetrise haut/bas
vv=[v;sym];

%On calcule la TFD
fvv=fft(vv);
%on ne garde que la moitie 
fvv=fvv(1:n,:);

%On construit le vecteur par lequel on multiplie la sortie de la TFD
w= exp(-i*pi*(1/(2*n))*(0:n-1))  %COMPLETER par l'onde adequate
w=w/sqrt(2*n);
w(1)=w(1)/sqrt(2);
%on s'assure que w ext colonne
w=w(:);

%On multiplie: la notation w(:,ones(1,m)) replique la colonne w m fois
fvv=fvv.*w(:,ones(1,m)); 

%----ASTUCE DEBUT 2
% if astuceactive==1
%     out=[real(fvv) imag(fvv)];
% else
%     out=real(fvv);
% end
%--- ASTUCE FIN 2
out =real(fvv); % a commenter si on utilise l'astuce

if (miseencolonne ==1)
    out=out';
end
