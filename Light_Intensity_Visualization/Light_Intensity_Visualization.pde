import java.util.*;

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
 * It plots the voltage output against time(or altitude) 
 * graph for eight different LEDs which are used as photometers.
 * A filtering mechanism is included to allow user to only look 
 * at LED readings that were taken when the LED is facing a 
 * specific direction.
 *
 * Author: Tao Qian (taoqian_2015@depauw.edu)
 */

String fileName = "78.txt";


FlightData data;//Contains all the data.
boolean needDraw;//Flag used to indicate that the graph needs to be redrawn.

SquareButton[] LEDButtons;//Buttons for selecting different LEDs.
int selectedLED;//The LED that is selected (0-7). It's data should be drawn.

SquareButton changeModeButton;//Button for user to change between time/altitude mode.
boolean timeMode;//Flag used to indicate the current mode.

//Describe the targeted direction. Contains three element ranging from 0 to 360 
//representing pitch, roll and yaw.
float[] target;
//Describe the window of the LEDs we are looking at. (0 - 180). Contains 3 elements.
//e.g. if window[0] = 45, target[0] = 0, the LEDs we are looking at have its
//pitch between -45 degrees and +45 degrees.
float[] window;
//Sliders for changing the target and window. 
//First three are for target, second three are for window.
Slider[] sliders;

//Button used for applying the target and window settings.
SquareButton applyButton;

//The color used to represent different LEDs.
color[] colors = new color[] {
  color(0, 0, 0, 255), color(155, 155, 155, 255), color(255, 0, 0, 255), color(255, 255, 0, 255), color(0, 255, 0, 255), color(0, 0, 255, 255), color(255, 0, 255, 255), color(55, 55, 55, 255)
};


void setup()
{
  target = new float[] {
    0, 0, 0
  };
  window = new float[] {
    0, 0, 0
  };
  needDraw = true;
  timeMode = true;
  selectedLED = 0;
  //Data to be passed to flight data.
  ArrayList<Long> time =  new ArrayList<Long>();
  ArrayList<ArrayList<Float>> leds = new ArrayList<ArrayList<Float>>();
  ArrayList<Float[]> orientation = new ArrayList<Float[]>();
  ArrayList<Float> altitude = new ArrayList<Float>();
  for (int i = 0;i<8;i++)//Intialize the arrays of LED readings.
  {
    ArrayList<Float> led = new ArrayList<Float>();
    leds.add(led);
  }

  /* Read data from file.
   * The data should be in a format that match the following criteria.
   * - Start with a column name line.
   * - The rest of the line contains numbers in int or float.
   * - Each line contains 13 numbers, with the first 8 being the readings
   *   from the 8 LEDs, the next 3 being the orientation in degrees in 
   *   pitch, roll and heading and the last two being the time and altitude in meters.
   * - Values in the same line are sepreated by a single space.
   */
  BufferedReader r = createReader(fileName);
  try {
    r.readLine();//Get rid of column names.
    String line = r.readLine();
    while (line != null)
    {
      StringTokenizer st = new StringTokenizer(line);
      for (int i = 0;i<8;i++)
        leds.get(i).add(Float.parseFloat(st.nextToken()));
      orientation.add(readFloats(3, st));
      time.add(readTime(st.nextToken()));
      altitude.add(Float.parseFloat(st.nextToken()));
      line = r.readLine();
    }
    r.close();
  }
  catch(Exception e)
  {
    e.printStackTrace();
  }
  size(800, 650, P3D);
  data = new FlightData(20, 20, 530, 530, leds, time, orientation, altitude, colors);
  //Set up UI.
  setUpSliders();
  setUpLEDButtons();
  //Setup Change Mode Button
  changeModeButton = new SquareButton(650, 20, 110, 20, color(255, 150, 0), "Change Mode");
}

void setUpSliders()
{
  //Names of the sliders used.
  String[] sliderLabels = new String[] {
    "pitch", "roll", "yaw", "pitch range", "roll range", "yaw range"
  };

  //Setup sliders
  sliders = new Slider[6];
  int sliderX = 600;
  int sliderY = 280;
  int sliderW = 180;
  int sliderH = 20;
  int sliderSpace = 20;
  //Initialize them at different time because the ranges are different.
  for (int i = 0;i<3;i++)
  {
    sliders[i] = new Slider(sliderX, sliderY, sliderW, sliderH, 360, sliderLabels[i]);
    sliderY += sliderH+sliderSpace;
  }
  for (int i = 3;i<6;i++)
  {
    sliders[i] = new Slider(sliderX, sliderY, sliderW, sliderH, 180, sliderLabels[i]);
    sliderY += sliderH+sliderSpace;
  }

  //Initialize the apply button.
  applyButton = new SquareButton(660, 510, 60, 20, color(255, 150, 0), "Apply");
  applyButton.showText = true;
}

