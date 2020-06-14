class Pelican {
  PVector pos, vel, accel, accelBumpVec, accelPush, dragVec;
  float rot, radRot, rotVel;
  int wingFlapCount;
  int numWingFlaps = 3;
  float velAddPerWingFlap = 2;
  float flapScale;
  float wingFlapTimer;
  float wingFlapUpTimerInc = 15, wingFlapDownTimerInc = 4; // wingFlagUpTimerInc must be a round divisor into 90
  float airspeedFriction = 0.9975; // air speed slows down by this amount
  float accelFactor = 1.1;
  float outerBoxSize, halfOuterBoxSize;
  boolean flappingWings = false;
  Cone body;
  
  Pelican(float oBoxSize) {
    outerBoxSize = oBoxSize;
    halfOuterBoxSize = outerBoxSize / 2;
    pos = new PVector(0,0);
    //vel = new PVector(random(0,1), random(0,1));
    vel = new PVector(1,0);
    accel = new PVector(0,0);
    accelPush = new PVector(0,0);
    dragVec = new PVector(0,0);
    accelBumpVec = new PVector(0,0);
    rot = 0.0;
    rotVel = 0.0;
    body = new Cone(30,10,80);
  }
  
  float wrap(float coord, float minimum, float maximum) {
    float newVal = coord;
    if (coord >= maximum) {
      newVal = minimum;
    }
    if (coord <= minimum) {
      newVal = maximum;
    } 
    return newVal;
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
        wingFlapTimer += (wingFlapTimer < 90 ? wingFlapUpTimerInc : wingFlapDownTimerInc);
      }
      
      if (wingFlapTimer >= 180) { // reset for another flap or stop flapping
        wingFlapCount--;
        wingFlapTimer = 0;
        if (wingFlapCount == 0) {
          stopFlappingWings();
        }
      } else if (wingFlapTimer == 90) {
        accelPush.set(vel.x, vel.y);
        accelPush.normalize();
        accelPush.mult(0.1);
        accel.set(accelPush);
      } else if ((wingFlapTimer > 90)) { // wings at top of flap, start to apply downward force
        accelBumpVec.set(accel.x, accel.y);
        float accelBump = (wingFlapTimer >= 90 ? wingFlapTimer - 90: 0);
        float sinAccel = sin(radians(accelBump)) * accelFactor;
        accelBumpVec.set(accelPush);
        accelBumpVec.mult(sinAccel);
        //println ("sinAccel", sinAccel, "accelBumpVec", accelBumpVec);
        accel.add(accelBumpVec);
      }
    } else {    
       if (vel.mag() < 0.8) {
        startFlappingWings();
      }

    }
    
    dragVec.set(vel.x, vel.y);
    dragVec.mult(random(-0.01, -0.001)); // drag in the opposite direction of the velocity
    accel.add(dragVec);
    vel.add(accel);
    //vel.limit(2.5);
    pos.add(vel);
    pos.set(wrap(pos.x, -halfOuterBoxSize, halfOuterBoxSize), wrap(pos.y, -halfOuterBoxSize, halfOuterBoxSize), wrap(pos.z, -halfOuterBoxSize, halfOuterBoxSize));
    accel.mult(0);
    
    if (!flappingWings) { // no turning while flapping wings
      rotVel += max(-0.01, min(0.01,random(-0.1,0.1)));
      vel.rotate(radians(rotVel));
    }

  }
  
  void render() {
    float theta = vel.heading();
    float r = 35;
    
    pushMatrix();
    translate(pos.x, pos.y, -100);
    
    // render vector for velocity
    stroke(255,0,0);
    strokeWeight(10); 
    line (0,0,0, vel.x * r,vel.y * r,vel.z * r);
   
    strokeWeight(1);
    if (wingFlapCount > 0) {
      flapScale = 1.0 + sin(radians(wingFlapTimer));
      scale(flapScale);
    }
    fill(100,140,190);

    //rotateZ(theta);
    rotateToVector(vel);
    body.render();
    
    popMatrix();
  }
  
}
