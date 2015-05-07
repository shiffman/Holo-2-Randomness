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

boolean debug = true;

boolean showDelaunay = true;
boolean showVoronoi = true;
boolean showPoints = true;


// This is an object for a generic Polygon
// Using to track convex hull at the moment
// But could be used for Voronoi regions?
Poly hull = null;

// Counting through vertices (and edges?) during triangulation
int counter = 3;

// Finished with edge flipping (i.e. every edge is legal)
boolean finishedFlipping = true;

// Start mode at 0
int mode = 0;

// Writing out points if I want to save for checking against other libraries / algorithms
PrintWriter output; 

void setup() {
  size(1200, 800);
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


  // Finish the file
  output.flush();  // Writes the remaining data to the file
  output.close();  // Finishes the file

  // Start triangulation
  initTriangulation();
}

// Adding a new point
void newPoint(float x, float y) {
  output.println(x + "," + y);  // Write the coordinate to the file
  points.add(new Point(x, y));
}


int illegalState = 0;

void draw() {
  background(51);

  // Starting off with Triangulation
  if (mode == 0) {

    // Triangulate with a new poing
    Point current = points.get(counter);
    triangulate(current);

    // Draw all points, edges, and convex hull
    for (Point p : points) {
      p.display();
    }
    for (Edge e : edges) {
      e.display();
    }

    hull.display();    

    // Show current point bigger
    current.display(8);

    // Are we done?
    if (counter < points.size()-1) {
      counter++;
    } else {
      // Switch to edge flipping
      mode++;
      counter = 0;
    }
    // Edge flipping
  } else if (mode == 1) {
    for (Edge e : edges) {
      // Show all edges
      e.display();
    }
    // Current edge
    Edge currentE = edges.get(counter);
    // Is it legal?
    if (currentE.illegal()) {
      // It's not, flip it!
      Edge newEdge = currentE.flip();
      // This is bad, I'm doing an extra check b/c
      // some edges are showing illegal with both flips
      // Probably floating point math problem for tiny or perfectly symmetrical triangles?
      if (!newEdge.illegal()) {
        // Delete extra edges and triangles
        cleanUp(newEdge);
      } else {
        // This edge is a problem see which one I should pick if I can?
        float newScore = newEdge.howBad();
        float oldScore = currentE.howBad();
        if (oldScore < newScore) {
          cleanUp(newEdge);
        } else {
          // Oh well, leave it alone for now
          currentE.failed();
        }
      }        
      // We're not done, illegal edge!
      finishedFlipping = false;
      illegalState = 1;
    } else {
      if (illegalState == 1) {
        illegalState = 2;
      } else if (illegalState == 2) {
        illegalState = 0;
      }
      // Go to the next
      counter++;
    }
    currentE.displayState(illegalState);


    // Are we done
    if (counter == edges.size()) {
      // All the edges are legal!
      if (finishedFlipping) {
        // Go to next mode
        mode++;
      } else {
        // Go through all edges again
        counter = 0;
        finishedFlipping = true;
      }
    }
  } else if (mode == 2) {

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
      for (Edge e : edges) {
        Edge vor = e.getVoronoi();
        if (vor != null) {
          vor.display(2, 255, 255, 255);
        }
      }
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
  if (key == 'd') {
    showDelaunay = !showDelaunay;
  } else if (key == 'v') {
    showVoronoi = !showVoronoi;
  } else if (key == 'p') {
    showPoints = !showPoints;
  }
}