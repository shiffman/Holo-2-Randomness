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