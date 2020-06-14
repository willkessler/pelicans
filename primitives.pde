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


class Cone {
  int sides;
  float r;
  float h;
  
  Cone(int coneSides, float coneRadius, float coneHeight) {
    sides = coneSides;
    r = coneRadius;
    h = coneHeight;
  }

  void render()
  {
      float angle = 360 / sides;
      float halfHeight = h / 2;
      
      // draw base
      beginShape();
      for (int i = 0; i < sides; i++) {
          float y = cos( radians( i * angle ) ) * r;
          float z = sin( radians( i * angle ) ) * r;
          vertex(-halfHeight, y, z );    
      }
      endShape(CLOSE);
      
      // draw body
      beginShape(TRIANGLE_STRIP);
      for (int i = 0; i < sides + 1; i++) {
        float y = cos( radians( i * angle ) ) * r;
        float z = sin( radians( i * angle ) ) * r;
        vertex( halfHeight, 0, 0);
        vertex( -halfHeight,y, z);    
      }
      endShape(CLOSE);
  }
}

class Axes {
  float axisSize;
  color xColor, yColor, zColor;
  PFont f;
  
  Axes(float sz, color xc, color yc, color zc) {
    axisSize = sz;
    xColor = xc;
    yColor = yc;
    zColor = zc;
    f = createFont("Courier",16,true);
  }
  
  void render() {
    strokeWeight(5); 
    stroke(xColor);
    PVector axis = new PVector(0,0,0);
    textFont(f);

    axis.set(1,0,0);
    axis.mult(axisSize);
    line(0,0,0,axis.x, axis.y, axis.z);
    fill(xColor);
    text("X", axis.x + 10, axis.y, axis.z);

    stroke(yColor);
    axis.set(0,1,0);
    axis.mult(axisSize);
    line(0,0,0,axis.x, axis.y, axis.z);
    fill(yColor);
    text("Y", axis.x , axis.y + 10, axis.z);

    stroke(zColor);
    axis.set(0,0,1);
    axis.mult(axisSize);
    line(0,0,0,axis.x, axis.y, axis.z);
    fill(zColor);
    text("Z", axis.x , axis.y, axis.z + 10);

    strokeWeight(1);
    noFill();
  }
  
}
