// TODO:
// actually animate wings
// easing function
// fix Hands during wings at rest, they should point down.
// bird tilts up a bit while climbing. : ? is this realistic? maybe the pelicans stay level while climbing?
//   rotate vel vector up a few degrees relative to climb speed and align with the rotated vector
// wings transcribe oval front-to-back while flapping in addition to up and down
// wings are polygons
// add actual pelican body
// add updraft, crosswind or facing winds
// Boids effects
// moving landscape



class Pelican {

  PVector pos, vel, gravityVel, accel, accelBumpVec, accelPush, gravityAcc, rRot;
  PVector wingHumerus, wingUlna, wingHand, wingJoint1, wingJoint2;
  float rot, radRot, rotVel;
  int wingTipPhase;
  int wingTipPhaseSpeed = 6;  // todo: replace with easing fn
  int degreeFactor = 2; 
  int wingTipPhaseMax = 360 * degreeFactor;
  int wingTipsAtRest = 250 * degreeFactor;
  int wingFlapCount;
  int numWingFlaps = 3;
  float wingFlapUpTimerInc = 15, wingFlapDownTimerInc = 4; // wingFlagUpTimerInc must be a round divisor into 90
  float airspeedFriction = 1.0 - 0.0001; // air speed slows down by this amount
  float accelFactor = 1.1;
  boolean flappingWings = false;
  boolean accelPushSet = false;
  float G = 0.001; // gravity constant
  float wingGBump = -200;
  float [] func1Vals;
  float [] func2Vals;
  float [] func3Vals;
  int [] easingIndexes;
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
    wingHumerus = new PVector(0,0,0);
    wingUlna = new PVector(0,0,0);
    wingHand = new PVector(0,0,0);
    wingJoint1 = new PVector(0,0,0);
    wingJoint2 = new PVector(0,0,0);

    wingTipPhase = wingTipsAtRest;
    rRot = new PVector(0,0);
    rot = 0.0;
    rotVel = 0.0;
    body = new Cone(20,4,40);
    float degreeIncrement = (1 / (float) degreeFactor); // how much we divide each degree of the unit circle when storing precalculated wing rot function values
    int numDegreeIncrements = degreeFactor * 360;
    int i;
    func1Vals = new float[numDegreeIncrements];
    func2Vals = new float[numDegreeIncrements];
    func3Vals = new float[numDegreeIncrements];
    easingIndexes = new int[numDegreeIncrements];
    int [] unshiftedEasingIndexes = new int[numDegreeIncrements];
    float iDegree = 0, iMapped;
    for (i = 0; i < numDegreeIncrements; i++) {
      func1Vals[i] = wingTipRotFunc1(iDegree);
      func2Vals[i] = wingTipRotFunc2(iDegree);
      func3Vals[i] = wingTipRotFunc3(iDegree);
      iDegree = iDegree + degreeIncrement;
      unshiftedEasingIndexes[i] = (int) map2((float) i, 0, (float) numDegreeIncrements  - 1, 0, (float) numDegreeIncrements - 1, QUARTIC, EASE_IN_OUT);
    }
    
     // rotate easing array so that its start is around the wingTipsAtRest index
     for (i = wingTipsAtRest; i < numDegreeIncrements; ++i) {
       easingIndexes[i - wingTipsAtRest] = unshiftedEasingIndexes[i];
     }
     for (i = 0; i < wingTipsAtRest; ++i) {
       easingIndexes[numDegreeIncrements - wingTipsAtRest + i] = unshiftedEasingIndexes[i];
     }

