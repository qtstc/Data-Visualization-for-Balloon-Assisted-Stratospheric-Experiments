import java.util.*;

FlightData data;
SelectBox[] boxes;
boolean needDraw;
int selected;
SelectBox modeBox;
boolean timeMode;
float[] target;
float[] window;
Slider[] sliders;
SelectBox applyBox;


void setup()
{
  target = new float[] {
    0, 0, 0
  };
  window = new float[] {
    0, 0, 0
  };
  needDraw = true;
  timeMode = true;
  selected = 0;
  ArrayList<Long> time =  new ArrayList<Long>();
  ArrayList<ArrayList<Float>> leds = new ArrayList<ArrayList<Float>>();
  ArrayList<Float[]> orientation = new ArrayList<Float[]>();
  ArrayList<Float> altitude = new ArrayList<Float>();
  for (int i = 0;i<8;i++)
  {
    ArrayList<Float> led = new ArrayList<Float>();
    leds.add(led);
  }

  String[] sliderLabels = new String[] {
    "pitch", "roll", "heading"
  };

  //Setup sliders
  sliders = new Slider[6];
  int sliderX = 625;
  int sliderY = 80;
  int sliderW = 80;
  int sliderH = 20;
  int sliderSpace = 8;
  for (int i = 0;i<3;i++)
  {
    fill(255);
    stroke(255);
    text(sliderLabels[i], sliderX - 10, sliderY);
    sliders[i] = new Slider(sliderX, sliderY, sliderW, sliderH, 360);
    sliderY += sliderH+sliderSpace;
  }
  sliderY = 80;
  sliderX += sliderW + sliderSpace;
  for (int i = 3;i<6;i++)
  {
    sliders[i] = new Slider(sliderX, sliderY, sliderW, sliderH, 180);
    sliderY += sliderH+sliderSpace;
  }

  //Setup boxes.
  modeBox = new SelectBox(650, 20, 110, 20, color(255, 150, 0), "Change Mode");
  modeBox.showText = true;
  applyBox = new SelectBox(670, 50, 60, 20, color(255, 150, 0), "Apply");
  applyBox.showText = true;
  boxes = new SelectBox[8];
  int boxX = 675;
  int boxY = 175;
  int boxW = 50;
  int boxH = 50;
  color[] colors = new color[] {
    color(0, 0, 0, 255), color(155, 155, 155, 255), color(255, 0, 0, 255), color(255, 255, 0, 255), color(0, 255, 0, 255), color(0, 0, 255, 255), color(255, 0, 255, 255), color(55, 55, 55, 255)
  };
  boxes[0] = new SelectBox(boxX, boxY, boxW, boxH, colors[0], "IR 940");
  boxY += boxH;
  boxes[1] = new SelectBox(boxX, boxY, boxW, boxH, colors[1], "IR 830");
  boxY += boxH;
  boxes[2] = new SelectBox(boxX, boxY, boxW, boxH, colors[2], "Red");
  boxY += boxH;
  boxes[3] = new SelectBox(boxX, boxY, boxW, boxH, colors[3], "Yellow");
  boxY += boxH;
  boxes[4] = new SelectBox(boxX, boxY, boxW, boxH, colors[4], "Green");
  boxY += boxH;
  boxes[5] = new SelectBox(boxX, boxY, boxW, boxH, colors[5], "Blue");
  boxY += boxH;  
  boxes[6] = new SelectBox(boxX, boxY, boxW, boxH, colors[6], "Violet 400");
  boxY += boxH;
  boxes[7] = new SelectBox(boxX, boxY, boxW, boxH, colors[7], "UV 351");



  BufferedReader r = createReader("data.txt");
  try {
    r.readLine();//Get rid of column names.
    String line = r.readLine();
    while (line != null)
    {
      StringTokenizer st = new StringTokenizer(line);
      for (int i = 0;i<8;i++)
        leds.get(i).add(Float.parseFloat(st.nextToken()));
      orientation.add(readFloats(3, st));
      time.add(readTime(st.nextToken()));
      altitude.add(Float.parseFloat(st.nextToken()));
      line = r.readLine();
    }
    r.close();
  }
  catch(Exception e)
  {
    e.printStackTrace();
  }
  size(800, 600, P3D);
  data = new FlightData(20, 20, 530, 530, leds, time, orientation, altitude, colors);
}

void draw()
{
  boolean redrawOrientation = false;
  for (int i = 0;i<sliders.length;i++)
  {
    if (sliders[i].update())
    {
      redrawOrientation = true;
    }
    sliders[i].display();
  }
  if (redrawOrientation)
  {
    fill(255);
    stroke(255);
    rect(550, 60, 70, 90);
  }
  drawOrientation();
  if (mousePressed)
  {
    for (int i = 0;i<boxes.length;i++)
    {
      if (boxes[i].isOver())
      {
        selected = i;
        needDraw = true;
        break;
      }
    }
     if (applyBox.isOver())
    {
      target[0] = sliders[0].index;
      target[1] = sliders[1].index;
      target[2] = sliders[2].index;
      window[0] = sliders[3].index;
      window[1] = sliders[4].index;
      window[2] = sliders[5].index;
      needDraw = true;
    }
    if (modeBox.isOver())
    {
      timeMode = !timeMode;
      mousePressed = false;
      needDraw = true;
    }
    
  }
  if (!needDraw)
    return;
  background(255);
  if (timeMode)
    data.drawDataByTime(target, window, selected);
  else
    data.drawDataByHeight(target, window, selected);
  needDraw = false;

  for (int i = 0;i<boxes.length;i++)
    boxes[i].drawBox();
  modeBox.drawBox();
  applyBox.drawBox();
}


Long readTime(String text)
{
  int dash = text.indexOf("-");
  int underscore = text.indexOf("_");
  int dot = text.indexOf(".");
  int month = Integer.parseInt(text.substring(0, dash));
  int date = Integer.parseInt(text.substring(dash+1, underscore));
  StringTokenizer st = new StringTokenizer(text.substring(underscore+1, dot));
  int hour = Integer.parseInt(st.nextToken(":"));
  int minute = Integer.parseInt(st.nextToken(":"));
  int second = Integer.parseInt(st.nextToken(":"));
  long millisecond = Integer.parseInt(text.substring(dot+1))*10;
  Calendar c = Calendar.getInstance();
  c.set(2013, month, date, hour, minute, second);
  return c.getTimeInMillis()+millisecond;
}

public static Float[] readFloats(int count, StringTokenizer st)
{
  Float[] result = new Float[count];
  for (int i = 0;i<count;i++)
    result[i] = Float.parseFloat(st.nextToken());
  return result;
}

void drawOrientation()
{
  int w = 20;
  int h = 20;
  int d = 20;
  pushMatrix();
  translate(600, 110);
  //data = new Float[]{0.0,0.0,0.0};
  rotateX(radians(sliders[0].index));
  rotateZ(radians(sliders[1].index));
  rotateY(radians(sliders[2].index));
  strokeWeight(1);
  stroke(#B8B8B8);
  fill(#888888, 220);
  box(w, h, d);
  translate(0, 0, d/2);
  fill(#CCCC00, 200);
  box(13, 13, 1);
  popMatrix();
}

