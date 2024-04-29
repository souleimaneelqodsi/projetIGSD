PShape model;
PShader myShader;
PVector eye = new PVector(width / 2, height / 2, -180);
PVector center = new PVector(width / 2, 0, -180);
PVector up = new PVector(0, 0, -1);

float X = 20;
float Y = 100;
int nbPylones = 25;

// en Y les pylones vont de 100 à -115
float shiftY = (100 - (-115)) / nbPylones;
// et en X ils vont de 20 à 40
float shiftX = (40 - 20) / nbPylones;
ArrayList<Pylone> pylones = new ArrayList<>();
ArrayList<PVector> coordPylones = new ArrayList<>();


boolean pylonesOK = true;
boolean terrainOK = true;
boolean repereOK = true;


// TODO : optimize code and divide into multiple files
// TODO : add comments and documentation where most needed


void setup() {
  size(800, 800, P3D);
  model = loadShape("hypersimple.obj");
  myShader = loadShader("myFragmentShader.glsl", "myVertexShader.glsl");
  perspective(PI/2, width/height, 1, 1500);


  for (int i = 0; i < nbPylones + 1; i++) {
    Pylone p = new Pylone();
    pylones.add(p);
    Y-= shiftY;
    X += shiftX;
    coordPylones.add(new PVector(X, Y, getTerrainAltitude(X, Y)));
  }
  noCursor();
}


class Pylone {

  final PVector leftAttach, rightAttach;
  final PShape shape = createShape(GROUP);
  final float hauteurPylone = 300; // Hauteur du pylône
  final float largeurPylone = 70; // Largeur du pylône


  public float getHauteur() {
    return hauteurPylone;
  }

  public float getLargeur() {
    return largeurPylone;
  }

  public PShape getShape() {
    return shape;
  }


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

    // partie pour l'attache fil electrique
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

    leftAttach = new PVector(-xx, yy, 0);
    rightAttach = new PVector(xx, yy, 0);

    shape.addChild(base);
    shape.addChild(triangleAttache);


    // on determine l'equation du plan ax+by+cz+d = 0 qui passe par un des triangle (face de la pyramyde)
    PVector p1 = new PVector (largeurPylone/2.0, 0, largeurPylone/2.0);
    PVector p2 = new PVector (0, -hauteurPylone, 0);
    PVector p3 = new PVector (-largeurPylone/2.0, 0, largeurPylone/2.0);

    PVector v1 = new PVector (p2.x-p1.x, p2.y-p1.y, p2.z-p1.z);
    PVector v2 = new PVector (p3.x-p1.x, p3.y-p1.y, p3.z-p1.z);

    PVector normal = v1.cross(v2);

    float a = normal.x;
    float c = normal.z;
    float d = a*(largeurPylone/2.0) - c*largeurPylone/2.0; // -largeur/2.0, 0, largeur/2.0


