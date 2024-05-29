# IGSD

## Mentions importantes

Ce projet a été réalisé **en binôme** dans le cadre du module d'informatique graphique pour la science des données (**IGSD**) du deuxième semestre de **licence informatique** à l'**université Paris-Saclay** dont les responsables et concepteurs du sujet sont **Frédéric Vernier** et **Thi Thuong Huyen Nguyen**.

## Objectif du projet

Ce projet a pour objectif de mettre en jeu plusieurs notions d'informatique graphique dont les shaders, les caméras et le dessin de formes, afin de créer une scène 3D animée d'un terrain montueux (où se trouve une petite ville) où sont installés des pylônes et des éoliennes en fonctionnement. L'effet de verdure produit ainsi que les lignes de niveaux entourant les collines ont été réalisés à l'aide de shaders, tout le reste, avec le langage Processing 3.

## Concernant les fonctionnalités

Il est possible de se déplacer à l'aides des touches directionnelles du clavier et de regarder autour dans un champ limité, avec les mouvements du curseur de la souris. Il est possible d'afficher un repère au centre à l'aide de la touche ``R``, d'afficher/masquer le terrain avec la touche ``T``, les pylônes avec la touche ``P`` ou encore les éoliennes avec la touche ``E``.
Les éoliennes sont fonctionnelles et en rotation constante.

## Structure du code

Le code est composé de **3 fichiers**, ainsi que deux fichiers de shader (vertex et fragment). Le premier, ``Projet.pde``, contient un appel aux shaders, une gestion de la vue, le placement et le mouvement de la caméra et la perspective, une fonction utile déterminant l'altitude d'un point donné à des coordonnées (x, y) et un dessin de toutes les formes.
Le second, ``Pylone.pde``, contient intégralement le dessin des pylônes, une fonction de placement de ces pylônes en ligne et une fonction de dessin de lignes électriques les reliant à l'aide de courbes de Bézier.
Enfin, le troisième fichier, ``Eolienne.pde``, contient le dessin structuré, partie par partie (_GROUP_ de _shapes_), de l'éolienne, du mât aux pales, en passant par la nacelle et son moyeu. 

## Le fonctionnement des shaders

Les shaders permettent le dessin d'un effet de verdure dans le terrain à l'aide d'un calcul basé sur la coordonnée ``z`` puis une modification du vecteur de couleur. Ils permettent également le dessin de lignes de niveaux noires entourant les collines, créées à l'aide de la modification du vecteur couleur à condition qu'un modulo du ``z`` interpolé soit compris dans un certain intervalle.

## Difficultés rencontrées

Les difficultés de ce projet furent nombreuses, mais les principales sont :
- le dessin correct et le placement correct de pales en utilisant les courbes de Bézier
- le positionnement correct des formes en ligne
- le dessin complexe et ingénieux de lignes électriques à l'aide de courbes de Bézier, en ajoutant un effet de gravité (dont l'intensité est réglable avec la variable ``antiGravity``) basé sur la distance entre les pylônes connectés
- le dessin de pylones
