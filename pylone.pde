
PShape createPylonModel() {
  float hauteurPylone = 300; // Hauteur du pylône
  float largeurPylone = 70; // Largeur du pylône

  PShape pylone = createShape(GROUP);

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

  triangleAttache.vertex(-largeurPylone, -hauteurPylone*0.9, 0 );
  triangleAttache.vertex(largeurPylone, -hauteurPylone*0.9, 0);
  triangleAttache.vertex(0, -hauteurPylone*0.7, 0);


  triangleAttache.endShape();

  pylone.addChild(base);
  pylone.addChild(triangleAttache);


  // on determine l'equation du plan ax+by+cz+d = 0 qui passe par un des triangle (face de la pyramyde)
  PVector p1 = new PVector (largeurPylone/2.0, 0, largeurPylone/2.0);
  PVector p2 = new PVector (0, -hauteurPylone, 0);
  PVector p3 = new PVector (-largeurPylone/2.0, 0, largeurPylone/2.0);

  PVector v1 = new PVector (p2.x-p1.x, p2.y-p1.y, p2.z-p1.z);
  PVector v2 = new PVector (p3.x-p1.x, p3.y-p1.y, p3.z-p1.z);

  PVector normal = v1.cross(v2);

  float a = normal.x;
  float b = normal.y;
  float c = normal.z;
  float d = a*(largeurPylone/2.0) - c*largeurPylone/2.0; // -largeur/2.0, 0, largeur/2.0


  /* avec le theoreme de thales la largeur du triangle en fonction de y est
   larg(y) = (h+y)/h * l    / h etant hauteur du grand triangle et l sa largeur !! le + y c'est un - -y parce que le y est inversé en processing
   */

  for (float y =0; y>=-hauteurPylone + 20; y-=20.0) {


    float largY = ((hauteurPylone+y)/hauteurPylone)* largeurPylone;

    // face 1
    PShape decoFace1 = triangleDecort (-largY/2.0, y, largY, 40, normal, d);
    pylone.addChild(decoFace1);

    // face 2
    PShape decoFace2 = triangleDecort (-largY/2.0, y, largY, 40, normal, d);
    decoFace2.rotateY(PI/2);
    pylone.addChild(decoFace2);

    // face 3
    PShape decoFace3 = triangleDecort (-largY/2.0, y, largY, 40, normal, d);
    decoFace3.rotateY(-PI/2);
    pylone.addChild(decoFace3);

    // face 4
    PShape decoFace4 = triangleDecort (-largY/2.0, y, largY, 40, normal, d);
    decoFace4.rotateY(-PI/2);
    decoFace4.rotateY(-PI/2);
    pylone.addChild(decoFace4);
  }

  return pylone;
}




/* x et y du coin bas gauche du triangle */
PShape triangleDecort (float x, float y, float largeur, float hauteur, PVector normal, float d) {
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
