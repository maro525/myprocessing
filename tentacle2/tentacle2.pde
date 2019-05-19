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
int numFrames = 150;
float shutterAngle = 1.0;

boolean bRecord = true;

OpenSimplexNoise noise;

class Point {
    Float size;
    // float sx, sy;
    float sx;
    // float gx, gy;
    float gx;
    float x, y;
    int index;

    Point(int i_, float sx_, float gx_) {
        index = i_;
        sx = sx_; gx = gx_;
        setPos(sx);
        println(sx, gx);
    }

    // Point(int i_, float sx_, float sy_, float gx_, float gy_) {
    //     index = i_;
    //     sx = sx_; sy = sy_;
    //     gx = gx_; gy = gy_;
    //     setPos(sx, sy);
    // }

    PVector getPos() {
        PVector pos = new PVector(x, y);
        return pos;
    }

    float getY(float x_) {
        // return (float)index / x_;
        float sy = 80000 / (x_ + index);
        println("sy", sy);
        return height - sy;
    }

    void setPos(float x_) {
        x = x_;
        y = getY(x);
    }

    // void setPos(float x_, float y_) {
    //     x = x_;
    //     y = y_;
    // }

    void setPosByLerp(float ph_) {
        float ph = easeOutCubic(ph_, 0.9*(index+1)/resolution);
        x = lerp(sx, gx, ph);
        setPos(x);

        println(index, x, y);
    }

    void show() {
        stroke(#444342);
        // fill(10, 100);
        point(x, y);
        // ellipse(x, y, 5, 5);
    }
}

float resolution = 400;

class Things {
    ArrayList<Point> points = new ArrayList<Point>();
    float border = 30.0;
    float bordery = 100.0;

    Things() {

        for(int i=0; i<resolution; i++) {
            float space = width / 3 / (float)(resolution+1);
            float x = border + space + i * space;
            // float y = bordery;
            float gx = width - border;
            // float l = random(50.0, 300.0);
            // Point p = new Point(i, x, y, x, y+l);
            Point p = new Point(i, x, gx);
            points.add(p);
        }
    }

    void updatePoints() {

        if(t>1)
            return;
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

// void drawEarth() {
//     float id = 100;
//     float ty = 10;
//     int I = width*2;
//     push();
//     stroke(#444342);
//     strokeWeight(1);

//     for(int i=0; i<I; i++) {
//         float cy = 30 + ty*(float)noise.eval(id+i, 100);
//         float cx = width * i / I;
//         line(cx, height-cy, cx, height);
//     }
//     pop();
// }

Things things;


void setup() {
    size(500, 500, P3D);
    result = new int[width*height][3];

    noise = new OpenSimplexNoise();

    frameRate(30);

    things = new Things();

    background(#f7f0e8);
}

void draw_(){
    // background(0);

    things.updatePoints();
    things.showPoints();

    // drawEarth();
}
