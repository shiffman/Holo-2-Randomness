PVector a;
PVector b;
PVector c;

void setup() {
  size(640, 360, JAVA2D_2X);
  randomSeed(15);
  a = new PVector(300, 50);
  b = new PVector(400, 100);
  c = new PVector(150, 200);


  background(255);
  stroke(0);
  noFill();
  triangle(a.x, a.y, b.x, b.y, c.x, c.y);
  strokeWeight(8);
  point(a.x, a.y);
  point(b.x, b.y);
  point(c.x, c.y);
  
  PVector ab = PVector.sub(b,a);
  PVector ac = PVector.sub(c,a);
  PVector abmid = PVector.add(a,b);
  abmid.div(2);

  PVector acmid = PVector.add(a,c);
  acmid.div(2);

  // We have a triangle with 3 vertices: a, b, c
  // We have vectors that define the sides of the triangle: ab, ac, bc
  // We also have the midpoints of the line segements: abmid, acmid, bcmid
  
  // We need perpendicular vectors to define the bisectors of each side
  ab.rotate(PI/2);
  ac.rotate(PI/2);
  
  // Find the intersection between the two perpendicular bisectors
  float numerator   = (ac.x * (abmid.y-acmid.y)) - (ac.y * (abmid.x-acmid.x));
  float denominator = (ac.y * ab.x) - (ac.x * ab.y);
  ab.mult(numerator / denominator);
  // The center of the circumcircle is that intersection!
  PVector center = PVector.add(abmid, ab);
  // The radius is the distance from the center to one of the triangle vertices
  float r = PVector.dist(center, c);
  strokeWeight(0.5);
  stroke(0);
  noFill();
  ellipse(center.x, center.y, r*2, r*2);
  noLoop();
}