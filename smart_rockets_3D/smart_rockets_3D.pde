float mutationRate=0.03;
float maxMutationRate=0.1;
float NNMC=0.1;
float maxMCA=1;
float maxValue=10;
float minValue=-10;
float forceMag=1;
float angleRange=2*PI;
float bestDist;
float prevDist;
float delta=1;
float maxVel=10;
int originalFPR=400;
int framesPerRun=originalFPR;
int numOfSensors=6;
int inputN=6+numOfSensors;
int outputN=3;
int hiddenN=6;
int count=0;
float targetX, targetY, targetR,targetZ;
ArrayList<Obstacle> obstacles;
int nnRockets=100;
Population Population;
int x, y,mouseZ,z=0;
float Xrotation=0,Yrotation=0,Zrotation=0;
float distScl, timeScl;
float goodDist=0.05;
float maxDist;
float maxFitness=0;
float zOff=600;
int generation=0;
boolean addObstacle=true;
boolean limitWorld=true;
int bestTime=framesPerRun+1;
Slider rateSlider;
Rocket r=new Rocket();
void setup() {
  size(800, 600,P3D);
  bestDist=width*width+height*height+zOff*zOff;
  prevDist=bestDist;
  maxDist=bestDist;
  targetX=width/2;
  targetY=50;
  targetR=10;
  targetZ=20;
  rateSlider=new Slider(0, 3, 0, 100, 20, 20, height-50);
  noStroke();
  Population=new Population();
  obstacles=new ArrayList<Obstacle>();
  fill(255);
  distScl=goodDist*goodDist*maxDist/exp(1);
  timeScl=2*distScl*framesPerRun*framesPerRun/(targetR*targetR);
  //randomSeed(1);
}
void draw() {
  background(0);
  pushMatrix();
  translate(width/2,height/2,zOff/2+z);
  noFill();
  strokeWeight(4);
  stroke(240);
  rotateX(Xrotation);
  rotateY(Yrotation);
  box(width,height,zOff);
  popMatrix();
  translate(0,0,z);
  strokeWeight(1);
  noStroke();
  //r.pos.x=mouseX;
  //r.pos.y=mouseY;
  //r.vel.rotate(noise(frameCount)/100);
  //r.show();
  //for (int i=0;i<numOfSensors;i++){
  //  r.sensors[i].updateSensor(r.pos,r.vel.heading());
  //  r.sensors[i].calcDist();
  //}
  //PVector direction=PVector.sub(new PVector(targetX,targetY),r.pos);
  //println(direction.heading()/PI);
  keyDown();
  rateSlider.show();
  texts();
  translate(width/2,height/2,z);
  rotateX(Xrotation);
  rotateY(Yrotation);
  //rotateY(frameCount/100.0);
  showTarget();
  popStuff();
  showObstacles();
  //println(frameRate);
}
void keyDown(){
  if (keyPressed){
    if (keyCode==LEFT){
      Yrotation+=0.1;
    }
    else if (keyCode==RIGHT){
      Yrotation-=0.1;
    }
    else if (keyCode==UP){
      Xrotation+=0.1;
    }
    else if (keyCode==DOWN){
      Xrotation-=0.1;
    }
  }
}
void mousePressed() {
  if (!rateSlider.clicked() && !keyPressed) {
    x=mouseX;
    y=mouseY;
    mouseZ=z;
    addObstacle=true;
  } else {
    addObstacle=false;
  }
}

void mouseReleased() {
  if (addObstacle){
    framesPerRun=originalFPR;
    bestTime=framesPerRun+1;
    obstacles.add(new Obstacle(x, y,z, mouseX, mouseY,mouseZ));
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if (e>0){
    z-=30;
  }
  else{
    z+=30;
  }
}