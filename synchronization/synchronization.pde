// import processing.sound.*;
import oscP5.*;
import netP5.*;
import controlP5.*;

// ArrayList<Thing> things = new ArrayList<Thing>();
ArrayList<Circle> things = new ArrayList<Circle>();
int N_ = 10;
int N = (int)sq(N_);
// float K = 0.005;
// float M = K / (float)N;
// int radius = 200;
// SoundFile clap;
float size = 15.0;

OscP5 oscP5;
NetAddress remote;
String address = "/clap";

int receivePort = 1234;
String sendIP = "127.0.0.1";
int sendPort = 1234;
String sendAddress = "/kvalue";

ControlP5 cp5;
Slider abc;
float kvalue = 0.1;

void setup() {
    size(1200, 600);
    background(0);

    float space = (width/2) / (float)(N_+1);

    for(int i=0; i < N; i++) {
        float px = space + space * (i % N_);
        float py = space + space * (i / N_);
        things.add(new Circle(px, py, size));
    }


    frameRate(30);

    oscP5 = new OscP5(this, receivePort);
    remote = new NetAddress(sendIP, sendPort);

    // clap = new SoundFile(this, "clap1.mp3");

    cp5 = new ControlP5(this);
    cp5.addSlider("kvalue")
        .setPosition(700, 100)
        .setSize(400, 20)
        .setRange(0.001, 5.0)
        .setNumberOfTickMarks(100);

    cp5.getController("kvalue")
        .getValueLabel()
        .align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE)//位置、外側の右寄せ
        .setPaddingX(-20);
}

void draw() {
    sendmsg();
    background(10);
    fill(100);
    rect(600, 0, 600, 600);
    drawthings();
}

// void updatethings() {
//     int clap_n = 0;
//     for(int i=0; i<things.size(); i++) {
//         for(int j=0; j<things.size(); j++) {
//             things.get(i).addAffect(things.get(j).phase);
//         }
//         things.get(i).update();
//         if(things.get(i).phase < 0.8 && !things.get(i).bPlay){
//             clap_n += 1;
//             things.get(i).bPlay = true;
//         }
//     }
//     if(clap_n != 0){
//         float amp_f = 10.0*(float)clap_n / (float)N;
//         int amp_i = ceil(amp_f);
//         float amp = (float)amp_i / 10.0;
//         clap.amp(amp);
//         clap.play();
//     }
// }

void drawthings() {
    for(int i=0; i<things.size(); i++) {
        things.get(i).draw();
    }
}

void oscEvent(OscMessage message) {
    if(message.checkAddrPattern(address)) {
        for(int i=0; i<N; i++) {
            int m = message.get(i).intValue();
            things.get(i).setStatus(m);
        }
    }
}

// void controlEvent(ControlEvent theEvent) {
//     if (theEvent.getController().getName() == "kvalue") {
//         OscMessage myMessage = new OscMessage(sendAddress);
//         myMessage.add(kvalue);
//         oscP5.send(myMessage, remote);
//     }
// }

void sendmsg() {
    OscMessage myMessage = new OscMessage(sendAddress);
    myMessage.add(kvalue);
    oscP5.send(myMessage, remote);
}