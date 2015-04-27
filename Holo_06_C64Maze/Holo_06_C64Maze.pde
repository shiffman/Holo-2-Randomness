size(1200, 800);
background(255);
int r = 10;
for (int y = 0; y < height; y += r) {
  for (int x = 0; x < width; x += r) {
    if (random(1) > 0.5) {
      line(x, y, x+r, y+r);
    } else {
      line(x, y+r, x+r, y);
    }
  }
}