/**
 * This demo shows the basic usage pattern of the Voronoi class in combination with
 * the SutherlandHodgeman polygon clipper to constrain the resulting shapes.
 *
 * Usage:
 * mouse click: add point to voronoi
 * p: toggle points
 * t: toggle triangles
 * x: clear all
 * r: add random
 * c: toggle clipping
 * h: toggle help display
 * space: save frame
 *
 * Voronoi class ported from original code by L. Paul Chew
 */

/* 
 * Copyright (c) 2010 Karsten Schmidt
 * 
 * This demo & library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * http://creativecommons.org/licenses/LGPL/2.1/
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */
import toxi.geom.*;
import toxi.geom.mesh2d.*;

import toxi.util.*;
import toxi.util.datatypes.*;
import toxi.processing.*;

FloatRange xpos, ypos;
Voronoi voronoi = new Voronoi();

import processing.pdf.*;

void newPoint(float x, float y) {
  voronoi.addPoint(new Vec2D(x, y));
}

void setup() {
  size(2598/4, 3425/4);
  // focus x positions around horizontal center (w/ 33% standard deviation)
  xpos=new BiasedFloatRange(0, width, width/2, 0.2);
  // focus y positions around bottom (w/ 50% standard deviation)
  ypos=new BiasedFloatRange(0, height, height/2, 0.2);
  // setup clipper with centered rectangle

  newPoint(0, 0);
  newPoint(width-1, 0);
  newPoint(1, height-1);
  newPoint(width-2, height-1);

  for (int i = 0; i < 2000; i++) {
    float x = random(width);
    float y = random(height);
    float prob = map(x, 0, width, 0, 1);
    if (random(1) > prob) {
      newPoint(xpos.pickRandom(), ypos.pickRandom());
    }
  }

  beginRecord(PDF, "Holo_voronoi.pdf");
  background(255);
  stroke(0);
  strokeWeight(1);
  noFill();
  for (Polygon2D poly : voronoi.getRegions()) {
    beginShape();
    for (Vec2D v : poly.vertices) {
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
  }

  endRecord();

  //fill(0, 200);
  //noStroke();
  //for (Vec2D c : voronoi.getSites()) {
  //  ellipse(c.x, c.y, 2, 2);
  //}

  //saveFrame("Holo_voronoi_2.png");
  exit();
}