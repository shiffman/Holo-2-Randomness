class Triangle {
  PVector a;
  PVector b;
  PVector c;

  Circle circum;

  Triangle(PVector a, PVector b, PVector c) {
    this.a = a;
    this.b = b;
    this.c = c;
    circum = circumCenter();
  }

  void update() {
    circum = circumCenter();
  }

  void display() {
    stroke(0);
    noFill();
    beginShape();
    vertex(a.x, a.y);
    vertex(b.x, b.y);
    vertex(c.x, c.y);
    endShape(CLOSE);

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