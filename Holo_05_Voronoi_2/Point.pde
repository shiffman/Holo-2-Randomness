// Processing triangulation
// Reference: https://www.youtube.com/watch?v=7VcuKj1_nHA
// http://geomalgorithms.com/a15-_tangents.html
// http://www.personal.kent.edu/~rmuhamma/Compgeometry/MyCG/ConvexHull/incrementCH.htm
// Daniel Shiffman
// May 2015
// https://github.com/shiffman/Holo-2-Randomness

// A PVector with some added functionality

class Point extends PVector implements Comparable<Point> {

  Point() {
    super();
  }

  Point(float x, float y) {
    super(x, y);
  }

  void display(int wght, float r, float g, float b) {
    stroke(r, g, b, 200);
    strokeWeight(wght);
    point(x, y);
  }

  void display(int wght) {
    display(wght, 255, 255, 255);
  }

  void display() {
    display(1, 255, 255, 255);
  }

  // Sort from left to right
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