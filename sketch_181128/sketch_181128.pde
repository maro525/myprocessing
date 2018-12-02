ArrayList<BSplineCurve> curves = new ArrayList<BSplineCurve>();
boolean bDrawControl = false;

int GRID_NUM = 10;
int split_num = 40;
int t = 2;

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

void addBSpline(int t)
{
    int _n = int(random(t,t+2));
    int _nn = int(random(0, 3));
    curves.add(new BSplineCurve(_n, _n+_nn));
}

void create_bspline(int t){
    println("Create BSpline : ", t);
    for(int n=0; n<GRID_NUM*GRID_NUM; n++) addBSpline(t);
}

void drawBSpline(int ind_x, int ind_y, float _p)
{
    pushMatrix();

    scale(1.0/(float)GRID_NUM);
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

void setup() {
  size(800, 800);
  frameRate(30);
  pixelDensity(displayDensity());

  create_bspline(t);
}

void draw() {
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

    if(p == 1.0) {
        t += 1;
        if(t == 21) exit();
        curves.clear();
        create_bspline(t);
    }
}