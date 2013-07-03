import java.util.Date;
import java.text.SimpleDateFormat;

class TimelineScrollbar {
  private int swidth, sheight;    // width and height of bar
  private float x, y;       // x and y position of bar
  private float spos, newspos;    // x position of slider
  private float sposMin, sposMax; // max and min values of slider
  private boolean over;           // whether the mouse over the slider
  private boolean locked; //whether the slider is locked. When locked, slider moves with the mouse
  private float ratio;  //The ratio between the actually width of the slider and the range it is represneting.

  private int cellNumber; // The number of different positions in the scrollbar. Each cell/position correspond to one set of flight data.
  private float cellWidth; //The actually width of each cell.
  private int index; //The index in the range represented by the position of the slider.

  static final float timewidth = 130; //The width of the time label.
  static final float buttonwidth = 50;//The width of the button.
  static final float sliderwidth = 10; // The width of the slider.
  
  //Below are pre-caculated values to save time during the loop.
  private float timex;//The x position of the time label.
  private float textheight;//The height of the text.
  private float[] trig; //The coordinates of the triganle on the button.
  private float[] pause;//The coordinates of the two bars on the button.
  

  private boolean playing;//Whether the slider is changing value by itself.
  SimpleDateFormat sdf; //The formatter for the date.
  
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
    playing = false;
    sdf = new SimpleDateFormat("MM/dd HH:mm:ss.SSS");

    this.cellNumber = newTime.size();

    cellWidth = ((sposMax+sliderwidth) - sposMin)/cellNumber;
    
    //Pre-calculate values.
    timex = timewidth + x;
    textheight = y+sheight*4/5;
    trig = new float[]{x+timewidth+buttonwidth*2/3,y+sheight/2,x+timewidth+buttonwidth/3,y+sheight/6,x+timewidth+buttonwidth/3,y+sheight*5/6};
    pause = new float[] {x+timewidth+buttonwidth/3,y+sheight/7,buttonwidth/10,sheight*5/7,x+timewidth+buttonwidth*13/24,y+sheight/7,buttonwidth/10,sheight*5/7};
  }

  /**
    * Update the index based on change in position of slider.
    */
  private void updateIndex()
  {
    index = (int)((spos - sposMin)/cellWidth);
  }
  
  /**
    * Update the position based on change in index.
    */
  private void updatePos()
  {
    spos = sposMin + ((float)index)*cellWidth;
    newspos = spos;
  }

  /**
    * Update the index based on the change in position
    */
  public int getIndex()
  {
    return index;
  }

  /**
    * Get the the number of indices on the slider.
    * a is the starting time while 
    * b is the ending time.
    */
  private int getCount(long a, long b, long interval)
  {
    long aRes = a%interval;
    long bRes = b%interval;
    long first = (interval - aRes)%interval + a;
    long last = b - b%interval;
    return (int)((last-first)/interval + 1);
  }
  
  /*
   * Update the parameters. To be called in the loop.
   */
  void update() {
    if (playing && !locked)
    {
      index++;
      if (index == newTime.size())
        index = 0;
      updatePos();
    }
    if (overEvent(timex, y, buttonwidth, sheight) && mousePressed && !locked)
    {
      playing = !playing;
      mousePressed = false;
    }
     if (overEvent(sposMin, y, swidth, sheight)) {
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
      newspos = constrain(mouseX, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = newspos;
      updateIndex();
    }

 
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  private boolean overEvent(float x, float y, float w, float h) {
    if (mouseX > x && mouseX < x+w &&
      mouseY > y && mouseY < y+h) {
      return true;
    } 
    else {
      return false;
    }
  }

  void display() {
    pushMatrix();
    //Draw bar background;
    noStroke();
    fill(100);
    rect(x, y, swidth, sheight);

    //Draw time text
    fill(200);
    text(sdf.format(getCalendar(newTime.get(index)).getTime()), x, textheight);

    //Draw button
    fill(150);
    rect(timex, y, buttonwidth, sheight, 3);
    fill(50);
    if(!playing)
      triangle(trig[0],trig[1],trig[2],trig[3],trig[4],trig[5]);
    else
    {
      rect(pause[0],pause[1],pause[2],pause[3]);
      rect(pause[4],pause[5],pause[6],pause[7]);
    }

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