void setUpLEDButtons()
{
  String[] buttonNames = new String[] {
    "IR940", "IR830", "Red", "Yellow", "Green", "Blue", "V400", "UV351"
  };
  LEDButtons = new SquareButton[8];
  int boxX = 120;
  int boxY = 580;
  int boxW = 50;
  int boxH = 50;
  for (int i = 0;i<LEDButtons.length;i++)
  {
    LEDButtons[i] = new SquareButton(boxX, boxY, boxW, boxH, colors[i], buttonNames[i]);
    boxX += boxW;
  }
}

void draw()
{
  //First check whether the orientation sliders are changed and update the sliders.
  boolean redrawOrientation = false;
  for (int i = 0;i<sliders.length;i++)
  {
    if (sliders[i].update())
    {
      redrawOrientation = true;
    }
    sliders[i].display();
  }

  //If changed, draw a rectange to cover the old one.
  if (redrawOrientation)
  {
    fill(255);
    stroke(255);
    rect(600, 100, 180, 400);
  }
  drawOrientation();//Then draw again.


  if (mousePressed) 
  {
    //First check whether it is one of the LED buttons.
    for (int i = 0;i<LEDButtons.length;i++)
    {
      if (LEDButtons[i].isOver())
      {
        selectedLED = i;
        needDraw = true;
        break;
      }
    }
    //If apply button is pressed, collect the UI data and redraw.
    if (applyButton.isOver())
    {
      target[0] = sliders[0].index;
      target[1] = sliders[1].index;
      target[2] = sliders[2].index;
      window[0] = sliders[3].index;
      window[1] = sliders[4].index;
      window[2] = sliders[5].index;
      needDraw = true;
    }

    //If change mode button is pressed, change the mode.
    if (changeModeButton.isOver())
    {
      timeMode = !timeMode;
      mousePressed = false;
      needDraw = true;
    }
  }

  if (!needDraw)
    return;
  background(255);
  if (timeMode)
    data.drawDataByTime(target, window, selectedLED);
  else
    data.drawDataByHeight(target, window, selectedLED);
  needDraw = false;

  //Draw the buttons.
  for (int i = 0;i<LEDButtons.length;i++)
    LEDButtons[i].drawButton();
  changeModeButton.drawButton();
  applyButton.drawButton();
}

//Method used to read time string in the format of "6-26_15:49:9.0".
Long readTime(String text)
{
  int dash = text.indexOf("-");
  int underscore = text.indexOf("_");
  int dot = text.indexOf(".");
  int month = Integer.parseInt(text.substring(0, dash));
  int date = Integer.parseInt(text.substring(dash+1, underscore));
  StringTokenizer st = new StringTokenizer(text.substring(underscore+1, dot));
  int hour = Integer.parseInt(st.nextToken(":"));
  int minute = Integer.parseInt(st.nextToken(":"));
  int second = Integer.parseInt(st.nextToken(":"));
  long millisecond = Integer.parseInt(text.substring(dot+1))*10;
  Calendar c = Calendar.getInstance();
  c.set(2013, month, date, hour, minute, second);
  return c.getTimeInMillis()+millisecond;
}

public static Float[] readFloats(int count, StringTokenizer st)
{
  Float[] result = new Float[count];
  for (int i = 0;i<count;i++)
    result[i] = Float.parseFloat(st.nextToken());
  return result;
}

void drawOrientation()
{
  int w = 80;
  int h = 80;
  int d = 80;
  pushMatrix();
  translate(690, 180, 0);

  noStroke();
  pushMatrix();
  translate(0, 0, d);
  fill(#1e90ff, 255);
  ellipse(0, 0, 15, 15);
  fill(#ffffff, 255);
  text("N", -4, 4);
  popMatrix();

  pushMatrix();
  translate(-w, 0, 0);
  fill(#1e90ff, 255);
  ellipse(0, 0, 15, 15);
  fill(#ffffff, 255);
  text("E", -4, 4);
  popMatrix();

  rotateX(-radians(sliders[0].index));
  rotateZ(radians(sliders[1].index));
  rotateY(-radians(sliders[2].index));
  strokeWeight(1);
  stroke(#B8B8B8);
  fill(#888888, 220);
  box(w, h, d);

  translate(0, 0, d/2);
  fill(#CCCC00, 200);
  box(w/2, h/2, 1);
  popMatrix();
}

