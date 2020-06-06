class Bird {
  PVector pos, vel, accel, accelBumpVec, dragVec;
  float rot, radRot, rotVel;
  int wingFlapCount;
  int numWingFlaps = 3;
  float velAddPerWingFlap = 2;
  float flapScale;
  float wingFlapTimer, wingFlapTimerInc = 2;
  float airspeedFriction = 0.9975; // air speed slows down by this amount
  float accelFactor = 2;
  boolean flappingWings = false;
  
  Bird() {
    pos = new PVector(width / 2, height / 2);
    //vel = new PVector(random(0,1), random(0,1));
    vel = new PVector(1,0);
    accel = new PVector(0,0);
    dragVec = new PVector(0,0);
    accelBumpVec = new PVector(0,0);
    rot = 0.0;
    rotVel = 0.0;
  }
  
  void wrap() {
    if (pos.x > width) {
      pos.x = 0;
    } else if (pos.x < 0) {
      pos.x = width;
    }
    
    if (pos.y > height) {
      pos.y = 0;
    } else if (pos.y < 0) {
      pos.y = height;
    }
  }
  
  void startFlappingWings() {
    wingFlapCount = int(random(1,numWingFlaps));
    wingFlapTimer = 0;
    flappingWings = true;
  }
  
  void stopFlappingWings() {
    flappingWings = false;
  }
  
  void update() {
   
     radRot = radians(rot);
   
    if (flappingWings) {
      //println("not updating rot");
      if (wingFlapTimer < 360) {
        wingFlapTimer += wingFlapTimerInc;
      }
      
      if (wingFlapTimer >= 180) { // reset for another flap or stop flapping
        wingFlapCount--;
        wingFlapTimer = 0;
        if (wingFlapCount == 0) {
          stopFlappingWings();
        }
      } else if (wingFlapTimer == 90) {
        accel.set(cos(radRot),sin(radRot));
      } else if ((wingFlapTimer > 90)) { // wings at top of flap, start to apply downward force
        //accel.set(cos(radRot),sin(radRot));
        accelBumpVec.set(accel.x, accel.y);
        float accelBump = (wingFlapTimer >= 90 ? wingFlapTimer + 45: 0);
        accelBumpVec.mult(sin(radians(accelBump)) * accelFactor);
        accel.add(accelBumpVec);
      }
    } else {    
       if (vel.mag() < 0.8) {
        startFlappingWings();
      }

    }
    
    dragVec.set(vel.x, vel.y);
    dragVec.mult(-0.01); // drag in the opposite direction of the velocity
    accel.add(dragVec);
    //println("accel", accel);
    vel.add(accel);
    //vel.limit(2.5);
    pos.add(vel);
    //println("vel", vel);
    wrap();
    accel.mult(0);
    
    if (!flappingWings) { // no turning while flapping wings
      rotVel += max(-0.02, min(0.02,random(-0.1,0.1)));
      rotVel = random(-5,5);
      rot = max(-20, min(20,rotVel + rot));
    }
    //println("updating rot", rot, "with rotvel", rotVel);

  }
  
  void render() {
    float theta = vel.heading() + PI/2;
    float r = 5;
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(theta);
    if (wingFlapCount > 0) {
      flapScale = 1.0 + sin(radians(wingFlapTimer));
      scale(flapScale);
    }
    noStroke();
    fill(255);
    beginShape();
    vertex(0, -r*2);
    vertex(-r*1.5, r*1.25);
    vertex(0, 0);
    vertex(r*1.5, r*1.25);
    endShape(CLOSE);
    popMatrix();
  }
  
}
