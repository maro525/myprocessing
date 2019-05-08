25::ms => dur T;
100 => int N;     // 聴衆の人数
.08 => float K;  // 秩序パラメータ：相互作用の強さ
K / N => float M;
float phase[N];
float freq[N];
float v[N];
int msg[N];
"clap.wav" @=> string file;
OscSend xmit;
xmit.setHost("localhost", 1234);

SndBuf s[N];
Pan2 p[N];
Pan2 g => dac;
.5 => g.gain;

"/clap, " => string address;

for (int i; i < N; i++) {
    s[i] => p[i] => g;
    file => s[i].read;
    s[i].samples() => s[i].pos;
    0 => s[i].loop;
    Std.rand2f(.8, 1.2) => s[i].rate;
    Std.rand2f(.01, .05) => s[i].gain;
    Std.rand2f(-1, 1) => p[i].pan;
    Std.rand2f(0, 2 * pi) => phase[i];
    Std.rand2f(.4, .6) => freq[i];
    "i, " +=> address;
}

while (T => now) {
    float sum;
    for (int i; i < N; i++) {
        0 => sum;
        for (int j; j < N; j++) {
            Math.sin(phase[j] - phase[i]) +=> sum;
        }
        freq[i] + M * sum => v[i];
        0 => msg[i];
    }
    xmit.startMsg(address);
    for (int i; i < N; i++) {
        v[i] +=> phase[i];
        if (phase[i] > 2 * pi) {
            2 * pi -=> phase[i];
            0 => s[i].pos;
            1 => msg[i];
        }
        xmit.addInt(msg[i]);
    }
}
