float r1,r2,r3 ,a; // rayon des cercles 
PShape pale1, pale2, pale3; //pale 1,2..
    
  // cordonnées de la courbe de bezier
  float x1 = 0;
  float y1 = 0;
 
   
void setup() {
  size(800, 800,P3D);
  r1 = 400;
  r2 = 250;
  r3 = 250;
  
  pale1 = createPale();
  pale2 = createPale();
  pale3 = createPale();
  
  // pour que trois ailes soit bien répartis de maniere homogene prendre juste un decalage de 2PI/3
  pale2.rotateZ(2*PI/3);
  pale3.rotateZ((2*PI/3) * 2);
  
  
  frameRate(20);
}




void draw(){
  background(255);
  translate(width/2, height/2);
  fill(255, 0, 0);
 
  stroke(0);
  rotateZ(a);
  
  shape(pale1);
  shape(pale2);
  shape(pale3);


  
  a+= PI/50;
  
}

PShape createPale (){
  
  PShape pale = createShape();
  pale.beginShape();
  pale.fill(255,0,0);
  pale.vertex(x1, y1);
  pale.bezierVertex(cos(a) * r2,sin(a) * r2, cos(a) * r3, sin(a) * r3,cos(a+PI/6) * r1,sin(a+PI/6) * r2);
  
  pale.endShape();
  
  return pale;
  
  
  
}
