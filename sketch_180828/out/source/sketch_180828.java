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

public class sketch_180828 extends PApplet {

Shape[] s;
int sn = 5;

public void setup()
{
    
    background(50);    

    s = new Shape[sn];
    for(int si=0; si<sn; si++)
        s[si] = new Shape(random(width), random(height));
}

public void draw()
{
    for(int si=0; si<sn; si++)
        s[si].draw();
}

class Shape
{
    int vn = 4;
    int thresh = 100;

    PVector[] vertex;
    int c;

    Shape(float px_, float py_)
    {
        vertex = new PVector[vn];
        for(int i=0; i<vn; i++){
             vertex[i] = new PVector(px_ + random(-thresh, thresh), py_+random(-thresh, thresh));
        }
        c = color(random(255), random(255), random(255));
    }

    public void draw()
    {
        noStroke();
        fill(c);
        beginShape();
        for(int j=0; j<vn; j++){
            vertex(vertex[j].x, vertex[j].y);
        }
        endShape(CLOSE);
    }
}
  public void settings() {  size(800, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_180828" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
