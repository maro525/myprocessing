Shape[] s;
int sn = 5;

void setup()
{
    size(800, 800);
    background(50);    

    s = new Shape[sn];
    for(int si=0; si<sn; si++)
        s[si] = new Shape(random(width), random(height));
}

void draw()
{
    for(int si=0; si<sn; si++)
        s[si].draw();
}

class Shape
{
    int vn = 4;
    int thresh = 100;

    PVector[] vertex;
    color c;

    Shape(float px_, float py_)
    {
        vertex = new PVector[vn];
        for(int i=0; i<vn; i++){
             vertex[i] = new PVector(px_ + random(-thresh, thresh), py_+random(-thresh, thresh));
        }
        c = color(random(255), random(255), random(255));
    }

    void draw()
    {
        noStroke();
        fill(c);
        beginShape();
        for(int j=0; j<vn; j++){
            vertex(vertex[j].x, vertex[j].y);
        }
        endShape(CLOSE);
    }
}