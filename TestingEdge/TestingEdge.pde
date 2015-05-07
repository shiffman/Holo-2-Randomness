

ArrayList<Edge> edges = new ArrayList<Edge>();

void setup() {
  size(1200, 800);

  Point a1 = new Point(989.9977, 696.7344);
  Point b = new Point(999.55023, 677.4872);
  Point c = new Point(1000.44617, 659.483);
  Point a2 = new Point(1000.61786, 659.1244);

  PVector offset = new PVector(50,50);//a1.copy();
  a1.sub(offset);
  c.sub(offset);
  a2.sub(offset);
  b.sub(offset);
  
  background(51);
  translate(width/2,height/2);
  scale(20);

  strokeWeight(1);
  stroke(255, 0, 0, 255);
  point(a1.x, a1.y);
  point(b.x, b.y);
  point(c.x, c.y);

  stroke(0, 255, 0, 100);
  point(a2.x, a2.y);

  float d = PVector.dist(c, a2);
  println(d);


  Edge e1 = new Edge(b, c);
  Triangle t11 = new Triangle(a1, b, c);
  Triangle t12 = new Triangle(a2, b, c);
  e1.setTriangle(t11);
  e1.setTriangle(t12);

  println("E1");
  println(e1.illegal());
  e1.howBad();



  Edge e2 = new Edge(a1, a2);
  Triangle t21 = new Triangle(a1, a2, b);
  Triangle t22 = new Triangle(a1, a2, c);
  e2.setTriangle(t21);
  e2.setTriangle(t22);
  println("E2");
  println(e2.illegal());
  e2.howBad();
  
}