class Edge implements Comparable<Edge> {
  Point a;
  Point b;

  Triangle t1;
  Triangle t2;

  color col = color(255);

  boolean toRemove = false;

  Edge(Point a_, Point b_) {
    a = a_;
    b = b_;
  }


  // Which point from a triangle is not part of this edge
  // There's got to be a better way to do this?
  Point notIncluded(Triangle t) {
    //println(a, b);
    //println("Triangle: ", t);
    //println("--------------");

    if (t.a != a && t.a != b) {
      return t.a;
    } else if (t.b != a && t.b != b) {
      return t.b;
    } else if (t.c != a && t.c != b) {
      return t.c;
    }
    return null;
  }

  boolean illegal() {
    // Edge edges
    if (t1 == null || t2 == null) {
      //println("null problem");
      return false;
    }

    //t1.highlight = true;
    //t2.highlight = true;
    //t1.display();
    //t2.display();

    Point p = this.notIncluded(t2);
    if (p == null) {
      println("BIG FAIL");
    }
    fill(255, 0, 0);
    ellipse(p.x, p.y, 16, 16);
    t1.showCircle();
    // println(p);
    // It's an illegal edge if the non shared point is in there
    if (t1.circleContains(p)) {
      return true;
    }



    //p = this.notIncluded(t1);
    //if (t2.circleContains(p)) {
    //  return true;
    //}

    return false;
  }

  void setTriangle(Triangle t) {
    if (t1 == null) {
      t1 = t;
    } else if (t1 == t) {
      // duplicate!
      //println("dup");
    } else {
      t2 = t;
      //println(t1, t2);
    }
  }



  //void setTriangles(Triangle t1_, Triangle t2_) {
  //  t1 = t1_;
  //  t2 = t2_;
  //}

  void markForRemoval() {
    toRemove = true;
  }

  // Swap out an old triangle for a new one
  //void swap(Triangle oldT1, Triangle newT1, Triangle oldT2, Triangle newT2) {
  //  println("SWAPIT");
  //  if (t1 == oldT1) {
  //    println("t1 swap t1");
  //    t1 = newT1;
  //  } else if (t1 == oldT2) {
  //    println("t1 swap t2");
  //    t1 = newT2;
  //  }
  //  if (t2 == oldT1) {
  //    println("t2 swap t1");
  //    t2 = newT1;
  //  } else if (t2 == oldT2) {
  //    println("t2 swap t2");
  //    t2 = newT2;
  //  }
  //}

  void swap(Triangle oldT, Triangle newT) {
    println("SWAPIT");
    if (t1 == oldT) {
      println("t1 swap");
      t1 = newT;
    } else if (t2 == oldT) {
      println("t2 swap");
      t2 = newT;
    }
  }

  void flip() {
    t1.markForRemoval();
    t2.markForRemoval();
    this.markForRemoval();

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

    // WORKS!
    newE1a.swap(t1, newT1);
    newE2a.swap(t2, newT1);
    newE1b.swap(t1, newT2);
    newE2b.swap(t2, newT2);

    edges.add(newE3);
    triangles.add(newT1);
    triangles.add(newT2);
    
    //newE3.setColor(0,255,0);
    //newE3.display();
    
    //newE3.t1.highlight = true;
    //newE3.t2.highlight = true;
    //newE3.t1.display();
    //newE3.t2.display();
    //newE3.setColor(0,0,255);
    //newE3.display();
    
    
  }


  // This is just for sorting by b's y for making new triangles
  int compareTo(Edge other) {
    float diff = other.b.y - this.b.y;
    if (diff < 0) {
      return -1;
    } else if (diff > 0) {
      return 1;
    } else {
      return 0;
    }
  }

  boolean equals(Edge other) {
    //float d = PVector.dist(a,other.a) + PVector.dist(b,other.b);
    //if (d < 0.1) {
    //  return true;
    //}
    //d = PVector.dist(a,other.b) + PVector.dist(b,other.a);
    //if (d < 0.1) {
    //  return true;
    //}
    //return false;
    return (a == other.a && b == other.b) || (a == other.b && b == other.a);
  }

  boolean alsoIn(Triangle t) {
    if (this.equals(t.ab) || this.equals(t.bc) || this.equals(t.ac)) {
      return true;
    }
    return false;
  }

  void setColor(float r, float g, float b) {
    col = color(r, g, b);
  }

  void display() {
    stroke(col);
    strokeWeight(1);
    line(a.x, a.y, b.x, b.y);
  }

  String toString() {
    return a.toString() + " : " + b.toString();
  }
}

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