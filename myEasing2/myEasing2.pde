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
    //     if(frameCount == 500)
    //         exit();
    // }
}

////////

int samplesPerFrame = 5;
int numFrames = 140;
float shutterAngle = .7;

boolean bRecord = false;

OpenSimplexNoise noise;

class Thing {
    float size = random(1,5);
    float offset;
    float theta;
    int index;

    Thing(float theta_, int index_) {
        theta = theta_;
        index = index_;
    }

    void show() {
        stroke(255, 200);
        strokeWeight(size);
        float t2 = ease(t-floor(t), 2.0);
        float radius = 150 + 80 * sin(TWO_PI*t2 + index);
        float x = 250 + radius*cos(theta);
        float y = 250 + radius*sin(theta);
        point(x, y);
    }
}

int n = 100;
Thing[] array = new Thing[n];

void setup() {
    size(500, 500, P3D);
    result = new int[width*height][3];

    noise = new OpenSimplexNoise();

    frameRate(30);

    for(int i=0; i<n; i++) {
        float theta = TWO_PI*i/n;
        array[i] = new Thing(theta, i);
    }
}

void draw_(){
    background(0);

    for(int i=0; i<n; i++) {
        array[i].show();
    }
}
