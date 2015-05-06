// Processing triangulation
// Reference: https://www.youtube.com/watch?v=7VcuKj1_nHA
// http://geomalgorithms.com/a15-_tangents.html
// http://www.personal.kent.edu/~rmuhamma/Compgeometry/MyCG/ConvexHull/incrementCH.htm
// Daniel Shiffman
// May 2015
// https://github.com/shiffman/Holo-2-Randomness


// Start triangulation
void initTriangulation() {

  // Sort all the points
  Collections.sort(points);
  
  // The convex hull
  hull = new Poly();
  // The first three points
  Point a = points.get(0);
  Point b = points.get(1);
  Point c = points.get(2);
  // Go in the hull
  hull.addVertex(a);
  hull.addVertex(b);
  hull.addVertex(c);  
  // now we need 3 edges
  Edge ab = new Edge(a, b);
  Edge bc = new Edge(b, c);
  Edge ac = new Edge(a, c);
  // Add to list
  edges.add(ab); 
  edges.add(bc); 
  edges.add(ac); 
  
  Triangle t = new Triangle(ab, bc, ac);

  // Assign triangle to the edges
  ab.setTriangle(t);
  bc.setTriangle(t);
  ac.setTriangle(t);
  triangles.add(t);

  // We'll manually make the first triangle
  // so start at 3
  counter = 3;
}

void triangulate(Point newPoint) {
  
  // What new edges will come out of this
  ArrayList<Edge> newEdges = new ArrayList<Edge>();

  // This should probably be in the Poly class 
  // so that it can track its own convex-hull-ness
  // I could probably implement this in a way where I'm not
  // resorting the vertices by inserting the point in the right place
  // but eh, this will do for now
  hull.sortVertices();
  // Find bi-tangents
  // For now finding upper and lower in one loop but could improve this
  int total = hull.vertices.size();
  int upper = -1;
  int lower = -1;
  for (int j = 0; j < total; j++) {
    Point current = hull.vertices.get(j);
    Point before = hull.vertices.get((j + total - 1) % total);
    Point after = hull.vertices.get( (j         + 1) % total);
    PVector v1 = PVector.sub(current, before);
    PVector v2 = PVector.sub(after, current);
    PVector toTarget1 = PVector.sub(newPoint, current);    
    PVector toTarget2 = PVector.sub(newPoint, after);

    // http://stackoverflow.com/questions/13221873/determining-if-one-2d-vector-is-to-the-right-or-left-of-another
    float dot1 = v1.x*-toTarget1.y + v1.y*toTarget1.x;//v1.dot(toTarget1);
    float dot2 = v2.x*-toTarget2.y + v2.y*toTarget2.x;//v2.dot(toTarget2);
    
    // Make a new edge from new point to two bi tangents
    if ((dot1 > 0 && dot2 < 0) || (dot1 < 0 && dot2 > 0)) {
      newEdges.add(new Edge(newPoint, current));
      if (upper == -1) {
        upper = j;
      } else {
        lower = j;
      }
    }
  }

  // Ok, I have found the upper and lower bitangents
  Point upperP = hull.vertices.get(upper);
  Point lowerP = hull.vertices.get(lower);    

  // Make a big triangle to see what is inside
  Triangle t = new Triangle(upperP, lowerP, newPoint);
  // See what needs to be deleted in here
  // Ok, I should be able to look at any vertex points inbetween upper and lower bitangent
  // But I didn't get that to work so am instead just seeing what points already in the hull
  // are inside a new triangle 
  for (int i = hull.vertices.size()-1; i >= 0; i--) {
    Point p = hull.vertices.get(i);
    // Bad floating point math something thinks upper or lower points are inside the new triangle
    // If it's inside we need some new edges/triangles
    if (t.contains(p) && p != upperP && p != lowerP) {
      newEdges.add(new Edge(newPoint, hull.vertices.get(i)));
      // And those points are no longer part of convex hull
      hull.vertices.remove(i);
    }
  }
  
  // Here are all the new edges
  for (int i = 0; i < newEdges.size(); i++) {
    Edge e = newEdges.get(i);
    edges.add(e);
  }

  // Sort them from top to bottom to make triangles
  Collections.sort(newEdges);


  // Make any new triangles
  for (int i = 0; i < newEdges.size()-1; i++) {
    Edge ab = newEdges.get(i);
    Edge ac = newEdges.get(i+1);
    // Find the other edge from our edges list
    // This is a HUGE FLAW here and should be fixed
    // I shouldn't need to search through the entire edge list to find the right object reference
    Edge bc = new Edge(ab.b, ac.b);
    for (Edge e : edges) {
      if (e.equals(bc)) {
        bc = e; 
        break;
      }
    }

    // But once I have it, make a new triangle
    Triangle newT = new Triangle(ab, bc, ac);
    ab.setTriangle(newT);
    ac.setTriangle(newT);
    bc.setTriangle(newT);
    
    // And add it to list
    triangles.add(newT);
  }

  // And we've got a new point now
  hull.addVertex(newPoint);
}