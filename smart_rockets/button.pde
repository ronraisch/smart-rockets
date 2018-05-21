class Button {
  float x, y, wid, hei;
  String txt;
  boolean prevClicked=false;
  boolean changed=false;
  boolean actuallyClicked=false;
  Button(float x, float y, float wid, float hei, String txt) {
    this.txt=txt;
    this.x=x;
    this.y=y;
    this.wid=wid;
    this.hei=hei;
  }
  boolean clicked(){
    return (mousePressed && mouseX>x && mouseX<(x+wid) && mouseY>y && mouseY<(y+hei));
  }
  void show(){
    changed=(clicked()!=prevClicked);
    if (changed && clicked())
      actuallyClicked=true;
    else
      actuallyClicked=false;
    if (clicked()){
      fill(150);
    }
    else{
      fill(240);
    }
    rect(x,y,wid,hei);
    fill(0);
    text(txt,x,y,x+wid,y+hei);
    noStroke();
    prevClicked=clicked();
  }
}