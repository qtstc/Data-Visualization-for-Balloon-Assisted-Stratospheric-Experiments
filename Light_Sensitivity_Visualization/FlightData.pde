class FlightData
{
  ArrayList<Float> ledReadings;
  ArrayList<Float[]> orientationReadings;
  ArrayList<Float> altitudeReading;
  ArrayList<Long> time;
  
  int x;
  int y;
  int w;
  int h;
  
  FlightData(int x, int y, int w, int h,ArrayList<Float> ledReadings, ArrayList<Long> time, ArrayList<Float[]> orientationReadings, ArrayList<Float> altitudeReading)
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.time = time;
    this.ledReadings = ledReadings;
    this.orientationReadings = orientationReadings;
    this.altitudeReading = altitudeReading;
  }
  
  void drawData(float[] targetOrientation, float[] error)
  {
    strokeWeight(3);
    //Draw the y axis.
    line(x,y,x,y+h);
    int yInterval = 100;
    int yStart = 0;
    while(yStart < 1024)
    {
      float yDraw = y+h-yStart*h/1024;
      line(x,yDraw,x+10,yDraw);
      yStart += yInterval;
    }
    
    //Draw the x axis.
    line(x,y+h,x+w,y+h);
    Long startTime = time.get(0);
    Long endTime = time.get(time.size()-1);
    Long range = endTime - startTime;
    float interval = (float)range/(float)10;
    
    int recurTime = 0;
    while(recurTime < range)
    {
      float xDraw = x+((float)recurTime*w/(float)range);
      line(xDraw,y+h,xDraw,y+h-10);
      recurTime+= interval;
    }
    
    for(int i = 0;i<ledReadings.size();i++)
    {
      if(!withInRange(targetOrientation,error,orientationReadings.get(i)))
        continue;
      float xDraw = x+((float)(time.get(i)-startTime)*w/(float)range);
      float yDraw = y+h-ledReadings.get(i)*h/1024; 
      strokeWeight(1);
      ellipse(xDraw,yDraw,1,1);
    }
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
}
