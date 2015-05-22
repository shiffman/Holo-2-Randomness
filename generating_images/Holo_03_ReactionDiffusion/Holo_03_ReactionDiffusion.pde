
// Written entirely based on
// http://www.karlsims.com/rd.html

// Also, could use for reference
// http://hg.postspectacular.com/toxiclibs/src/44d9932dbc9f9c69a170643e2d459f449562b750/src.sim/toxi/sim/grayscott/GrayScott.java?at=default

Cell[][] grid;
Cell[][] prev;

void setup() {
  size(2598, 3425);
  grid = new Cell[width][height];
  prev = new Cell[width][height];

  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j ++) {
      float a = 1;
      float b = 0;
      grid[i][j] = new Cell(a, b);
      prev[i][j] = new Cell(a, b);
    }
  }

  for (int n = 0; n < 100; n++) {
    int startx = int(random(50, width-50));
    int starty = int(random(50, height-50));

    for (int i = startx; i < startx+50; i++) {
      for (int j = starty; j < starty+50; j ++) {
        float a = 1;
        float b = 1;
        grid[i][j] = new Cell(a, b);
        prev[i][j] = new Cell(a, b);
      }
    }
  }
}

void draw() {
  for (int i = 0; i < 5000; i++) {
    update();
    swap();
    if (i % 100 == 0) {
      println(i);
    }
  }

  loadPixels();
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j ++) {
      Cell spot = grid[i][j];
      float a = spot.a;
      float b = spot.b;
      int pos = i + j * width;

      color cc = color(0);
      if ((a-b)*255 > 25) {
        cc = color(255);
      }

      //pixels[pos] = cc;//color((a-b)*255);
      pixels[pos] = color((a-b)*255);
    }
  }
  updatePixels();

  saveFrame("Reaction-diffusion####_holo.png");
}

//void mousePressed() {
//  save("Holo_rd.png"); 
//}


float dA = 1.0;
float dB = 0.5;
float feed = 0.055;
float k = 0.062;

class Cell {
  float a;
  float b;

  Cell(float a_, float b_) {
    a = a_;
    b = b_;
  }
}


void update() {
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j ++) {

      Cell spot = prev[i][j];
      Cell newspot = grid[i][j];

      float a = spot.a;
      float b = spot.b;

      float laplaceA = 0;
      laplaceA += a*-1;
      laplaceA += prev[(i+1+width)%width][(j+height)%height].a*0.2;
      laplaceA += prev[(i-1+width)%width][(j+height)%height].a*0.2;
      laplaceA += prev[(i+width)%width][(j+1+height)%height].a*0.2;
      laplaceA += prev[(i+width)%width][(j-1+height)%height].a*0.2;
      laplaceA += prev[(i-1+width)%width][(j-1+height)%height].a*0.05;
      laplaceA += prev[(i+1+width)%width][(j-1+height)%height].a*0.05;
      laplaceA += prev[(i-1+width)%width][(j+1+height)%height].a*0.05;
      laplaceA += prev[(i+1+width)%width][(j+1+height)%height].a*0.05;

      float laplaceB = 0;
      laplaceB += b*-1;
      laplaceB += prev[(i+1+width)%width][(j+height)%height].b*0.2;
      laplaceB += prev[(i-1+width)%width][(j+height)%height].b*0.2;
      laplaceB += prev[(i+width)%width][(j+1+height)%height].b*0.2;
      laplaceB += prev[(i+width)%width][(j-1+height)%height].b*0.2;
      laplaceB += prev[(i-1+width)%width][(j-1+height)%height].b*0.05;
      laplaceB += prev[(i+1+width)%width][(j-1+height)%height].b*0.05;
      laplaceB += prev[(i-1+width)%width][(j+1+height)%height].b*0.05;
      laplaceB += prev[(i+1+width)%width][(j+1+height)%height].b*0.05;

      newspot.a = a + (dA*laplaceA - a*b*b + feed*(1-a))*1;
      newspot.b = b + (dB*laplaceB + a*b*b - (k+feed)*b)*1;

      newspot.a = constrain(newspot.a, 0, 1);
      newspot.b = constrain(newspot.b, 0, 1);
    }
  }
}

void swap() {
  Cell[][] temp = prev;
  prev = grid;
  grid = temp;
}