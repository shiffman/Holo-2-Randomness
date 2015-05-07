
// This is a mess, why am I doing this?
// Better references of 
Edge findEdge(Triangle t1, Triangle t2, Point a, Point b) {
  Edge e = t1.ab;
  if (e.a == a && e.b == b || e.a == b && e.b == a) {
    return e;
  }
  e = t1.bc;
  if (e.a == a && e.b == b || e.a == b && e.b == a) {
    return e;
  }  
  e = t1.ac;
  if (e.a == a && e.b == b || e.a == b && e.b == a) {
    return e;
  }  
  e = t2.ab;
  if (e.a == a && e.b == b || e.a == b && e.b == a) {
    return e;
  }
  e = t2.bc;
  if (e.a == a && e.b == b || e.a == b && e.b == a) {
    return e;
  }  
  e = t2.ac;
  if (e.a == a && e.b == b || e.a == b && e.b == a) {
    return e;
  }
  println("No edge found");
  return null;
}

// Processing triangulation
// Reference: https://www.youtube.com/watch?v=7VcuKj1_nHA
// http://geomalgorithms.com/a15-_tangents.html
// http://www.personal.kent.edu/~rmuhamma/Compgeometry/MyCG/ConvexHull/incrementCH.htm
// Daniel Shiffman
// May 2015
// https://github.com/shiffman/Holo-2-Randomness

// A triangle

class Triangle {
  // It has three points
  Point a;
  Point b;
  Point c;

  // And three edges
  Edge ab;
  Edge bc;
  Edge ac;

  // Delete this triangle?
  boolean toRemove = false;

  // Circumcircle
  Circle circum;

  // Make a triangle from 3 edges
  Triangle(Edge ab, Edge bc, Edge ac) {
    // Need the three unique points
    this.a = ab.a;
    this.b = ab.b;
    this.c = ac.b;

    this.ab = ab;
    this.bc = bc;
    this.ac = ac;

    circum = circumCenter();
  }

  // Make a triangle from three points
  Triangle(Point a, Point b, Point c) {
    this.a = a;
    this.b = b;
    this.c = c;
    circum = circumCenter();

    // Make edges here?
    // This constructor is just for the test during the convex hull stage
    // ab = new Edge(this.a, this.b);
    // bc = new Edge(this.b, this.c);
    // ac = new Edge(this.a, this.c);
  }

  void markForRemoval() {
    toRemove = true;
  }

  // The triangle should track its own neighbors
  // This is crazy that I'm searching the entire edge list?
  boolean isNeighbor(Triangle t) {
    boolean neighbor = false;
    for (Edge e1 : edges) {
      if (e1.alsoIn(t)) {
        neighbor = true;
        break;
      }
    }
    return neighbor;
  }

  // Update the circumcircle
  void update() {
    circum = circumCenter();
  }

  // Is a point inside the circumcircle
  boolean circleContains(PVector v) {
    return circum.contains(v);
  }


  void display() {
    display(1, 0, 0, 0, false);
  }
  void display(float r, float g, float b) {
    display(1, r, g, b, true);
  }
  void display(int wght, float r, float g, float b) {
    display(wght, r, g, b, true);
  }

  // Draw
  void display(int wght, float rr, float gg, float bb, boolean fillIt) {
    strokeWeight(wght);
    stroke(255);
    if (fillIt) {
      fill(rr, gg, bb, 200);
    } else {
      noFill();
    }
    strokeWeight(1);
    beginShape();
    vertex(a.x, a.y);
    vertex(b.x, b.y);
    vertex(c.x, c.y);
    endShape(CLOSE);
  }

  // Show circle
  void showCircle(float wght, float rr, float gg, float bb) {
    circum.display(wght, rr, gg, bb);
  }

  void showCircle() {
    circum.display();
  }

  // From: http://www.ics.uci.edu/~eppstein/junkyard/circumcenter.html
  Circle circumCenter() {
    Point center = new Point(); 

    // D = 2( a_1 c_0 + b_1 a_0 - b_1 c_0 -a_1 b_0 -c_1 a_0 + c_1 b_0 ).
    float commonD = 2 * (a.y*c.x + b.y*a.x - b.y*c.x - a.y*b.x - c.y*a.x + c.y*b.x);

    center.x = b.y * a.x * a.x
      - c.y * a.x * a.x 
      - b.y * b.y * a.y
      + c.y * c.y * a.y
      + b.x * b.x * c.y
      + a.y * a.y * b.y
      + c.x * c.x * a.y
      - c.y * c.y * b.y
      - c.x * c.x * b.y
      - b.x * b.x * a.y
      + b.y * b.y * c.y
      - a.y * a.y * c.y;

    center.y = a.x * a.x * c.x
      + a.y * a.y * c.x 
      + b.x * b.x * a.x
      - b.x * b.x * c.x
      + b.y * b.y * a.x
      - b.y * b.y * c.x
      - a.x * a.x * b.x
      - a.y * a.y * b.x
      - c.x * c.x * a.x
      + c.x * c.x * b.x
      - c.y * c.y * a.x
      + c.y * c.y * b.x;

    center.div(commonD);
    float r = PVector.dist(center, a);

    return new Circle(center, r);
  }

  // From: http://stackoverflow.com/questions/2049582/how-to-determine-a-point-in-a-triangle
  boolean contains(Point p) {
    Point p0 = a;
    Point p1 = b;
    Point p2 = c;
    float A = 0.5 * (-p1.y * p2.x + p0.y * (-p1.x + p2.x) + p0.x * (p1.y - p2.y) + p1.x * p2.y);
    float sign = A < 0 ? -1 : 1;
    float s = (p0.y * p2.x - p0.x * p2.y + (p2.y - p0.y) * p.x + (p0.x - p2.x) * p.y) * sign;
    float t = (p0.x * p1.y - p0.y * p1.x + (p0.y - p1.y) * p.x + (p1.x - p0.x) * p.y) * sign;
    return s > 0 && t > 0 && (s + t) < 2 * A * sign;
  }

  String toString() {
    return a + " " + b + " " + c;
  }
}

// Processing triangulation
// Reference: https://www.youtube.com/watch?v=7VcuKj1_nHA
// http://geomalgorithms.com/a15-_tangents.html
// http://www.personal.kent.edu/~rmuhamma/Compgeometry/MyCG/ConvexHull/incrementCH.htm
// Daniel Shiffman
// May 2015
// https://github.com/shiffman/Holo-2-Randomness

// Class for a circle
class Circle {

  // Center
  Point center;
  // Radius
  float r;

  Circle(Point c, float r_) {
    center = c;
    r = r_;
  }

  // Draw circle
  void display() {
    display(1, 255, 255, 255);
  }

  void display(float wght, float rr, float gg, float bb) {
    strokeWeight(wght);
    stroke(rr, gg, bb, 175);
    fill(rr, gg, bb, 25);
    ellipse(center.x, center.y, r*2, r*2);
  }

  // Is a point inside?
  boolean contains(PVector v) {
    float d = center.dist(v);
    // Bad floating point math is causing problems?
    // Making sure it's not a point just sitting on the edge, we can get stuck flipping
    // forever, but this is quite bad to take off 0.1 here
    if (d < r) {
      return true;
    } else {
      return false;
    }
  }

  String toString() {
    return center.toString() + " " + r;
  }
}

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