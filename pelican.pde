// TODO: 
// add updraft, crosswind or facing winds
// bird tilts up a bit while climbing. : ? is this realistic? maybe the pelicans stay level while climbing?
//   rotate vel vector up a few degrees relative to climb speed and align with the rotated vector
// actually animate wings
// Boids effects
// moving landscape



class Pelican {
  
  PVector pos, vel, gravityVel, accel, accelBumpVec, accelPush, gravityAcc, rRot;
  PVector wingTip;
  float rot, radRot, rotVel;
  float wingTipPhase;
  int wingFlapCount;
  int numWingFlaps = 3;
  float velAddPerWingFlap = 2;
  float flapScale;
  float wingFlapTimer;
  float wingFlapUpTimerInc = 15, wingFlapDownTimerInc = 4; // wingFlagUpTimerInc must be a round divisor into 90
  float airspeedFriction = 1.0 - 0.0001; // air speed slows down by this amount
  float accelFactor = 1.1;
  boolean flappingWings = false;
  float G = 0.001; // gravity constant
  float wingGBump = -200;
  Cone body;
  
  Pelican() {
    pos = new PVector(0,0);
    //vel = new PVector(random(0,1), random(0,1));
    vel = new PVector(1,0,0);
    accel = new PVector(0,0,0);
    accelPush = new PVector(0,0,0);
    gravityVel = new PVector(0,0,0);
    gravityAcc = new PVector(0,G,0);
    accelBumpVec = new PVector(0,0,0);
    wingTip = new PVector(0,0,0);
    wingTipPhase = 0;
    rRot = new PVector(0,0);
    rot = 0.0;
    rotVel = 0.0;
    body = new Cone(20,4,40);
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
        accelPush.set(vel.x, 0, vel.z);
        accelPush.normalize();
        accelPush.mult(0.1);
        accel.set(accelPush);
        gravityVel.y = wingGBump * G;
      } else if ((wingFlapTimer > 90)) { // wings at top of flap, start to apply downward force
        accelBumpVec.set(accel.x, accel.y, accel.z);
        float accelBump = (wingFlapTimer >= 90 ? wingFlapTimer - 90: 0);
        float sinAccel = sin(radians(accelBump)) * accelFactor;
        accelBumpVec.set(accelPush);
        accelBumpVec.mult(sinAccel);
        //println ("sinAccel", sinAccel, "accelBumpVec", accelBumpVec);
        accel.add(accelBumpVec);
      }
    } else {
      //println("gravityVel y", gravityVel.y);
       if (gravityVel.y > 0.2) {
        startFlappingWings();
      }

    }
    
    accel.mult(airspeedFriction);
    gravityVel.add(gravityAcc);
    vel.add(accel);
    vel.limit(2);
    pos.add(vel);
    pos.add(gravityVel);
    pos.set(wrap(pos.x, -halfOuterBoxSize, halfOuterBoxSize), wrap(pos.y, -halfOuterBoxSize, halfOuterBoxSize), wrap(pos.z, -halfOuterBoxSize, halfOuterBoxSize));
    accel.mult(0);
    
    if (!flappingWings) { // no turning while flapping wings
      //rotVel += max(-0.01, min(0.01,random(-0.1,0.1)));
      rotVel += random(-0.005,0.005);
      rRot.set(vel.x, vel.z);
      rRot.rotate(radians(rotVel));
      vel.x = rRot.x;
      vel.y = rRot.z;
    }

  }
  
  void render() {
    //float theta = vel.heading();
    float r = 35;
    
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    
    // render vector for velocity
    stroke(255,0,0);
    //strokeWeight(10); 
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
    
    strokeWeight(10);
    stroke(0,0,255);
    wingTipPhase += 0.05;
    float wingTipRot = map(sin(wingTipPhase),-1,1,-75,75);
    println("wingTipPhase", wingTipPhase, "wingTipRot", wingTipRot);
    wingTip.set(cos(radians(wingTipRot)), sin(radians(wingTipRot)),0);
    wingTip.mult(100);
    line(0,0,0, wingTip.x, wingTip.y, wingTip.z);
  }
  
}
