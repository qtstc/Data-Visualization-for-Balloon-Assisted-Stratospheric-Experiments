Data Visualization for-Balloon Assisted Stratospheric Experiments
=================================================================

This project is created to visualize and analyze the environmental data collected by high altitude balloons during BASE research 2013.

It consists of two parts:
* Visualization of balloon flight
* Visualization and analysis of light intensity data.

For details on the collection of the original data, please refer to the [Arduino code](https://github.com/qtstc/Arduino-Code-for-Balloon-Assisted-Stratospheric-Experiments).

## Flight Visualization([demo](http://www.youtube.com/watch?v=pSrWSYUl3eU))
This tool allows the user to visualize the orientation of an experiment box attached to a high-altitude balloon. The user can either look at the orientation of the box at specific points during the flight or leave the simulation running and look at how the data changes over time.

The original data used is the pitch, roll and yaw of the experimental box, and the time and altitude collected from a GPS receiver. Please refer to [existing data files](https://github.com/qtstc/Data-Visualization-for-Balloon-Assisted-Stratospheric-Experiments/tree/master/Flight_Visualization/data) for the data format. The first three columns are the pitch, roll and yaw in degrees. The fourth column is the time at which the data is collected and the last column is the altitude.

## Light Intensity Data Visualization([demo](http://www.youtube.com/watch?v=th-NEccRkbk))
This tool allows the user to visualize and analyze how the intensity of light changes during a high-altitude balloon flight. It plots the voltage output against time(or altitude) graph for eight different LEDs which are used as photometers. A filtering mechanism is included to allow user to only look at LED readings that were taken when the LED is facing a specific direction.

The original data used is the voltage readding from eight photometers(LEDs), pitch, roll and yaw of the box, GPS time and altitude at which the data is taken. Sample data files can be found [here](https://github.com/qtstc/Data-Visualization-for-Balloon-Assisted-Stratospheric-Experiments/tree/master/Light_Intensity_Visualization/data).

=================================================================
Copyright 2013 Tao Qian

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
