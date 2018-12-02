import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class sketch_181128 extends PApplet {

ArrayList<BSplineCurve> curves = new ArrayList<BSplineCurve>();
boolean bDrawControl = false;

int GRID_NUM = 10;
int split_num = 40;
int t = 2;

public void drawControlPoints(BSplineCurve b) {
  // control points
  fill(0, 255, 255);
  for (int k=0; k < b.n; k++)
  {
    ellipse(b.P[k].x, b.P[k].y, 5, 5);

    fill(255, 255, 255);
    text("P"+str(k), b.P[k].x+10, b.P[k].y+10);
  }
}

public void addBSpline(int t)
{
    int _n = PApplet.parseInt(random(t,t+2));
    int _nn = PApplet.parseInt(random(0, 3));
    curves.add(new BSplineCurve(_n, _n+_nn));
}

public void create_bspline(int t){
    println("Create BSpline : ", t);
    for(int n=0; n<GRID_NUM*GRID_NUM; n++) addBSpline(t);
}

public void drawBSpline(int ind_x, int ind_y, float _p)
{
    pushMatrix();

    scale(1.0f/(float)GRID_NUM);
    int tx = ind_x * width;
    int ty = ind_y * height;
    translate(tx, ty);
    
    int i = ind_y * GRID_NUM + ind_x;
    if(i < curves.size()){ // null pointer check
        BSplineCurve c = curves.get(i);
        c.draw(_p);
    }
    noFill();
    rect(0, 0, width, height);

    popMatrix();
}

/*
main function
*/

public void setup() {
  
  frameRate(30);
  

  create_bspline(t);
}

public void draw() {
    background(30);

    float p = (float)(frameCount % (split_num+1)) / split_num;

    for(int iy = 0; iy < GRID_NUM; iy++)
    {
        for(int ix = 0; ix < GRID_NUM; ix++){
            int index = iy * GRID_NUM + ix;
            drawBSpline(ix, iy, p);
        }
    }
    saveFrame("frame/bspline####.png");

    if(p == 1.0f) {
        t += 1;
        if(t == 21) exit();
        curves.clear();
        create_bspline(t);
    }
}
class BSplineCurve {
    int[] u;
    int n, k, t_max;
    int rs = 250;
    float t_step;
    float[][] N;
    PVector[] P;
    PVector[] R;
    float r = 10.0f;
    int c = color(255);
    int padding = 200;

    BSplineCurve(int _k, int _n) {
        n = _n;
        k = _k;

        R = new PVector[rs+1];
        u = new int[n+k+1];
        N = new float[n+k][n+2];
        P = new PVector[n];

        t_max = n-k+2;

        t_step = (float)t_max/rs;

        // Control Points
        for (int i=0; i < n; i++) P[i] = new PVector(random(padding, width-padding), random(padding, height-padding));

        // knot vectors
        for ( int j=0; j<=n+k; j=j+1) u[j] = knot(j, n, k);

        int tt = 0;
        for ( float t=0.0f; t<(t_max+1e-6f); t=t+t_step ) {
            int ii, kk;

            // k = 1{
            for ( ii=0; ii<n+2; ii+=1 ) {
                if (u[ii] <= t && t <= u[ii+1]) N[ii][1] = 1;
                else N[ii][1] = 0;
            }
            // k > 1
            float d=0, e=0;
            for ( kk=2; kk<=k; kk=kk+1 ) {
                for ( ii=0; ii<=(n+k)-kk; ii=ii+1 ) {
                    d= (u[ii+kk-1]-u[ii] != 0)
                        ? (t-u[ii]) * N[ii][kk-1]/(u[ii+kk-1]-u[ii])
                        : 0;
                    e= (u[ii+kk]-u[ii+1] != 0)
                        ? (u[ii+kk]-t) * N[ii+1][kk-1] / (u[ii+kk] - u[ii+1])
                        : 0;
                    N[ii][kk] = d + e;
                }
            }

            // R(t)
            R[tt] = new PVector();
            R[tt].x = 0; 
            R[tt].y = 0;
            for (int j=0; j<n; j++)
            {
                R[tt].x += N[j][k]*P[j].x;
                R[tt].y += N[j][k]*P[j].y;
            }
            
            tt += 1;
        }
    }

    public int knot(int j, int n, int k) {
        int uj=0;
        if ( j<k ) uj = 0;
        else if ( k <= j && j <= n ) uj = j-k+1;
        else if ( j > n ) uj = n-k+1;
        return uj;
    }

    public void draw(float _p) {
        stroke(c);
        fill(255);

        float portion = _p;
        if(portion > 0.95f) portion = 1.0f;
        else if(portion < 0.0f) portion = 0.0f;

        for (int _i = 0; _i < R.length; _i++) {
            float cp = (float)_i / (float)(rs+1); // current portion
            if(cp > portion) break;
        
            if(R[_i] == null) continue; // null check
            if(R[_i].x == 0 && R[_i].y == 0) continue;

            ellipse(R[_i].x, R[_i].y, r, r);
        }
    }
}
  public void settings() {  size(800, 800);  pixelDensity(displayDensity()); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_181128" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
