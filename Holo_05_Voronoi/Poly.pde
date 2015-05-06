// Processing triangulation
// Reference: https://www.youtube.com/watch?v=7VcuKj1_nHA
// http://geomalgorithms.com/a15-_tangents.html
// http://www.personal.kent.edu/~rmuhamma/Compgeometry/MyCG/ConvexHull/incrementCH.htm
// Daniel Shiffman
// May 2015
// https://github.com/shiffman/Holo-2-Randomness

// This class comes from: http://shiffman.net/2011/12/23/night-4-sorting-the-vertices-of-a-polygon/
// But it's been adjusted to do a few more things

// Maybe this should be more specifically a convex hull class

class Poly {
  // A list of vertices
  ArrayList<Point> vertices;
  // The center
  PVector centroid;

  // Show more info?
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



  // This is a weird thing that I am not using anymore
  // but could be useful
  // Reorders list with a specific vertex at index 0

  //void reorder(int start) {
  //  reorder(start, false);
  //}

  //void reorder(int start, boolean reverse) {
  //  int total = vertices.size();
  //  ArrayList<Point> temp = new ArrayList<Point>();
  //  int index = start;
  //  while (true) {
  //    temp.add(vertices.get(index));
  //    if (reverse) {
  //      index = (index - 1 + total) % total;
  //    } else {
  //      index = (index + 1) % total;
  //    }
  //    if (index == start) {
  //      break;
  //    }
  //  }
  //  vertices = temp;
  //}


  // Which point on this polygon is closest to another
  // Also not using at the moment
  //int closestPoint(Point p) {
  //  float record = 100000000;
  //  int closest = 0;
  //  for (int i = 0; i < vertices.size(); i++) {
  //    float d = PVector.dist(vertices.get(i), p);
  //    if (d < record) {
  //      record = d;
  //      closest = i;
  //    }
  //  }
  //  return closest;
  //}


  // Add a new vertex
  void addVertex(Point newVertex) {
    // Don't add duplicate vertices?
    if (vertices.contains(newVertex)) {
      return;
    }
    vertices.add(newVertex);
    // Could automatically sort and update center
    // sortVertices();
    // updateCentroid();
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
  // This could use some work
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
        text(i, v.x+dir.x, v.y+dir.y+6);
      } 

      // Once we have two vertices draw the center
      if (vertices.size() > 1  ) {
        fill(255);
        ellipse(centroid.x, centroid.y, 8, 8);
        text("centroid", centroid.x, centroid.y+16);
      }
    }
  }
}