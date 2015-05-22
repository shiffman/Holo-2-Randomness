// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Flow Field Following
// Via Reynolds: http://www.red3d.com/cwr/steer/FlowFollow.html

// Using this variable to decide whether to draw all the stuff
boolean debug = false;

// Flowfield object
FlowField flowfield;
// An ArrayList of vehicles
ArrayList<Vehicle> vehicles;
import processing.pdf.*;

void setup() {
  size(2598/4, 3425/4);
  // Make a new flow field with "resolution" of 16
  flowfield = new FlowField(10);
  flowfield.update();
  vehicles = new ArrayList<Vehicle>();
  // Make a whole bunch of vehicles with random maxspeed and maxforce values
  for (int i = 0; i < 10000; i++) {
    //PVector start = new PVector(width/2,height/2);
    PVector start = new PVector(random(width), random(height));
    vehicles.add(new Vehicle(start, random(2, 6), random(0.1, 0.4)));
  }
  beginRecord(PDF,"Noise_holo.pdf");
  background(255);
  for (int i = 0; i < 500; i++) {
    flowfield.update();
    // Display the flowfield in "debug" mode
    if (debug) flowfield.display();
    // Tell all the vehicles to follow the flow field
    for (Vehicle v : vehicles) {
      v.follow(flowfield);
      v.run();
    }
    if (i % 25 == 0) {
      println(i); 
    }
  }
  endRecord();
  
  //saveFrame("Holo_noise.png");
  exit();
}