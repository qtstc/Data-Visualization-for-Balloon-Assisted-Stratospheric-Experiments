import java.util.*;
import processing.opengl.*;

class OrientationModule extends VisualizationModule
{
  
  private int w;
  private int h;
  private int d;
  public OrientationModule(int x, int y, int mwidth, int mheight, ArrayList<Float[]> originalData)
  {
    super(x, y, mwidth, mheight, originalData);
    w = mwidth/2;
    h = w;
    d = h;
  }


  void draw(Float[] data)
  {
    pushMatrix();
    translate(x, y);
    rotateX(radians(data[0]));
    rotateZ(radians(data[1]));
    rotateY(radians(data[2]));
    strokeWeight(2);
    stroke(#B8B8B8);
    fill(#888888, 220);
    box(w, h, d);
    popMatrix();
  }

  protected Float[] map(long startTime, long stopTime, long middleTime, Float[] start, Float[] stop)
  {
    float ratio = ((float)(middleTime-startTime))/((float)(stopTime-startTime));
    Float[] result = new Float[dataSize];
    for (int i =0;i<dataSize;i++)
    {
      float r = circleDistance(start[i], stop[i])*ratio+start[i];
      if (r < 0)
        r += 360;
      else if (r >=360)
        r -= 360;
      result[i] = r;
    }
    return result;
  }

  private float circleDistance(float start, float stop)
  {
    float diff = stop - start;
    if (diff > 180)
      diff -= 360;
    else if (diff < -180)
      diff += 360;
    return diff;
  }
}

