class Slider
{
  private int swidth, sheight;    // width and height of bar
  private float x, y;       // x and y position of bar
  private float spos, newspos;    // x position of slider
  private float sposMin, sposMax; // max and min values of slider
  private boolean over;           // is the mouse over the slider?
  private boolean locked;
  
  private int sliderwidth = 10;
  
  private int cellNumber; // The number of different positions in the scrollbar. Each cell/position correspond to one set of flight data.
  private float cellWidth;
  private int index;
  
  Slider (float x, float y, int swidth, int sheight,int cellNum)
  {
    this.x = x;
    this.y = y;
    this.swidth = swidth;
    this.sheight = sheight; 
    cellNumber = cellNum;
    spos = x;
    newspos = spos;
    sposMin = x;
    sposMax = x + swidth-sliderwidth;
    
    cellWidth = ((sposMax+sliderwidth) - sposMin)/cellNumber;
    index = 0;
  }
  
  boolean update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos);
      index = (int)((spos - sposMin)/cellWidth);
      return true;
    }
    return false;
  }
  
boolean overEvent() {
    if (mouseX > x && mouseX < x+swidth &&
       mouseY > y && mouseY < y+sheight) {
      return true;
    } else {
      return false;
    }
  }
  
    void display() {
     pushMatrix();
    //Draw bar background;
    noStroke();
    fill(100);
    rect(x, y, swidth, sheight);
    //Draw slider
    if (over || locked) {
      fill(200, 0, 0);
    } 
    else {
      fill(150, 0, 0);
    }
    rect(spos, y, sliderwidth, sheight, 2);
    popMatrix();
  }

}
