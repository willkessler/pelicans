// from: https://vormplus.be/full-articles/drawing-a-cylinder-with-processing

class Cylinder {
  int sides;
  float r;
  float h;
  
  Cylinder(int cylinderSides, float cylinderRadius, float cylinderHeight) {
    sides = cylinderSides;
    r = cylinderRadius;
    h = cylinderHeight;
  }

  void render()
  {
      float angle = 360 / sides;
      float halfHeight = h / 2;
      // draw top shape
      beginShape();
      for (int i = 0; i < sides; i++) {
          float x = cos( radians( i * angle ) ) * r;
          float y = sin( radians( i * angle ) ) * r;
          vertex( x, y, -halfHeight );    
      }
      endShape(CLOSE);
      // draw bottom shape
      beginShape();
      for (int i = 0; i < sides; i++) {
          float x = cos( radians( i * angle ) ) * r;
          float y = sin( radians( i * angle ) ) * r;
          vertex( x, y, halfHeight );    
      }
      endShape(CLOSE);
      
      // draw body
      beginShape(TRIANGLE_STRIP);
      for (int i = 0; i < sides + 1; i++) {
        float x = cos( radians( i * angle ) ) * r;
        float y = sin( radians( i * angle ) ) * r;
        vertex( x, y, halfHeight);
        vertex( x, y, -halfHeight);    
      }
      endShape(CLOSE);
  }

}
