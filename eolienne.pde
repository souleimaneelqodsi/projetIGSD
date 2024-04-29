class Eolienne {

  PShape eolienne;
  PShape nacelle;
  PShape pale1, pale2, pale3;
  PShape mat;

  public Eolienne(PVector position, float hauteurMat, float largeurNacelle, PVector rayonsMat,
    PVector rayonsNacelle, float rotateAngleNacelle, char axisNacelle)
  {
    PShape eolienne = createShape(GROUP);
    int detailNacelle = 30;
    translate(position.x, position.y, position.z);
    createMat(hauteurMat, rayonsMat.x, rayonsMat.y);
    createPale();
    createNacelle(rayonsNacelle.x, rayonsNacelle.y, largeurNacelle, detailNacelle, rotateAngleNacelle, axisNacelle);
    eolienne.addChild(mat);
    eolienne.addChild(pale1);
    eolienne.addChild(pale2);
    eolienne.addChild(pale3);
    eolienne.addChild(nacelle);
  }

  void createMat(float hauteur, float rayonBas, float rayonHaut) {
    mat = createShape();
    mat.beginShape(QUAD_STRIP);
    for (int i = 0; i <= 20; i++) {
      float angle = map(i, 0, 20, 0, 1) * 2*PI;
      float xHaut = cos(angle) * rayonHaut;
      float zHaut = sin(angle) * rayonHaut;
      float xBas = cos(angle) * rayonBas;
      float zBas = sin(angle) * rayonBas;
      mat.vertex(xHaut, -hauteur/2, zHaut);
      mat.vertex(xBas, hauteur/2, zBas);
    }
    mat.endShape();
  }

  void createPale() {
    pale1 = createShape();
    pale2 = createShape();
    pale3 = createShape();
  }

  void createNacelle(float baseRadius, float topRadius, float largeur, int detail, float rotateAngle, char axis) {
    switch(axis) {
    case 'X' :
      rotateX(rotateAngle);
      break;
    case 'Y' :
      rotateY(rotateAngle);
      break;
    case 'Z' :
      rotateZ(rotateAngle);
      break;
    default :
      break;
    }
    nacelle = createShape(GROUP);
    nacelle.stroke(0);
    nacelle.strokeWeight(0);
    nacelle.fill(230);
    float angleStep = TWO_PI / detail; // Calcul de l'incrément angulaire
    float h = largeur / 2;

    PShape cone = createShape();
    // Dessiner le cône tronqué
    cone.beginShape(TRIANGLE_STRIP); // Commencer une forme composée de bandes de triangles
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
    nacelle.addChild(cone);
    PShape disks = createShape(GROUP);
    disks.strokeWeight(0.025);
    // grand disque de base
    disks.addChild(createDisk(baseRadius, detail, h));
    // petit disque de sommet
    disks.addChild(createDisk(topRadius, detail, -h));
    nacelle.addChild(disks);
  }

  PShape createDisk(float radius, int detail, float z) {
    PShape disk = createShape();
    // float angleStep = TWO_PI / detail; // Calculer l'incrément angulaire
    disk.beginShape(TRIANGLE_FAN); // Commencer une forme de triangle fan pour le disque
    disk.vertex(0, 0, z); // Centre du disque
    for (int i = -detail; i <= detail; i++) {
      float angle = map(i, -detail, detail, -TWO_PI, TWO_PI);
      disk.vertex(radius * cos(angle), radius * sin(angle), z); // Points sur le périmètre
    }
    disk.endShape(CLOSE); // Fermer la forme pour connecter le dernier point au premier
    return disk;
  }
}
