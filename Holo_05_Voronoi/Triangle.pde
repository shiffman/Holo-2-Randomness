class Triangle {
  PVector a;
  PVector b;
  PVector c;

  boolean highlight = false;

  Edge[] edges = new Edge[3];

  Circle circum;

  Triangle(PVector a, PVector b, PVector c) {
    this.a = a;
    this.b = b;
    this.c = c;

    edges[0] = new Edge(this.a, this.b);
    edges[1] = new Edge(this.b, this.c);
    edges[2] = new Edge(this.a, this.c);

    circum = circumCenter();
  }

  void update() {
    circum = circumCenter();
  }

  boolean circleContains(PVector v) {
    return circum.contains(v);
  }


  void display() {
    if (highlight) {
      display(255,0,0);
    } else {
      display(0, 0, 0);
    }
  }

  void display(float rr, float gg, float bb) {
    stroke(rr, gg, bb);
    if (rr != 0 || gg != 0 || bb != 0) {
      fill(rr, gg, bb, 100);
    } else {
      noFill();
    }
    beginShape();
    vertex(a.x, a.y);
    vertex(b.x, b.y);
    vertex(c.x, c.y);
    endShape(CLOSE);
  }

  void showCircle() {
    circum.display();
  }

  // From: http://www.ics.uci.edu/~eppstein/junkyard/circumcenter.html
  Circle circumCenter() {
    PVector center = new PVector(); 

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
}