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

public class sketch_180515a extends PApplet {

Point[] points;
Line[] lines;
int num_corners = 4;
int randomness = 50;
int num_each_line = 1;
int line_num, point_num;
int start_angle = 45;

public void setup()
{
  
  background(255);
  

  point_num = num_corners * num_each_line * 2;
  line_num = point_num / 2;
  points = new Point[point_num];
  lines = new Line[line_num];

  for (int i = 0; i < num_corners; i++)
  {
    int radius = width/3;
    int ang = (start_angle + i * 360 / num_corners) % 360;
    float rad = radians(ang);
    int x = width/2 + PApplet.parseInt((radius * cos(rad)));
    int y = height/2 + PApplet.parseInt((radius * sin(rad)));
    for (int k = 0; k < num_each_line*2; k++) {
      x += random(-randomness, randomness);
      y += random(-randomness, randomness);
      int point_index = i * num_each_line * 2 + k;
      //println(point_index);
      points[point_index] = new Point(x, y);
    }
  }
  
  for (int j = 0; j < line_num; j++){
    println("");
    int start_blick = j / (num_each_line*2);
    int start_index;
    if(start_blick % 2 == 0)
    {
      println("ok");
      println(j%num_each_line);
      start_index = start_blick * num_each_line * 2 * 2 + j % num_each_line;
    }
    else
    {
      println("notok");
     start_index = start_blick * num_each_line * 2 * 2 + j % num_each_line + 1; 
    }
    int end_index;
    if(j % 2 == 0) 
    {
      end_index = (start_index + num_each_line*2) % (num_each_line * num_corners * 2);
    } 
    else if((start_index - num_each_line*2) < 0) 
    {
      end_index = (num_each_line * num_corners - (start_index - num_each_line*2)) % (num_each_line * num_corners * 2);
    }
    else 
    {
      end_index = (start_index - num_each_line*2) % (num_each_line * num_corners);
    };
    println(start_index);
    println(end_index);
    lines[j] = new Line(points[start_index], points[end_index]);
    int c = color(10);
    lines[j].setColor(c);
  }

}

public void draw()
{
  for (int b = 0; b < line_num; b++) {
    lines[b].drawLine();
  }
}
class Line
{
  Point start, end;
  int c;
  float strokeWeight = 2;
  
  Line(Point _start, Point _end)
  {
    start = _start;
    end = _end;
  }
  
  public void setColor(int _c)
  {
    c = _c;
  }
  
  public void drawLine()
  {
    stroke(c);
    strokeWeight(strokeWeight);
    line(start.px, start.py, end.px, end.py);
  }
}
class Point
{
  int px, py;
  
  Point(int x, int y)
  {
    px = x;
    py = y;
  }
  
  public void reset(int x, int y)
  {
    px = x;
    py = y;
  }
}
  public void settings() {  size(800, 800);  smooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_180515a" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
