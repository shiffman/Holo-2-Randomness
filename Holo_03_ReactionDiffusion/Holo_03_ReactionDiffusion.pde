
// Written entirely based on
// http://www.karlsims.com/rd.html

// Also, could use for reference
// http://hg.postspectacular.com/toxiclibs/src/44d9932dbc9f9c69a170643e2d459f449562b750/src.sim/toxi/sim/grayscott/GrayScott.java?at=default

PVector[][] grid;
PVector[][] prev;

void setup() {
  size(300, 300);
  grid = new PVector[width][height];
  prev = new PVector[width][height];

  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j ++) {
      float a = 1;
      float b = 0;
      grid[i][j] = new PVector(a, b);
      prev[i][j] = new PVector(a, b);
    }
  }

  for (int n = 0; n < 10; n++) {
    int startx = int(random(20, width-20));
    int starty = int(random(20, height-20));

    for (int i = startx; i < startx+10; i++) {
      for (int j = starty; j < starty+10; j ++) {
        float a = 1;
        float b = 1;
        grid[i][j] = new PVector(a, b);
        prev[i][j] = new PVector(a, b);
      }
    }
  }
}

float dA = 1.0;
float dB = 0.5;
float feed = 0.055;
float k = 0.062;


void update() {
  for (int i = 1; i < width-1; i++) {
    for (int j = 1; j < height-1; j ++) {

      PVector spot = prev[i][j];
      PVector newspot = grid[i][j];

      float a = spot.x;
      float b = spot.y;

      float laplaceA = 0;
      laplaceA += a*-1;
      laplaceA += prev[i+1][j].x*0.2;
      laplaceA += prev[i-1][j].x*0.2;
      laplaceA += prev[i][j+1].x*0.2;
      laplaceA += prev[i][j-1].x*0.2;
      laplaceA += prev[i-1][j-1].x*0.05;
      laplaceA += prev[i+1][j-1].x*0.05;
      laplaceA += prev[i-1][j+1].x*0.05;
      laplaceA += prev[i+1][j+1].x*0.05;

      float laplaceB = 0;
      laplaceB += b*-1;
      laplaceB += prev[i+1][j].y*0.2;
      laplaceB += prev[i-1][j].y*0.2;
      laplaceB += prev[i][j+1].y*0.2;
      laplaceB += prev[i][j-1].y*0.2;
      laplaceB += prev[i-1][j-1].y*0.05;
      laplaceB += prev[i+1][j-1].y*0.05;
      laplaceB += prev[i-1][j+1].y*0.05;
      laplaceB += prev[i+1][j+1].y*0.05;

      newspot.x = a + (dA*laplaceA - a*b*b + feed*(1-a))*1;
      newspot.y = b + (dB*laplaceB + a*b*b - (k+feed)*b)*1;

      newspot.x = constrain(newspot.x, 0, 1);
      newspot.y = constrain(newspot.y, 0, 1);
    }
  }
}

void swap() {
  PVector[][] temp = prev;
  prev = grid;
  grid = temp;
}

void draw() {

  for (int i = 0; i < 10; i++) {
    update();
    swap();
  }

  loadPixels();
  for (int i = 1; i < width-1; i++) {
    for (int j = 1; j < height-1; j ++) {
      PVector spot = grid[i][j];
      float a = spot.x;
      float b = spot.y;
      int pos = i + j * width;
      pixels[pos] = color((a-b)*255);
    }
  }
  updatePixels();
}