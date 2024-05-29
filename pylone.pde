// --------- VARIABLES GLOBALES POUR LES PYLÔNES ---------

// en Y les pylones vont de 100 à -115
float shiftY = (100 - (-115)) / nbPylones;
// et en X ils vont de 20 à 40
float shiftX = (40 - 20) / nbPylones;
ArrayList<Pylone> pylones = new ArrayList<>();
ArrayList<PVector> coordPylones = new ArrayList<>();
float lastZMid = 0.0;


// --------- CLASSE PYLÔNE ---------


class Pylone {

  final PShape shape = createShape(GROUP);
  final float hauteurPylone = 300; // Hauteur des pylônes
  final float largeurPylone = 70; // Largeur des pylônes


  public float getHauteur() {
    return hauteurPylone;
  }

  public float getLargeur() {
    return largeurPylone;
  }

  public PShape getShape() {
    return shape;
  }

  // dessin du pylône
  public Pylone() {
    PShape base = createShape();
    base.beginShape(TRIANGLE);
    base.noFill();
    base.stroke(15);
    base.strokeWeight(1.5);

    base.vertex(-largeurPylone/2.0, 0, largeurPylone/2.0);
    base.vertex(largeurPylone/2.0, 0, largeurPylone/2.0);
    base.vertex(0, -hauteurPylone, 0);

    base.vertex(largeurPylone/2.0, 0, largeurPylone/2.0);
    base.vertex(largeurPylone/2.0, 0, -largeurPylone/2.0);
    base.vertex(0, -hauteurPylone, 0);

    base.vertex(largeurPylone/2.0, 0, -largeurPylone/2.0);
    base.vertex(-largeurPylone/2.0, 0, -largeurPylone/2.0);
    base.vertex(0, -hauteurPylone, 0);

    base.vertex(-largeurPylone/2.0, 0, -largeurPylone/2.0);
    base.vertex(-largeurPylone/2.0, 0, largeurPylone/2.0);
    base.vertex(0, -hauteurPylone, 0);

    base.endShape();

    // partie pour l'attache du fil éléctrique
    PShape triangleAttache = createShape();
    triangleAttache.beginShape(TRIANGLE);
    triangleAttache.noFill();
    triangleAttache.stroke(15);
    triangleAttache.strokeWeight(1.5);

    float xx = largeurPylone;
    float yy = -hauteurPylone*0.9;
    triangleAttache.vertex(-xx, yy, 0);
    triangleAttache.vertex(xx, yy, 0);
    triangleAttache.vertex(0, -hauteurPylone*0.7, 0);

    triangleAttache.endShape();

    shape.addChild(base);
    shape.addChild(triangleAttache);

    // on détermine l'équation du plan ax+by+cz+d = 0 qui passe par un des triangles (face de la pyramide)
    PVector p1 = new PVector (largeurPylone/2.0, 0, largeurPylone/2.0);
    PVector p2 = new PVector (0, -hauteurPylone, 0);
    PVector p3 = new PVector (-largeurPylone/2.0, 0, largeurPylone/2.0);

    PVector v1 = new PVector (p2.x-p1.x, p2.y-p1.y, p2.z-p1.z);
    PVector v2 = new PVector (p3.x-p1.x, p3.y-p1.y, p3.z-p1.z);

    PVector normal = v1.cross(v2);

    float a = normal.x;
    float c = normal.z;
    float d = a*(largeurPylone/2.0) - c*largeurPylone/2.0;


    /* avec le théorème de Thalès la largeur du triangle en fonction de y est
     larg(y) = (h+y)/h * l, h étant la hauteur du grand triangle et l sa largeur. 
     le + y, c'est un - (-y) parce que le y est "inversé" en Processing
    */

    for (float y =0; y>=-hauteurPylone + 20; y-=20.0) {


      float largY = ((hauteurPylone+y)/hauteurPylone)* largeurPylone;

      // face 1
      PShape decoFace1 = triangleDecor (-largY/2.0, y, largY, 40, normal, d);
      shape.addChild(decoFace1);

      // face 2
      PShape decoFace2 = triangleDecor (-largY/2.0, y, largY, 40, normal, d);
      decoFace2.rotateY(PI/2);
      shape.addChild(decoFace2);

      // face 3
      PShape decoFace3 = triangleDecor (-largY/2.0, y, largY, 40, normal, d);
      decoFace3.rotateY(-PI/2);
      shape.addChild(decoFace3);

      // face 4
      PShape decoFace4 = triangleDecor (-largY/2.0, y, largY, 40, normal, d);
      decoFace4.rotateY(-PI/2);
      decoFace4.rotateY(-PI/2);
      shape.addChild(decoFace4);
    }
  }
}


