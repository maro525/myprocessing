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

public class sketch_180424b extends PApplet {

// https://www.openprocessing.org/sketch/399194

ArrayList<Donut> donuts = new ArrayList<Donut>();

public void setup()
{
  
  background(255f);
  
  donuts.add(new Donut(0f, 0f, 50f, 1, 40f, false));
  donuts.add(new Donut(0f, 0f, 70f, 1, -5f, true));
  donuts.add(new Donut(0f, 0f, 100f, 1, 65f, false));
  donuts.add(new Donut(0f, 0f, 140f, 1, -25f, true));
  donuts.add(new Donut(0f, 0f, 200f, 1, 40f, false));
}

public void draw()
{
  translate(width / 2, height / 2);
  colorMode(HSB, 100f);
  background(0f, 0f, 100f);
  
  float tmpAngle = radians(frameCount);
  
  for(Donut currentDonut : donuts)
  {
    currentDonut.reflect(10f * cos(tmpAngle), 10f * sin(tmpAngle));
    currentDonut.update();
    currentDonut.draw();
  }
}
class Donut
{
  ArrayList<DonutSection> sections = new ArrayList<DonutSection>();
  
  final float positionX;
  final float positionY;
  
  final float radius;
  
  final float marginAngle;
  float offsetAngle;
  final boolean reverseFlag;
  
  Donut(float posX, float posY, float r, int sectionNum, float huePrm, boolean revFlag)
  {
    positionX = posX;
    positionY = posY;
    radius = r;
    
    marginAngle = -radians(30);
    reverseFlag = revFlag;
    
    for(int i = 0; i < sectionNum; i++)
    {
      sections.add(new DonutSection(huePrm));
    }
  }
  
  public void draw()
  {
    noFill();
    strokeCap(SQUARE);
    strokeWeight(5f);
    ellipseMode(RADIUS);
    
    for(DonutSection currentSection : sections)
    {
      offsetAngle += marginAngle / 2;
      
      float arcAngle = currentSection.getArcAngle(getTotalQuantity());
      stroke(currentSection.getColor());
      arc(positionX, positionY, radius, radius, offsetAngle, offsetAngle + arcAngle - marginAngle);
      
      offsetAngle += arcAngle;
      offsetAngle -= marginAngle / 2;
    }
  }
  
  public float getTotalQuantity()
  {
    float totalQuantity = 0f;
    for(DonutSection currentSection : sections)
    {
      totalQuantity += currentSection.getQuantity();
    }
    return totalQuantity;
  }
  
  public void reflect(float x, float y)
  {
    if(reverseFlag)
    {
      float tmp = x;
      x = y;
      y = tmp;
    }
    
    for(DonutSection currentSection : sections)
    {
      currentSection.reflect(x,y);
    }
    
    offsetAngle = atan2(y - positionY, x - positionX);
  }
  
  public void update()
  {
    for(DonutSection currentSection : sections)
    {
      currentSection.update();
    }
  }
}
class DonutSection
{
  static final float NOISE_SCALE = 0.005f;
  float quantity;
  
  float hueParameter;
  final float saturationParameter;
  final float brightnessParameter;
  
  float seed;
  
  DonutSection(float huePrm)
  {
    setHue(random(huePrm - 5f, huePrm + 5f));
    
    switch(PApplet.parseInt(random(10f)))
    {
      case 0:
      case 1:
      case 2:
        saturationParameter = 0f;
        brightnessParameter = 100f;
        break;
      case 3:
        addHue(50f);
      default:
        saturationParameter = 70f;
        brightnessParameter = 90f;
        break;
    }
    
    seed = random(0f, 100f);
  }
  
  public int getColor()
  {
    colorMode(HSB, 100f);
    return color(hueParameter, saturationParameter, brightnessParameter);
  }
  
  public float getQuantity()
  {
    return quantity;
  }
  
  public float getArcAngle(float totalQuantity)
  {
    return TWO_PI * quantity / totalQuantity;
  }
  
  public void setHue(float huePrm)
  {
    hueParameter = (huePrm % 100 + 100) % 100;
  }
  
  public void addHue(float hueDistance)
  {
    setHue(hueParameter + hueDistance);
  }
  
  public void reflect(float x, float y)
  {
    quantity = noise(seed + x * NOISE_SCALE, y * NOISE_SCALE);
    quantity = pow(quantity, 3);
  }
  
  public void update()
  {
    addHue(0.1f);
  }
}
  public void settings() {  size(480, 480, P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_180424b" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
