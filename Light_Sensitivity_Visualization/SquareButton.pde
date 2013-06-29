class SquareButton
{
  int x;
  int y;
  int w;
  int h;
  color c;
  String t;
  boolean showText;
  
  SquareButton(int x, int y, int w, int h,color c,String t)
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.c = c;
    this.t = t;
    showText = true;
  }
  
  boolean isOver()
  {
    if(mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h)
      return true;
    return false;
  }
  
  void drawBox()
  {
    pushMatrix();
    stroke(255);
    fill(c);
    rect(x,y,w,h);
    fill(255);
    if(showText)
      text(t,x+w/6,y+(float)h/1.5);
    popMatrix();
  }
}
