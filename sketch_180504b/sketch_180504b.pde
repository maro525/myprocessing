int speed = 15; //<>//

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

void setup()
{
  size(1000, 800);
  frameRate(30);
  background(bgColor);
  strokeJoin(ROUND);

  setupLines();
}

void draw()
{
  background(bgColor);
  blendMode(BLEND);

  int num = frameCount / speed;
  int percent = frameCount % speed;

  for (int i=0; i < lines.size(); i++)
  {
    int n = abs(10-(num-i) % 10) / 3;
    float w = float(str(n));
    if (i < num && num <50) {
      //float w = (8 - (num-i)) / 10;
      strokeWeight(w);
      lines.get(i).drawAll();
    }
    else if(num >= 50 && i < num){
      float we = float((70 - num) / 20);
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
