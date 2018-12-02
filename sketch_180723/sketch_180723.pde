class BSplineCurve {

  int[] u;
  int n;
  int k;
  int t_max;
  int rs;
  float t_step;
  float[][] N;
  PVector[] P;
  PVector[] R;
  // noise
  float tx, ty = 0.0;
  int noiseScale = 100;

  BSplineCurve(int _k, int _n) {
    n = _n; //
    k = _k; //

    rs = 200;
    R = new PVector[rs+1];
    u = new int[n+k+1];
    N = new float[n+k][n+2];
    P = new PVector[n];

    t_max = n-k+1;

    t_step = (float)t_max/rs;

    // Control Points
    for (int i=0; i < n; i++)
      P[i] = new PVector(random(width), random(height));
  }

  int knot(int j, int n, int k) {
    int uj=0;
    if ( j<k ) uj = 0;
    else if ( k <= j && j <= n ) uj = j-k+1;
    else if ( j > n ) uj = n-k+1;
    return uj;
  }

  void update() {
      for(int c=0; c < n; c++)
      {
          P[c].x = noise(1, tx, ty) * width;
          P[c].y = noise(2, tx, ty) * height;

          tx += 0.005; ty += 0.005;
      }
  }

  void draw(color c) {
    noFill();
    stroke(c);

    // knot vectors
    for ( int j=0; j<=n+k; j=j+1) u[j] = knot(j, n, k);

    // 0<t<t_max
    int tt = 0;
    for ( float t=0.0; t<(t_max+1e-6); t=t+t_step ) {
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
      if(tt>rs) break;
      R[tt] = new PVector();
      R[tt].x = 0;
      R[tt].y = 0;
      for (int j=0; j<n; j++)
      {
        R[tt].x += N[j][k]*P[j].x;
        R[tt].y += N[j][k]*P[j].y;
      }

      // line
      if (tt!=0 && tt<rs) line(R[tt-1].x, R[tt-1].y, R[tt].x, R[tt].y);

      tt = tt + 1;
    }
  }
}

void drawControlPoints(BSplineCurve b) {
  // control points
  fill(0, 255, 255);
  for (int k=0; k < b.n; k++)
  {
    ellipse(b.P[k].x, b.P[k].y, 5, 5);

    fill(255, 255, 255);
    text("P"+str(k), b.P[k].x+10, b.P[k].y+10);
  }
}

void drawLabel() {
  fill(255, 255, 255);
  text("BSplineCurves", 10, 20);
}

BSplineCurve b0, b1, b2;
boolean bDrawControl = false;

void setup() {
  size(400, 400);
  frameRate(30);

  b0 = new BSplineCurve(3, 4);
  b1 = new BSplineCurve(4, 5);
  b2 = new BSplineCurve(5, 6);
}

void draw() {
  background(100, 255);

  b0.update();
  b1.update();
  b2.update();

  //drawLabel();
  if (bDrawControl)
  {
    drawControlPoints(b0);
    drawControlPoints(b1);
    drawControlPoints(b2);
  }

  b0.draw(color(255, 0, 100));
  b1.draw(color(125, 0, 255));
  b2.draw(color(125, 255, 0));
}

void initBSpline()
{
  int temp_n = int(random(3, 6));
  b0 = new BSplineCurve(temp_n, temp_n+int(random(0, 3)));
  temp_n = int(random(4, 8));
  b1 = new BSplineCurve(temp_n, temp_n+int(random(0, 4)));
  temp_n = int(random(7,10));
  b2 = new BSplineCurve(temp_n, temp_n+int(random(0, 6)));
}


void mousePressed()
{
  initBSpline();
}

void keyPressed()
{
  if (key == 'c') bDrawControl = !bDrawControl;
  if (key == 'n') initBSpline();
}
