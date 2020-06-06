int numPelicans = 1;
Pelican[] pelicans;
  
void setup() {
  size(500,500);
  pelicans = new Pelican[numPelicans];

  for (int i = 0; i < numPelicans; ++i) {
    pelicans[i] = new Pelican();
  }
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
}
