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

boolean showEdges = false;
boolean showDelaunay = false;
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

  // A bunch of random points
  for (int i = 0; i < 1000; i++) {
    newPoint(random(width), random(height));
  }

  // This is my hack b/c I don't want points super close to each
  // other, I think the floating point math is failing on tiny tiny triangles?
  for (int i = points.size()-1; i >= 0; i--) {    
    for (int j = 0; j < i; j++) {
      Point pi = points.get(i);
      Point pj = points.get(j);
      float d = PVector.dist(pi, pj);
      if (d < 10) {
        points.remove(i);
      }
    }
  }

  //float offset = 0;
  //float xoff = 0;
  //for (float r = 100; r < 101; r+=20) {
  //  for (float angle = 0; angle < 360; angle += 10) {
  //    float a = radians(angle + offset);
  //    float x = r * cos(a);
  //    float y = r * sin(a);
  //    newPoint(width/2+x, height/2+y);
  //  }    
  //  offset += map(xoff,0,1,0,360);
  //  xoff += 0.1;
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
        // This is bad, I'm doing an extra check b/c
        // some edges are showing illegal with both flips
        // Probably floating point math problem for tiny or perfectly symmetrical triangles?
        if (!newEdge.illegal()) {
          // Delete extra edges and triangles
          cleanUp(newEdge);
        } else {
          // This edge is a problem see which one I should pick if I can?
          float newScore = newEdge.howBad();
          float oldScore = e.howBad();
          if (oldScore < newScore) {
            cleanUp(newEdge);
          } else {
            // Oh well, leave it alone for now
            e.failed();
          }
        }        
        // We're not done, illegal edge!
        finishedFlipping = false;
      }
    }
  }

  for (Edge e : edges) {
    Edge voronoiEdge = e.getVoronoi();
    if (voronoiEdge != null) {
      // Hack here probably need to deal with those infinity points?
      if (validate(voronoiEdge)) {
        voronoi.add(voronoiEdge);
      }
    }
  }
}

boolean validate(Edge e) {
  float d1 = dist(e.a.x, e.a.y, width/2, height/2);
  float d2 = dist(e.b.x, e.b.y, width/2, height/2);
  float threshold = 5000;
  if (d1 > threshold || d2 > threshold) {
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