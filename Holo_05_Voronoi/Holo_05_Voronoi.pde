 //<>//

ArrayList<PVector> points = new ArrayList<PVector>();
ArrayList<Triangle> triangles = new ArrayList<Triangle>();

void setup() {
  size(400, 400);
  randomSeed(1);
}

void initTriangles() {
  PVector a = points.get(0);
  PVector b = points.get(1);
  PVector c = points.get(2);
  Triangle t = new Triangle(a, b, c);
  triangles.add(t);
}

Object getRandom(ArrayList list) {
  int i = int(random(list.size()));
  return list.get(i);
}

void keyPressed() {
  if (key == ' ') {
    swap();
  }
  delaunay(null);

  redraw();
}

void swap() {
  Triangle t1 = (Triangle) getRandom(triangles);
  Triangle t2 = (Triangle) getRandom(triangles);

  PVector tempA = t1.a;
  PVector tempB = t2.b;
  t2.a = tempA;
  t1.c = tempB;
  t1.update();
  t2.update();
  
}

void delaunay(PVector v) {

  if (v != null) {
    Triangle t = (Triangle) getRandom(triangles);
    PVector a = t.a;
    PVector b = t.b;
    Triangle newT = new Triangle(a, b, v);
    triangles.add(newT);
  }


  boolean finished = false;
  while (!finished) {
    finished = true;
    for (Triangle tri : triangles) {
      Circle c = tri.circum;
      int total = 0;
      for (PVector p : points) {
        if (c.contains(p)) {
          total++;
        }
      }
      println(c, total);
      if (total >= 4) {
        //finished = false;
      }
    }

    //if (!finished) {

    //  // Do a swap

    //}
    redraw();
  }



  //ArrayList<PVector> tempP = new ArrayList<PVector>();
  //for (PVector v : points) {
  //  tempP.add(v);
  //}

  //while (tempP.size() >= 3) {
  //  PVector a = tempP.remove(int(random(tempP.size())));
  //  PVector b = tempP.remove(int(random(tempP.size())));
  //  PVector c = tempP.remove(int(random(tempP.size())));
  //  tempP.add(b);
  //  tempP.add(c);
  //  Triangle t = new Triangle(a, b, c);
  //  triangles.add(t);

  //  if (triangles.size() > 1) {
  //    swapUntilDone();
  //  }
  //}
}

void draw() {
  background(100);

  for (Triangle t : triangles) {
    t.display();
  }

  for (PVector v : points) {
    fill(182);
    stroke(0);
    ellipse(v.x, v.y, 8, 8);
  }

  noLoop();
}

void mousePressed() {
  PVector spot = new PVector(mouseX, mouseY);
  points.add(spot);

  if (points.size() == 3) {
    initTriangles();
  } else if (points.size() >= 3) {
    delaunay(spot);
  }
  redraw();
}