class Terrain {

  PVector[] coords;
  int numRows, numCols;
  float gridWidth, gridHeight;
  PShape terrainShape;
  
  Terrain(int nRows, int nCols, float gWidth, float gHeight) {
    // generate a terrain grid
    int j1, j2;
    numRows = nRows;
    numCols = nCols;
    gridWidth = gWidth;
    gridHeight = gHeight;
    coords = new PVector[numRows * numCols];
    float x,y,z;
    float squareWidth = gridWidth / (float) numCols;
    float squareHeight = gridHeight / (float) numRows;
    for (int i = 0; i < numRows; ++i) {
      for (int j = 0; j < numCols; ++j) {
        x = i * squareWidth;
        z = -1 * j * squareHeight;
        y = noise(map(x, 0, gridWidth,0,10),map(z, 0, gridHeight,0,10)) * 100;
        coords[j * numCols + i] = new PVector(x,y,z);
      }
    }
    terrainShape = createShape();
    terrainShape.beginShape(TRIANGLE_STRIP);
    terrainShape.stroke(0);
    terrainShape.fill(0,255,0);
    for (int i = 0; i < numRows ; ++i) {
      for (int j = 0; j < numCols; ++j) {
        //j1 = j * numCols;
        //j2 = (j + 1) * numCols;
        //terrainShape.vertex(coords[j1 + i].x, coords[j1 + i].y, coords[j1 + i].z);
        //terrainShape.vertex(coords[j1 + i + 1].x, coords[j1 + i +1 ].y, coords[j1 + i + 1].z);
        //terrainShape.vertex(coords[j2 + i + 1].x, coords[j2 + i + 1].y, coords[j2 + i + 1].z);
        //terrainShape.vertex(coords[j2 + i].x, coords[j2 + i].y, coords[j2 + i].z);
        j1 = i * j + j;
        terrainShape.vertex(coords[j1].x, coords[j1].y, coords[j1].z);
      }
    }
    terrainShape.endShape(CLOSE);

}
  
  void render() {
    stroke(0,255,0);
    pushMatrix();
    translate(width/2 - gridWidth / 2,height - height / 4);
    shape(terrainShape);
    popMatrix();
  }
}
