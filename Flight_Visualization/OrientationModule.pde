import java.util.*;
import processing.opengl.*;

/**
  * This is a visualization module used to visualize the 
  * the orientation of box in the air.
  */
class OrientationModule extends VisualizationModule
{

  private int w;//The width of the box
  private int h;//The height of the box
  private int d;//Dimension in z

  private int boardw;//The width of the breadboard on the side of the box.
  private int boardh;//The height of the breadboard on the side of the box.

  public OrientationModule(int x, int y, int mwidth, int mheight, ArrayList<Float[]> originalData)
  {
    super(x, y, mwidth, mheight, originalData);
    w = mwidth/2;
    h = w;
    d = h;
    boardw = (int)(((float)w)/1.5);
    boardh = (int)(((float)h)/1.5);
  }


  void draw(Float[] data)
  {

    pushMatrix();
    translate(x, y);
    
    //Draw the label for north
    noStroke();
    pushMatrix();
    translate(0, 0, d/5*4);
    fill(#1e90ff, 255);
    ellipse(0, 0, 15, 15);
    fill(#ffffff, 255);
    text("N", -4, 4);
    popMatrix();
    
    //Draw the label for east
    pushMatrix();
    translate(-w/5*4, 0, 0);
    fill(#1e90ff, 255);
    ellipse(0, 0, 15, 15);
    fill(#ffffff, 255);
    text("E", -4, 4);
    popMatrix();

    //Draw the box
    rotateX(radians(data[0]));
    rotateZ(-radians(data[1]));
    rotateY(radians(data[2]));
    strokeWeight(2);
    stroke(#B8B8B8);
    fill(#888888, 220);
    box(w, h, d);
    //draw the breadboard
    translate(0, 0, d/2);
    fill(#CCCC00, 200);
    box(boardw, boardh, 1);
    popMatrix();
  }

  protected Float[] map(long startTime, long stopTime, long middleTime, Float[] start, Float[] stop)
  {
    //Overriden because the mapping of degrees is different from the mapping of ordinary numbers.
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

  /**
    * Calculate the difference in degrees of two angles.
    * The two angles should both be between 0 and 360 degrees.
    * And the result is always between 0 to 180 degrees.
    */
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

