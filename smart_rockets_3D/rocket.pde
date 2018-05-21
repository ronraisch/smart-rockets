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
  //rocket's ranking
  int rank=nnRockets;
  //rockets distances values
  float distance=maxDist,Ydist=height,Xdist=width;
  //rocket's sensors
  Sensor[] sensors; 
  Rocket(DNA dna){
    this.dna=dna.clone();
    pos=new PVector(width/2,height-2,zOff-2);
    acc=new PVector(0,0,0);
    vel=new PVector(0,-0.01,0);
    sensors=new Sensor[numOfSensors];
    for (int i=0;i<numOfSensors;i++){
      sensors[i]=new Sensor();
    }
  }
  Rocket(){
    dna=new DNA(inputN,hiddenN,outputN);
    pos=new PVector(width/2,height-2,zOff-2);
    acc=new PVector(0,0,0);
    vel=new PVector(0,-0.01,0);
    sensors=new Sensor[numOfSensors];
    for (int i=0;i<numOfSensors;i++){
      sensors[i]=new Sensor();
    }
  }
  PVector calcForce(){
    float[] input=new float[inputN];
    //updating sensors
    for (int i=0;i<numOfSensors;i++){
      sensors[i].updateSensor(pos,2*PI/numOfSensors*i+vel.heading());
      input[i]=sqrt(sensors[i].calcDist()/maxDist);
    }
    //adding more inputs
    input[numOfSensors]=pos.x/width;
    input[numOfSensors+1]=pos.y/height;
    input[numOfSensors+2]=vel.mag()/maxVel;
    input[numOfSensors+3]=vel.heading()/PI;
    //input[numOfSensors+6]=targetX/width;
    //input[numOfSensors+7]=targetY/height;
    PVector direction=PVector.sub(new PVector(targetX,targetY),pos);
    input[numOfSensors+4]=direction.heading()/PI;
    input[numOfSensors+5]=sqrt(direction.magSq()/maxDist);
    //calculating output
    float[] output=dna.genes.output(input);
    PVector force=new PVector(output[0]*forceMag/activationFunction(1),output[1]*angleRange/activationFunction(1),output[2]*angleRange/activationFunction(1));
    return pol2cart(force);
  }
  void update(){
    if (!crashed && !hit){
      float d=distSq(targetX,targetY,targetZ,pos.x,pos.y,pos.z);
      distance=min(distance,d);
      applyForce(calcForce());
      if (crash()){
        crashed=true;
        Xdist=abs(pos.x-targetX);
        Ydist=abs(pos.y-targetY);
      }
      else if(hitTarget()){
        hit=true;
        time=count;
        bestTime=min(bestTime,time);
        distance=targetR*targetR;
      }
      if (count>=framesPerRun-2-rateSlider.value){
        Xdist=abs(pos.x-targetX);
        Ydist=abs(pos.y-targetY);
      }
    }
  }
  boolean hitTarget(){
    return (distance<=targetR*targetR);
  }
  boolean crash(){
    //return (hitWall() || hitObstacle());
    return (hitWall() && limitWorld);
  }
  boolean hitWall(){
    return (pos.x>width || pos.x<0 || pos.y>height || pos.y<0);
  }
  //boolean hitObstacle(){
  //  for (Obstacle obs:obstacles){
  //    if (obs.checkHit(pos)){
  //      return true;
  //    }
  //  }
  //  return false;
  //}
  void applyForce(PVector force){
    force.limit(forceMag);
    acc.add(force);
    vel.add(acc);
    vel.limit(maxVel);
    pos.add(vel);
    acc.mult(0);
  }
  void show(){
    pushMatrix();
    translate(pos.x-width/2,pos.y-height/2,pos.z);
    //rotateX(acos(vel.x)/sqrt(vel.x*vel.x+vel.y*vel.y));
    //rotateY(acos(vel.y)/sqrt(vel.x*vel.x+vel.y*vel.y));
    //rotateZ(asin(vel.z));
    box(10);
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