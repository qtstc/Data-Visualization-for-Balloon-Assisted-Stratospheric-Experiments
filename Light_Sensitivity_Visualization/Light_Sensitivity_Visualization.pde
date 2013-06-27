import java.util.*;

FlightData data;
SelectBox[] boxes;
boolean needDraw;
int selected;

void setup()
{
  needDraw = true;
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

  boxes = new SelectBox[8];
  int boxX = 675;
  int boxY = 20;
  int boxW = 50;
  int boxH = 50;
  color[] colors = new color[] {
    color(0, 0, 0, 255), color(0, 0, 0, 155), color(255, 0, 0), color(255, 255, 0), color(0, 255, 0), color(0, 0, 255), color(255, 0, 255), color(0, 0, 0, 55)
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
  size(800, 600);
  data = new FlightData(20, 20, 530, 530, leds, time, orientation, altitude, colors);
}

void loop()
{
  if (mousePressed)
  {
    println("Pressed");
    for (int i = 0;i<boxes.length;i++)
    {
      if (boxes[i].isOver())
      {
        selected = i;
        needDraw = true;
        break;
      }
    }
  }
  if (!needDraw)
    return;
  background(255);
  data.drawData(new float[] {
    0, 0, 0
  }
  , new float[] {
    180, 180, 180
  }
  , selected);
  needDraw = false;

  for (int i = 0;i<boxes.length;i++)
    boxes[i].drawBox();
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

