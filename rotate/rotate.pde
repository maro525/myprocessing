int px, py;

float sw = 3.0;

void setup()
{
    frameRate(30);
    size(640, 640);

    px = width/2;
    py = height/2;

    strokeWeight(2.0);
}

float b = 0.0;

void draw()
{
    if(frameCount % 30 == 0) px += random(-50, 50); py += random(-50, 50);
    
    background(255);
    translate(width/2, height/2);
    float a = atan2(px-width/2, py-height/2);
    ellipse(px-width/2, py-width/2, 15, 15);
    rotate(a);
    rect(-30, -5, 60, 10);
    rotate(-a);
    rotate(HALF_PI);
    line(-100, 0, 100, 0);
    b += 0.001;
    
    saveFrame("frame/rotate###.png");
}
