import java.util.*;

FlightData data;

void setup()
{
  ArrayList<Long> time =  new ArrayList<Long>();
  ArrayList<ArrayList<Float>> leds = new ArrayList<ArrayList<Float>>();
  ArrayList<Float[]> orientation = new ArrayList<Float[]>();
  ArrayList<Float> altitude = new ArrayList<Float>(); 
  for(int i = 0;i<8;i++)
  {
    ArrayList<Float> led = new ArrayList<Float>();
    leds.add(led);
  }
  
  
  BufferedReader r = createReader("data.txt");
  try {
    r.readLine();//Get rid of column names.
    String line = r.readLine();
    while (line != null)
    {
      StringTokenizer st = new StringTokenizer(line);
      for(int i = 0;i<8;i++)
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
  size(625, 615);
  data = new FlightData(10, 10, 500, 500, leds, time, orientation, altitude);
  background(255);

  data.drawData(new float[]{0,0,0}, new float[]{180,180,180},0);
}

void loop()
{
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


