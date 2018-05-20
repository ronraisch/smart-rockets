class Rocket{
  PVector pos,vel,acc;//simple mechanics vectors
  DNA dna;
  //booleans for the rocket's state
  boolean crashed=false;
  boolean hit=false;
  boolean bestRocket=false;
  //rocket's fitness and probability values
  float fitness=0,prob=0;
  //rocket's time for hitting the target
  int time;
  //rockets distances values
  float distance=width*width+height*height,Ydist=height,Xdist=width;
  Rocket(DNA dna){
    this.dna=dna.clone();
    pos=new PVector(width/2,height);
    acc=new PVector(0,0);
    vel=new PVector(0,0);
  }
  Rocket(){
    dna=new DNA();
    pos=new PVector(width/2,height);
    acc=new PVector(0,0);
    vel=new PVector(0,0);
  }
  void update(){
    if (!crashed && !hit){
      float d=distSq(targetX,targetY,pos.x,pos.y);
      distance=min(distance,d);
      applyForce(pol2cart(dna.genes[count]));
      if (crash()){
        crashed=true;
        Xdist=abs(pos.x-targetX);
        Ydist=abs(pos.y-targetY);
      }
      else if(hitTarget()){
        hit=true;
        anyHit=true;
        time=count;
        bestTime=min(bestTime,time);
        distance=targetR*targetR;
      }
      if (count==framesPerRun-1){
        Xdist=abs(pos.x-targetX);
        Ydist=abs(pos.y-targetY);
      }
    }
  }
  boolean hitTarget(){
    return (distSq(pos.x,pos.y,targetX,targetY)<=targetR*targetR);
  }
  boolean crash(){
    return (hitWall() || hitObstacle());
  }
  boolean hitWall(){
    return (pos.x>width || pos.x<0 || pos.y>height || pos.y<0);
  }
  boolean hitObstacle(){
    for (Obstacle obs:obstacles){
      if (obs.checkHit(pos)){
        return true;
      }
    }
    return false;
  }
  void applyForce(PVector force){
    acc.add(force);
    vel.add(acc);
    pos.add(vel);
    acc.mult(0);
  }
  void show(){
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(vel.heading());
    rect(-25,-5,50,10);
    popMatrix();
  }
  void calcFitness(){
    fitness=distScl/distance;
    if (hit){
      fitness+=timeScl/(time*time);
    }
    else{
      fitness+=exp(-Ydist);
      if (Ydist<height*goodDist){
        fitness+=exp(-Xdist);
      }
    }
  }
}