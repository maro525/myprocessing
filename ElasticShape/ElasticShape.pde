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
int numFrames = 250;
float shutterAngle = .7;

boolean bRecord = false;

OpenSimplexNoise noise;

int n = 8;

int r = 160;

float motion_rad = 1.0;

float l = 50;

class Center {
    float cx, cy;

    float seed = random(1000);

    float ii;
    float theta;

    Center(float i) {
        theta = i*TWO_PI/n;

        ii = i;

        cx = r*cos(theta);
        cy = r*sin(theta);
    }

    float x(float q) {
        return cx+l*(float)noise.eval(seed+motion_rad*cos(TWO_PI*(t+q)), motion_rad*sin(TWO_PI*(t+q)));
    }

    float y(float q) {
        return cy+l*(float)noise.eval(2*seed+motion_rad*cos(TWO_PI*(t+q)), motion_rad*sin(TWO_PI*(t+q)));
    }

    void show() {
        fill(255);
        stroke(55);
        ellipse(x(0), y(0), 6, 6);
    }
}

Center[] array = new Center[n];

void setup() {
    size(500, 500, P3D);
    result = new int[width*height][3];
    frameRate(30);

    noise = new OpenSimplexNoise();

    for(int i=0; i<n; i++) {
        array[i] = new Center(i);
    }
}

int m = 300;

float offset_factor = 0;

void draw_(){
    background(0);
    push();
    translate(width/2, height/2);

    strokeWeight(1);
    for(int i=0; i<n; i++) {
        array[i].show();
    }

    stroke(255, 70);
    strokeWeight(2);
    for(int i=0; i<n; i++) {
        for(int j=0; j<i; j++){
            float d = 1.0;

            for(int k=0; k<=m; k++) {
                float tt = 1.0*k/m;

                float xx = lerp(array[i].x(-d*offset_factor*tt), array[j].x(-d*offset_factor*(1-tt)), tt);
                float yy = lerp(array[i].y(-d*offset_factor*tt), array[j].y(-d*offset_factor*(1-tt)), tt);

                point(xx, yy);
            }
        }
    }

    pop();
    
    offset_factor = abs(sin(TWO_PI*frameCount/500) * 0.6);
}