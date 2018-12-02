class Donut
{
  ArrayList<DonutSection> sections = new ArrayList<DonutSection>();
  
  final float positionX;
  final float positionY;
  
  final float radius;
  
  final float marginAngle;
  float offsetAngle;
  final boolean reverseFlag;
  
  Donut(float posX, float posY, float r, int sectionNum, float huePrm, boolean revFlag)
  {
    positionX = posX;
    positionY = posY;
    radius = r;
    
    marginAngle = -radians(30);
    reverseFlag = revFlag;
    
    for(int i = 0; i < sectionNum; i++)
    {
      sections.add(new DonutSection(huePrm));
    }
  }
  
  void draw()
  {
    noFill();
    strokeCap(SQUARE);
    strokeWeight(5f);
    ellipseMode(RADIUS);
    
    for(DonutSection currentSection : sections)
    {
      offsetAngle += marginAngle / 2;
      
      float arcAngle = currentSection.getArcAngle(getTotalQuantity());
      stroke(currentSection.getColor());
      arc(positionX, positionY, radius, radius, offsetAngle, offsetAngle + arcAngle - marginAngle);
      
      offsetAngle += arcAngle;
      offsetAngle -= marginAngle / 2;
    }
  }
  
  float getTotalQuantity()
  {
    float totalQuantity = 0f;
    for(DonutSection currentSection : sections)
    {
      totalQuantity += currentSection.getQuantity();
    }
    return totalQuantity;
  }
  
  void reflect(float x, float y)
  {
    if(reverseFlag)
    {
      float tmp = x;
      x = y;
      y = tmp;
    }
    
    for(DonutSection currentSection : sections)
    {
      currentSection.reflect(x,y);
    }
    
    offsetAngle = atan2(y - positionY, x - positionX);
  }
  
  void update()
  {
    for(DonutSection currentSection : sections)
    {
      currentSection.update();
    }
  }
}
