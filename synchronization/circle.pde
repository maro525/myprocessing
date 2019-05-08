class Circle {
    float size;
    boolean flag;
    float px, py;
    
    Circle(float x_, float y_, float size_) {
        size = size_;
        px = x_;
        py = y_;
    }

    void setStatus(int flagint_) {
        if(flagint_ == 1)
            flag = true;
        else
            flag = false;
    }

    void setStatus(boolean flag_) {
        flag = flag_;
    }

    void draw() {
        fill(0, 255, 0);
        if(flag) {
            ellipse(px, py, size, size);
        }
    }
}