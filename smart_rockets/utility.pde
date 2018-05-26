PVector pol2cart(PVector v) {
  PVector u=new PVector(1, 0);
  u.rotate(v.y);
  u.mult(v.x);
  return u;
}
float distSq(float x1, float y1, float x2, float y2) {
  return (x1-x2)*(x1-x2)+(y1-y2)*(y1-y2);
}
void changeMutation() {
  if (anyHit && !prevHit) {
    mutationRate/=4;
    MCF/=2;
    MCA/=5;
  } else if (prevHit && !anyHit) {
    mutationRate*=2;
    MCF*=2;
    MCA*=2;
  }
}
void showObstacles() {
  fill(255);
  for (Obstacle obs : obstacles) {
    obs.show();
  }
  if (mousePressed && addObstacle) {
    rect(x, y, mouseX-x, mouseY-y);
  }
}
void showTarget() {
  fill(200, 80, 50);
  ellipse(targetX, targetY, 2*targetR, 2*targetR);
}
boolean buttonsPressed() {
  return (showBest.clicked() || savePop.clicked() || moveTarget.clicked() || train.clicked());
}
void buttonStuff() {
  showBest.show();
  savePop.show();
  moveTarget.show();
  train.show();
  if (showBest.actuallyClicked) {
    showBestRocket=!showBestRocket;
    if (showBest.txt=="show best") {
      showBest.txt="show all";
    } else {
      showBest.txt="show best";
    }
  }
  if (savePop.actuallyClicked && keyPressed) {
    NNpopulation.savePop();
  }
  if (moveTarget.actuallyClicked) {
    movingTarget=true;
  }
  if (movingTarget) {
    targetX=mouseX;
    targetY=mouseY;
  }
  if (train.actuallyClicked) {
    training=!training;
    if (training)
      println("training population");
    else
      println("stopped training");
  }
}
void popStuff() {
  if (!showBestRocket) {
    population.calcFrames(ceil(rateSlider.value()));
  } else {
    population.calcFrameBest();
  }
}
void NNpopStuff() {
  if (!showBestRocket) {
    NNpopulation.calcFrames(ceil(rateSlider.value()));
  } else {
    NNpopulation.calcFrameBest();
  }
}
void texts() {
  text("generation:"+generation, 20, height-20);
  text("best time:"+bestTime, 20, height-10);
  text("succes rate:"+succes+"%", 20, height);
}
//activation function
float activationFunction(float x) {
  return maxValue*x/(1+abs(x));
}
void block() {
  framesPerRun=originalFPR;
  bestTime=framesPerRun+1;
  obstacles.clear();
  obstacles.add(new Obstacle(width/4, height/4, 3*width/4, 3*height/4));
}
void noObstacles() {
  framesPerRun=originalFPR;
  bestTime=framesPerRun+1;
  obstacles.clear();
}
void narrow() {
  framesPerRun=originalFPR;
  bestTime=framesPerRun+1;
  obstacles.clear();
  obstacles.add(new Obstacle(0, height/18, width/2-gap, height*4/5));
  obstacles.add(new Obstacle(width/2+gap, height/18, width, height*4/5));
}
void levels() {
  framesPerRun=originalFPR;
  bestTime=framesPerRun+1;
  obstacles.clear();
  obstacles.add(new Obstacle(0, height*7/10, width*3/4, height*6/10));
  obstacles.add(new Obstacle(width, height*8/20, width/4, height*6/20));
}
void rightBlock() {
  framesPerRun=originalFPR;
  bestTime=framesPerRun+1;
  obstacles.clear();
  obstacles.add(new Obstacle(width/3, height/6, width, height*3/4));
}
void leftBlock() {
  framesPerRun=originalFPR;
  bestTime=framesPerRun+1;
  obstacles.clear();
  obstacles.add(new Obstacle(0, height/6, width*2/3, height*3/4));
}
void bigBlock() {
  obstacles.clear();
  obstacles.add(new Obstacle(width/10, height/6, width*9/10, height*4/5));
}
void smiley() {
  block();
  obstacles.add(new Obstacle(width/10*3, height/20, width*2/5, height/6));
  obstacles.add(new Obstacle(width/5*3, height/20, width/10*7, height/6));
}
void centerOfMass() {
  fill(255, 140, 0);
  centerOfMass=NNpopulation.calcCenter();
  if (lastGenCenter==generation) {
    float d=distSq(centerOfMass.x, centerOfMass.y, targetX, targetY);
    centerDist=min(d, centerDist);
  } else {
    centerDist=maxDist;
  }
  lastGenCenter=generation;
  ellipse(centerOfMass.x, centerOfMass.y, 16, 16);
}
void calcStuck(){
  if (succes>0) {
    stuckCount=0;
  } else {
    stuckCount++;
  }
  if (levelMod==0){
    stuckLimit=10;
  }
  else if (levelMod==1){
    stuckLimit=25;
  }
  else if (levelMod==2){
    stuckLimit=75;
  }
  else if (levelMod==3){
    stuckLimit=45;
  }
  else if (levelMod==4){
    stuckLimit=350;
  }
  else if (levelMod==5){
    stuckLimit=65;
  }
  else if (levelMod==6){
    stuckLimit=150;
  }
  else if (levelMod==7){
    stuckLimit=250;
  }
  if (stuckCount>stuckLimit){
    println("stuck at level:"+levelMod);
    if (levelMod==1){
      levelMod=0;
      noObstacles();
    }
    else{
      levelMod=1;
      block();
    }
  }
}
void trainPopulation() {
  //calcStuck();
  if (levelsPassed<50000) {
    if (succes<2.0/nnRockets) {
      gen=-1;
    } else if ((generation-gen)>5 && levelMod==1) {
      if (centerDist<40000 || succes>15) {
        float r=random(1);
        levelsPassed++;
        //lastGenSucces=generation;
        //lastPop=NNpopulation.clone();
        if (r<0.05) {
          levelMod=0;
          noObstacles();
          gen=-1;
        } else if (r<0.35) {
          levelMod=2;
          smiley();
          gen=-1;
        } else if (r<0.55) {
          levelMod=3;
          narrow();
          gen=-1;
        } else {
          passedBoth=min(passedRight, passedLeft);
          if (passedBoth>6 && generation>300) {
            //if (random(1)<0.5) {
              levelMod=4;
              levels();
              gen=-1;
            //} else {
            //  levelMod=7;
            //  bigBlock();
            //  gen=-1;
            //}
          } else {
            if (random(1)<0.5 && (passedRight-passedLeft)<3) {
              rightBlock();
              passedRight++;
              levelMod=5;
              gen=-1;
            } else {
              levelMod=6;
              gen=-1;
              passedLeft++;
              leftBlock();
            }
          }
        }
      } else {
        levelMod=0;
        gen=-1;
        noObstacles();
      }
    } else if (succes>=2.0/nnRockets && gen==-1) {
      gen=generation;
    } else if ((generation-gen)>5 || ((generation-gen)>1 && (levelMod==0)) || ((generation-gen)>3 && levelMod==1 && generation>20)) {
      println("level passed:"+levelMod+", generation:"+generation+", levels passed:"+levelsPassed);
      levelMod=1;
      gen=-1;
      block();
    }
  }
}
