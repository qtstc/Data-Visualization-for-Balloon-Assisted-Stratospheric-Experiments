import java.util.Date;

class TimelineScrollbar {
  int swidth, sheight;    // width and height of bar
  float x, y;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  int cellNumber; // The number of different positions in the scrollbar. Each cell/position correspond to one set of flight data.
  float cellWidth;
  int interval; // The time interval at which data was recorded. In millisecond.
  int index;
  Long startingTime;
  
  float timewidth = 100;
  float buttonwidth = 50;
  float sliderwidth = 10;

  TimelineScrollbar (float x, float y, int swidth, int sheight, int interval, ArrayList<Calendar> dataTime) {
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

    this.cellNumber = getCount(dataTime.get(0).getTimeInMillis(),dataTime.get(dataTime.size()-1).getTimeInMillis(),interval);
    
    cellWidth = ((sposMax+sliderwidth) - sposMin)/cellNumber;
    this.interval = interval;
    long first = dataTime.get(0).getTimeInMillis();
    startingTime = (interval - first%interval)%interval + first;
  }
  
  private void updateIndex()
  {
    index = (int)((spos - sposMin)/cellWidth);
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
    text(startingTime+index*interval ,x,y+sheight);
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

