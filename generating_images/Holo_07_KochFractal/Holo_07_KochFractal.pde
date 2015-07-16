// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Koch Snowflake

// Renders a simple fractal, the Koch snowflake
// Each recursive level drawn in sequence

ArrayList<KochLine> lines  ;   // A list to keep track of all the lines

void setup() {
  size(2598, 3425);
  background(255);
  lines = new ArrayList<KochLine>();

  for (float i = 1; i >=0; i -= 0.025) {
    //    PVector a   = new PVector((-width/2)*i, (-width/2+173)*i);
    //    PVector b   = new PVector((width/2)*i, (-width/2+173)*i);
    //    PVector c   = new PVector(0*i, (-height/2+173+width*cos(radians(30)))*i);

    PVector a = new PVector(-width/2*i, -height/2*i);
    PVector b = new PVector(width/2*i, -height/2*i);
    PVector c = new PVector(width/2*i, height/2*i);
    PVector d = new PVector(-width/2*i, height/2*i);

    // Starting with additional lines
    lines.add(new KochLine(a, b));
    lines.add(new KochLine(b, c));
    lines.add(new KochLine(c, d));
    lines.add(new KochLine(d, a));
  }

  for (int i = 0; i < 5; i++) {
    generate();
  }
}

void draw() {
  background(255);
  translate(width/2, height/2);
  for (KochLine l : lines) {
    l.display();
  }
  saveFrame("fractal.png");
  noLoop();
}

void generate() {
  ArrayList next = new ArrayList<KochLine>();    // Create emtpy list
  for (KochLine l : lines) {
    //if (l.length() > 16) {
      // Calculate 5 koch PVectors (done for us by the line object)
      PVector a = l.kochA();                 
      PVector b = l.kochB();
      PVector c = l.kochC();
      PVector d = l.kochD();
      PVector e = l.kochE();
      // Make line segments between all the PVectors and add them
      next.add(new KochLine(a, b));
      next.add(new KochLine(b, c));
      next.add(new KochLine(c, d));
      next.add(new KochLine(d, e));
    //} else {
      //next.add(l);
    //}
  }
  lines = next;
}