     for (i = 0; i < numDegreeIncrements; ++i) {
       print("[", i, ",", easingIndexes[i], "] ");
     }

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
    flappingWings = true;
  }

  void stopFlappingWings() {
    flappingWings = false;
  }
  
  void applyAccelPush() {
    if (!accelPushSet) {
      accelPush.set(vel.x, 0, vel.z);
      accelPush.normalize();
      accelPush.mult(0.1);
      accel.set(accelPush);
      gravityVel.y = wingGBump * G;
      accelPushSet = true;
    }

    accelBumpVec.set(accel.x, accel.y, accel.z);
    float wingTipRange = (float) wingTipPhase / degreeFactor;
    float accelBump = (wingTipRange >= 180 ? (wingTipRange - 180): 0);
    float sinAccel = sin(radians(accelBump)) * accelFactor;
    accelBumpVec.set(accelPush);
    accelBumpVec.mult(sinAccel);
    accel.add(accelBumpVec);
  }
  
  void resetAccelPush() {
    accelPushSet = false;
  }
  
  void turn() {
   if (!flappingWings) { // no turning while flapping wings
      //rotVel += max(-0.01, min(0.01,random(-0.1,0.1)));
      rotVel += random(-0.005,0.005);
      rRot.set(vel.x, vel.z);
      rRot.rotate(radians(rotVel));
      vel.x = rRot.x;
      vel.z = rRot.y;
      //println("rRot", rRot, vel);
    }
  }
  
  void update() {
    radRot = radians(rot);

    if (gravityVel.y > 0.2  && !flappingWings) {
        startFlappingWings();
    }

    accel.mult(airspeedFriction);
    gravityVel.add(gravityAcc);
    vel.add(accel);
    vel.limit(2);
    pos.add(vel);
    pos.add(gravityVel);
    pos.set(wrap(pos.x, -halfOuterBoxSize, halfOuterBoxSize), wrap(pos.y, -halfOuterBoxSize, halfOuterBoxSize), wrap(pos.z, -halfOuterBoxSize, halfOuterBoxSize));
    accel.mult(0);

    //turn();

  }

  // apparently, as i learned from Zach Lieberman, you can also square off a sin wave by running it through itself a few times ala f(x) = PI/2 * sin(x), 
  // then. return f(f(x));
  float wingTipRotFunc1(float wingTipPhase) {
    return (sin(PI/3 * cos(radians(wingTipPhase))));
  }

  // got this idea from : https://math.stackexchange.com/questions/100655/cosine-esque-function-with-flat-peaks-and-valleys
  float wingTipRotFunc2(float wingTipPhase) {
    float cosX = cos(radians(wingTipPhase));
    float b = 1;
    float bSquared = b * b;
    float result = sqrt( ( 1 + bSquared) / (1 + bSquared * cosX * cosX ) )  * cosX;
    return result;
  }

  float wingTipRotFunc3(float wingTipPhase) {
    float sinX = sin(radians(wingTipPhase));
    float sinXMinusPi = sin(radians(wingTipPhase) - PI);
    float b = 0.75;
    float bSquared = b * b;
    float result = sqrt( ( 1 + bSquared) / (1 + bSquared * sinX * sinX ) )  * sinXMinusPi;
    return result;
  }

  int wrapWingTipPhase(int phase) {
    if (phase < 0) {
      return wingTipPhaseMax + phase;
    } else if (phase >= wingTipPhaseMax) {
      return phase - wingTipPhaseMax;
    }
    return phase;
  }
  

  void renderWings() {
    int wingTipInc1 = wingTipPhaseSpeed;
    int wingTipInc2 = wingTipInc1 + 2;
    int currentWingTipPhase;

    rotateY(PI/2);
    translate(0,0,-10);
    strokeWeight(10);

    if (flappingWings) {
      currentWingTipPhase = wingTipPhase;
      if (wingTipPhase < 180 * degreeFactor) {
        wingTipPhase = wrapWingTipPhase(wingTipPhase + wingTipInc1);
      } else {
        applyAccelPush();
        wingTipPhase = wrapWingTipPhase(wingTipPhase + wingTipInc2); // wing downstroke faster than upstroke, looks more natural-like ya know
      }
      
      //println("wingTipPhase", wingTipPhase, "wingTipsAtRest", wingTipsAtRest);
      if (wingTipPhase >= wingTipsAtRest && currentWingTipPhase < wingTipsAtRest) {
        //println("Resetting wingTipPhase");
        resetAccelPush();
        wingFlapCount--;
        if (wingFlapCount == 0) {
          stopFlappingWings();
        }
      }
    } else {
      wingTipPhase = wingTipsAtRest;
    }
    
    float wingHumerusRot = map(func1Vals[easingIndexes[wingTipPhase]],-1,1,-65,40);
    wingHumerus.set(cos(radians(wingHumerusRot)), sin(radians(wingHumerusRot)),0);
    //println(wingTipPhase, wingHumerus.x, wingHumerus.y);
    wingHumerus.mult(40); //<>//
    wingJoint1.set(0,0,0);
    wingJoint2.set(0,0,0);
    stroke(255,0,0);
    line(wingJoint1.x, wingJoint1.y, wingJoint1.z, wingHumerus.x, wingHumerus.y, wingHumerus.z);
    line(wingJoint2.x, wingJoint2.y, wingJoint2.z, -wingHumerus.x, wingHumerus.y, wingHumerus.z);
    wingJoint1.set(wingHumerus.x, wingHumerus.y, wingHumerus.z);
    wingJoint2.set(-wingHumerus.x, wingHumerus.y, wingHumerus.z);

    float wingUlnaRot = map(func2Vals[easingIndexes[wrapWingTipPhase(wingTipPhase-10)]],-1,1,-55,45);
    wingUlna.set(cos(radians(wingUlnaRot)), sin(radians(wingUlnaRot)),0);
    wingUlna.mult(55);
    stroke(0,255,0);
    line(wingJoint1.x, wingJoint1.y, wingJoint1.z, wingJoint1.x + wingUlna.x, wingJoint1.y + wingUlna.y, wingJoint1.z + wingUlna.z);
    line(wingJoint2.x, wingJoint2.y, wingJoint2.z, wingJoint2.x - wingUlna.x, wingJoint2.y + wingUlna.y, wingJoint2.z + wingUlna.z);
    wingJoint1.set(wingJoint1.x + wingUlna.x, wingJoint1.y + wingUlna.y, wingJoint1.z + wingUlna.z);
    wingJoint2.set(wingJoint2.x - wingUlna.x, wingJoint2.y + wingUlna.y, wingJoint2.z + wingUlna.z);

    float wingHandRot =  map(func3Vals[easingIndexes[wrapWingTipPhase(wingTipPhase + 45)]],-1,1,-65,75);
    wingHand.set(cos(radians(wingHandRot)), sin(radians(wingHandRot)),0);
    wingHand.mult(20);
    stroke(0,0,255);
    line(wingJoint1.x, wingJoint1.y, wingJoint1.z, wingJoint1.x + wingHand.x, wingJoint1.y - wingHand.y, wingJoint1.z + wingHand.z);
    line(wingJoint2.x, wingJoint2.y, wingJoint2.z, wingJoint2.x - wingHand.x, wingJoint2.y - wingHand.y, wingJoint2.z + wingHand.z);

    strokeWeight(1);

    // hand flap:
    // -1/2 * sin( pi / 2 * cos(x - pi/2)))
    // hand flap 2
    // exp(- ((1.5x) ^ 6))
    // another alternate arm flap
    // \sqrt{\frac{\left(1+b^{2}\right)}{\left(1+b^{2}\cdot\cos^{2}x\right)}\ }\cos x
    // sqrt( ( 1 + b^2) / (1 + b^2 * cos(x) * cos(x) ) )  * cos(x)
    // \frac{-1}{3}\sin\left(\frac{\pi}{2}\cos\left(x-\frac{\pi}{2}\right)\right)
    // alternate arm flap: abs(cos(1.5x)^5)
    // weird very square graph with discontinuities:
    // 3 * cos(x) ^ (1/25)
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
    fill(100,140,190);

    //rotateZ(theta);
    rotateToVector(vel);
    body.render();

    renderWings();

    popMatrix();

  }

}
