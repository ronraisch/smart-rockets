class Obstacle{
  int x1,x2,y1,y2,z1,z2,leftX,rightX,topY,bottomY,forwardZ,backZ;
  Obstacle(int x1,int y1,int z1,int x2,int y2,int z2){
    //coordinates for obstacle
    this.x1=x1;
    this.x2=x2;
    this.y1=y1;
    this.y2=y2;
    this.z1=z1;
    this.z2=z1;
    //usefull variables
    leftX=min(x1,x2);
    rightX=max(x1,x2);
    topY=min(y1,y2);
    bottomY=max(y1,y2);
    forwardZ=max(z1,z2);
    backZ=min(z1,z2);
    if (abs(x1-x2)<delta || abs(y1-y2)<delta || abs(z1-z2)<delta){
      println("small obstacle");
    }
  }
  void show(){
    pushMatrix();
    translate(x1,y1,z1);
    box(x1-x2,y1-y2,z1-z2);
    popMatrix();
  }
  //receives postion vector and returns boolean for hitting the obstacle
  boolean checkHit(PVector pos){
    return (pos.x>leftX && pos.x<rightX && pos.y>topY && pos.y<bottomY && pos.z<forwardZ && pos.z>backZ);
  }
}