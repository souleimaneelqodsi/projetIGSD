PShape model;
PShader myShader;

// coordonnées de caméra : 
PVector eye = new PVector(width / 2, height / 2, -180);
PVector center = new PVector(width / 2, 0, -180);
PVector up = new PVector(0, 0, -1);

// position du premier pylône
float X = 20;
float Y = 100;
int nbPylones = 25;
int nbEoliennes = 5;

ArrayList<Eolienne> eoliennes = new ArrayList<>();
ArrayList<PVector> eoliennesCoord = new ArrayList<>(); // coordonnées de chaque éolienne

// variables de statut : objet affiché ou pas
boolean pylonesOK = true;
boolean terrainOK = true;
boolean repereOK = true;
boolean eoliennesOK = true;

void setup() {
  size(800, 800, P3D);
  model = loadShape("hypersimple.obj");
  myShader = loadShader("myFragmentShader.glsl", "myVertexShader.glsl");
  perspective(PI/2, width/height, 1, 1500);

  for (int i = 0; i < nbPylones + 1; i++) {
    Pylone p = new Pylone();
    pylones.add(p);
    Y -= shiftY; // on retire à chaque fois le décalage calculé en fonction de la distance entre le premier et dernier pylône ainsi que le nombre total de pylones
    X += shiftX;
    coordPylones.add(new PVector(X, Y, getTerrainAltitude(X, Y)));
  }

  float hauteurMat = 300;
  float largeurNacelle = 60;
  PVector rayonsMat = new PVector(20, 10);
  PVector rayonsNacelle = new PVector(20, 15);
  PVector dimensionsPales = new PVector(200, 125, 125);
  PVector positionHolder; // variable mise à jour à chaque tour de la boucle pour stocker la position de chaque éolienne
  for (int i = 0; i < nbEoliennes + 1; i++) {
    XEol -= shiftY;
    positionHolder = new PVector(XEol, YEol, getTerrainAltitude(XEol, YEol));
    Eolienne e = new Eolienne(positionHolder, hauteurMat, largeurNacelle, rayonsMat, rayonsNacelle, dimensionsPales, rayonsNacelle.y);
    eoliennesCoord.add(positionHolder);
    eoliennes.add(e);
  }
  noCursor();
  frameRate(60);
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


void draw() {
  background(125, 205, 250);
  
  translate(width/2, height/2, 0);
  camera(eye.x, eye.y, eye.z, center.x, center.y, center.z, up.x, up.y, up.z);
  
  if (terrainOK) {
    shader(myShader);
    shape(model);
    resetShader();
  }

  if (eoliennesOK) {
    for (int i = 0; i < nbEoliennes; i++) {
      PVector position = eoliennesCoord.get(i);
      Eolienne eolienne = eoliennes.get(i);
      eolienne.rotatePales(position, 300, 60, 20); 
      pushMatrix();
      translate(eoliennesCoord.get(i).x, eoliennesCoord.get(i).y, getTerrainAltitude(eoliennesCoord.get(i).x, eoliennesCoord.get(i).y) + 3);
      rotateX(-PI / 2);
      rotateY(PI);
      scale(0.025);
      shape(eoliennes.get(i).getShape());
      popMatrix();
    }
  }

  if (pylonesOK) drawPylones();

  if (repereOK) {
    pushMatrix();
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
    popMatrix();
  }
}



void moveDirections(int backward, int forward, int right, int left, float speed) {
  if (keyCode == backward) {
    eye.y -= speed;
    center.x = map(mouseX, 0, width, 1000, -1000) - speed;
    center.z = map(mouseY, 0, height, 1000, -1000);
    center.y = mouseY - speed;
  } else if (keyCode == forward) {
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
  // vitesse de déplacement de la caméra
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

  // fait disparaître/apparaître les pylônes
  else if (keyCode == 'P')
    pylonesOK = !pylonesOK;

  // fait disparaître/apparaître le terrain
  else if (keyCode == 'T')
    terrainOK = !terrainOK;

  // fait disparaître/apparaître le repère
  else if (keyCode == 'R')
    repereOK = !repereOK;

  else if (keyCode == 'E') {
    eoliennesOK = !eoliennesOK;
  }
}


void mouseMoved() {
  // [-1000, 1000] semble être un intervalle correct pour avoir assez de sensibilité sans pour autant causer de bugs...
  center.x = map(mouseX, 0, width, 1000, -1000);
  center.z = map(mouseY, 0, height, 1000, -1000);
  center.y = mouseY;
}
