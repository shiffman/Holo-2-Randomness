
void triangulate(Point newPoint) {

  if (hull == null) {

    hull = new Poly();

    Point a = points.get(0);
    Point b = points.get(1);
    Point c = points.get(2);

    hull.addVertex(a);
    hull.addVertex(b);
    hull.addVertex(c);

    edges.add(new Edge(a, b)); 
    edges.add(new Edge(b, c)); 
    edges.add(new Edge(a, c)); 

    // This could be made more efficient
  }



  if (newPoint != null) {

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
        edges.add(new Edge(newPoint, current));
        if (lower == -1) {
          lower = j;
        } else {
          upper = j;
        }
      }
    }

    println("upper", upper, "lower", lower);
    for (int i = upper-1; i > lower; i--) {
      println("Deleting", i);
      edges.add(new Edge(newPoint, hull.vertices.get(i)));
      hull.vertices.remove(i);
    }

    hull.addVertex(newPoint);
    hull.sortVertices();
  }

  //redraw();
}