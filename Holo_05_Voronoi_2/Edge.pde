class Edge implements Comparable<Edge> {
  Point a;
  Point b;

  Edge(Point a_, Point b_) {
    a = a_;
    b = b_;
  }
  
  // This is just for sorting by b's y for making new triangles
  int compareTo(Edge other) {
    float diff = this.b.y - other.b.y;
    if (diff < 0) {
      return -1;
    } else if (diff > 0) {
      return 1;
    } else {
      return 0;
    }
  }

  boolean equals(Edge other) {
    return (a == other.a && b == other.b) || (a == other.b && b == other.a);
  }

  boolean alsoIn(Triangle t) {
    if (this.equals(t.ab) || this.equals(t.bc) || this.equals(t.ac)) {
      return true;
    }
    return false;
  }

  void display() {
    stroke(255, 150);
    strokeWeight(1);
    line(a.x, a.y, b.x, b.y);
  }

  String toString() {
    return a.toString() + " : " + b.toString();
  }
}