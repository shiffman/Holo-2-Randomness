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
boolean flippingFinished = true;

// Start mode at 0
int mode = 0;

// Writing out points if I want to save for checking against other libraries / algorithms
PrintWriter output; 

void setup() {
  size(1200, 800, P2D_2X);
  randomSeed(10);

  //frameRate(5);
  // Write the file
  output = createWriter("positions.txt"); 

  // Four points at corners
  newPoint(0, 0);
  newPoint(width-1, 0);
  newPoint(1, height-1);
  newPoint(width-2, height-1);

  // A bunch of random points
  for (int i = 0; i < 64; i++) {
    newPoint(random(width), random(height));
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

  if (illegalState > 0) {
    //delay(250);
  }


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
    //frameRate(10);

    // Current edge
    Edge currentE = edges.get(counter);
    // Is it legal?
    if (currentE.illegal()) {
      // It's not, flip it!
      currentE.flip();
      // We're not done, illegal edge!
      flippingFinished = false;
      illegalState = 1;
      // Delete extra edges and triangles
      cleanUp();
      // We will draw illegal triangles twice for animation purposes
    } else {
      if (illegalState == 1) {
        illegalState = 2;
      } else if (illegalState == 2) {
        illegalState = 0;
      } 
      // Go to the next
      counter++;
    }

    // Draw one triangle's circle

    currentE.displayState(illegalState);

    // Are we done
    if (counter == edges.size()) {
      // All the edges are legal!
      if (flippingFinished) {
        // Go to next mode
        mode++;
      } else {
        // Go through all edges again
        counter = 0;
        flippingFinished = true;
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
          vor.display(2, 255,255,255);
        }
      }
    }
  }
}


// Global variable to track new edge added during edge flipping
// This could probably be improved
Edge newEdge;

// Remove and delete any invalid triangles and edges after flipping
void cleanUp() {
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