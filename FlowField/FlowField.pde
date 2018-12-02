boolean showsFPS = false;
boolean showsField = false;
PFont font;

float gridSize = 70;
int xRes, yRes;
Node[] nodes;

int numParts = 5000;
Part[] parts;

void setup()
{
  size(940, 540);
  background(255);
  noStroke();
  rectMode(CENTER);
  ellipseMode(CENTER);
  createField();
  createParts();
  font = createFont("Helvetica", 24);
}

void draw()
{
  fill(0, 15);
  noStroke();
  rect(width/2, height/2, width, height);
  updateField();
  updateParts();
  if (showsFPS) displayFPS();
}

void scatter()
{
  for (int i=0; i<numParts; i++)
  {
    Part part = parts[i];
    part.vx += random(-1.0, 1.0) * 50.5;
    part.vy += random(-1.0, 1.0) * 50.5;
  }
}

void displayFPS()
{
  textFont(font, 18);
  fill(255);
  String output = "fps=";
  output += (int) frameRate;
  text(output, 10, 30);
}

void updateField()
{
  for (int i=0; i<yRes; i++)
  {
    for (int j=0; j<xRes; j++)
    {
      Node node = nodes[i*xRes+j];
      float noiseScale = 0.1;
      float a = noise(i*noiseScale, j*noiseScale, frameCount*0.003)*TWO_PI*2;
      PVector vector = new PVector(cos(a), sin(a));
      node.vector = vector;
      if (showsField) node.render();
    }
  }
}

void updateParts()
{
  noFill();
  stroke(255, 70);

  for (int i=0; i<numParts; i++)
  {
    Part part = parts[i];

    int xPos = floor(part.x/gridSize);
    int yPos = floor(part.y/gridSize);
    int currentIndex = yPos*xRes + xPos;

    part.vx += nodes[currentIndex].vector.x * 0.7;
    part.vy += nodes[currentIndex].vector.y * 0.7;

    part.vx += random(-1.0, 1.0) * 0.5;
    part.vy += random(-1.0, 1.0) * 0.5;

    part.update();
    part.render();
  }
}

void createField()
{
  xRes = ceil(width/gridSize);
  yRes = ceil(height/gridSize);
  nodes = new Node[xRes*yRes];

  for (int i=0; i<yRes; i++)
  {
    for (int j=0; j<xRes; j++)
    {
      float noiseScale = 0.1;
      float a = noise(i*noiseScale, j*noiseScale)*TWO_PI;
      PVector vector = new PVector(cos(a), sin(a));

      float cx = j*gridSize + gridSize/2;
      float cy = i*gridSize + gridSize/2;
      PVector center = new PVector(cx, cy);
      Node node = new Node(vector, center);
      nodes[i*xRes+j] = node;
    }
  }
}

void createParts()
{
  parts = new Part[numParts];
  for (int i=0; i<numParts; i++)
  {
    Part part = new Part(random(width), random(height));
    parts[i] = part;
  }
}

void keyPressed()
{
  if (key == 'f') showsFPS = !showsFPS;
  if (key == 'g') showsField = !showsField;
}

class Node
{
  PVector vector;
  PVector center;
  color randColor;

  Node(PVector v, PVector c)
  {
    vector = v;
    center = c;
    selectNewColor();
  }

  void update()
  {
  }

  void render()
  {
    noStroke();
    fill(randColor);
    rect(center.x, center.y, gridSize, gridSize);
    PVector renderVector = vector.get();
    renderVector.mult(gridSize/2);
    stroke(150);
    line(center.x, center.y, center.x+renderVector.x, center.y+renderVector.y);
  }

  void selectNewColor()
  {
    randColor = color(random(255), random(255), random(255), 40);
  }
}

class Part
{
  float x, y, vx, vy, px, py;

  Part(float _x, float _y)
  {
    x = px = _x;
    y = py = _y;
    vx = 0.0;
    vy = 0.0;
  }

  void update()
  {
    px = x;
    py = y;

    vx *= 0.95;
    vy *= 0.95;

    x += vx;
    y += vy;

    wrap();
  }

  void wrap()
  {
    if (x > width) x = px = 0;
    if (x < 0) x = px = width;

    if (y > height) y = py = 0;
    if (y < 0) y = py = height;
  }

  void render()
  {
    line(x, y, px, py);
  }
}
