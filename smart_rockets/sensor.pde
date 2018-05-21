class Sensor {
  PVector pos, vel, origin;
  Sensor() {
    origin=new PVector();
    vel=new PVector();
    pos=new PVector();
  }
  void updateSensor(PVector newPos,float angle){
    origin=newPos.copy();
    pos=newPos.copy();
    vel.set(1,0);
    vel.rotate(angle);
    vel.mult(delta);
  }
  boolean hit(){
    for (Obstacle obs:obstacles){
      if (obs.checkHit(pos)){
        return true;
      }
    }
    return (pos.x>width || pos.x<0 || pos.y>height || pos.y<0);
  }
  float calcDist(){
    //stroke(255,0,0);
    while(!hit()){
      pos.add(vel);
      //point(pos.x,pos.y);
    }
    return distSq(pos.x,pos.y,origin.x,origin.y);
  }
}