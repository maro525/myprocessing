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

float easeOutCubic(float p, float g) {
    return (-p)*pow(p, g-1)+1;
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

class Point {
    Float size;
    float sx, sy;
    float gx, gy;
    float x, y;
    int index;

    Point(int i_, float sx_, float sy_, float gx_, float gy_) {
        index = i_;
        sx = sx_; sy = sy_;
        gx = gx_; gy = gy_;
        size = random(1.0, 4.0);
        setPos(sx, sy);
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
            ph = easeOutCubic(ph_*2, 3.0*(index+1)/m);
            x = lerp(sx, gx, ph);
            y = lerp(sy, gy, ph);
        } else {
            ph = easeOutCubic((ph_-0.5)*2, 3.0*(index+1)/m);
            x = lerp(gx, sx, ph);
            y = lerp(gy, sy, ph);
        }
    }

    void setShpe(float _s) {
        size = _s;
    }

    void show() {
        stroke(255);
        fill(255);
        ellipse(x, y, size, size);
    }
}

float border = 100.0;

class Things {
    ArrayList<Point> points = new ArrayList<Point>();
    float x,y;
    float jj1 = 350, jj2= 300;

    Things() {

        for(int i=0; i<m; i++) {
            float space = width / (float)(m+1);
            x = random(border, width-border);
            y = random(border, height-border);
            PVector gp = initPoint();
            int direction = floor(random(0, 2));
            float jump = direction == 0 ? random(-jj1, -jj2) : random(jj2, jj1);
            PVector sp = new PVector(gp.x+jump, gp.y+jump);
            Point p = new Point(i, sp.x, sp.y, gp.x, gp.y);
            
            points.add(p);
        }
    }

    PVector initPoint() {
        float j1 = 50; float j2 = 150;
        float jump = random(j1, j2);
        int k = floor(random(0, 8));

        if(k==0) { x += jump; }
        if(k==1) { x -= jump; }
        if(k==2) { y += jump; }
        if(k==3) { y -= jump; }
        if(k==4) { x += jump; y += jump; }
        if(k==5) { x -= jump; y += jump; }
        if(k==6) { x += jump; y -= jump; }
        if(k==7) { x -= jump; y -= jump; }

        if(x>width-border) { x -= 2*jump; }
        if(x<border)       { x += 2*jump; }
        if(y>height-border){ y -= 2*jump; }
        if(y<border)       { y += 2*jump; }

        float ix = x; float iy = y;
        PVector p = new PVector(ix, iy);
        return p;
    }

    void updatePoints() {

        float tt = t % 1;

        for (Point p : points) {
            p.setPosByLerp(tt);
        }
    }

    void showPoints() {
        for(Point p : points) {
            p.show();
        }
    }
}

int m = 80;

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
