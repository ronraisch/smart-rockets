class Sensor {
  PVector pos, vel, origin;
  Sensor() {
    origin=new PVector();
    vel=new PVector();
    pos=new PVector();
  }
  void updateSensor(PVector newPos, float angle) {
    origin=newPos.copy();
    pos=newPos.copy();
    vel.set(1, 0);
    vel.rotate(angle);
    vel.mult(delta);
  }
  boolean hit() {
    for (Obstacle obs : obstacles) {
      if (obs.checkHit(pos)) {
        return true;
      }
    }
    return (pos.x>width || pos.x<0 || pos.y>height || pos.y<0);
  }
  float calcDist() {
    //stroke(255, 0, 0);
    pos.add(vel);
    while (!hit()) {
      pos.add(vel);
      //point(pos.x, pos.y);
    }
    float diff=delta*delta;
    float scl=0.5;
    int mod=1;
    float x, y;
    
    vel.mult(-scl);
    boolean prevState=hit();
    while (diff>sensorPrecision*sensorPrecision) {
      x=pos.x;
      y=pos.y;
      prevState=hit();
      pos.add(vel);
      if (hit()!=prevState) {
        mod=-1;
      }
      else{
        mod=1;
      }
      vel.mult(mod*scl);
      //point(pos.x, pos.y);
      diff=distSq(pos.x, pos.y, x, y);
    }
    //stroke(100, 100, 200);
    //strokeWeight(6);
    //point(pos.x, pos.y);
    //strokeWeight(1);
    return distSq(pos.x, pos.y, origin.x, origin.y);
  }
}
