

void initTriangulation() {
  Collections.sort(points);
  counter = 3;
  hull = new Poly();
  Point a = points.get(0);
  Point b = points.get(1);
  Point c = points.get(2);
  hull.addVertex(a);
  hull.addVertex(b);
  hull.addVertex(c);  
  Edge ab = new Edge(a, b);
  Edge bc = new Edge(b, c);
  Edge ac = new Edge(a, c);
  edges.add(ab); 
  edges.add(bc); 
  edges.add(ac); 

  Triangle t = new Triangle(ab, bc, ac);
  //t.highlight = true;
  triangles.add(t);
}

void triangulate(Point newPoint) {

  ArrayList<Edge> newEdges = new ArrayList<Edge>();

  // This should probably be in the Poly class 
  // so that it can track its own convex-hull-ness
  // I could probably implement this in a way where I'm not
  // resorting the vertices by inserting the point in the right place
  // but eh, this will do for now
  hull.sortVertices();
  // Find upper bi-tangent
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
  // Make a big triangle
  Triangle t = new Triangle(upperP, lowerP, newPoint);

  // See what needs to be deleted in here
  for (int i = hull.vertices.size()-1; i >= 0; i--) {
    Point p = hull.vertices.get(i);
    // Bad floating point math something thinks upper or lower points are inside the new triangle
    if (t.contains(p) && p != upperP && p != lowerP) {
      newEdges.add(new Edge(newPoint, hull.vertices.get(i)));
      hull.vertices.remove(i);
    }
  }

  for (int i = 0; i < newEdges.size(); i++) {
    Edge e = newEdges.get(i);
    edges.add(e);
  }

  Collections.sort(newEdges);


  //if (newEdges.size() == 2) {
  for (int i = 0; i < newEdges.size()-1; i++) {
    Edge ab = newEdges.get(i);
    Edge bc = newEdges.get(i+1);
    // Find the other edge from our edges list
    // This is terribly problematic probably but will do for now
    Edge ac = new Edge(ab.a, bc.b);
    for (Edge e : edges) {
      if (e.equals(ac)) {
        ac = e; 
        break;
      }
    }


    Triangle newT = new Triangle(ab, bc, ac);
    //newT.highlight = true;
    triangles.add(newT);
  }


  hull.addVertex(newPoint);
  hull.sortVertices();
}