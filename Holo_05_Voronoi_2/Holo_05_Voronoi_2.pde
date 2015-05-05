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

int triangulation = 0;
int flipping = 1;

int mode = triangulation;

boolean flippingFinished = true;
PrintWriter output; 

void setup() {
  size(1200, 800, P2D_2X);
  randomSeed(20);
  //frameRate(1);
  output = createWriter("positions.txt"); 
  newPoint(0, 0);
  newPoint(width-1, 0);
  newPoint(1, height-1);
  newPoint(width-2, height-1);

  for (int i = 0; i < 100; i++) {
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

  if (mode == triangulation) {
    background(200);
    Point current = points.get(counter);
    triangulate(current);
    int count = 0;
    for (Point p : points) {
      p.display();
    }
    //noLoop();

    for (Edge e : edges) {
      e.display();
    }

    for (Triangle t : triangles) {
      //t.display();
    }
    //frameRate(5);
    hull.display();    
    fill(255, 0, 0);
    ellipse(current.x, current.y, 10, 10);

    if (counter < points.size()-1) {
      counter++;
    } else {
      mode = flipping;
      counter = 0;
    }
  } else if (mode == flipping) {
    background(200);
    //noLoop();
    //println(counter, edges.size(), triangles.size());

    //frameRate(5);
    for (Edge e : edges) {
      e.display();
    }

    Edge e = edges.get(counter);
    //println("---------------------");
    //println(e);
    if (e.illegal()) {
      //testE = e;
      e.setColor(255, 0, 0);
      e.flip();
      flippingFinished = false;
      counter = 0;
      resetEdgeColors();
      cleanUp();
      //println("Flipped");
      //mode = 5;
    } else {
      e.setColor(0, 0, 255);
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
    background(200);
    for (Point p : points) {
      fill(255, 0, 0);
    }
    resetEdgeColors();
    for (Edge e : edges) {
      e.display();
    }
    for (Triangle t : triangles) {
      t.display();
    }
    noLoop();
  } else if (mode == 6) {
    fill(255,200);
    rect(0,0,width,height);
    for (Point p : points) {
      p.display();
    }
    resetEdgeColors();
    for (Edge e : edges) {
      //e.display();
    }
    for (Triangle t : triangles) {
      //t.display();
    }
    testE.flip();
    cleanUp();

    noLoop();
  }
}

void mousePressed() {
  //mode++;
  //redraw();
}

void resetEdgeColors() {
  for (Edge e : edges) {
    e.setColor(255, 255, 255);
  }
}

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
    }
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