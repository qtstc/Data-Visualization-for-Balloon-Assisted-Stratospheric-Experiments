import java.util.*;

class HeightModule extends VisualizationModule
{
  private int scale = 1000;//In cm. So we can do integer division and remainder.
  private int interval = 500;//In cm.
  private float drawRatio;
  private float drawInterval;
  
  private int markingLength = 10;
  
  private int endPointY;
  private int markingEndX;
  
  HeightModule(int x, int y, int mwidth, int mheight, ArrayList<Float[]> originalData)
  {
    super(x, y, mwidth, mheight, originalData);
    endPointY = y+mheight;
    markingEndX = x + markingLength;
    drawRatio = mheight/(float)scale/2.0;
    drawInterval = drawRatio*(float)interval;
  }
  
  void draw(Float[] data)
  {
    stroke(0);
    line(x,y,x,endPointY);
    int lengthIncm = (int)(data[0] * 10000);
    int startingPoint = lengthIncm - scale;
    int diff = startingPoint % interval;
    if(diff != 0)
      diff = interval - diff;
    float base = endPointY - diff*drawRatio;
    while(base >= y)
    {
      line(x,base,markingEndX,base);
      text(((float)startingPoint)/10000+"m",markingEndX,base);
      startingPoint += interval;
      base -= drawInterval;
    }
  }
}
