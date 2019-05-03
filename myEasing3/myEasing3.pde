int[][] result;
float t, c;

float ease(float p) {
  return 3*p*p - 2*p*p*p;
}

float ease(float p, float g) {
  if (p < 0.5)
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}

float mn = .5*sqrt(3), ia = atan(sqrt(.5));

void draw() {

    for (int i=0; i<width*height; i++)
        for (int a=0; a<3; a++)
            result[i][a] = 0;

    c = 0;
    for (int sa=0; sa<samplesPerFrame; sa++) {
        t = map(frameCount-1 + sa*shutterAngle/samplesPerFrame, 0, numFrames, 0, 1);
        draw_();
        loadPixels();
        for (int i=0; i<pixels.length; i++) {
            result[i][0] += pixels[i] >> 16 & 0xff;
            result[i][1] += pixels[i] >> 8 & 0xff;
            result[i][2] += pixels[i] & 0xff;
         }
    }

    loadPixels();
    for (int i=0; i<pixels.length; i++)
        pixels[i] = 0xff << 24 |
            int(result[i][0]*1.0/samplesPerFrame) << 16 |
            int(result[i][1]*1.0/samplesPerFrame) << 8 |
            int(result[i][2]*1.0/samplesPerFrame);
    updatePixels();

    if(bRecord){
        saveFrame("output/fr###.png");
        println(frameCount,"/",numFrames);
        if (frameCount==numFrames)
            exit();
    }
    // else {
    //     if(frameCount == 10)
    //         exit();
    // }
}

////////

int samplesPerFrame = 5;
int numFrames = 100;
float shutterAngle = 1.0;

boolean bRecord = true;

OpenSimplexNoise noise;

float border = 75;

class Point {
    Float size;
    float px, py;
    float dx, dy;
    float x, y;
    int index;

    Point(int i_) {
        index = i_;

        float space = width / (float)(m_+1);
        dx = space + (float)(index % m_) * space;
        dy = space + (float)(index / m_) * space;

        x = dx; y = dy;
    }

    PVector getPos() {
        PVector pos = new PVector(x, y);
        return pos;
    }

    void setPos(float x_, float y_) {
        x = x_;
        y = y_;
    }

    void setPosByLerp(float ph_) {
        float ph;
        if(ph_<0.5) {
            ph = ease(ph_*2, 4.0);
            x = lerp(dx, px, ph);
            y = lerp(dy, py, ph);
        } else {
            ph = ease((ph_-0.5)*2, 4.0);
            x = lerp(px, dx, ph);
            y = lerp(py, dy, ph);
        }
    }

    void setSize(float _s) {
        size = _s;
    }

    void setDistinationFromPrevious(float px_, float py_) {
        float j1 = 50;
        float j2 = 150;
        float jump = random(j1, j2);
        int k = floor(random(0, 8));

        if(k==0) { px_ += jump; }
        if(k==1) { px_ -= jump; }
        if(k==2) { py_ += jump; }
        if(k==3) { py_ -= jump; }
        if(k==4) { px_ += jump; py_ += jump; }
        if(k==5) { px_ -= jump; py_ += jump; }
        if(k==6) { px_ += jump; py_ -= jump; }
        if(k==7) { px_ -= jump; py_ -= jump; }

        if(px_>width-border) { px_ -= 2*jump; }
        if(px_<border)       { px_ += 2*jump; }
        if(py_>height-border){ py_ -= 2*jump; }
        if(py_<border)       { py_ += 2*jump; }

        px = px_; py = py_;

        size = random(2,4);  
    }

    void setNextPos() {
        setDistinationFromPrevious(px, py);
    }

    void show() {
        stroke(255);
        fill(255);
        ellipse(x, y, 2, 2);
    }
}

class Things {
    float x0 = random(border, width-border);
    float y0 = random(border, height-border);

    ArrayList<Point> points = new ArrayList<Point>();

    Things() {

        float x = x0;
        float y = y0;

        for(int i=0; i<m; i++) {
            Point p = new Point(i);
            p.setDistinationFromPrevious(x, y);
            x = p.px; y = p.py;
            points.add(p);
        }
    }

    void updatePoints() {

        float tt = t % 1;

        for (Point p : points) {
            p.setPosByLerp(tt);

            if(tt > 0.998){
                p.setNextPos();
            }
        }
    }

    void showPoints() {
        for(Point p : points) {
            p.show();
        }
    }
}

int m_ = 9;
int m = int(sq(m_));

Things things;


void setup() {
    size(500, 500, P3D);
    result = new int[width*height][3];

    noise = new OpenSimplexNoise();

    frameRate(30);

    things = new Things();
}

void draw_(){
    background(0);

    things.updatePoints();
    things.showPoints();
}
