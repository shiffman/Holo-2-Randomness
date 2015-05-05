// Daniel Shiffman
// Hanukkah 2011
// 8 nights of Processing examples
// http://www.shiffman.net

// A class that generates a polygon sorted
// according to relative angle from center

class Poly {
  // A list of vertices
  ArrayList<Point> vertices;
  // The center
  PVector centroid;
  boolean polyDebug = false;

  Poly() {
    // Empty at first
    vertices = new ArrayList<Point>();
    centroid = new Point();
  }

  // We can clear the whole thing if necessary
  void clear() {
    vertices.clear();
  }

  void deleteVertex(int index) {
    vertices.remove(index);
  }

  void insertVertex(int index, Point p) {
    vertices.add(index, p);
  }

  void deleteEnd() {
    deleteVertex(vertices.size()-1);
  }

  void reorder(int start) {
    reorder(start, false);
  }

  void reorder(int start, boolean reverse) {
    int total = vertices.size();
    ArrayList<Point> temp = new ArrayList<Point>();
    int index = start;
    while (true) {

      temp.add(vertices.get(index));
      if (reverse) {
        index = (index - 1 + total) % total;
      } else {
        index = (index + 1) % total;
      }
      
      if (index == start) {
        break;
      }
    }
    vertices = temp;
  }

  int closestPoint(Point p) {
    float record = 100000000;
    int closest = 0;
    for (int i = 0; i < vertices.size(); i++) {
      float d = PVector.dist(vertices.get(i), p);
      if (d < record) {
        record = d;
        closest = i;
      }
    }
    return closest;
  }


  // Add a new vertex
  void addVertex(Point newVertex) {

    if (vertices.contains(newVertex)) {
      return;
    }


    vertices.add(newVertex);
    // sortVertices();
    // Whenever we have a new vertex
    // We have to recalculate the center
    // and re-sort the vertices
    //updateCentroid();
  }

  // The center is the average location of all vertices
  void updateCentroid() {
    centroid = new PVector();
    for (PVector v : vertices) {
      centroid.add(v);
    } 
    centroid.div(vertices.size());
  }


  // Sorting the ArrayList
  void sortVertices() {
    // Make sure center is updated 
    updateCentroid();

    // This is something like a selection sort
    // Here, instead of sorting within the ArrayList
    // We'll just build a new one sorted
    ArrayList<Point> newVertices = new ArrayList<Point>();

    // As long as it's not empty
    while (!vertices.isEmpty ()) {
      // Let's find the one with the highest angle
      float biggestAngle = 0;
      Point biggestVertex = null;
      // Look through all of them
      for (Point v : vertices) {
        // Make a vector that points from center
        PVector dir = PVector.sub(v, centroid);
        // What is it's heading
        // The heading function will give us values between -PI and PI
        // easier to sort if we have from 0 to TWO_PI
        float a = dir.heading() + PI;
        // Did we find it
        if (a > biggestAngle) {
          biggestAngle = a;
          biggestVertex = v;
        }
      }

      // Put the one we found in the new arraylist
      newVertices.add(biggestVertex);
      // Delete it so that the next biggest one 
      // will be found the next time
      vertices.remove(biggestVertex);
    }
    // We've got a new ArrayList
    vertices = newVertices;
  }


  // Draw everything!
  void display() {

    // First draw the polygon
    stroke(255);
    strokeWeight(2);
    noFill();
    beginShape();
    for (PVector v : vertices) {
      vertex(v.x, v.y);
    } 
    endShape(CLOSE);


    if (polyDebug) {
      // Then we'll draw some addition information
      // at each vertex to show the sorting
      for (int i = 0; i < vertices.size(); i++) {

        // This is overkill, but we want the numbers to
        // appear outside the polygon so we extend a vector
        // from the center
        PVector v = vertices.get(i);      
        PVector dir = PVector.sub(v, centroid);
        dir.normalize();
        dir.mult(12);

        // Number the vertices
        fill(255);
        stroke(255);
        ellipse(v.x, v.y, 4, 4);
        textAlign(CENTER);
        //text(i, v.x+dir.x, v.y+dir.y+6);
      } 


      // Once we have two vertices draw the center
      if (vertices.size() > 1  ) {
        fill(255);
        //ellipse(centroid.x, centroid.y, 8, 8);
        //text("centroid", centroid.x, centroid.y+16);
      }
    }
  }
}