PShape model;
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


void setup() {
  size(800, 800, P3D);
  model = loadShape("hypersimple.obj");
  myShader = loadShader("myFragmentShader.glsl", "myVertexShader.glsl");
  perspective(PI/2, width/height, 1, 1500);
}



void draw() {
  background(200);
  //translate(width/2, height/2, 0);
  camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ);
  shader(myShader);
  shape(model);
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
