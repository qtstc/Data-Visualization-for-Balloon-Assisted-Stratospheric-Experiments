import java.util.*;
import processing.opengl.*;

TimelineScrollbar hs1;  // Two scrollbars
BufferedReader r;
ArrayList<VisualizationModule> modules;
ArrayList<Long> dataTime;
ArrayList<Long> newTime;
ArrayList<Integer> newTimeMapDataTime;

void setup() {
  frameRate(15);
  size(800, 600, P3D);
  noStroke();

  modules = new ArrayList<VisualizationModule>();
  dataTime = new ArrayList<Long>();
  newTime = new ArrayList<Long>();
  newTimeMapDataTime = new ArrayList<Integer>();
  ArrayList<Float[]> orientationData = new ArrayList<Float[]>();
  ArrayList<Float[]> heightData = new ArrayList<Float[]>();

  r = createReader("complete.txt");
  try {
    String line = r.readLine();
    while (line != null)
    {
      StringTokenizer st = new StringTokenizer(line);
      orientationData.add(readFloats(3, st));
      dataTime.add(readTime(st.nextToken()));
      heightData.add(readFloats(1,st));
      line = r.readLine();
    }
  }
  catch(Exception e)
  {
    e.printStackTrace();
  }

  modules.add(new OrientationModule(400, 280, 600, 400, orientationData));
  modules.add(new HeightModule(0,0,20,height-16,heightData));

  generateData(100);
  hs1 = new TimelineScrollbar(0, height-16, width, 16,newTime);
}


private void generateData(long interval)
{
  for (int i = 0;i<dataTime.size()-1;i++)
  {
    long startTime = dataTime.get(i);
    long stopTime = dataTime.get(i+1);
    long middleTime = (interval - startTime%interval)%interval + startTime;
    while (middleTime < stopTime)
    {
      newTime.add(middleTime);
      newTimeMapDataTime.add(i);
      for (VisualizationModule m: modules)
        m.addMapped(startTime, stopTime, middleTime, i);
      middleTime += interval;
    }
  }

  //Add the last data point in.
  if (dataTime.get(dataTime.size()-1)%interval == 0)
    for (VisualizationModule m: modules)
      m.addGenerated(m.getOriginal(dataTime.size()-1));
}


Calendar getCalendar(long millis)
{
  Calendar c = Calendar.getInstance();
  c.setTimeInMillis(millis);
  return c;
}

public static Float[] readFloats(int count, StringTokenizer st)
{
  Float[] result = new Float[count];
  for (int i = 0;i<count;i++)
    result[i] = Float.parseFloat(st.nextToken());
  return result;
}

void draw() {
  background(255);
  for (VisualizationModule m:modules)
    m.drawData(hs1.getIndex());
  hs1.update();
  hs1.display();
  stroke(0);
}

Long readTime(String text)
{
    int dash = text.indexOf("-");
    int underscore = text.indexOf("_");
    int dot = text.indexOf(".");
    int month = Integer.parseInt(text.substring(0,dash));
    int date = Integer.parseInt(text.substring(dash+1,underscore));
    StringTokenizer st = new StringTokenizer(text.substring(underscore+1,dot));
    int hour = Integer.parseInt(st.nextToken(":"));
    int minute = Integer.parseInt(st.nextToken(":"));
    int second = Integer.parseInt(st.nextToken(":"));
    long millisecond = Integer.parseInt(text.substring(dot+1))*10;
    Calendar c = Calendar.getInstance();
    c.set(2013, month, date, hour, minute, second);
    return c.getTimeInMillis()+millisecond;
}

