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

public class sketch_180910 extends PApplet {

int speed = 3; //<>//

// Racaman's sequence

int line_num = 10000;
int start_x = 30;
int start_y = 30;
int padding = 5;
float min_len = 150;
float max_len = 1500;
ArrayList<Line>  lines = new ArrayList<Line>();
PVector START = new PVector(0, 5);

int index = 0;
int count = 1;
int[] sequence = new int[line_num];
boolean[] numbers = new boolean[line_num];
int[] directions = new int[line_num];

boolean bMaxX = false, bMinX = false, bMaxY = false, bMinY = false;
int preDirection = -1;

public boolean check(PVector p)    
{
    print("check p = ");
    println(p);
    return p.x > 0 && p.y > 0;
}

public void setupNum()
{
    if (count >= line_num) return;

    int next = index - count;
    if(next < 0 || numbers[next]){
        next = index + count;
    }

    numbers[next] = true;
    sequence[count] = next;

    PVector p = new PVector();
    PVector q = new PVector();
    if(lines.size() == 0) p = START;
    else p = lines.get(lines.size()-1).end;
    q = new PVector();

    int direction;
    boolean bOut = true;

    do {
        bOut = false;
        direction = PApplet.parseInt(random(0.0f, 4.0f));
        println(direction + " " + preDirection);
        if(direction == 0 && bMaxX) bOut = true;
        if(direction == 1 && bMaxY) bOut = true;
        if(direction == 2 && bMinX) bOut = true;
        if(direction == 3 && bMinY) bOut = true;
    } while(bOut);
    preDirection = direction;

    int length = next % 100;
    switch(direction){
        case 0:
            // q.x = p.x + next;
            q.x = p.x + length;
            q.y = p.y;
            break;
        case 1:
            q.x = p.x;
            // q.y = p.y + next;
            q.y = p.y + length;
            break;
        case 2:
            // q.x = p.x - next;
            q.x = p.x - length;
            q.y = p.y;
            break;
        case 3:
            q.x = p.x;
            // q.y = p.y - next;
            q.y = p.y - length;
            break;
    }
    
    Line line = new Line(p, q);
    println("q = " + q);
    lines.add(line);

    index = next;

    bMaxX=false; bMinX=false; bMaxY=false; bMinY=false;
    if( q.x > width ) bMaxX = true;
    else if( q.x < 0 ) bMinX = true;
    if (q.y > height ) bMaxY = true;
    else if (q.y < 0 ) bMinY = true;

    count++;
}

int bgColor = 10;
PVector direction;
float STROKE_WEIGHT = 0.5f;
float scaleFactor = 1.0f;

public void setup()
{
    
    frameRate(30);
    background(bgColor);
    strokeJoin(ROUND);

    numbers[index] = true;
    directions[index] = 0;
}

public void draw()
{
    setupNum();
    translate(width/2, height/2);
    // scaleFactor = width/biggest;
    scale(scaleFactor);

    background(bgColor);
    blendMode(BLEND);

    int num = frameCount / speed;
    int percent = frameCount % speed;

    for (int i=0; i < lines.size(); i++)
    {
        strokeWeight(STROKE_WEIGHT);
        if(i < num) lines.get(i).drawAll();
        else if (i == num) 
        {
            lines.get(i).partialDraw(percent);
        }
    }

    // saveFrame("frame/lines-#####.png");
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
    //strokeWeight(0.5);
    stroke(255);
    line(start.x, start.y, end.x, end.y);
  }
  
  public void drawPoint()
  {
    ellipse(start.x, start.y, r, r);
  }
}
  public void settings() {  size(800, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_180910" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
