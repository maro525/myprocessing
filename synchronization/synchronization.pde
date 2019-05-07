import processing.sound.*;

ArrayList<Thing> things = new ArrayList<Thing>();
int N = 1;
float K = 0.005;
float M = K / (float)N;
int radius = 200;
SoundFile clap;


void setup() {
    size(600, 600);

    for(int i=0; i < N; i++) {
        things.add(new Thing(M));
    }

    background(0);

    frameRate(30);

    clap = new SoundFile(this, "clap1.mp3");
}

void draw() {
    updatethings();

    background(10);
    drawthings();
}

void updatethings() {
    int clap_n = 0;
    for(int i=0; i<things.size(); i++) {
        for(int j=0; j<things.size(); j++) {
            things.get(i).addAffect(things.get(j).phase);
        }
        things.get(i).update();
        if(things.get(i).phase < 0.8 && !things.get(i).bPlay){
            clap_n += 1;
            things.get(i).bPlay = true;
        }
    }
    if(clap_n != 0){
        float amp_f = 10.0*(float)clap_n / (float)N;
        int amp_i = ceil(amp_f);
        float amp = (float)amp_i / 10.0;
        clap.amp(amp);
        clap.play();
    }
}

void drawthings() {
    int br = 200;
    for(int i=0; i<things.size(); i++) {
        float x = width/2 + br*cos(TWO_PI*i/N);
        float y = height/2 + br*sin(PI/2 + TWO_PI*i/N);
        things.get(i).draw();
    }
}