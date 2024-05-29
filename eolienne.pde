// --------- VARIABLES GLOBALES POUR LES PYLÔNES ---------

float XEol = 80; // position de la première éolienne
float YEol = 83; 
float XEolFin = 44; // position en abscisse de la dernière éolienne

// --------- CLASSE ÉOLIENNES ---------

class Eolienne {

  float angle = 0;
  
  PShape eolienne;
  PShape nacelle;
  PShape pale1, pale2, pale3;
  PShape mat;
  
  public PShape getShape() {
    return eolienne;
  }

  // Longueurs des segments des pales : r1Pale, r2Pale, r3Pale
  public Eolienne(PVector position, float hauteurMat, float largeurNacelle, PVector rayonsMat,
                  PVector rayonsNacelle, PVector dimensionsPales, float radialOffset) {
    eolienne = createShape(GROUP);

    int detailNacelle = 30;
    createMat(hauteurMat, rayonsMat.x, rayonsMat.y);
    mat.translate(position.x, position.y, position.z);
    
    createNacelle(rayonsNacelle.x, rayonsNacelle.y, largeurNacelle, detailNacelle);
    nacelle.translate(position.x, position.y - hauteurMat / 2, position.z);
    
    float angleOffset = TWO_PI / 3; // 120 degrés entre chaque pale

    // Création des pales
    pale1 = createPale(dimensionsPales.x, dimensionsPales.y, dimensionsPales.z);
    pale2 = createPale(dimensionsPales.x, dimensionsPales.y, dimensionsPales.z);
    pale3 = createPale(dimensionsPales.x, dimensionsPales.y, dimensionsPales.z);

    // Placement des pales autour de la nacelle
    applyPaleTransform(pale1, 0 * angleOffset, position, hauteurMat, largeurNacelle, rayonsNacelle.y);
    applyPaleTransform(pale2, 1 * angleOffset, position, hauteurMat, largeurNacelle, rayonsNacelle.y);
    applyPaleTransform(pale3, 2 * angleOffset, position, hauteurMat, largeurNacelle, rayonsNacelle.y);

    // Ajout des composants à l'objet eolienne
    eolienne.addChild(mat);
    eolienne.addChild(pale1);
    eolienne.addChild(pale2);
    eolienne.addChild(pale3);
    eolienne.addChild(nacelle);

    // Appliquer les styles après avoir ajouté tous les composants
    applyStyles(eolienne);
    applyStyles(mat);
    applyStyles(pale1);
    applyStyles(pale2);
    applyStyles(pale3);
    applyStyles(nacelle);  // Assurez-vous que la nacelle reçoit aussi les styles
  }

  // style général pour toutes les formes
  void applyStyles(PShape shape) {
    shape.setStroke(0);
    shape.setStrokeWeight(1);
  }

  // fonction appliquant les transformations nécessaires aux pales après leur dessin
  void applyPaleTransform(PShape pale, float angle, PVector position, float hauteurMat, float largeurNacelle, float rayonNacelle) {
    pale.resetMatrix();
    pale.rotateZ(angle); 
    pale.translate(position.x, position.y - hauteurMat / 2, position.z - largeurNacelle / 2 - rayonNacelle / 2);
  }

  // fonction à appeler chaque seconde pour faire tourner les pales de l'éolienne
  void rotatePales(PVector position, float hauteurMat, float largeurNacelle, float rayonNacelle) {
    angle += 0.05; 
  
    pale1.resetMatrix();
    pale1.rotateZ(angle);
    applyPaleTransform(pale1, angle + 0, position, hauteurMat, largeurNacelle, rayonNacelle);
    
    pale2.resetMatrix();
    pale2.rotateZ(angle);
    applyPaleTransform(pale2, angle + TWO_PI / 3, position, hauteurMat, largeurNacelle, rayonNacelle);
    
    pale3.resetMatrix();
    pale3.rotateZ(angle);
    applyPaleTransform(pale3, angle + 2 * TWO_PI / 3, position, hauteurMat, largeurNacelle, rayonNacelle);
  }

