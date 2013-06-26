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
  private long startingTime;//The starting time of the flight
  private long interval;//The desired interval of the generated data.
  protected ArrayList<ArrayList<Float>> generatedData;//Data generated from the original data set. It basically has more data points generated through mapping to make the data more continuous.
  
  /*
   * Constructor. The first four parameters determine where to draw on the canvas.
   * The last two parameters should have the same length, e.g. originalData.get(i) should
   * be the data taken at dataTime.get(i).
   */
  public VisualizationModule(int x, int y, int mwidth, int mheight,long interval,ArrayList<ArrayList<Float>> originalData, ArrayList<Calendar> dataTime)
  {
    this.x = x;
    this.y = y;
    this.mheight = mheight;
    this.mwidth = mwidth;
    this.interval = interval;
    startingTime = dataTime.get(0).getTimeInMillis();
    generateData(originalData, dataTime, interval);
  }
  
  /*
   * Draw a specific data.
   * The data position is an index for generatedData.
   */
  protected abstract void draw(ArrayList<Float> data);
  
  
  public void drawData(int i)
  {
    draw(generatedData.get(i));
  }
  
  /**
    * Generate the data used in visualization based on the original data from the flight.
    * This is necessary because the time interval at which data is taken during the flight is often too large.
    * We need to fill in the gaps between two consecutive flight data with generated data so the visualization will have smooth animation.
    */
  private void generateData(ArrayList<ArrayList<Float>> originalData,ArrayList<Calendar> dataTime, long interval)
  {
    startingTime = dataTime.get(0).getTimeInMillis();
    Calendar endingTime = dataTime.get(dataTime.size()-1);
    generatedData = new ArrayList<ArrayList<Float>>();
    for(int i = 0;i<originalData.size()-1;i++)
    {
      long startTime = dataTime.get(i).getTimeInMillis();
      long stopTime = dataTime.get(i+1).getTimeInMillis();
      long middle = (interval - startTime%interval)%interval + startTime;
      while(middle < stopTime)
      {
        ArrayList<Float> generated = map(startTime,stopTime,originalData.get(i),originalData.get(i+1),middle);
        generatedData.add(generated);
        middle += interval;
      }
    }
    
    //Add the last data point in.
    if(endingTime.getTimeInMillis()%interval == 0)
      generatedData.add(originalData.get(originalData.size()-1));
      
  }
  
  protected ArrayList<Float> map(long startTime, long stopTime, ArrayList<Float> start, ArrayList<Float> stop, long middle)
  {
    float ratio = ((float)(middle-startTime))/((float)(stopTime-startTime));
    ArrayList<Float> result = new ArrayList<Float>();
    for(int i = 0;i<start.size();i++)
      result.add((stop.get(i)-start.get(i))*ratio+start.get(i));
    return result;
  }
  
  private long diffInMillis(Calendar before, Calendar after)
  {
    return after.getTimeInMillis() - before.getTimeInMillis();
  }
}
