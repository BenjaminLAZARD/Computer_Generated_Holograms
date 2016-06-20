function [sortie] = lireimage(image)
    lecture = imread(strcat(strcat(pwd, '\'), image));

    [hauteur, largeur] = size(lecture); % Dimension des images
    
    sortie = zeros(hauteur, largeur);
    
    for ligne = 1:1:hauteur
        for colonne = 1:1:largeur
            if lecture(ligne, colonne) >= 128 % Fonction seuil
                sortie(ligne, colonne) = 1;
            end
        end
    end
end