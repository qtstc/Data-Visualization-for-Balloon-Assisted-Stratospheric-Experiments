import java.text.SimpleDateFormat;
import java.util.Date;

class FlightData
{
  ArrayList<ArrayList<Float>> ledReadings;
  ArrayList<Float[]> orientationReadings;
  ArrayList<Float> altitudeReadings;
  ArrayList<Long> time;
  SimpleDateFormat sdf;
  
  int x;
  int y;
  int w;
  int h;
  
  int xAxisTextWidth;
  int yAxisTextHeight;
  color[] colors;
  
  FlightData(int x, int y, int w, int h,ArrayList<ArrayList<Float>> ledReadings, ArrayList<Long> time, ArrayList<Float[]> orientationReadings, ArrayList<Float> altitudeReading,color[] colors)
  {
    xAxisTextWidth = 30;
    yAxisTextHeight = 15;
    this.x = x+xAxisTextWidth;
    this.y = y;
    this.w = w-xAxisTextWidth;
    this.h = h-2*yAxisTextHeight;
    this.time = time;
    this.ledReadings = ledReadings;
    this.orientationReadings = orientationReadings;
    this.altitudeReadings = altitudeReading;
    this.colors = colors;
    sdf = new SimpleDateFormat("HH:mm:ss");
  }
  
  void drawDataByTime(float[] targetOrientation, float[] error, int led)
  {
    strokeWeight(2);
    fill(0);
    stroke(0);
    //Draw the y axis.
    line(x,y,x,y+h);
    int yInterval = 100;
    int yStart = 0;
    while(yStart < 1024)
    {
      float yDraw = y+h-yStart*h/1024;
      line(x,yDraw,x+10,yDraw);
      text(yStart,x-xAxisTextWidth,yDraw+5);
      yStart += yInterval;
    }
    
    //Draw the x axis.
    line(x,y+h,x+w,y+h);
    Long startTime = time.get(0);
    Long endTime = time.get(time.size()-1);
    Long range = endTime - startTime;
    float interval = (float)range/(float)10;
    
    int unevenYAxisTextHeight = yAxisTextHeight;
    int diff = yAxisTextHeight;
    
    int recurTime = 0;
    while(recurTime < range)
    {
      float xDraw = x+((float)recurTime*w/(float)range);
      line(xDraw,y+h,xDraw,y+h-10);
      text(sdf.format(getCalendar(recurTime+startTime).getTime()),xDraw-25,y+h+unevenYAxisTextHeight);
      recurTime+= interval;
      unevenYAxisTextHeight += diff;
      diff = diff * -1;
    }
    
    pushStyle();
    stroke(colors[led]);
    strokeWeight(1);
    for(int i = 0;i<ledReadings.get(led).size();i++)
    {
      if(!withInRange(targetOrientation,error,orientationReadings.get(i)))
        continue;
      float xDraw = x+((float)(time.get(i)-startTime)*w/(float)range);
      float yDraw = y+h-ledReadings.get(led).get(i)*h/1024; 
      ellipse(xDraw,yDraw,1,1);
    }
    popStyle();
  }
  
  void drawDataByHeight(float[] targetOrientation, float[] error, int led)
  {
    strokeWeight(2);
    fill(0);
    stroke(0);
    //Draw the y axis.
    line(x,y,x,y+h);
    int yInterval = 100;
    int yStart = 0;
    while(yStart < 1024)
    {
      float yDraw = y+h-yStart*h/1024;
      line(x,yDraw,x+10,yDraw);
      text(yStart,x-xAxisTextWidth,yDraw+5);
      yStart += yInterval;
    }
    
    //Draw the x axis.
    line(x,y+h,x+w,y+h);
    float startHeight = 0;
    float endHeight = 13000;
    float range = endHeight - startHeight;
    float interval = range/(float)10;
    
    float unevenYAxisTextHeight = yAxisTextHeight;
    float diff = yAxisTextHeight;
    
    float recurHeight = 0;
    while(recurHeight < range)
    {
      float xDraw = (float)x+(recurHeight*(float)w/range);
      line(xDraw,y+h,xDraw,y+h-10);
      text(recurHeight+"m",xDraw-25,y+h+unevenYAxisTextHeight);
      recurHeight+= interval;
      unevenYAxisTextHeight += diff;
      diff = diff * -1;
    }
    
    pushStyle();
    stroke(colors[led]);
    fill(colors[led]);
    strokeWeight(1);
    for(int i = 0;i<ledReadings.get(led).size();i++)
    {
      if(!withInRange(targetOrientation,error,orientationReadings.get(i)))
        continue;
       //float xDraw = (float)x+(recurHeight*(float)w/range);
      float xDraw = (float)x+(altitudeReadings.get(i)-startHeight)*(float)w/range;
      float yDraw = y+h-ledReadings.get(led).get(i)*h/1024; 
      ellipse(xDraw,yDraw,2,2);
    }
    popStyle();
  }
  
  
  boolean withInRange(float[] target, float[] error, Float[] actual)
  {
    for(int i = 0;i<target.length;i++)
    {
      float diff = circleDistance(target[i], actual[i]);
      if(diff > error[i])
        return false;
    }
    return true; 
  }
  
  float circleDistance(float start, float stop)
  {
    float diff = stop - start;
    if (diff > 180)
      diff -= 360;
    else if (diff < -180)
      diff += 360;
    return abs(diff);
  }
  
  Calendar getCalendar(long millis)
  {
    Calendar c = Calendar.getInstance();
    c.setTimeInMillis(millis);
    return c;
  }
}
