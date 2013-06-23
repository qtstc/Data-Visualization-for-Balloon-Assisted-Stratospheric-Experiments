import java.util.*;

/**
  * Class used to store a specific data collected from the flight.
  * The generic type is the type of the data. And the time indicates
  * the time at which the data is taken.
  */
class DataSet<T> implements Comparable<DataSet<T>>
{
  Calendar time;
  T data;
  DataSet(Date time, T data)
  {
    this.data = data;
  }
  
  int compareTo(DataSet<T> that)
  {
    return this.time.compareTo(that.time);
  }
}
