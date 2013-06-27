import java.util.*;
import processing.opengl.*;

/**
  * This is the parent class for all visualization modules.
  * Each of the modules is responsible for visualizing a specific dataset.
  */
abstract class VisualizationModule
{
  protected int x;//The x coordinate of the upper left corner of the module on the canvas.
  protected int y;//The y coordinat of the upper left corner of the module on the canvas.
  protected int mheight;//The height of the module on the canvas.
  protected int mwidth;//The width of the module on the canvas.
  protected ArrayList<Float[]> originalData;
  protected ArrayList<Float[]> generatedData;//Data generated from the original data set. It basically has more data points generated through mapping to make the data more continuous.
  protected int dataSize;
  
  /*
   * Constructor. The first four parameters determine where to draw on the canvas.
   * The last two parameters should have the same length, e.g. originalData.get(i) should
   * be the data taken at dataTime.get(i).
   */
  public VisualizationModule(int x, int y, int mwidth, int mheight,ArrayList<Float[]> originalData)
  {
    this.x = x;
    this.y = y;
    this.mheight = mheight;
    this.mwidth = mwidth;
    this.originalData = originalData;
    this.generatedData = new ArrayList<Float[]>();
    dataSize = originalData.get(0).length;
  }
  
  
  
  /*
   * Draw a specific data.
   * The data position is an index for generatedData.
   */
  protected abstract void draw(Float[] data);
  
  
  public void drawData(int i)
  {
    draw(generatedData.get(i));
  }
  
  protected Float[] map(long startTime,long stopTime,long middleTime,Float[] start, Float[] stop)
  {
    float ratio = ((float)(middleTime-startTime))/((float)(stopTime-startTime));
    Float[] result = new Float[dataSize];
   for(int i =0;i<dataSize;i++)
      result[i] = (stop[i] - start[i])*ratio+start[i];
   return result; 
  }
  
  public void addMapped(long startTime,long stopTime, long middleTime, int dataIndex)
  {
    addGenerated(map(startTime,stopTime,middleTime,originalData.get(dataIndex),originalData.get(dataIndex+1)));
  }
  
  public void addGenerated(Float[] generated)
  {
    generatedData.add(generated);
  }
  
  public Float[] getOriginal(int dataIndex)
  {
    return originalData.get(dataIndex);
  }
  
  public Float[] getGenerated(int dataIndex)
  {
    return generatedData.get(dataIndex);
  }
}
