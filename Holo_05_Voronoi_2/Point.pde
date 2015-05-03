
class Point extends PVector implements Comparable<Point> {

  Point() {
    super();
  }

  Point(float x, float y) {
    super(x, y);
  }

  void display() {
    stroke(255);
    strokeWeight(4);
    point(x,y);
  }

  int compareTo(Point other) {
    return int(this.x - other.x);
  }
}