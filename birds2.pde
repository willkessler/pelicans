int numBirds = 1;
Bird[] birds;
  
void setup() {
  size(500,500);
  birds = new Bird[numBirds];

  for (int i = 0; i < numBirds; ++i) {
    birds[i] = new Bird();
  }
}

void updateBirds() {
  for (Bird b : birds) {
    b.update();
  }
}

void renderBirds() {
  for (Bird b : birds) {
    b.render();
  }
}


void draw() {
  background(0,0,0);
  updateBirds();
  renderBirds();
}
