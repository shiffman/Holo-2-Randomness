// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Demonstration of Craig Reynolds' "Flocking" behavior
// See: http://www.red3d.com/cwr/
// Rules: Cohesion, Separation, Alignment

// Click mouse to add boids into the system

Flock flock;
int burst = 200;

void setup() {
  size(1200, 800, P2D_2X);
  flock = new Flock();
  // Add an initial set of boids into the system
  burst();
}

void burst() {
  PVector v = PVector.random2D();
  for (int i = 0; i < burst; i++) {
  PVector pos = new PVector(random(width), random(height));
    Boid b = new Boid(pos.x+random(-1, 1), pos.y+random(-1, 1), v);
    flock.addBoid(b);
  }
}

void draw() {
  background(255);
  flock.run();
  if (frameCount % 45 == 0) {
    burst(); 
  }

}

// Add a new boid into the System
void mouseDragged() {
  flock.addBoid(new Boid(mouseX, mouseY));
}