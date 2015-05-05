
class Circle {
  PVector center;
  float r;

  Circle(PVector c, float r_) {
    center = c;
    r = r_;
  }

  void display() {
    stroke(255, 175);
    fill(255, 25);
    ellipse(center.x, center.y, r*2, r*2);
    //fill(255, 0, 0, 10);
    //ellipse(center.x, center.y, r*2, r*2);
  }

  boolean contains(PVector v) {
    //println(center,v);
    float d = center.dist(v);
    if (d <= r) {// + 0.00001) {
      return true;
    } else {
      return false;
    }
  }
}