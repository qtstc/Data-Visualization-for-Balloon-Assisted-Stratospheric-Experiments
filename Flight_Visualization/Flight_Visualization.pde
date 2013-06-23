import java.util.*;

TimelineScrollbar hs1;  // Two scrollbars

void setup() {
  size(1000, 600);
  noStroke();
  
  hs1 = new TimelineScrollbar(0, height-8, width, 16,100,1000,new Date(2013,6,11,15,1,0));
}

void draw() {
  background(255);
 
  hs1.update();
  hs1.display();
  
  stroke(0);
}
