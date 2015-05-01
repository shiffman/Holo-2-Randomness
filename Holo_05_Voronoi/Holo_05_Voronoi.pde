 //<>//

ArrayList<PVector> points = new ArrayList<PVector>();
ArrayList<Triangle> triangles = new ArrayList<Triangle>();

void setup() {
  size(400, 400);
  int buffer = 0;
  PVector a = new PVector(buffer, buffer);
  PVector b = new PVector(width-buffer, buffer);
  PVector c = new PVector(width-buffer, height-buffer);
  PVector d = new PVector(buffer, height-buffer);
  points.add(a);
  points.add(b);
  points.add(c);
  points.add(d);
  triangles.add(new Triangle(a, b, c));
  triangles.add(new Triangle(a, c, d));
  newPoint(500, 500);

  debug = false;
}

boolean debug = false;

void delaunay(PVector v) {
  // A list of triangles whose circumcircle contains the new point
  ArrayList<Triangle> toConsider = new ArrayList<Triangle>();
  for (int i = triangles.size()-1; i >= 0; i--) {
    Triangle t = triangles.get(i);
    if (t.circleContains(v)) {
      toConsider.add(t);
      if (debug) {
        t.highlight = true;
      } else {
        triangles.remove(i);
      }
    }
  } 

  if (!debug) {
    ArrayList<Edge> uniqueEdges = new ArrayList<Edge>();
    if (toConsider.size() == 1) {
      Edge[] edges = toConsider.get(0).edges;
      for (int i = 0; i  < edges.length; i++) {
        uniqueEdges.add(edges[i]);
      }
    } else {
      // Let's make list of edges for a new polygon
      for (int i = 0; i < toConsider.size(); i++) {
        Triangle ti = toConsider.get(i);
        for (int j = 0; j < toConsider.size(); j++) {
          Triangle tj = toConsider.get(j);
          if (i != j) {
            // What edges from i are unique to i only?
            for (int k = 0; k  < ti.edges.length; k++) {
              if (!ti.edges[k].alsoIn(tj)) {
                uniqueEdges.add(ti.edges[k]);
              }
            }
          }
        }
      }
    }

    Poly poly = new Poly();
    for (Edge e : uniqueEdges) {
      poly.addVertex(e.a);
      poly.addVertex(e.b);
    }
    poly.sortVertices();

    for (int i = 0; i < poly.vertices.size(); i++) {
      PVector a = poly.vertices.get(i);
      PVector b = poly.vertices.get((i+1) % poly.vertices.size());
      PVector c = v;        
      Triangle t = new Triangle(a, b, c);
      triangles.add(t);
    }
  }
  redraw();
}

void draw() {
  background(100);

  for (Triangle t : triangles) {
    t.display();

    if (debug) {
      PVector m = new PVector(mouseX, mouseY);
      if (t.circleContains(m)) {
        t.showCircle();
      }
    }

    //t.showCircle();
  }

  for (PVector v : points) {
    fill(182);
    stroke(0);
    ellipse(v.x, v.y, 8, 8);
  }
  //noLoop();
}


void newPoint(float x, float y) {
  PVector spot = new PVector(x, y);
  points.add(spot);
  delaunay(spot);
  redraw();
}

void mousePressed( ) {
  newPoint(mouseX, mouseY);
}