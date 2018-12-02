int speed = 30;

int line_num = 50;
int padding = 50;
float min_len = 150;
float max_len = 1500;
ArrayList<Line>  lines = new ArrayList<Line>();

void setupLines()
{
  PVector p, q;
  p = new PVector(random(padding, width-padding), random(padding, height-padding));
  q = new PVector(0, 0);
  for(int i = 0; i < line_num; i++)
  {
    if(i ==0)
    {
      while(p == q || q.x < padding || q.x > width-padding || q.y < padding || q.y > height-padding) 
      {
        float length = 0;
        while(abs(length) <  min_len) length = random(-max_len, max_len);
        q = new PVector(p.x + length, p.y);
      }
    }
    else
    {
      p = lines.get(lines.size()-1).end;
      
      while (p == q || q.x < padding || q.x > width-padding || q.y < padding || q.y > height-padding)
      {
        float length = 0;
        while(abs(length) < min_len) length = random(-max_len, max_len);
        if(i%2 == 0) q = new PVector(p.x + length, p.y + length);
        else q = new PVector(p.x + length, p.y - length);
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

void setup()
{
  size(800, 600);
  frameRate(30);
  background(bgColor);
  strokeJoin(ROUND);
  
  setupLines();
  
  direction = new PVector(0, 0);
}

void draw()
{
  background(bgColor);
  blendMode(BLEND);
  
  int num = frameCount / speed;
  PVector dir = lines.get(num).getDir();
  direction.x += -dir.x*2;
  direction.y += -dir.y*2;
  pushMatrix();
  translate(direction.x, direction.y);
  
  for(int i=0; i < lines.size(); i++)
  {
    if(i < num) lines.get(i).partialDraw(speed);
    else if (i == num) 
    {
      int percent = frameCount % speed;
      lines.get(i).partialDraw(percent);
    }
    
    //lines.get(i).draw();

    //lines.get(i).drawPoint();
    
    //saveFrame("frame/" + frameCount + ".tif");
  }
  popMatrix();
}
