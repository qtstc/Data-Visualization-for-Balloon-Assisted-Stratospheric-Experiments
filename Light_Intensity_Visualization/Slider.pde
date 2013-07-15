/**
  * Customized slider that allows the user to select a values.
  */
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
  private String label;

  Slider (float x, float y, int swidth, int sheight, int cellNum, String label)
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

    cellWidth = ((sposMax) - sposMin)/(float)cellNumber;
    index = 0;
    this.label = label;
  }

  boolean update() {
    if (overEvent()) {
      over = true;
    } 
    else {
      over = false;
      locked = false;
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
    } 
    else {
      return false;
    }
  }

  void display() {
    pushStyle();
    //Draw bar background;
    noStroke();
    fill(100);
    rect(x, y+sheight/2, swidth, sheight/2,4);
    //Draw slider
    if (over || locked) {
      fill(200, 0, 0);
    } 
    else {
      fill(150, 0, 0);
    }
    rect(spos, y,sliderwidth,sheight, 4);
    text(label+": "+index, x, y-sheight/3);
    popStyle();
  }
}