    /* avec le theoreme de thalese la largeur du triangle en fonction de y est
     larg(y) = (h+y)/h * l    / h etant hauteur du grand triangle et l sa largeur !! le + y c'est un - -y parce que le y est inversé en processing
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


/* x et y du coin bas gauche du triangle */
PShape triangleDecor (float x, float y, float largeur, float hauteur, PVector normal, float d) {
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

float getTerrainAltitude(float x, float y) {
  float altitudeZ = 0; //stocker l'altitude
  float distanceMin = Float.MAX_VALUE; //stocker la distance la plus proche

  // Parcourir tous les points du terrain
  for (int i = 0; i < model.getChildCount(); i++) {
    PShape child = model.getChild(i);
    if (child.getVertexCount() > 0) {
      // Parcourir tous les vertices du child
      for (int j = 0; j < child.getVertexCount(); j++) {
        float vertexX = child.getVertex(j).x;
        float vertexY = child.getVertex(j).y;
        float vertexZ = child.getVertex(j).z;
        float distance = dist(vertexX, vertexY, x, y); // Calculer la distance entre le point actuel et la position x, y donnée

        if (distance < distanceMin) {
          distanceMin = distance;
          altitudeZ = vertexZ;
        }
      }
    }
  }

  return altitudeZ; // Retourner l'altitude la plus proche
}

// la déclaration est ici pour signifier que c'est en rapport avec la fonction en-dessous, mais c'est bien une var. globale : 
float lastZMid = 0;

// (xA, yA, zA) sont les coordonnées du pylône de départ des lignes
// et (xB, yB, zB) celles du pylôle d'arrivée
void drawElectricLines(float hauteur, float largeur, float xA, float yA, float zA, float xB, float yB, float zB) {
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


void drawPylones() {
  // placement pylônes
  for (int j = 1; j < nbPylones + 1; j++) {
    pushMatrix();
    translate(coordPylones.get(j - 1).x, coordPylones.get(j - 1).y, coordPylones.get(j - 1).z);
    scale(0.025);
    rotateX(-PI/2);
    Pylone pyloneA = pylones.get(j-1);
    shape(pyloneA.getShape());
    popMatrix();
    noFill();
    stroke(0);
    strokeWeight(2.5);
    if (j < nbPylones)
      //la condition ci-dessus permet d'éviter que des lignes ne soient tracées dans le vide après le dernier pylone
      // (logiquement, le dernier pylone à tracer des lignes devant lui devrait être l'avant-dernier dans l'ordre de dessin)
      drawElectricLines(
        pyloneA.getHauteur() - 70, pyloneA.getLargeur(),
        coordPylones.get(j - 1).x, coordPylones.get(j - 1).y, coordPylones.get(j - 1).z,
        coordPylones.get(j).x, coordPylones.get(j).y, coordPylones.get(j).z
        );
  }
}


void draw() {
  background(125, 205, 250);
  translate(width/2, height/2, 0);

  camera(eye.x, eye.y, eye.z, center.x, center.y, center.z, up.x, up.y, up.z);
  if (terrainOK) {
    shader(myShader);
    shape(model);
  }


  if (pylonesOK) drawPylones();

  if (repereOK) {

    push();

    //TODO : rectify scaling

    translate(0, 0, -190);

    //dessin du repère
    //Axe X (rouge)
    stroke(255, 0, 0);
    beginShape(LINES);
    vertex(-300, 0, 0);
    vertex(0, 0, 0);
    endShape();

    // Axe Y (vert)
    stroke(0, 255, 0);
    beginShape(LINES);
    vertex(0, 0, 0);
    vertex(0, 300, 0);
    endShape();

    //Axe Z (bleu)
    stroke(0, 0, 255);
    beginShape(LINES);
    vertex(0, 0, 0);
    vertex(0, 0, 300);
    endShape();

    pop();
  }
}


void moveDirections(int down, int up, int right, int left, float speed) {
  if (keyCode == down) {
    eye.y -= speed;
    center.x = map(mouseX, 0, width, 1000, -1000) - speed;
    center.z = map(mouseY, 0, height, 1000, -1000);
    center.y = mouseY - speed;
  } else if (keyCode == up) {
    eye.y += speed;
    center.x = map(mouseX, 0, width, 1000, -1000) - speed;
    center.z = map(mouseY, 0, height, 1000, -1000);
    center.y = mouseY + speed;
  } else if (keyCode == right) {
    eye.x -= speed;
    center.x = map(mouseX, 0, width, 1000, -1000) - 2*speed;
    center.z = map(mouseY, 0, height, 1000, -1000);
    center.y = mouseY;
  } else if (keyCode == left) {
    eye.x += speed;
    center.x = map(mouseX, 0, width, 1000, -1000) + 2*speed;
    center.z = map(mouseY, 0, height, 1000, -1000);
    center.y = mouseY;
  }
}

void keyPressed() {
  float speed = 3.0;
  // CAS OÙ L'ON REGARDE DROIT DEVANT SOI
  if (center.x >= -135*4 && center.x <= 127*4)
    moveDirections(DOWN, UP, RIGHT, LEFT, speed);
  // CAS OÙ L'ON REGARDE COMPLÈTEMENT À GAUCHE
  else if (center.x <= -135*5)
    moveDirections(RIGHT, LEFT, UP, DOWN, speed);
  else
    // CAS OÙ L'ON REGARDE COMPLÈTEMENT À DROITE
    moveDirections(LEFT, RIGHT, DOWN, UP, speed);

  // pour monter
  if (keyCode == 'U')
    eye.z += speed;
  // pour descendre, inutile d'aller plus bas que -190, on se retrouvera soit "dans" le terrain soit en-dessous (au niveau de la scène)
  else if (keyCode == 'D')
    eye.z = max(eye.z - speed, -190);

  else if (keyCode == 'P')
    pylonesOK = !pylonesOK;

  else if (keyCode == 'T')
    terrainOK = !terrainOK;
    
  else if (keyCode == 'R')
    repereOK = !repereOK;
}


void mouseMoved() {
  // [-1000, 1000] semble être un intervalle correct pour avoir assez de sensibilité sans pour autant causer de bugs...
  center.x = map(mouseX, 0, width, 1000, -1000);
  center.z = map(mouseY, 0, height, 1000, -1000);
  center.y = mouseY;
}
