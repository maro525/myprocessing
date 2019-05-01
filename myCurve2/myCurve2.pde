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
    else {
        if(frameCount == 500)
            exit();
    }
}

////////

int samplesPerFrame = 5;
int numFrames = 300;
float shutterAngle = .7;

boolean bRecord = true;

OpenSimplexNoise noise;

int n = 4;

int m = 500;

class Thing{
    float ax, ay, bx, by, cx, cy;

    float id = random(100);

    float mov = 25;
    float rad = 1.2;

    float offset_factor = 0.4;

    Thing(float _sx, float _sy) {
        float thresh = 20.0;
        cx = random(_sx-thresh, _sx+thresh);
        cy = random(_sy-thresh, _sy+thresh);
    }

    void setPoint(float _ax, float _ay, float _bx, float _by){
        ax = _ax;
        ay = _ay;
        bx = _bx;
        by = _by;
    }

    float x(float ph) {
        return cx + mov*(float)noise.eval(id+rad*cos(TWO_PI*(t+ph)), rad*sin(TWO_PI*(t+ph)));
    }

    float y(float ph) {
        return cy + mov*(float)noise.eval(100+id+rad*cos(TWO_PI*(t+ph)), rad*sin(TWO_PI*(t+ph)));
    }

    void show() {
        float x = x(0);
        float y = y(0);
        
        stroke(255);
        strokeWeight(1);
        fill(255);
        // ellipse(x,y,6,6);

        stroke(255, 100);
        for(int i=0; i<=m; i++) {
            float tt = 1.0*i/m;

            float xx = lerp(x(-offset_factor*tt), ax, tt);
            float yy = lerp(y(-offset_factor*tt), ay, tt);

            point(xx, yy);
        }
        for(int k=0; k<=m; k++) {
            float tt = 1.0*k/m;

            float xx = lerp(x(-offset_factor*tt), bx, tt);
            float yy = lerp(y(-offset_factor*tt), by, tt);

            point(xx, yy);
        }
    }
}


Thing[] array = new Thing[n];

void setup() {
    size(500, 500, P3D);
    result = new int[width*height][3];

    frameRate(30);

    noise = new OpenSimplexNoise();

    float sx = width/2;
    float sy = height/4;
    array[0] = new Thing(sx, sy);
    array[0].setPoint(width*3/4, sy, width/4, sy);
    sx = width/4;
    sy = height/2;
    array[1] = new Thing(sx, sy);
    array[1].setPoint(sx, height/4, sx, height*3/4);
    sx = width/2;
    sy = height*3/4;
    array[2] = new Thing(sx, sy);
    array[2].setPoint(width/4, sy, width*3/4, sy);
    sx = width*3/4;
    sy = height/2;
    array[3] = new Thing(sx, sy);
    array[3].setPoint(sx, height*3/4, sx, height/4);
}

void draw_(){
    background(0);

    float sx = 250;
    float sy = 250;
    for(int i=0; i<n; i++) {
        array[i].show();
    }
}