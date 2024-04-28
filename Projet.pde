PShape model;
PShader myShader;
PShape pylonsGroup;
PShape ligne;
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


// TODO : optimize code and divide into multiple files


void setup() {
  size(800, 800, P3D);
  model = loadShape("hypersimple.obj");
  myShader = loadShader("myFragmentShader.glsl", "myVertexShader.glsl");
  perspective(PI/2, width/height, 1, 1500);


  for (int i = 0; i < nbPylones; i++) {
    Pylone p = new Pylone();
    pylones.add(p);
    Y-= shiftY;
    X += shiftX;
    coordPylones.add(new PVector(X, Y, getTerrainAltitude(X, Y)));
  }
  System.out.println(shiftY);
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

  public PVector getLeftAttach() {
    return leftAttach;
  }
  public PVector getRightAttach() {
    return rightAttach;
  }
  public PShape getShape() {
    return shape;
  }


  public Pylone() {
    //PShape shape = createShape(GROUP);

    //translate(X,Y,Z);

    //partie pour la structure du pylone
    PShape base = createShape();
    base.beginShape(TRIANGLE);
    base.noFill();
    base.stroke(0, 0, 0);

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

    //partie pour l'attache fil electrique
    PShape triangleAttache = createShape();
    triangleAttache.beginShape(TRIANGLE);
    triangleAttache.noFill();
    triangleAttache.stroke(0, 0, 0);


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
    //float b = normal.y;
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


// getLargeur(), getHauteur()
// x, y
// z en fct de x et y
/*
 float xx = largeurPylone;
 float yy = -hauteurPylone*0.9;
 newXXLeft = (xPyl - left.xx) * 0.05
 newYY = (yPyl + yy) * 0.05
 newXXRight = (xPyl - right.xx) * 0.05
 
 */

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
  face.stroke(0, 0, 0);

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

//TODO : correct ending and add bezier shape

// fonction qui dessine des lignes électriques, fléchies si la distance entre les deux pylones est grande et tendues sinon
void drawElectricLines(Pylone pyloneA, float xA, float yA, float zA, float xB, float yB, float zB) {
  float xMid, yMid, zDeb, zMid, zFin;
  float hauteur = pyloneA.getHauteur() - 70;
  float largeur = pyloneA.getLargeur();
  // partie gauche :
  float xxDebLeft = xA - largeur * 0.025;
  float xxDebRight = xA + largeur * 0.025;
  zDeb = zA + (hauteur - hauteur*0.1)*0.025 + 1.6;// - hauteur*0.025*0.1);
  xMid = xxDebLeft + shiftX/2;
  yMid = yA + shiftY/2;
  float xxFinLeft = xB - largeur * 0.025;
  float xxFinRight = xB + largeur * 0.025;
  zFin = zB + (hauteur - hauteur*0.1)*0.025 + 1.6;// - hauteur*0.025*0.1);
  // on ne veut pas que si les pylones sont très rapprochés, que la ligne électrique dépasse la hauteur moyenne du segment les séparant
  if (shiftY == 0) zMid = max(-202 + 100*(1./shiftY), (zDeb+zFin)/2);
  // si jamais, ce qui peut difficilement arriver, shiftY est nul, on évite l'erreur de division et on met la hauteur moyenne entre les deux pylones
  else zMid = (zDeb+zFin)/2;
  System.out.println("-------- GAUCHE --------");
  System.out.println("Début (x, y, z) : (" + xxDebLeft + ", " + yA + ", " + zDeb + ")");
  System.out.println("Milieu (x, y, z) : (" + xMid + ", " + yMid + ", " + zMid + ")");
  System.out.println("Fin (x, y, z) : (" + xxFinLeft + ", " + yB + ", " + zFin + ")");
  //bezier(xxDebLeft, yA, zDeb, xMid, yMid, zMid, xMid, yMid, zMid, xxFinLeft, yB, zFin);
  line(xxDebLeft, yA, zDeb, xxFinLeft, yB, zFin);
  // partie droite :
  xMid = xxDebRight + shiftX/2;
  yMid = yA + shiftY/2;
  if (shiftY == 0) zMid = max(-202 + 15*(1./shiftY), (zDeb+zFin)/2);
  else zMid = (zDeb+zFin)/2;
  System.out.println("-------- DROITE --------");
  System.out.println("Début (x, y, z) : (" + xxDebRight + ", " + yA + ", " + zDeb + ")");
  System.out.println("Milieu (x, y, z) : (" + xMid + ", " + yMid + ", " + zMid + ")");
  System.out.println("Fin (x, y, z) : (" + xxFinRight + ", " + yB + ", " + zFin + ")");
  //bezier(xxDebRight, yA, zDeb, xMid, yMid, zMid, xMid, yMid, zMid, xxFinRight, yB, zFin);
  line(xxDebRight, yA, zDeb, xxFinRight, yB, zFin);
}

void drawPylones() {
  // placement pylones
  for (int j = 1; j < nbPylones; j++) {
    pushMatrix();
    translate(coordPylones.get(j - 1).x, coordPylones.get(j - 1).y, coordPylones.get(j - 1).z);
    scale(0.025);
    rotateX(-PI/2);
    Pylone pyloneA = pylones.get(j-1);
    //Pylone pyloneB = pylones.get(j);
    shape(pyloneA.getShape());
    popMatrix();
    noFill();
    stroke(0);
    strokeWeight(1);
    drawElectricLines(
      pyloneA,
      coordPylones.get(j - 1).x, coordPylones.get(j - 1).y, coordPylones.get(j - 1).z,
      coordPylones.get(j).x, coordPylones.get(j).y, coordPylones.get(j).z
      );
  }
}


void draw() {
  background(200);
  translate(width/2, height/2, 0);

  camera(eye.x, eye.y, eye.z, center.x, center.y, center.z, up.x, up.y, up.z);
  shader(myShader);
  shape(model);

  drawPylones();

  push();
  
  
  //TODO : correct scaling

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
  float speed = 1.0;
  // CAS Où L'ON REGARDE DROIT DEVANT SOI
  if (center.x >= -135*5 && center.x <= 127*5)
    moveDirections(DOWN, UP, RIGHT, LEFT, speed);
  // CAS Où L'ON REGARDE COMPLèTEMENT À GAUCHE
  else if (center.x <= -135*5)
    moveDirections(RIGHT, LEFT, UP, DOWN, speed);
  else
    // CAS Où L'ON REGARDE COMPLèTEMENT À DROITE
    moveDirections(LEFT, RIGHT, DOWN, UP, speed);

  // pour monter
  if (keyCode == 'U')
    eye.z += speed;
  // pour descendre, inutile d'aller plus bas que -180, on se retrouvera soit "dans" le terrain soit en-dessous (au niveau de l'espace)
  else if (keyCode == 'D')
    eye.z = max(eye.z - speed, -190);
}

void mouseMoved() {
  center.x = map(mouseX, 0, width, 1000, -1000);
  center.z = map(mouseY, 0, height, 1000, -1000);
  center.y = mouseY;
}
