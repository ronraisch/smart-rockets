class Obstacle{
  int x1,x2,y1,y2,leftX,rightX,topY,bottomY;
  Obstacle(int x1,int y1,int x2,int y2){
    //coordinates for obstacle
    this.x1=x1;
    this.x2=x2;
    this.y1=y1;
    this.y2=y2;
    //usefull variables
    leftX=min(x1,x2);
    rightX=max(x1,x2);
    topY=min(y1,y2);
    bottomY=max(y1,y2);
    if (abs(x1-x2)<delta || abs(y1-y2)<delta){
      println("small obstacle");
    }
  }
  void show(){
    rect(x1,y1,x2-x1,y2-y1);
  }
  //receives postion vector and returns boolean for hitting the obstacle
  boolean checkHit(PVector pos){
    return (pos.x>leftX && pos.x<rightX && pos.y>topY && pos.y<bottomY);
  }
}