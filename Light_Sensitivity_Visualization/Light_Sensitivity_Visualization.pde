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

color[] colors = new color[] {
  color(0, 0, 0, 255), color(155, 155, 155, 255), color(255, 0, 0, 255), color(255, 255, 0, 255), color(0, 255, 0, 255), color(0, 0, 255, 255), color(255, 0, 255, 255), color(55, 55, 55, 255)
};


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

  setUpSliders();
  setUpSelectBoxes();
  //Setup boxes.
  modeBox = new SelectBox(650, 20, 110, 20, color(255, 150, 0), "Change Mode");
  modeBox.showText = true;



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
  size(800, 650, P3D);
  data = new FlightData(20, 20, 530, 530, leds, time, orientation, altitude, colors);
}

void setUpSliders()
{
  String[] sliderLabels = new String[] {
    "pitch", "roll", "yaw", "pitch range", "roll range", "yaw range"
  };

  //Setup sliders
  sliders = new Slider[6];
  int sliderX = 600;
  int sliderY = 280;
  int sliderW = 180;
  int sliderH = 20;
  int sliderSpace = 20;
  for (int i = 0;i<3;i++)
  {
    sliders[i] = new Slider(sliderX, sliderY, sliderW, sliderH, 360, sliderLabels[i]);
    sliderY += sliderH+sliderSpace;
  }
  for (int i = 3;i<6;i++)
  {
    sliders[i] = new Slider(sliderX, sliderY, sliderW, sliderH, 180, sliderLabels[i]);
    sliderY += sliderH+sliderSpace;
  }
  applyBox = new SelectBox(660, 510, 60, 20, color(255, 150, 0), "Apply");
  applyBox.showText = true;
}

void setUpSelectBoxes()
{
  boxes = new SelectBox[8];
  int boxX = 120;
  int boxY = 580;
  int boxW = 50;
  int boxH = 50;
  boxes[0] = new SelectBox(boxX, boxY, boxW, boxH, colors[0], "IR940");
  boxX += boxW;
  boxes[1] = new SelectBox(boxX, boxY, boxW, boxH, colors[1], "IR830");
  boxX += boxW;
  boxes[2] = new SelectBox(boxX, boxY, boxW, boxH, colors[2], " Red");
  boxX += boxW;
  boxes[3] = new SelectBox(boxX, boxY, boxW, boxH, colors[3], "Yellow");
  boxX += boxW;
  boxes[4] = new SelectBox(boxX, boxY, boxW, boxH, colors[4], "Green");
  boxX += boxW;
  boxes[5] = new SelectBox(boxX, boxY, boxW, boxH, colors[5], " Blue");
  boxX += boxW;
  boxes[6] = new SelectBox(boxX, boxY, boxW, boxH, colors[6], "V400");
  boxX += boxW;
  boxes[7] = new SelectBox(boxX, boxY, boxW, boxH, colors[7], "UV351");
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
    rect(600, 100, 180, 400);
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
  int w = 80;
  int h = 80;
  int d = 80;
  pushMatrix();
  translate(690, 180, 0);
  rotateX(radians(sliders[0].index));
  rotateZ(radians(sliders[1].index));
  rotateY(radians(sliders[2].index));
  strokeWeight(1);
  stroke(#B8B8B8);
  fill(#888888, 220);
  box(w, h, d);
  translate(0, 0, d/2);
  fill(#CCCC00, 200);
  box(w/2, h/2, 1);
  popMatrix();
}

