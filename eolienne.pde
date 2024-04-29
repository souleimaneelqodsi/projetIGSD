PShape eolienne;

void setup() {
  size(800, 800, P3D);
  eolienne = createEolienne();
}

void draw(){
  background(255);
  translate(width/2, height/2);
  rotateY(frameCount * 0.01);
  shape(eolienne);
}

PShape createEolienne(){
  PShape eolienne = createShape(GROUP);
  eolienne.addChild(createMat());
  //eolienne.addChild(createPale());
  return eolienne;
}

PShape createMat(){
  PShape mat = createShape();
  mat.beginShape(QUAD_STRIP);
  float hauteur = 600;
  float rayonHaut = 5;
  float rayonBas = 20;
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
  return mat;
}

PShape createPale(){
    PShape pale = createShape();
    pale.beginShape();
    return pale;
}
  
PShape createNacelle(){
  PShape nacelle = createShape();
  
  
  return nacelle;


}
  
  
  
  
  
  
  
