import java.util.*;

class VisualizationModule<T extends Data>
{
  int x;//The x coordinate of the upper left corner of the module on the canvas.
  int y;//The y coordinat of the upper left corner of the module on the canvas.
  int mheight;//The height of the module on the canvas.
  int mwidth;//The width of the module on the canvas.
  Calendar startingTime;//The starting time of the flight
  ArrayList<T> generatedData;
  
  VisualizationModule(int x, int y, int mwidth, int mheight,long interval,ArrayList<DataSet<T>> originalData)
  {
    this.x = x;
    this.y = y;
    this.mheight = mheight;
    this.mwidth = mwidth;
    //Collections.sort(originalData);//Sort the flight data according to time. We assume it is already sorted to save time.
  }
  
  /**
    * Generate the data used in visualization based on the original data from the flight.
    * This is necessary because the time interval at which data is taken during the flight is often too large.
    * We need to fill in the gaps between two consecutive flight data with generated data so the visualization will have smooth animation.
    */
  void generateData(ArrayList<DataSet<T>> originalData, long interval)
  {
    startingTime = originalData.get(0).time;
    Calendar endingTime = originalData.get(originalData.size()-1).time;
    int dataNum = (int)((endingTime.getTimeInMillis() -startingTime.getTimeInMillis())/interval+1);//We assume the desired interval is smaller than the interval of the original data.
    generatedData = new ArrayList<T>();
    for(int i = 0;i<originalData.size()-1;i++)
    {
      DataSet<T> first = originalData.get(i);
      DataSet<T> last = originalData.get(i+1);
      long fTime = (interval - diffInMillis(startingTime,first.time)%interval)%interval + first.time.getTimeInMillis();
      while(fTime < last.time.getTimeInMillis())
      {
        //
      }
    }
  }
  
  long diffInMillis(Calendar before, Calendar after)
  {
    return after.getTimeInMillis() - before.getTimeInMillis();
  }
}
