import java.util.Date;

class TimelineScrollbar {
  private int swidth, sheight;    // width and height of bar
  private float x, y;       // x and y position of bar
  private float spos, newspos;    // x position of slider
  private float sposMin, sposMax; // max and min values of slider
  private boolean over;           // is the mouse over the slider?
  private boolean locked;
  private float ratio;

  private int cellNumber; // The number of different positions in the scrollbar. Each cell/position correspond to one set of flight data.
  private float cellWidth;
  private int index;
  
  static final float timewidth = 100;
  static final float buttonwidth = 50;
  static final float sliderwidth = 10;

  TimelineScrollbar (float x, float y, int swidth, int sheight, ArrayList<Long> newTime) {
    this.swidth = swidth;
    this.sheight = sheight;
    int widthtoheight = swidth - sheight;
    ratio = (float)swidth / (float)widthtoheight;
    this.x = x;
    this.y = y;
    sposMin = x + timewidth + buttonwidth;
    sposMax = x + swidth-sliderwidth;
    spos = sposMin;
    newspos = spos;

    this.cellNumber = newTime.size();
    
    cellWidth = ((sposMax+sliderwidth) - sposMin)/cellNumber;
  }
  
  private void updateIndex()
  {
    index = (int)((spos - sposMin)/cellWidth);
  }
  
  public int getIndex()
  {
    return index;
  }
  
  private int getCount(long a, long b, long interval)
  {
    long aRes = a%interval;
    long bRes = b%interval;
    long first = (interval - aRes)%interval + a;
    long last = b - b%interval;
    return (int)((last-first)/interval + 1);
  }

  void update() {
    if (overEvent()) {
      over = true;
    } 
    else {
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
      spos = spos + newspos-spos;
    }
    updateIndex();
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
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
    noStroke();
    fill(204);
    rect(x,y,swidth,sheight);
    fill(150);
    text(newTime.get(index),x,y+sheight*4/5);
    fill(50);
    rect(x+timewidth,y , buttonwidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } 
    else {
      fill(102, 102, 102);
    }
    rect(spos, y, sliderwidth, sheight);
  }
  
Calendar getCalendar(long millis)
{
  Calendar c = Calendar.getInstance();
  c.setTimeInMillis(millis);
  return c;
}

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
}

