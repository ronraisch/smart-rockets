class Slider{
  float min,max,def,wid,hei,x,y,value;
  Slider(float min,float max,float def,float wid,float hei,float x,float y){
    this.min=min;
    this.x=x;
    this.y=y;
    this.wid=wid;
    this.hei=hei;
    this.max=max;
    this.def=def;
    value=def;
  }
  boolean clicked(){
    return (mousePressed && mouseX>(x-10) && mouseX<(x+wid+10) && mouseY>y && mouseY<(y+hei));
  }
  float value(){
    if (clicked()){
      if (mouseX<x){
        value=min;
      }
      else if (mouseX>x+wid){
        value=max;
      }
      else{
        value=(mouseX-x)/wid*(max-min)+min;
      }
    }
    return value;
  }
  void show(){
    fill(200,100);
    rect(x,y,wid,hei);
    fill(255,200);
    float tmp=(value-min)*wid/(max-min)+x;
    rect(tmp,y,hei,hei);
  }
}