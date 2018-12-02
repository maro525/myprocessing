import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class sketch_180715a extends PApplet {

public void setup()
{
  
}

float b = 0.0f;

public void draw()
{
  background(255);
  translate(width/2, height/2);
  float a = atan2(mouseY-width/2, mouseX-height/2);
  println("radian " + a + " degree " + degrees(a));
  ellipse(mouseX-width/2, mouseY-width/2, 15, 15);
  rotate(a);
  rect(-30, -5, 60, 10);
  rotate(-a);
  rotate(HALF_PI);
  line(-100, 0, 100, 0);
  b += 0.001f;
}
  public void settings() {  size(640, 640); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_180715a" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
