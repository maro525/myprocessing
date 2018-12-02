// https://www.openprocessing.org/sketch/399194

ArrayList<Donut> donuts = new ArrayList<Donut>();

void setup()
{
  size(480, 480, P2D);
  background(255f);
  
  donuts.add(new Donut(0f, 0f, 50f, 1, 40f, false));
  donuts.add(new Donut(0f, 0f, 70f, 1, -5f, true));
  donuts.add(new Donut(0f, 0f, 100f, 1, 65f, false));
  donuts.add(new Donut(0f, 0f, 140f, 1, -25f, true));
  donuts.add(new Donut(0f, 0f, 200f, 1, 40f, false));
}

void draw()
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
