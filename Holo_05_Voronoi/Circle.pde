
class Circle {
  PVector center;
  float r;

  Circle(PVector c, float r_) {
    center = c;
    r = r_;
  }

  void display() {
    fill(255, 0, 0);
    ellipse(center.x, center.y, 4, 4);
    fill(255, 10);
    ellipse(center.x, center.y, r*2, r*2);
  }

  boolean contains(PVector v) {
    float d = center.dist(v);
    if (d <= r*2 + 0.00001) {
      return true;
    } else {
      return false;
    }
  }
}