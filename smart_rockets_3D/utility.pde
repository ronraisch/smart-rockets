PVector pol2cart(PVector v){
  return new PVector(cos(v.y)*cos(v.z),sin(v.y)*cos(v.z),sin(v.z));
}
float distSq(float x1,float y1,float z1, float x2,float y2,float z2){
  return (x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2);
}

void showObstacles() {
  fill(255);
  for (Obstacle obs : obstacles) {
    obs.show();
  }
  if (mousePressed && addObstacle){
    pushMatrix();
    translate(x,y,z);
    box(mouseX-x,mouseY-y,mouseZ-z);
    popMatrix();
  }
}
void showTarget() {
  fill(200, 80, 50);
  pushMatrix();
  translate(targetX-width/2, targetY-height/2,targetZ);
  sphere(targetR);
  popMatrix();
}

void popStuff(){
  Population.calcFrames(ceil(rateSlider.value()));
}
void texts(){
  text("generation:"+generation, 20, height-20);
  text("best time:"+bestTime, 20, height-10);
}
//activation function
float activationFunction(float x){
  return x/(1+abs(x));
}
//void changeMutation(){
//  if (anyHit && !prevHit){
//    mutationRate/=2;
//    MCF/=2;
//    MCA/=2;
//  }
//  else if(prevHit && !anyHit){
//    mutationRate*=2;
//    MCF*=2;
//    MCA*=2;
//  }
//}