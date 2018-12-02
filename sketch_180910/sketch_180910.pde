int speed = 3; //<>//

// Racaman's sequence

int line_num = 10000;
int start_x = 30;
int start_y = 30;
int padding = 5;
float min_len = 150;
float max_len = 1500;
ArrayList<Line>  lines = new ArrayList<Line>();
PVector START = new PVector(0, 5);

int index = 0;
int count = 1;
int[] sequence = new int[line_num];
boolean[] numbers = new boolean[line_num];
int[] directions = new int[line_num];

boolean bMaxX = false, bMinX = false, bMaxY = false, bMinY = false;
int preDirection = -1;

boolean check(PVector p)    
{
    print("check p = ");
    println(p);
    return p.x > 0 && p.y > 0;
}

void setupNum()
{
    if (count >= line_num) return;

    int next = index - count;
    if(next < 0 || numbers[next]){
        next = index + count;
    }

    numbers[next] = true;
    sequence[count] = next;

    PVector p = new PVector();
    PVector q = new PVector();
    if(lines.size() == 0) p = START;
    else p = lines.get(lines.size()-1).end;
    q = new PVector();

    int direction;
    boolean bOut = true;

    do {
        bOut = false;
        direction = int(random(0.0, 4.0));
        println(direction + " " + preDirection);
        if(direction == 0 && bMaxX) bOut = true;
        if(direction == 1 && bMaxY) bOut = true;
        if(direction == 2 && bMinX) bOut = true;
        if(direction == 3 && bMinY) bOut = true;
    } while(bOut);
    preDirection = direction;

    int length = next % 100;
    switch(direction){
        case 0:
            // q.x = p.x + next;
            q.x = p.x + length;
            q.y = p.y;
            break;
        case 1:
            q.x = p.x;
            // q.y = p.y + next;
            q.y = p.y + length;
            break;
        case 2:
            // q.x = p.x - next;
            q.x = p.x - length;
            q.y = p.y;
            break;
        case 3:
            q.x = p.x;
            // q.y = p.y - next;
            q.y = p.y - length;
            break;
    }
    
    Line line = new Line(p, q);
    println("q = " + q);
    lines.add(line);

    index = next;

    bMaxX=false; bMinX=false; bMaxY=false; bMinY=false;
    if( q.x > width ) bMaxX = true;
    else if( q.x < 0 ) bMinX = true;
    if (q.y > height ) bMaxY = true;
    else if (q.y < 0 ) bMinY = true;

    count++;
}

int bgColor = 10;
PVector direction;
float STROKE_WEIGHT = 0.5;
float scaleFactor = 1.0;

void setup()
{
    size(800, 800);
    frameRate(30);
    background(bgColor);
    strokeJoin(ROUND);

    numbers[index] = true;
    directions[index] = 0;
}

void draw()
{
    setupNum();
    translate(width/2, height/2);
    // scaleFactor = width/biggest;
    scale(scaleFactor);

    background(bgColor);
    blendMode(BLEND);

    int num = frameCount / speed;
    int percent = frameCount % speed;

    for (int i=0; i < lines.size(); i++)
    {
        strokeWeight(STROKE_WEIGHT);
        if(i < num) lines.get(i).drawAll();
        else if (i == num) 
        {
            lines.get(i).partialDraw(percent);
        }
    }

    // saveFrame("frame/lines-#####.png");
}
