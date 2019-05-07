class Thing{

    int size;
    float natural_frequency;
    float circular_frequency;
    float phase;
    float affect;
    float m;
    boolean bPlay = false;
    
    Thing(float m_) {
        size = 10;

        natural_frequency = 2 * TWO_PI * random(1.0);

        circular_frequency = 0.0;
        phase = random(0, TWO_PI);
        affect = 0.0;
        m = m_;

    }

    void setBClap(boolean _b){
        bPlay = _b;
    }

    void addAffect(float theta) {
        float diff_angle = theta - phase;
        float affect_value = sin(diff_angle%TWO_PI);
        affect += affect_value;
    }

    void update() {
        float ss = m * affect;
        circular_frequency = natural_frequency + ss;
        affect = 0;

        phase += circular_frequency;
        phase = phase % TWO_PI;

        if(phase > PI && bPlay) {
            bPlay = false;
        }
    }

    void draw() {
        float dr = 200.0;
        float px = width/2 + dr * cos(phase);
        float py = height/2 + dr * sin(phase);
        float r = 10.0;
        fill(255);
        ellipse(px, py, r, r);
    }

    void drawAt(float x, float y) {
        float r = 3 + size * abs(phase-PI);
        fill(255);
        ellipse(x, y, r, r);
    }
}
