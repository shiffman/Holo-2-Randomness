// Processing triangulation
// Reference: https://www.youtube.com/watch?v=7VcuKj1_nHA
// http://geomalgorithms.com/a15-_tangents.html
// http://www.personal.kent.edu/~rmuhamma/Compgeometry/MyCG/ConvexHull/incrementCH.htm
// Daniel Shiffman
// May 2015
// https://github.com/shiffman/Holo-2-Randomness

// An edge object

class Edge implements Comparable<Edge> {
  // An edge is two points
  Point a;
  Point b;

  // Neighboring triangles
  // Should probably say right / left?
  Triangle t1;
  Triangle t2;

  // A color if I want to highlight edges
  color col = color(255);

  boolean legal = true;

  boolean prevState = legal;

  // Is it slated for deletion?
  boolean toRemove = false;

  Edge(Point a_, Point b_) {
    a = a_;
    b = b_;
  }

  // Which point from a triangle is not part of this edge
  // There's got to be a better way to do this?
  Point notIncluded(Triangle t) {
    if (t.a != a && t.a != b) {
      return t.a;
    } else if (t.b != a && t.b != b) {
      return t.b;
    } else if (t.c != a && t.c != b) {
      return t.c;
    }
    return null;
  }


  void displayState(int illegalState) {

    float rr = 255;
    float gg = 255;
    float bb = 255;
    if (!legal) {
      rr = 255;
      gg = 0;
      bb = 0;
      // Using a global variable here
      // Bad idea
    } else if (illegalState == 2) {
      rr = 0;
      gg = 255;
      bb = 0;
    }
    t1.showCircle(4, rr, gg, bb);
    t1.display(4, rr, gg, bb);
    if (outsideT1 != null) {
      outsideT1.display(16, rr, gg, bb);
      t2.display(4, rr, gg, bb);
    }
    prevState = legal;

    stroke(rr, gg, bb);
    strokeWeight(8);
    line(a.x, a.y, b.x, b.y);
  }


  Point outsideT1 = null;

  boolean illegal() {
    // Edge edges
    legal = true;
    if (t1 == null || t2 == null) {
      // It's legal if it's only got one neighbor
      return false;
    }

    // Which is not included
    outsideT1 = this.notIncluded(t2);
    if (outsideT1 == null) {
      println("Something went wrong here!");
    }

    // It's an illegal edge if the non-shared point is inside
    if (t1.circleContains(outsideT1)) {
      legal = false;
    }
    return !legal;
  }


  // Assign a Triangle neighbor
  void setTriangle(Triangle t) {
    // First goes to t1
    if (t1 == null) {
      t1 = t;
      // I already assigned this triangle here, stop it!
    } else if (t1 == t) {
      // duplicate!
      // Second goes to t2
    } else {
      t2 = t;
    }
  }


  // This Edge should be deleted
  void markForRemoval() {
    toRemove = true;
  }

  // Swap this triangle out for this new one
  void swap(Triangle oldT, Triangle newT) {
    if (t1 == oldT) {
      t1 = newT;
    } else if (t2 == oldT) {
      t2 = newT;
    }
  }

  // Flip this edge!
  // This method is something of a disaster, help!
  Edge flip() {
    // These three things will be deleted when all is said and done
    t1.markForRemoval();
    t2.markForRemoval();
    this.markForRemoval();

    // Two non shared points
    Point p1 = this.notIncluded(t1);
    Point p2 = this.notIncluded(t2);

    // Find me the edge that goes from a to p1
    // Gosh this is really terrible!
    Edge newE1a = findEdge(t1, t2, a, p1);
    Edge newE2a = findEdge(t1, t2, a, p2);
    Edge newE3 = new Edge(p1, p2);
    Triangle newT1 = new Triangle(newE1a, newE2a, newE3);
    Edge newE1b = findEdge(t1, t2, b, p1);
    Edge newE2b = findEdge(t1, t2, b, p2);
    Triangle newT2 = new Triangle(newE1b, newE2b, newE3);

    // Need to reset which triangles are associated with which edges
    // newE1a, newE2a, newE3, new E1b, new E2b <--> remove t1, t2 replace newT1, newT2
    newE3.setTriangle(newT1);
    newE3.setTriangle(newT2);

    // Swap out, somehow I did this right where only E1a and E2a gets swapped with newT1 and E1b, E2b with newT2
    // The names here really need refactoring and I need to examine this more closely
    newE1a.swap(t1, newT1);
    newE2a.swap(t2, newT1);
    newE1b.swap(t1, newT2);
    newE2b.swap(t2, newT2);


    // edges.add(newE3);
    // Save the new edge to be added later, not now
    // Add the new triangles
    triangles.add(newT1);
    triangles.add(newT2);
    return newE3;
  }


  // This is just for sorting by b's y for making new triangles
  //int compareTo(Edge other) {
  //  float diff = other.b.y - this.b.y;
  //  if (diff < 0) {
  //    return -1;
  //  } else if (diff > 0) {
  //    return 1;
  //  } else {
  //    return 0;
  //  }
  //}



  // This is just for sorting by b's y for making new triangles
  int compareTo(Edge other) {
   PVector v1 = PVector.sub(this.b, this.a);
   PVector v2 = PVector.sub(other.b, other.a);

   float a1 = v1.heading();
   float a2 = v2.heading();
   if (a1 < 0) {
     a1 = map(a1, -PI, 0, PI, TWO_PI);
   }
   if (a2 < 0) {
     a2 = map(a2, -PI, 0, PI, TWO_PI);
   }
   float diff = a1 - a2;
   if (diff < 0) {
     return -1;
   } else if (diff > 0) {
     return 1;
   } else {
     return 0;
   }
  }


  // Same edge as another edge even if the points are reversed?
  boolean equals(Edge other) {
    return (a == other.a && b == other.b) || (a == other.b && b == other.a);
  }

  // Is this edge part of a triangle?
  boolean alsoIn(Triangle t) {
    if (this.equals(t.ab) || this.equals(t.bc) || this.equals(t.ac)) {
      return true;
    }
    return false;
  }

  void display() { 
    display(1, 255, 255, 255);
  }

  void display(float wght, float rr, float gg, float bb) { 
    stroke(rr, gg, bb, 127);
    strokeWeight(wght);
    line(a.x, a.y, b.x, b.y);
  }


  // Console printing
  String toString() {
    return a.toString() + " : " + b.toString();
  }

  Edge getVoronoi() {
    if (t1 != null && t2 != null) {
      Point newA = t1.circum.center;
      Point newB = t2.circum.center;
      return new Edge(newA, newB);
    } else {
      return null;
    }
  }
}


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