function out=madct2(im);
%calcule la dct2D d'une image (supposee reelle)

out=madct(im);
out=madct(out');
out=out';
