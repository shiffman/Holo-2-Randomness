//void initTriangles() {
//  PVector a = points.get(0);
//  PVector b = points.get(1);
//  PVector c = points.get(2);
//  Triangle t = new Triangle(a, b, c);
//  triangles.add(t);
//}

//Object getRandom(ArrayList list) {
//  int i = int(random(list.size()));
//  return list.get(i);
//}

//Triangle superTriangle() {
//  // Determine bounds for super triangle.
//  float xmin = points.get(0).x;
//  float ymin = points.get(0).y;
//  float xmax = xmin;
//  float ymax = ymin;
//  for (int i =  1; i < points.size(); i++) {
//    PVector v = points.get(i);
//    xmin = min(v.x, xmin);
//    xmax = max(v.x, xmax);
//    ymin = min(v.y, ymin);
//    ymax = max(v.y, ymax);
//  }
//  float dx = xmax - xmin;
//  float dy = ymax - ymin;
//  float dmax = (dx > dy ? dx : dy) * 20;
//  float xmid = (xmax + xmin) / 2f;
//  float ymid = (ymax + ymin) / 2f;

//  PVector a = new PVector(xmid - dmax, ymid - dmax);
//  PVector b = new PVector(xmid, ymid + dmax);
//  PVector c = new PVector(xmid + dmax, ymid - dmax);
//  Triangle superTriangle = new Triangle(a, b, c);
//  return superTriangle;
//}