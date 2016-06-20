function out=imadct(v)
%calcule la dct inverse

[n,m]=size(v);

%CAS particulier si v est une ligne on suppose que l'utilisateur veut une 
%une dct ligne
if (n==1)
    v=v';
    miseencolonne=1;
    n=m;
    m=1;
else
    miseencolonne=0;
end


%On construit le vecteur par lequel on multiplie la sortie de la TFD
w=exp(-i*pi*(0:n-1)/(2*n)); 
w=w/sqrt(2*n);
w(1)=w(1)/sqrt(2);
%on s'assure que w est colonne
w=w(:);
%on revient a la TFD d'origine
v=v./(w(:,ones(1,m)));
vv=[v;zeros(1,m);conj(v(end:-1:2,:))]; %on ne peut plus utiliser ASTUCE car la conjugaison n'est pas lineaire
fvv=ifft(vv);

fvv=fvv(1:n,:);
out =real(fvv); % a commenter si on utilise l'astuce

if (miseencolonne ==1)
    out=out';
end
