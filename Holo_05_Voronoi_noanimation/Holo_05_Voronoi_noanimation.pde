// Processing triangulation //<>//
// Reference: https://www.youtube.com/watch?v=7VcuKj1_nHA
// http://geomalgorithms.com/a15-_tangents.html
// http://www.personal.kent.edu/~rmuhamma/Compgeometry/MyCG/ConvexHull/incrementCH.htm
// Daniel Shiffman
// May 2015
// https://github.com/shiffman/Holo-2-Randomness

import java.util.Collections;

// Points, Edges, and Triangles
ArrayList<Point> points = new ArrayList<Point>();
ArrayList<Edge> edges = new ArrayList<Edge>();
ArrayList<Triangle> triangles = new ArrayList<Triangle>();

ArrayList<Edge> voronoi = new ArrayList<Edge>();

boolean debug = true;

boolean showEdges = true;
boolean showDelaunay = true;
boolean showVoronoi = true;
boolean showPoints = true;

// This is an object for a generic Polygon
// Using to track convex hull at the moment
// But could be used for Voronoi regions?
Poly hull = null;

// Writing out points if I want to save for checking against other libraries / algorithms
PrintWriter output; 

void setup() {
  size(1200, 800, P2D_2X);
  randomSeed(11);

  //frameRate(5);
  // Write the file
  output = createWriter("positions.txt"); 

  // Four points at corners
  newPoint(0, 0);
  newPoint(width-1, 0);
  newPoint(1, height-1);
  newPoint(width-2, height-1);

  // Some random points
  for (int i = 0; i < 50; i++) {
   newPoint(random(width), random(height));
  }

  // A bunch of random points
  //float r = 10;
  //float angle = 0;
  //for (int i = 0; i < 50; i++) {
  //  float x = r * cos(angle);
  //  float y = r * sin(angle);
  //  newPoint(width/2+x, height/2+y);
  //  r += 10;
  //  angle += 0.25;
  //}

  // Finish the file
  output.flush();  // Writes the remaining data to the file
  output.close();  // Finishes the file

  // Start triangulation
  initTriangulation();
  for (int i = 3; i < points.size(); i++ ) {
    // Triangulate with a new point
    Point current = points.get(i);
    triangulate(current);
  } 

  boolean finishedFlipping = false;
  while (!finishedFlipping) {
    finishedFlipping = true;
    for (int i = edges.size()-1; i >= 0; i--) {
      Edge e = edges.get(i);
      if (e.illegal()) {
        // It's not, flip it!
        Edge newEdge = e.flip();
        // Delete extra edges and triangles
        cleanUp(newEdge);
        // We're not done, illegal edge!
        finishedFlipping = false;
      }
    }
  }

  for (Edge e : edges) {
    Edge voronoiEdge = e.getVoronoi();
    if (voronoiEdge != null) {
      // Hack here probably need to deal with those infinity points?
      //if (validate(voronoiEdge)) {
        voronoi.add(voronoiEdge);
      //}
      //vor.display(2, 255, 255, 255);
    }
  }
}

boolean validate(Edge e) {
  float d1 = dist(e.a.x, e.a.y, width/2, height/2);
  float d2 = dist(e.b.x, e.b.y, width/2, height/2);
  if (d1 > 1000 || d2 > 1000) {
    return false;
  } else {
    return true;
  }
}

// Adding a new point
void newPoint(float x, float y) {
  output.println(x + "," + y);  // Write the coordinate to the file
  points.add(new Point(x, y));
}



void draw() {
  background(51);

  if (showEdges) {
    for (Edge e : edges) {
      e.display();
    }
  }

  // We're done, let's see all the triangles
  if (showDelaunay) {
    for (Triangle t : triangles) {
      t.display();
    }
  } 

  if (!mousePressed) {
    Point p = points.get(testCount);
    p.display(16, 0, 255, 0);
  }

  if (showPoints) {
    for (Point p : points) {
      p.display(4);
    }
  } 

  if (showVoronoi) {
    for (Edge e : voronoi) {
      e.display(2, 255, 255, 255);
    }
  }
}

// Remove and delete any invalid triangles and edges after flipping
void cleanUp(Edge newEdge) {
  for (int i = triangles.size()-1; i >=0; i--) {
    Triangle t = triangles.get(i);
    if (t.toRemove) {
      triangles.remove(i);
    }
  }
  for (int i = edges.size()-1; i >=0; i--) {
    Edge e = edges.get(i);
    if (e.toRemove) {
      edges.remove(i);
      // Add the new Edge in its place!
      edges.add(i, newEdge);
      break;
    }
  }
}

void keyPressed() {
  if (key == 'e') {
    showEdges = !showEdges;
  } else if (key == 'd') {
    showDelaunay = !showDelaunay;
  } else if (key == 'v') {
    showVoronoi = !showVoronoi;
  } else if (key == 'p') {
    showPoints = !showPoints;
  }
}