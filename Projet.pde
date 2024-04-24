PShape model;
PShape pylons;

PShader myShader;

float eyeX = width/2;
float eyeY = height/2;
float eyeZ = -180;
float centerX = width/2                                                                                                                                                                                                                                                                                                                                                                                ;
float centerY = 0;
float centerZ = -180;
float upX = 0;
float upY = 0;
float upZ = -1;

int numPylons = 5;


void setup() {
  size(800, 800, P3D);
  model = loadShape("hypersimple.obj");
  myShader = loadShader("myFragmentShader.glsl", "myVertexShader.glsl");
  perspective(PI/2, width/height, 1, 1500);
  pylons = createShape(GROUP);
    // Create and position pylons here
  for (int i = 0; i < numPylons; i++) {
    // Calculate pylon positions and use getTerrainAltitude(x, y) to get Z
    float pylonX = 0; // Your logic to determine pylon X position
    float pylonY = i*100; // Your logic to determine pylon Y position
    float pylonZ = -150;

    // Create a pylon
    PShape pylon = createPylonModel();
    pylon.translate(pylonX, pylonY, pylonZ);

    // Add the pylon to the group
    pylons.addChild(pylon);
  }
}



void draw() {
  background(200);
  translate(width/2, height/2, 0);
  camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ);
  shader(myShader);
  shape(model);
  shape(pylons);
}


// déplacement de la vue
void keyPressed() {
  float speed = 10;
  if (keyCode == UP) {
    eyeY -= speed;
    centerY -= speed;
  } else if (keyCode == DOWN) {
    eyeY += speed;
    centerY += speed;
  } else if (keyCode == LEFT) {
    eyeX -= speed;
    centerX -= speed;
  } else if (keyCode == RIGHT) {
    eyeX += speed;
    centerX += speed;
  }
  // pour monter 
  if (keyCode == 'U')
    eyeZ += speed;
  // pour descendre, inutile d'aller plus bas que -180, on se retrouvera soit "dans" le terrain soit en-dessous (au niveau de l'espace)
  else if (keyCode == 'D')
    eyeZ = max(eyeZ - speed, -180);
}
