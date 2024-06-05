# IGSD

## Mentions importantes / Important Mentions

### Français
Ce projet a été réalisé **en binôme** dans le cadre du module d'informatique graphique pour la science des données (**IGSD**) du deuxième semestre de **licence informatique** à l'**université Paris-Saclay** dont les responsables et concepteurs du sujet sont **Frédéric Vernier** et **Thi Thuong Huyen Nguyen**.

### English
This project was carried out **as a team** as part of the graphics computing module for data science (**IGSD**) in the second semester of the **computer science bachelor's degree** at **Université Paris-Saclay**, with the project supervisors and designers being **Frédéric Vernier** and **Thi Thuong Huyen Nguyen**.

## Objectif du projet / Project Objective

### Français
Ce projet a pour objectif de mettre en jeu plusieurs notions d'informatique graphique dont les shaders, les caméras et le dessin de formes, afin de créer une scène 3D animée d'un terrain montueux (où se trouve une petite ville) où sont installés des pylônes et des éoliennes en fonctionnement. L'effet de verdure produit ainsi que les lignes de niveaux entourant les collines ont été réalisés à l'aide de shaders, tout le reste, avec le langage Processing 3.

### English
The objective of this project is to implement several concepts of graphics computing, including shaders, cameras, and shape drawing, to create an animated 3D scene of a hilly terrain (with a small town) where pylons and working wind turbines are installed. The greenery effect produced and the contour lines surrounding the hills were created using shaders, while everything else was done with the Processing 3 language.

## Concernant les fonctionnalités / Regarding Features

### Français
Il est possible de se déplacer à l'aide des touches directionnelles du clavier et de regarder autour dans un champ limité, avec les mouvements du curseur de la souris. Il est possible d'afficher un repère au centre à l'aide de la touche ``R``, d'afficher/masquer le terrain avec la touche ``T``, les pylônes avec la touche ``P`` ou encore les éoliennes avec la touche ``E``. Les éoliennes sont fonctionnelles et en rotation constante.

### English
It is possible to move using the directional keys on the keyboard and look around within a limited field using the mouse cursor movements. You can display a marker at the center using the ``R`` key, show/hide the terrain with the ``T`` key, the pylons with the ``P`` key, and the wind turbines with the ``E`` key. The wind turbines are functional and in constant rotation.

## Structure du code / Code Structure

### Français
Le code est composé de **3 fichiers**, ainsi que deux fichiers de shader (vertex et fragment). Le premier, ``Projet.pde``, contient un appel aux shaders, une gestion de la vue, le placement et le mouvement de la caméra et la perspective, une fonction utile déterminant l'altitude d'un point donné à des coordonnées (x, y) et un dessin de toutes les formes. Le second, ``Pylone.pde``, contient intégralement le dessin des pylônes, une fonction de placement de ces pylônes en ligne et une fonction de dessin de lignes électriques les reliant à l'aide de courbes de Bézier. Enfin, le troisième fichier, ``Eolienne.pde``, contient le dessin structuré, partie par partie (_GROUP_ de _shapes_), de l'éolienne, du mât aux pales, en passant par la nacelle et son moyeu.

### English
The code consists of **3 files**, as well as two shader files (vertex and fragment). The first, ``Projet.pde``, contains shader calls, view management, camera placement and movement, perspective handling, a useful function determining the altitude of a given point at coordinates (x, y), and the drawing of all shapes. The second, ``Pylone.pde``, entirely contains the drawing of pylons, a function to place these pylons in a line, and a function to draw electrical lines connecting them using Bézier curves. Finally, the third file, ``Eolienne.pde``, contains the structured drawing, part by part (_GROUP_ of _shapes_), of the wind turbine, from the mast to the blades, including the nacelle and its hub.

## Le fonctionnement des shaders / Shader Functionality

### Français
Les shaders permettent le dessin d'un effet de verdure dans le terrain à l'aide d'un calcul basé sur la coordonnée ``z`` puis une modification du vecteur de couleur. Ils permettent également le dessin de lignes de niveaux noires entourant les collines, créées à l'aide de la modification du vecteur couleur à condition qu'un modulo du ``z`` interpolé soit compris dans un certain intervalle.

### English
Shaders allow for the drawing of a greenery effect on the terrain using a calculation based on the ``z`` coordinate and then a modification of the color vector. They also enable the drawing of black contour lines surrounding the hills, created by modifying the color vector provided that a modulo of the interpolated ``z`` falls within a certain range.

## Difficultés rencontrées / Difficulties Encountered

### Français
Les difficultés de ce projet furent nombreuses, mais les principales sont :
- le dessin correct et le placement correct de pales en utilisant les courbes de Bézier
- le positionnement correct des formes en ligne
- le dessin complexe et ingénieux de lignes électriques à l'aide de courbes de Bézier, en ajoutant un effet de gravité (dont l'intensité est réglable avec la variable ``antiGravity``) basé sur la distance entre les pylônes connectés
- le dessin de pylônes

### English
The difficulties in this project were numerous, but the main ones are:
- Correctly drawing and placing blades using Bézier curves
- Correct positioning of shapes in a line
- The complex and ingenious drawing of electrical lines using Bézier curves, adding a gravity effect (with adjustable intensity via the ``antiGravity`` variable) based on the distance between connected pylons
- Drawing the pylons