  // fonction dessinant le mât de l'éolienne
  void createMat(float hauteur, float rayonBas, float rayonHaut) {
    mat = createShape(GROUP);
    PShape matShape = createShape();
    matShape.stroke(255);
    
    float zBas = 0.0;
    matShape.setFill(color(255));
    matShape.beginShape(QUAD_STRIP);
    for (int i = 0; i <= 20; i++) {
      float angle = map(i, 0, 20, 0, 1) * 2 * PI;
      float xHaut = cos(angle) * rayonHaut;
      float zHaut = sin(angle) * rayonHaut;
      float xBas = cos(angle) * rayonBas;
      zBas = sin(angle) * rayonBas;
      matShape.vertex(xHaut, -hauteur / 2, zHaut);
      matShape.vertex(xBas, hauteur / 2, zBas);
    }
    matShape.endShape();
    applyStyles(matShape);
    mat.addChild(matShape);
    // disque inférieur pour "fermer" le mât de l'éolienne
    PShape bottomDisk = createDisk(rayonBas, 30, -hauteur / 2);
    bottomDisk.rotateX(PI / 2);
    applyStyles(bottomDisk);
    mat.addChild(bottomDisk);
  }

  // fonction dessinant pales
  PShape createPale(float r1, float r2, float r3) {
    PShape pale = createShape();
    pale.setFill(color(255));
    pale.setStroke(color(0));
    pale.beginShape();
    pale.vertex(0, 0);
    pale.bezierVertex(cos(angle) * r2, sin(angle) * r2, cos(angle) * r3, sin(angle) * r3, cos(angle + PI / 6) * r1, sin(angle + PI / 6) * r2);
    pale.endShape();
    return pale;
  }

  // fonction dessinant la nacelle de l'éolienne
  void createNacelle(float baseRadius, float topRadius, float largeur, int detail) {
    rotateY(PI / 4);
    nacelle = createShape(GROUP);
    float angleStep = TWO_PI / detail; // incrément angulaire
    float h = largeur / 2;

    PShape cone = createShape();
    // Dessiner le cône tronqué
    cone.setStroke(color(0));
    cone.setFill(color(255));
    cone.beginShape(TRIANGLE_STRIP);
    for (int i = 0; i <= detail; i++) {
      float angle = i * angleStep;
      float x = cos(angle);
      float y = sin(angle);
      // Vertex pour le disque supérieur
      cone.vertex(x * topRadius, y * topRadius, -h);
      // Vertex pour le disque inférieur
      cone.vertex(x * baseRadius, y * baseRadius, h);
    }
    cone.endShape(CLOSE);
    applyStyles(cone);
    nacelle.addChild(cone);
    PShape disks = createShape(GROUP);
        disks.setStrokeWeight(0.025);
    disks.setStroke(color(0));
    disks.setFill(color(255));
    // grand disque de base
    disks.addChild(createDisk(baseRadius, detail, h));
    // petit disque de sommet
    disks.addChild(createDisk(topRadius, detail, -h));
    applyStyles(disks);
    nacelle.addChild(disks);

    // On ajoute une sphère moyeu : le moyeu et commande du rotor
    PShape moyeu = createShape(SPHERE, topRadius);
    moyeu.translate(0, 0, -h - 2);
    moyeu.setFill(color(125, 0, 0));  // Assurez-vous que le moyeu est blanc
    applyStyles(moyeu);
    nacelle.addChild(moyeu);
  }

  // fonction auxiliaire dessinant les disques couvrant le cône qui représente la nacelle
  PShape createDisk(float radius, int detail, float z) {
    PShape disk = createShape();
    disk.beginShape(TRIANGLE_FAN); // Commencer une forme de triangle fan pour le disque
    disk.vertex(0, 0, z); // Centre du disque
    for (int i = -detail / 2; i <= detail / 2; i++) {
      float angle = map(i, -detail, detail, -TWO_PI, TWO_PI);
      disk.vertex(radius * cos(angle), radius * sin(angle), z); // Points sur le périmètre
    }
    disk.endShape(CLOSE);
    applyStyles(disk);
    return disk;
  }
}
