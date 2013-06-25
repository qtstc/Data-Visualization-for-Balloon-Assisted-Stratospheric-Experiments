import java.util.*;
import processing.opengl.*;

class OrientationModule extends VisualizationModule
{
  OrientationModule(int x, int y, int mwidth, int mheight,long interval,ArrayList<ArrayList<Float>> originalData, ArrayList<Calendar> dataTime)
  {
    super(x, y, mwidth, mheight,interval,originalData,dataTime);
  }
  
  int count = 0;
  
  void draw(ArrayList<Float> data)
  {
    pushMatrix();
    translate(x,y);
    rotateX(radians(data.get(0)));
    rotateZ(radians(data.get(1)));
    rotateY(radians(data.get(2)));
    strokeWeight(2);
    stroke(#990000);
    fill(#009999, 220);
    box(100,100,100);
    popMatrix();
  }
  
  protected ArrayList<Float> map(long startTime, long stopTime, ArrayList<Float> start, ArrayList<Float> stop, long middle)
  {
    float ratio = ((float)(middle-startTime))/((float)(stopTime-startTime));
    ArrayList<Float> result = new ArrayList<Float>();
    for(int i = 0;i<start.size();i++)
    {
      float r = circleDistance(start.get(i),stop.get(i))*ratio+start.get(i);
      if(r < 0)
        r += 360;
      else if(r >=360)
        r -= 360;
      result.add(r);
    }
    return result;
  }
  
  private float circleDistance(float start, float stop)
  {
    float diff = stop - start;
    if(diff > 180)
      diff -= 360;
    else if (diff < -180)
      diff += 360;
    return diff;
  }
}
