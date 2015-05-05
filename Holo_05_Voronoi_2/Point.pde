
class Point extends PVector implements Comparable<Point> {

  Point() {
    super();
  }

  Point(float x, float y) {
    super(x, y);
  }
  
  void display(int wght) {
    stroke(255,200);
    strokeWeight(wght);
    point(x,y);
    
  }

  void display() {
    stroke(255,200);
    strokeWeight(4);
    point(x,y);
  }

  int compareTo(Point other) {
    float diff = this.x - other.x;
    if (diff < 0) {
      return -1;
    } else if (diff > 0) {
      return 1;
    } else {
      return 0;
    }
  }
}