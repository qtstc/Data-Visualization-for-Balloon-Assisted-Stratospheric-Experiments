import java.util.*;
import processing.opengl.*;

TimelineScrollbar hs1;  // Two scrollbars
BufferedReader r;
OrientationModule orientation;

void setup() {
  size(800, 600,P3D);
  noStroke();
  
  ArrayList<Calendar> time = new ArrayList<Calendar>();
  ArrayList<ArrayList<Float>> orientationData = new ArrayList<ArrayList<Float>>();
 
  r = createReader("test.txt");
  try{
      String line = r.readLine();
    while(line != null)
    {
      StringTokenizer st = new StringTokenizer(line);
      time.add(getCalendar(Long.parseLong(st.nextToken())));
      ArrayList<Float> triple = new ArrayList<Float>();
      for(int i = 0;i<3;i++)
        triple.add(Float.parseFloat(st.nextToken()));
      orientationData.add(triple);
      line = r.readLine();
    }
  }
  catch(Exception e)
  {
    e.printStackTrace();
  }
  
  orientation = new OrientationModule(400,300,100,100,100,orientationData,time);
  
  hs1 = new TimelineScrollbar(0, height-16, width, 16,100,time);
}


Calendar getCalendar(long millis)
{
  Calendar c = Calendar.getInstance();
  c.setTimeInMillis(millis);
  return c;
}

void draw() {
  background(255);
  orientation.drawData(hs1.index);
  hs1.update();
  hs1.display();
  //orientation.drawData();
  stroke(0);
}
