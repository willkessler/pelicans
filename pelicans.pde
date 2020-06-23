// TODO
// convert to 3d: 
//   draw 3d grid
//   change canvas to 3d
//   bird becomes 3d
//   bird has actual wings
//   bird flaps when altitude drops enough, not speed. number of flaps is proportional to how much altitude it wishes to (re)gain
//   upstroke of flap should be faster than downstroke since less resistance

// wind: birds don't always aim in the direction of their forward velocity. 
// if there's a crosswind they may float along at an angle to their forward motion, which you see seagulls often doing along cliff lines
// break out pelicans from seagulls and maybe albatrosses and cormorants
// create scrolling cliffline with ocean break
// birds fly past GG bridge
// birds dive into water for fish https://www.youtube.com/watch?v=SD8nHfLYmPE  https://www.youtube.com/watch?v=wfLl26yzpk8  https://www.youtube.com/watch?v=krrQjPZOCoY


int numPelicans = 1;
Pelican[] pelicans;
Terrain theGround;
Axes theAxes;
float windowSize = 800;  
float outerBoxSize = windowSize / 2 * .8;
float halfOuterBoxSize = outerBoxSize / 2;
PVector pointToVec;

// =-=-=-=-=-=-=-=-=-=-=-=- UTILS =-=-=-=-=-=-=-=-=-=-=-=-=-=-

// see: https://www.euclideanspace.com/maths/algebra/vectors/angleBetween/
float angleBetweenVectors(PVector v1, PVector v2) {
  float dp = v1.dot(v2);
  float denom = v1.mag() * v2.mag();
  float angle = acos(dp/denom);
  return degrees(angle);
}

void rotateToVector(PVector v1) {
  PVector xAxis = new PVector(1,0,0);
  float angleBetween = angleBetweenVectors(v1,xAxis);
  PVector rotVec = xAxis.cross(v1);
  // even though not doc'd, Processing supports rotate about arbitrary vector here:
  // https://github.com/processing/processing/blob/349f413a3fb63a75e0b096097a5b0ba7f5565198/core/src/processing/core/PMatrix3D.java#L244
  rotate(radians(angleBetween), rotVec.x, rotVec.y, rotVec.z); 
}

// =-=-=-=-=-=-=-=-=-=-=-=- MAIN CODE =-=-=-=-=-=-=-=-=-=-=-=-=-=-

void setup() {
  size(800,800, P3D);
  pelicans = new Pelican[numPelicans];

  for (int i = 0; i < numPelicans; ++i) {
    pelicans[i] = new Pelican();
  }
  //theGround = new Terrain(25,25,2000,2000);
  theAxes = new Axes(100, color(255,0,0), color(0,255,0), color(0,0,255));
  pointToVec = new PVector(random(-1,1), random(-1,1), random(-1,1));
  pointToVec.mult(70);

}

void updatePelicans() {
  for (Pelican p : pelicans) {
    p.update();
  }
}

void renderPelicans() {
  for (Pelican p : pelicans) {
    p.render();
  }
}


void draw() {
 background(0,0,0);
  noFill();
  float fov = PI/4.5;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height), 
              cameraZ/20, cameraZ*10.0);
              
  translate(windowSize/2, windowSize/2, 0);
  float yRot = map(mouseX, 0, windowSize, -PI/2, PI/2);
  float xRot = map(height - mouseY, 0, windowSize, -PI/2, PI/2);
  rotateY(yRot);
  rotateX(xRot);
  
  stroke(255);
  box(outerBoxSize);
  fill(0,50,255);
  noStroke();
  beginShape(TRIANGLE_STRIP);
  vertex(halfOuterBoxSize, halfOuterBoxSize, halfOuterBoxSize);
  vertex(-halfOuterBoxSize, halfOuterBoxSize, halfOuterBoxSize);
  vertex(-halfOuterBoxSize, halfOuterBoxSize, -halfOuterBoxSize);
  vertex(halfOuterBoxSize, halfOuterBoxSize, -halfOuterBoxSize);
  vertex(halfOuterBoxSize, halfOuterBoxSize, halfOuterBoxSize);
  endShape(CLOSE);
  
  updatePelicans();
  renderPelicans();
  
  
  //stroke(255,255,0);
  //strokeWeight(5);
  //line(0,0,0, pointToVec.x, pointToVec.y, pointToVec.z);
  //strokeWeight(1);

  theAxes.render();

  //theGround.render();

}
