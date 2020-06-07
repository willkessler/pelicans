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
  
void setup() {
  size(800,800, P3D);
  pelicans = new Pelican[numPelicans];

  for (int i = 0; i < numPelicans; ++i) {
    pelicans[i] = new Pelican();
  }
  theGround = new Terrain(25,25,2000,2000);
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
  updatePelicans();
  renderPelicans();
  theGround.render();
}
