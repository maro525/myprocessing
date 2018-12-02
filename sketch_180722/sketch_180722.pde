ArrayList<BSplineCurve> curves = new ArrayList<BSplineCurve>();
boolean bDrawControl = false;

int GRID_NUM = 10;
int split_num = 40;

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

void addBSpline()
{
    int _n = int(random(8,10));
    int _nn = int(random(0, 3));
    curves.add(new BSplineCurve(_n, _n+_nn));
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

  for(int n=0; n<GRID_NUM*GRID_NUM; n++) addBSpline();
}

void draw() {
    background(30);

    for(int iy = 0; iy < GRID_NUM; iy++)
    {
        for(int ix = 0; ix < GRID_NUM; ix++){
            int index = iy * GRID_NUM + ix;
            int draw_ind = int(frameCount / split_num);
            if(index < draw_ind) drawBSpline(ix, iy, 1.0);
            if(index == draw_ind ) {
                float p = (float)(frameCount % split_num) / split_num;
                drawBSpline(ix, iy, p);
            }
        }
    }
    saveFrame("frame/bspline####.png");
}