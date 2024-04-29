void setup() {
  size(800, 800, P3D);
}

void draw() {
  background(255);
  translate(width/2, height/2);
  
  // Dessin de l'appui de l'éolienne
  fill(255);
  box(20, 300, 20);
  
  //Dessin du moteur de l'éolienne 
  translate(0, -140, 0); // Déplacement vers le haut du pilier
  push();
  stroke(0);
  sphere(30);
  pop();
  
  // Dessin des pales
  rotateZ(frameCount/20);
  fill(255);
  drawBlade();
  rotateZ(-3*PI/4);
  drawBlade();
  rotateZ(-2*PI/3);
  drawBlade();
  
}

void drawBlade() {
  beginShape();
  vertex(0, 10, 0);
  vertex(100, 20, -10);
  vertex(0, 0, 0);
  endShape(CLOSE);
}
