// Processing triangulation //<>// //<>//
// Reference: https://www.youtube.com/watch?v=7VcuKj1_nHA
// http://geomalgorithms.com/a15-_tangents.html
// http://www.personal.kent.edu/~rmuhamma/Compgeometry/MyCG/ConvexHull/incrementCH.htm

import java.util.Collections;

ArrayList<Point> points = new ArrayList<Point>();
ArrayList<Edge> edges = new ArrayList<Edge>();
ArrayList<Triangle> triangles = new ArrayList<Triangle>();

boolean showVoronoi = false;
boolean showDelaunay = true;
boolean debug = true;
Poly hull = null;
PVector test;
int counter = 3;

void setup() {
  size(1200, 800, P2D_2X);
  //randomSeed(20);
  //frameRate(1);
  newPoint(0, 0);
  newPoint(width-1, 0);
  newPoint(0, height-1);
  newPoint(width-1, height-1);

  for (int i = 0; i < 256; i++) {
    newPoint(random(width), random(height));
  }
  initTriangulation();
}

void newPoint(float x, float y) {
  points.add(new Point(x, y));
}



void draw() {
  background(100);
  Point current = points.get(counter);
  triangulate(current);

  int count = 0;
  for (Point p : points) {
    p.display();
  }

  for (Edge e : edges) {
    //e.display();
  }
  
  for (Triangle t: triangles) {
    t.display(); 
  }
  
  hull.display();

  if (debug) {
    if (hull != null) {
      hull.polyDebug = true;
    }
    if (test != null) {
      fill(255, 0, 0);
      ellipse(test.x, test.y, 8, 8);
      //drawVector(test, width/2, height/2, 1);
    }
  }

  fill(255, 0, 0);
  ellipse(current.x, current.y, 10, 10);

  if (counter < points.size()-1) {
    counter++;
  } else {
    hull.display();
    noLoop();
  }
}


void keyPressed() {
  if (key == 'd') {
    showDelaunay = !showDelaunay;
  } else if (key == 'v') {
    showVoronoi = !showVoronoi;
  }
}

// Renders a vector object 'v' as an arrow and a location 'x,y'
void drawVector(PVector v, float x, float y, float scayl) {
  pushMatrix();
  float arrowsize = 4;
  // Translate to location to render vector
  translate(x, y);
  stroke(255);
  // Call vector heading function to get direction (note that pointing up is a heading of 0) and rotate
  rotate(v.heading());
  // Calculate length of vector & scale it to be bigger or smaller if necessary
  float len = v.mag()*scayl;
  // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
  line(0, 0, len, 0);
  line(len, 0, len-arrowsize, +arrowsize/2);
  line(len, 0, len-arrowsize, -arrowsize/2);
  popMatrix();
}