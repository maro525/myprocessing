class Line
{
  PVector start, end, current, bCurrent;
  float r = 0.5;
  
  Line(PVector _start, PVector _end)
  {
    start = _start;
    end = _end;
    current = new PVector(0, 0);
    bCurrent = new PVector(0, 0);
  }
  
  void setCurrent(int percent)
  {
    float length;
    
    bCurrent.x = current.x;
    bCurrent.y = current.y;
    
    if(start.x != end.x) 
    {
      length = (end.x - start.x) * percent;
      current.x = start.x + (length/speed);
    }
    else current.x = end.x;
    
    if(start.y != end.y) 
    {
      length = (end.y - start.y) * percent;
      current.y = start.y + (length/speed);
    }
    else current.y = end.y;
  }
  
  PVector getDir()
  {
    PVector dir = new PVector(0, 0);
    dir.x = current.x - bCurrent.x;
    dir.y = current.y - bCurrent.y;
    return dir;
  }
  
  void partialDraw(int percent)
  {
    setCurrent(percent);
    //strokeWeight(3.0);
    line(start.x, start.y, current.x, current.y);
  }
  
  void drawAll()
  {
    strokeWeight(0.5);
    line(start.x, start.y, end.x, end.y);
  }
  
  void drawPoint()
  {
    ellipse(start.x, start.y, r, r);
  }
}
