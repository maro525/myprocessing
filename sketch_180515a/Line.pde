class Line
{
  Point start, end;
  color c;
  float strokeWeight = 2;
  
  Line(Point _start, Point _end)
  {
    start = _start;
    end = _end;
  }
  
  void setColor(color _c)
  {
    c = _c;
  }
  
  void drawLine()
  {
    stroke(c);
    strokeWeight(strokeWeight);
    line(start.px, start.py, end.px, end.py);
  }
}
