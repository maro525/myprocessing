class BSplineCurve {
    int[] u;
    int n, k, t_max;
    int rs = 250;
    float t_step;
    float[][] N;
    PVector[] P;
    PVector[] R;
    float r = 20.0;
    color c = color(255);
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

    int knot(int j, int n, int k) {
        int uj=0;
        if ( j<k ) uj = 0;
        else if ( k <= j && j <= n ) uj = j-k+1;
        else if ( j > n ) uj = n-k+1;
        return uj;
    }

    void draw(float _p) {
        stroke(c);
        fill(255);

        float portion = _p;
        if(portion > 0.95) portion = 1.0;
        else if(portion < 0.0) portion = 0.0;

        for (int _i = 0; _i < R.length; _i++) {
            float cp = (float)_i / (float)(rs+1); // current portion
            if(cp > portion) break;
        
            if(R[_i] == null) continue; // null check
            if(R[_i].x == 0 && R[_i].y == 0) continue;

            ellipse(R[_i].x, R[_i].y, r, r);
        }
    }
}