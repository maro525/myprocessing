int sw = 5;
float r = 300;

void setup()
{
  size(800, 800);
  strokeWeight(sw);
  smooth();
}

void draw()
{
  background(250);
  translate(width/2, height/2);
  stroke(0);
  noFill();
  //ellipse(0, 0, r*2, r*2);

  float startAngle, endAngle;
  endAngle = 0.1 * frameCount % 360;
  if (endAngle > 355) startAngle = endAngle;
  else if (endAngle > 180) startAngle = endAngle - 180;
  else startAngle = 0;
  println(startAngle);
  println(endAngle);

  float x, y;

  for (float ang = startAngle; ang < endAngle; ang += 5)
  {
    float rad = radians(ang);
    x = r * cos(rad);
    y = r * sin(rad);
    point(x, y);
  }
  
  stroke(150);
  noFill();
  arc(0, 0, r*2-50, r*2-50, startAngle, endAngle);
}
