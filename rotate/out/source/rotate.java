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

public class rotate extends PApplet {

int px, py;

float sw = 3.0f;

public void setup()
{
    frameRate(30);
    

    px = width/2;
    py = height/2;

    strokeWeight(3.0f);
}

float b = 0.0f;

public void draw()
{
    if(frameCount % 30 == 0) px += random(-50, 50); py += random(-50, 50);
    
    background(255);
    translate(width/2, height/2);
    float a = atan2(px-width/2, py-height/2);
    ellipse(px-width/2, py-width/2, 15, 15);
    rotate(a);
    rect(-30, -5, 60, 10);
    rotate(-a);
    rotate(HALF_PI);
    line(-100, 0, 100, 0);
    b += 0.001f;
    
    saveFrame("frame/rotate###.png");
}
  public void settings() {  size(640, 640); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "rotate" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
