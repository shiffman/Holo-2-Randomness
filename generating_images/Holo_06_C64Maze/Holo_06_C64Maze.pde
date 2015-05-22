import processing.pdf.*;

void setup() {
  size(2598/4, 3425/4);

  beginRecord(PDF, "Holo_maze.pdf");
  background(255);
  int r = 5;
  for (int y = 0; y < height; y += r) {
    for (int x = 0; x < width; x += r) {
      if (random(1) > 0.5) {
        line(x, y, x+r, y+r);
      } else {
        line(x, y+r, x+r, y);
      }
    }
  }
  endRecord();

}