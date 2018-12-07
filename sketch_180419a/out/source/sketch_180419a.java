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

public class sketch_180419a extends PApplet {

// https://www.openprocessing.org/sketch/494102

Particle[] particles_a;
Particle[] particles_b;
Particle[] particles_c;
int nums = 100;
int noiseScale = 20000;

class Particle
{
  PVector dir, vel, pos;
  float speed;

  Particle(float x, float y) {
    dir = new PVector(0, 0);
    vel = new PVector(0, 0);
    pos = new PVector(x, y);
    speed = 2.0f;
  }

  public void move()
  {
    float angle = noise(pos.x/noiseScale, pos.y/noiseScale)*TWO_PI*noiseScale;
    dir.x = cos(angle);
    dir.y = sin(angle);
    vel = dir.copy();
    vel.mult(speed);
    pos.add(vel);
  }

  public void checkEdge()
  {
    if (pos.x > width || pos.x < 0 || pos.y > height || pos.y < 0)
    {
      pos.x = random(50, width);
      pos.y = random(50, height);
    }
  }

  public void display(float r)
  {
    ellipse(pos.x, pos.y, r, r);
  }
}

public void setup()
{
  
  background(21, 8, 50);
  particles_a = new Particle[nums];
  particles_b = new Particle[nums];
  particles_c = new Particle[nums];
  for (int i=0; i < nums; i++)
  {
    Particle p_a = new Particle(random(0, width), random(0, height));
    particles_a[i] = p_a;
    Particle p_b = new Particle(random(0, width), random(0, height));
    particles_b[i] = p_b;
    Particle p_c = new Particle(random(0, width), random(0, height));
    particles_c[i] = p_c;
  }
}

public void draw()
{
  noStroke();
  smooth();
  for (int i = 0; i < nums; i++)
  {
    float radius = map(i, 0, nums, 1, 2);
    float alpha  = map(i, 0, nums, 0, 250);

    fill(69, 33, 124, alpha);
    particles_a[i].move();
    particles_a[i].display(radius);
    particles_a[i].checkEdge();

    fill(7, 153, 242, alpha);
    particles_b[i].move();
    particles_b[i].display(radius);
    particles_b[i].checkEdge();

    fill(255, 255, 255, alpha);
    particles_c[i].move();
    particles_c[i].display(radius);
    particles_c[i].checkEdge();
  }

  saveFrame("frame/###.png");
}
  public void settings() {  size(800, 600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_180419a" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
