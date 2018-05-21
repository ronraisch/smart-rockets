PVector pol2cart(PVector v){
  PVector u=new PVector(1,0);
  u.rotate(v.y);
  u.mult(v.x);
  return u;
}
float distSq(float x1,float y1,float x2,float y2){
  return (x1-x2)*(x1-x2)+(y1-y2)*(y1-y2);
}
void changeMutation(){
  if (anyHit && !prevHit){
    mutationRate/=2;
    MCF/=2;
    MCA/=2;
  }
  else if(prevHit && !anyHit){
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
  if (mousePressed && addObstacle){
    rect(x,y,mouseX-x,mouseY-y);
  }
}
void showTarget() {
  fill(200, 80, 50);
  ellipse(targetX, targetY, 2*targetR, 2*targetR);
}
void buttonStuff(){
  showBest.show();
  if (showBest.actuallyClicked){
    showBestRocket=!showBestRocket;
    if (showBest.txt=="show best"){
      showBest.txt="show all";
    }
    else{
      showBest.txt="show best";
    }
  }
}
void popStuff(){
  if (!showBestRocket){
    population.calcFrames(ceil(rateSlider.value()));
  }
  else{
    population.calcFrameBest();
  }
}
void NNpopStuff(){
  if (!showBestRocket){
    NNpopulation.calcFrames(ceil(rateSlider.value()));
  }
  else{
    NNpopulation.calcFrameBest();
  }
}
void texts(){
  text("generation:"+generation, 20, height-20);
  text("best time:"+bestTime, 20, height-10);
}
//activation function
float activationFunction(float x){
  return x/(1+abs(x));
}