// Processing triangulation //<>// //<>//
// Reference: https://www.youtube.com/watch?v=7VcuKj1_nHA
// http://geomalgorithms.com/a15-_tangents.html
// http://www.personal.kent.edu/~rmuhamma/Compgeometry/MyCG/ConvexHull/incrementCH.htm

import java.util.Collections;

ArrayList<Point> points = new ArrayList<Point>();
ArrayList<Edge> edges = new ArrayList<Edge>();
ArrayList<Triangle> triangles = new ArrayList<Triangle>();
boolean debug = true;
Poly hull = null;
int counter = 3;
int triangulation = 0;
int flipping = 1;
int mode = triangulation;
boolean flippingFinished = true;
PrintWriter output; 

void setup() {
  size(1200, 800, P2D_2X);
  //frameRate(8);
  randomSeed(20);
  //frameRate(1);
  output = createWriter("positions.txt"); 
  newPoint(0, 0);
  newPoint(width-1, 0);
  newPoint(1, height-1);
  newPoint(width-2, height-1);

  for (int i = 0; i < 600; i++) {
    newPoint(random(width), random(height));
  }
  output.flush();  // Writes the remaining data to the file
  output.close();  // Finishes the file

  initTriangulation();
}

void newPoint(float x, float y) {
  output.println(x + "," + y);  // Write the coordinate to the file
  points.add(new Point(x, y));
}

Edge testE;


void draw() {
  background(51);
  if (mode == triangulation) {
    Point current = points.get(counter);
    triangulate(current);
    for (Point p : points) {
      p.display();
    }
    for (Edge e : edges) {
      e.display();
    }
    hull.display();    

    current.display(8);

    if (counter < points.size()-1) {
      counter++;
    } else {
      mode = flipping;
      counter = 0;
    }
  } else if (mode == flipping) {
    //frameRate(5);
    for (Edge e : edges) {
      e.display();
    }
    Edge e = edges.get(counter);
    if (e.illegal()) {
      e.setColor(255, 0, 0);
      e.flip();
      flippingFinished = false;
      //counter = 0;
      //resetEdgeColors();
      counter++;
      cleanUp();
    } else {
      e.setColor(255, 255, 255);
      counter++;
    }
    if (counter == edges.size()) {
      if (flippingFinished == true) {
        mode = 5;
      } else {
        counter = 0;
        flippingFinished = true;
      }
    }
  } else if (mode == 5) {
    for (Triangle t : triangles) {
      t.display();
    }
    noLoop();
  }
}

void resetEdgeColors() {
  for (Edge e : edges) {
    e.setColor(255, 255, 255);
  }
}


Edge newEdge;
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
      edges.add(i, newEdge);
      break;
    }
  }
}