
class Point extends PVector implements Comparable<Point> {

  Point() {
    super();
  }

  Point(float x, float y) {
    super(x, y);
  }

  void display() {
    ellipse(x, y, 4, 4);
  }

  int compareTo(Point other) {
    return int(this.x - other.x);
  }
}