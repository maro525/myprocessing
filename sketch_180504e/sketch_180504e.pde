int sx = 20;
int sy = 40;
float sw = 0.1;
int length = 220;
float speed = 0.01;

void setup()
{
  size(800, 300);
  frameRate(20);
  background(248);
}

void draw()
{
  if(sx > 780) return;
  float w = abs(-sw * (sw - 20.0) * speed);
  println(w);
  strokeWeight(w);
  line(sx, sy, sx, sy + length);
  sx += (w+0.990);
  sw += 0.05;
  
  saveFrame("frame/" + frameCount + ".png");
}
