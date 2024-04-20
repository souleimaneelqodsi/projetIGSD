PShape model;
PShape pylons;

PShader myShader;

PVector eye = new PVector(width / 2, height / 2, -180);
PVector center = new PVector(width / 2, 0, -180);
PVector up = new PVector(0, 0, -1);

int numPylons = 5;



void setup() {
  size(800, 800, P3D);
  model = loadShape("hypersimple.obj");
  myShader = loadShader("myFragmentShader.glsl", "myVertexShader.glsl");
  perspective(PI/2, float(width)/height, 1, 1500);
  noCursor();
  pylons = createShape(GROUP);
  for (int i = 0; i < numPylons; i++) {
    float pylonX = 0;
    float pylonY = i*100; 
    float pylonZ = -150;

    PShape pylon = createPylonModel();
    pylon.translate(pylonX, pylonY, pylonZ);

    pylons.addChild(pylon);
  }
}

void draw() {
  background(200);
  translate(width/2 , height/2, 0);
  camera(eye.x, eye.y, eye.z, center.x, center.y, center.z, up.x, up.y, up.z);
  shader(myShader);
  shape(model);
  shape(pylons);
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
  float speed = 10.0;
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
  else if (keyCode == 'V')
    eye.z = max(eye.z - speed, -180);
}

void mouseMoved() {
  center.x = map(mouseX, 0, width, 1000, -1000);
  center.z = map(mouseY, 0, height, 1000, -1000);
  center.y = mouseY;
}
