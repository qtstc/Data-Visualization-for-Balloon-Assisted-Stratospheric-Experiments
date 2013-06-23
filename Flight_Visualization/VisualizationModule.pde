import java.util.*;

class VisualizationModule<T>
{
  int x;//The x coordinate of the upper left corner of the module on the canvas.
  int y;//The y coordinat of the upper left corner of the module on the canvas.
  int mheight;//The height of the module on the canvas.
  int mwidth;//The width of the module on the canvas.
  Calendar startingTime;//The starting time of the 
  T[] generatedData;
  
  VisualizationModule(int x, int y, int mwidth, int mheight,long interval,ArrayList<DataSet<T>> originalData)
  {
    this.x = x;
    this.y = y;
    this.mheight = mheight;
    this.mwidth = mwidth;
    this.startingTime = startingTime;
  }
}
