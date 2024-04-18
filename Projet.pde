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
  background(204);
  translate(width/2, height/2, 0);
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
  // touche U permet de monter en altitude
  else if (keyCode == 85) {
    eyeZ += speed;
    centerZ += speed;
  }
  // touche D du clavier permet de descendre en altitude
  else if (keyCode == 68) {
    eyeZ = max(eyeZ - speed, -180); // au-délà de 180, soit on "rentre dans" le terrain soit on va en-dessous de la map et il n'y a plus rien
    centerZ = max(centerZ - speed, -180);
  }
  redraw();
}
