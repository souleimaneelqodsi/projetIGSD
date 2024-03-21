PShape s;

void setup(){
  size(800,800,P3D);
  s = loadShape("hypersimple.obj");
  perspective(PI/2, width/height, 1, 1500);
}

void draw(){
   translate(width/2, height/2);
     camera(0, 50,-190, 0, 100,  -200,0, 0, -1);
   shape(s);
   
   //for(int i = -100 ; i < 100 ; i++) vertex(height/2, width/2, 
}
