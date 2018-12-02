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

public class sketch_180504b extends PApplet {

int speed = 15; //<>//

int line_num = 50;
int padding = 50;
float min_len = 150;
float max_len = 1500;
ArrayList<Line>  lines = new ArrayList<Line>();

public void setupLines()
{
  PVector p, q;
  p = new PVector(random(padding, width-padding), random(padding, height-padding));
  q = new PVector(0, 0);
  for (int i = 0; i < line_num; i++)
  {
    if (i ==0)
    {
      while (p == q || q.x < padding || q.x > width-padding || q.y < padding || q.y > height-padding) 
      {
        float length = 0;
        while (abs(length) <  min_len) length = random(-max_len, max_len);
        q = new PVector(p.x + length, p.y);
      }
    } else
    {
      p = lines.get(lines.size()-1).end;

      while (p == q || q.x < padding || q.x > width-padding || q.y < padding || q.y > height-padding)
      {
        float length = 0;
        while (abs(length) < min_len) length = random(-max_len, max_len);
        if (i%2 == 0) q = new PVector(p.x + length, p.y);
        else q = new PVector(p.x, p.y + length);
      }
    }
    print("p = ");
    print(p);
    print("q = ");
    println(q);
    Line line = new Line(p, q);
    lines.add(line);
  }
}

int bgColor = 248;
PVector direction;

public void setup()
{
  
  frameRate(30);
  background(bgColor);
  strokeJoin(ROUND);

  setupLines();
}

public void draw()
{
  background(bgColor);
  blendMode(BLEND);

  int num = frameCount / speed;
  int percent = frameCount % speed;

  for (int i=0; i < lines.size(); i++)
  {
    int n = abs(10-(num-i) % 10) / 3;
    float w = PApplet.parseFloat(str(n));
    if (i < num && num <50) {
      //float w = (8 - (num-i)) / 10;
      strokeWeight(w);
      lines.get(i).drawAll();
    }
    else if(num >= 50 && i < num){
      float we = PApplet.parseFloat((70 - num) / 20);
      strokeWeight(we);
      lines.get(i).drawAll();
    }
    
    

    if (i == num) 
    {
      strokeWeight(5);
      lines.get(i).partialDraw(percent);
    }
  }
  
  saveFrame("frame/lines-#####.png");
}
class Line
{
  PVector start, end, current, bCurrent;
  float r = 0.5f;
  
  Line(PVector _start, PVector _end)
  {
    start = _start;
    end = _end;
    current = new PVector(0, 0);
    bCurrent = new PVector(0, 0);
  }
  
  public void setCurrent(int percent)
  {
    float length;
    
    bCurrent.x = current.x;
    bCurrent.y = current.y;
    
    if(start.x != end.x) 
    {
      length = (end.x - start.x) * percent;
      current.x = start.x + (length/speed);
    }
    else current.x = end.x;
    
    if(start.y != end.y) 
    {
      length = (end.y - start.y) * percent;
      current.y = start.y + (length/speed);
    }
    else current.y = end.y;
  }
  
  public PVector getDir()
  {
    PVector dir = new PVector(0, 0);
    dir.x = current.x - bCurrent.x;
    dir.y = current.y - bCurrent.y;
    return dir;
  }
  
  public void partialDraw(int percent)
  {
    setCurrent(percent);
    //strokeWeight(3.0);
    line(start.x, start.y, current.x, current.y);
  }
  
  public void drawAll()
  {
    strokeWeight(0.5f);
    line(start.x, start.y, end.x, end.y);
  }
  
  public void drawPoint()
  {
    ellipse(start.x, start.y, r, r);
  }
}
  public void settings() {  size(1000, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_180504b" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
