// Processing triangulation //<>//
// Reference: https://www.youtube.com/watch?v=7VcuKj1_nHA
// http://geomalgorithms.com/a15-_tangents.html
// http://www.personal.kent.edu/~rmuhamma/Compgeometry/MyCG/ConvexHull/incrementCH.htm

import java.util.Collections;

ArrayList<Point> points = new ArrayList<Point>();
ArrayList<Edge> edges = new ArrayList<Edge>();

boolean showVoronoi = false;
boolean showDelaunay = true;
boolean debug = false;
Poly hull = null;
PVector test;
int counter = 3;

void setup() {
  size(600, 400, JAVA2D_2X);
  randomSeed(2);
  for (int i = 0; i < 64; i++) {
    newPoint(random(width), random(height));
  }
  Collections.sort(points);
}



void newPoint(float x, float y) {
  points.add(new Point(x, y));
}

void draw() {
  background(100);
  Point current = points.get(counter);
  triangulate(current);

  for (Point p : points) {
    p.display();
  }

  for (Edge e : edges) {
    e.display();
  }

  if (debug) {
    if (hull != null) {
      hull.polyDebug = true;
      hull.display();
    }
    if (test != null) {
      drawVector(test, width/2, height/2, 1);
    }
  }

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