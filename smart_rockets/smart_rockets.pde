float mutationRate=0.03;
float maxMutationRate=0.1;
float MCF=0.2;
float MCA=0.15;
float NNMC=0.1;
float maxMCA=1;
float maxValue=10;
float minValue=-10;
float forceMag=1;
float angleRange=2*PI;
float bestDist;
float prevDist;
float delta=40;
float sensorPrecision=0.1;
float maxVel=10;
int originalFPR=400;
int framesPerRun=originalFPR;
int numOfSensors=6;
int inputN=4+numOfSensors;
int outputN=2;
int hidden1N=6;
int hidden2N=6;
int count=0;
int weight=10;
float mu=0.1;
float targetX, targetY, targetR;
ArrayList<Obstacle> obstacles;
int nRockets=1000;
int nnRockets=100;
Population population;
NNPopulation NNpopulation;
int x, y;
float distScl, timeScl;
float goodDist=0.05;
float maxDist;
float maxFitness=0;
int stuckCount=0;
int stuckLimit=100;
int generation=0;
boolean movingTarget=false;
boolean addObstacle=true;
boolean showBestRocket=false;
boolean anyHit=false, prevHit=false;
int bestTime=framesPerRun+1;
Slider rateSlider;
NNRocket r=new NNRocket();
Button savePop;
Button showBest;
Button moveTarget;
void setup() {
  size(800, 600);
  bestDist=width*width+height*height;
  prevDist=bestDist;
  maxDist=bestDist;
  targetX=width/2;
  targetY=50;
  targetR=10;
  moveTarget=new Button(20,height-110,64,16,"move target");
  savePop=new Button(20, height-90, 84, 16, "save population");
  showBest=new Button(20, height-70, 54, 16, "show best");
  rateSlider=new Slider(0, 30, 0, 100, 20, 20, height-50);
  noStroke();
  population=new Population();
  NNpopulation=new NNPopulation();
  obstacles=new ArrayList<Obstacle>();
  fill(255);
  distScl=goodDist*goodDist*maxDist/exp(1);
  timeScl=2*distScl*framesPerRun*framesPerRun/(targetR*targetR);
  randomSeed(1);
}
void draw() {
  background(0);
  //r.pos.x=mouseX;
  //r.pos.y=mouseY;
  ////r.vel.rotate(noise(frameCount)/100);
  //r.show();
  //r.sensors[0].updateSensor(r.pos,r.vel.heading());
  ////PVector direction=PVector.sub(new PVector(targetX,targetY),r.pos);
  //println(sqrt(r.sensors[0].calcDist()));
  showTarget();
  buttonStuff();
  NNpopStuff();
  showObstacles();
  rateSlider.show();
  texts();
  //if (frameCount%4==0) {
   // saveFrame("training/#####.tif");
  //}
  println(frameRate);
}
void mousePressed() {
  if (!rateSlider.clicked() && !showBest.clicked() && !savePop.clicked() && !movingTarget) {
    x=mouseX;
    y=mouseY;
    addObstacle=true;
  } else {
    addObstacle=false;
  }
  if (movingTarget){
    movingTarget=false;
  }
}
void mouseReleased() {
  if (addObstacle) {
    framesPerRun=originalFPR;
    bestTime=framesPerRun+1;
    obstacles.add(new Obstacle(x, y, mouseX, mouseY));
  }
}
void mouseWheel(MouseEvent event) {
  if (obstacles.size()>0) {
    framesPerRun=originalFPR;
    bestTime=framesPerRun+1;
    obstacles.remove(obstacles.size()-1);
  }
}
