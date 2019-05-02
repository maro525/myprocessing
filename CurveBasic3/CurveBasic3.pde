// https://necessarydisorder.wordpress.com/2018/03/31/a-trick-to-get-looping-curves-with-lerp-and-delay/

int numFrames = 120;
int m = 3000;
boolean bRecord = true;

float delay_factor = 1.0;

OpenSimplexNoise noise;

void setup() {
    size(500, 500, P3D);

    stroke(255);
    fill(255);

    frameRate(30);

    noise = new OpenSimplexNoise();
}

float motion_radius = 1.5;
float x1(float t) {
    float seed = 1337;
    return 0.5*width + 300*(float)noise.eval(seed+motion_radius*cos(TWO_PI*t), motion_radius*sin(TWO_PI*t));
}

float y1(float t) {
    float seed = 1515;
    return 0.5*height + 180*(float)noise.eval(seed+motion_radius*cos(TWO_PI*t), motion_radius*sin(TWO_PI*t));
}

float x2(float t) {
    // return 0.75*width + 50*cos(2*TWO_PI*t);
    return 0.5*width;
}

float y2(float t) {
    // return 0.5*height + 50*sin(2*TWO_PI*t);
    return 0.5*height;
}

void draw() {
    float t = 1.0*(frameCount - 1) / numFrames;
    render(t);

    if(bRecord) {
        saveFrame("output/gif-" + nf(frameCount, 3) + ".png");
    
        if(frameCount == numFrames)
            exit();
    }
}

void render(float t) {

    background(0);

    ellipse(x1(t), y1(t), 6, 6);
    ellipse(x2(t), y2(t), 6, 6);

    push();
    strokeWeight(2);
    stroke(255, 35);
    for(int i=0; i<=m; i++) {
        float tt = 1.0*i/m;

        float x = lerp(x1(t - delay_factor*tt), x2(t-delay_factor*tt), tt);
        float y = lerp(y1(t-delay_factor*tt), y2(t-delay_factor*tt), tt);

        point(x, y);
    }
    pop();
}