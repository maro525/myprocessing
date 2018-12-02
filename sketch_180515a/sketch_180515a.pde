Point[] points;
Line[] lines;
int num_corners = 4;
int randomness = 50;
int num_each_line = 1;
int line_num, point_num;
int start_angle = 45;

void setup()
{
  size(800, 800);
  background(255);
  smooth();

  point_num = num_corners * num_each_line * 2;
  line_num = point_num / 2;
  points = new Point[point_num];
  lines = new Line[line_num];

  for (int i = 0; i < num_corners; i++)
  {
    int radius = width/3;
    int ang = (start_angle + i * 360 / num_corners) % 360;
    float rad = radians(ang);
    int x = width/2 + int((radius * cos(rad)));
    int y = height/2 + int((radius * sin(rad)));
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
    color c = color(10);
    lines[j].setColor(c);
  }

}

void draw()
{
  for (int b = 0; b < line_num; b++) {
    lines[b].drawLine();
  }
}
