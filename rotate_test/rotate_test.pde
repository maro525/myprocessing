void setup()
{
  size(640, 640);
}

float b = 0.0;

void draw()
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
  b += 0.001;
  
  saveFrame("frame/rotate###.png");
}
