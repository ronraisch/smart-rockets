class NNRocket{
  PVector pos,vel,acc;//simple mechanics vectors
  NNdna dna;
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
  NNRocket(NNdna dna){
    this.dna=dna.clone();
    pos=new PVector(width/2,height-2);
    acc=new PVector(0,0);
    vel=new PVector(0,-0.01);
    sensors=new Sensor[numOfSensors];
    for (int i=0;i<numOfSensors;i++){
      sensors[i]=new Sensor();
    }
  }
  NNRocket(){
    dna=new NNdna(inputN,hidden1N,hidden2N,outputN);
    pos=new PVector(width/2,height-2);
    acc=new PVector(0,0);
    vel=new PVector(0,-0.01);
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
    //input[numOfSensors]=pos.x/width;
    //input[numOfSensors+1]=pos.y/height;
    input[numOfSensors]=vel.mag()/maxVel;
    input[numOfSensors+1]=vel.heading()/PI;
    //input[numOfSensors+6]=targetX/width;
    //input[numOfSensors+7]=targetY/height;
    PVector direction=PVector.sub(new PVector(targetX,targetY),pos);
    input[numOfSensors+2]=direction.heading()/PI;
    input[numOfSensors+3]=sqrt(direction.magSq()/maxDist);
    //calculating output
    float[] output=dna.genes.output(input);
    PVector force=new PVector(output[0]*forceMag/activationFunction(maxValue),output[1]*angleRange/activationFunction(maxValue));
    force=pol2cart(force);
    force.add(calcFriction());
    return force;
  }
  PVector calcFriction(){
    PVector fric=new PVector(1,0);
    fric.rotate(vel.heading()+PI);
    fric.mult(mu*weight);
    return fric;
  }
  void update(){
    if (!crashed && !hit){
      float d=distSq(targetX,targetY,pos.x,pos.y);
      distance=min(distance,d);
      applyForce(calcForce());
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
      if (count>=framesPerRun-2-rateSlider.value){
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
  NNRocket clone(){
    return new NNRocket(dna);
  }
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
