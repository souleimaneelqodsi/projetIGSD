float getTerrainAltitude(float x, float y) {
  float altitudeZ = 0; //stocker l'altitude 
  float distanceMin = 0; //stocker la distance la plus proche
  
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
