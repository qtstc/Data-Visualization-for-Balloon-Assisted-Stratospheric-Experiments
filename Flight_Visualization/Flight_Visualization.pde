import java.util.*;
import processing.opengl.*;

/*
 * Copyright 2013 Tao Qian
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/** This is a data visualization project for DePauw University's
  * BASE (Balloon Assisted Stratospheric Research) 2013.
  *
  * It displays various sensor data collected during balloon flight
  * in an animated, graphical and interactive way.
  * It creates a timeline with the time data collected from GPS.
  * User can either click on certain points on the timeline to 
  * view the data collected at that point or leave the simulation
  * running and see how the data changes over time.
  *
  * Author: Tao Qian (taoqian_2015@depauw.edu)
  */ 

TimelineScrollbar timelineScroll;//The timeline scroll bar at the bottom of the software. 
BufferedReader r;//Used for reading data input.
//An array of modules. Each module is responsible for 
//the visualization of a certain type of data.
ArrayList<VisualizationModule> modules;
//The time at which the data was taken.
ArrayList<Long> dataTime;
//The time generated from dataTime.
//Necessary because in order for the visualization animation to be smooth,
//new data points needs to be added between the original data points.
//This array holds the list of original time and new time. 
ArrayList<Long> newTime;
//A map that maps the newTime to the dataTime.
//Allowing the user to view the original data if necessary.
ArrayList<Integer> newTimeMapDataTime;


void setup() {
  frameRate(15);
  size(800, 600, P3D);
  noStroke();

  //Initialize ArrayLists.
  modules = new ArrayList<VisualizationModule>();
  dataTime = new ArrayList<Long>();
  newTime = new ArrayList<Long>();
  newTimeMapDataTime = new ArrayList<Integer>();
  
  //Original data from flight for different modules.
  //To be passed to the constructor of those modules.
  ArrayList<Float[]> orientationData = new ArrayList<Float[]>();//OrientationModule
  ArrayList<Float[]> heightData = new ArrayList<Float[]>();//HeightModule

  //Read data from file and store them in ArrayLists.
  r = createReader("complete.txt");
  try {
    String line = r.readLine();
    while (line != null)
    {
      StringTokenizer st = new StringTokenizer(line);
      orientationData.add(readFloats(3, st));
      dataTime.add(readTime(st.nextToken()));
      heightData.add(readFloats(1,st));
      line = r.readLine();
    }
  }
  catch(Exception e)
  {
    e.printStackTrace();
  }

  //Create and adds different modules.
  modules.add(new OrientationModule(400, 280, 600, 400, orientationData));
  modules.add(new HeightModule(0,0,20,height-16,heightData));
  
  //Generate new data to make the visualization smooth.
  generateData(100);
  //Intialzie the TimeLineScrollBar.
  timelineScroll = new TimelineScrollbar(0, height-16, width, 16,newTime);
}


/*
 * Generate new data based on original data.
 * This is necessary to make the visualization smooth.
 * Interval is the desired time interval in milli second of new data points.
 * The shorter the interval the more smooth the animation.
 * Note, a interval that is too small may cause performance issues.
 */
private void generateData(long interval)
{
  for (int i = 0;i<dataTime.size()-1;i++)//For each consecutive data pairs
  {
    long startTime = dataTime.get(i);
    long stopTime = dataTime.get(i+1);
    long middleTime = (interval - startTime%interval)%interval + startTime;
    while (middleTime < stopTime)
    {
      newTime.add(middleTime);
      newTimeMapDataTime.add(i);
      for (VisualizationModule m: modules)
        m.addMapped(startTime, stopTime, middleTime, i);
      middleTime += interval;
    }
  }

  //Add the last data point in.
  if (dataTime.get(dataTime.size()-1)%interval == 0)
    for (VisualizationModule m: modules)
      m.addGenerated(m.getOriginal(dataTime.size()-1));
}

/** Get the calendar from milli second. 
  */
public static Calendar getCalendar(long millis)
{
  Calendar c = Calendar.getInstance();
  c.setTimeInMillis(millis);
  return c;
}

/**
  * Read a number of float point numbers from a StringTokenizer
  * and store them in an array. The numbers need to be separated
  * by space.
  */
public static Float[] readFloats(int count, StringTokenizer st)
{
  Float[] result = new Float[count];
  for (int i = 0;i<count;i++)
    result[i] = Float.parseFloat(st.nextToken());
  return result;
}


void draw() {
  background(255);
  for (VisualizationModule m:modules)
    m.drawData(timelineScroll.getIndex());
  timelineScroll.update();
  timelineScroll.display();
  stroke(0);
}

/**
  * Parse time from string.
  * String should be in format of
  * "MM-DD_HH:MM:SS.Milisecond".
  * Return time in millisecond. 
  */
Long readTime(String text)
{
    int dash = text.indexOf("-");
    int underscore = text.indexOf("_");
    int dot = text.indexOf(".");
    int month = Integer.parseInt(text.substring(0,dash));
    int date = Integer.parseInt(text.substring(dash+1,underscore));
    StringTokenizer st = new StringTokenizer(text.substring(underscore+1,dot));
    int hour = Integer.parseInt(st.nextToken(":"));
    int minute = Integer.parseInt(st.nextToken(":"));
    int second = Integer.parseInt(st.nextToken(":"));
    long millisecond = Integer.parseInt(text.substring(dot+1))*10;
    Calendar c = Calendar.getInstance();
    c.set(2013, month, date, hour, minute, second);
    return c.getTimeInMillis()+millisecond;
}

