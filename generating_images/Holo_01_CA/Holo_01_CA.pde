// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Wolfram Cellular Automata

// Simple demonstration of a Wolfram 1-dimensional cellular automata
// with the system scrolling by
// Also implements wrap around

CA ca;   // An object to describe a Wolfram elementary Cellular Automata

import processing.pdf.*;
int w = 2;

void setup() {
  size(2598/2, 3425/2);
  frameRate(30);
  int[] ruleset = { 0, 0, 0, 1, 1, 1, 1, 0 }; 

  ca = new CA(ruleset);                 // Initialize CA

  for (int i = 0; i < height/2; i++) {
    ca.generate();
  }

  beginRecord(PDF, "CA_holo.pdf");
  background(255);


  ca.display();          // Draw the CA
  endRecord();
  //save("CA_holo.png");
  exit();
}