// --------- PROCÉDURES POUR LES PYLÔNES ---------


// fonction dessinant triangle
PShape triangleDecor(float x, float y, float largeur, float hauteur, PVector normal, float d) {
  // les param. x et y = coords. coin bas gauche du triangle 
  float a = normal.x;
  float b = normal.y;
  float c = normal.z;

  float z = -(a*x+b*y+d)/c;
  float zP = -(b*(-hauteur+y)+d)/c;

  PShape face = createShape();
  face.beginShape(TRIANGLE);
  face.noFill();
  face.stroke(15);
  face.strokeWeight(1.5);

  face.vertex(x, y, z);
  face.vertex(x+largeur, y, z);
  face.vertex(0, -hauteur+y, zP);

  face.endShape();

  return face;
}

// fonction dessinant les lignes électriques
void drawElectricLines(float hauteur, float largeur, float xA, float yA, float zA, float xB, float yB, float zB) {
  // (xA, yA, zA) sont les coordonnées du pylône de départ des lignes
  // et (xB, yB, zB) celles du pylôle d'arrivée
  float antiGravity = 30; // moins cette valeur est élevée, plus la gravité est forte
  float xMid, yMid, zStart, zMid, zEnd;
  float XStartLeft = xA - largeur * 0.025;
  float XStartRight = xA + largeur * 0.025;
  // ci-dessous 1.6 est une valeur purement arbitraire car malgré la précision du calcul nous avons constaté qu'un décalage était quand même présent
  zStart = zA + (hauteur - hauteur*0.1)*0.025 + 1.6;
  xMid = XStartLeft;
  yMid = (yA + yB)/2; // point de courbure de Bézier se trouve au point médiant du segment de distance séparant les deux pylones
  float XEndLeft = xB - largeur * 0.025;
  float XEndRight = xB + largeur * 0.025;
  zEnd = zB + (hauteur - hauteur*0.1)*0.025 + 1.6;

  if (lastZMid == 0) zMid = getTerrainAltitude(xMid, yMid) + antiGravity*(1/shiftY);
  // on fait la moyenne (avec une petite pondération) entre la hauteur du point de courbure et le précédent dans le dessin pour rendre plus naturelle
  // la gravité des lignes en évitant les "brusques" irrégularités de trajectoire et l'hypersensibilité aux changements d'altitude
  else zMid = ((getTerrainAltitude(xMid, yMid) + antiGravity*(1/shiftY)) + lastZMid)/2;
  // on fait une dernière manip : on vérifie que le point ne va pas en dessous du sol sinon la ligne traversera celui-ci
  zMid = max(zMid, getTerrainAltitude(xMid, yMid + 5));
  lastZMid = zMid;
  bezier(XStartLeft, yA, zStart, xMid, yMid, zMid, xMid, yMid, zMid, XEndLeft, yB, zEnd);
  xMid += 2 * largeur * 0.025;
  bezier(XStartRight, yA, zStart, xMid, yMid, zMid, xMid, yMid, zMid, XEndRight, yB, zEnd);
}


// fonction dessinant les pylônes
void drawPylones() {
  // placement pylônes
  Pylone selectedPylone;
  for (int j = 1; j < nbPylones + 1; j++) {
    pushMatrix();
    translate(coordPylones.get(j - 1).x, coordPylones.get(j - 1).y, coordPylones.get(j - 1).z);
    scale(0.025);
    rotateX(-PI/2);
    selectedPylone = pylones.get(j-1);
    shape(selectedPylone.getShape());
    popMatrix();
    noFill();
    stroke(0);
    strokeWeight(2.5);
    if (j < nbPylones)
      //la condition ci-dessus permet d'éviter que des lignes ne soient tracées dans le vide après le dernier pylone
      // (logiquement, le dernier pylone à tracer des lignes devant lui devrait être l'avant-dernier dans l'ordre de dessin)
      drawElectricLines(
        selectedPylone.getHauteur() - 70, selectedPylone.getLargeur(),
        coordPylones.get(j - 1).x, coordPylones.get(j - 1).y, coordPylones.get(j - 1).z,
        coordPylones.get(j).x, coordPylones.get(j).y, coordPylones.get(j).z
        );
  }
}
