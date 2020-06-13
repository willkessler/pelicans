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


int numPelicans = 1;
Pelican[] pelicans;
Terrain theGround;
float windowSize = 800;  
float outerBoxSize = windowSize / 2 * .8;


void setup() {
  size(800,800, P3D);
  pelicans = new Pelican[numPelicans];

  for (int i = 0; i < numPelicans; ++i) {
    pelicans[i] = new Pelican(outerBoxSize);
  }
  //theGround = new Terrain(25,25,2000,2000);
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
  stroke(255);
  float fov = PI/4.5;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height), 
              cameraZ/20, cameraZ*10.0);
              
  translate(windowSize/2, windowSize/2, 0);
  float yRot = map(mouseX, 0, windowSize, -PI/2, PI/2);
  float xRot = map(-mouseY, 0, windowSize, -PI/4, PI/4);
  rotateY(yRot);
  rotateX(xRot);
  box(outerBoxSize);

  updatePelicans();
  renderPelicans();
  
  //theGround.render();

}
