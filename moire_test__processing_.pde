// reference: https://wewanttolearn.files.wordpress.com/2015/10/brief-01_moire-system-analysis_linear-animation-page-001.jpg

// PRINT AT 65%!!!!!
// are you sure it wasn't 60.5%?


// Overlay params
PGraphics underlay;
 
boolean IS_EXPORT = true; // Preview or export to PDF?
void setup() {
  // Change this if you want to preview
  size(500, 500);
  
  noSmooth();
  
  // set up the frame
  underlay = createGraphics(width, height);
  underlay.beginDraw();
  
  PGraphics frameGraphic = createGraphics(width, height);
  
  for (int f = 0; f < FRAMES; f++) {
    // Draw the frame
    drawFrame(frameGraphic, f, width, height);

    // Update underlay with new frame
    appendToUnderlay(underlay, frameGraphic, f, FRAMES, SLIT_SIZE); 
  }
  
  underlay.endDraw();
}

void draw() {
  background(255);
  image(underlay, 0, 0, width, height);
  
  PImage overlay = generateOverlay(width, height, FRAMES, SLIT_SIZE);
  
  if(IS_EXPORT){
    noLoop(); // Only draw once
    saveFrame("moire_underlay.png");
    background(255); // clear canvas
    image(overlay, 0, 0, width, height);
    saveFrame("moire_overlay.png");
    exit(); // exit the program
  } else {
    image(overlay, 0, 0, width, height);
  }
}


/*
  DRAW YOUR FRAME HERE
*/

// Sketch Configuration
int FRAMES = 6;           // The number of frames in the sequence
int SLIT_SIZE = 1;         // Slit size, must be an int >= 1

// Draw each frame
void drawFrame(PGraphics underlay, int frameIndex, int w, int h) {
  underlay.beginDraw();
  underlay.clear();
  
  /* Draw moving, rotating rectangles */
  //underlay.stroke(0);
  //underlay.strokeWeight(20);
  //underlay.noFill();
  
  //underlay.rectMode(CENTER);
  
  //int squareSize = 100;
 
  //for(int x = 0; x < underlay.width; x+= squareSize * 1.5) {
  //  float _squareSize = map(x, 0, underlay.width, squareSize / 3, squareSize);
  //  underlay.strokeWeight(map(x, 0, underlay.width, 10, 20));
  //  for(int y = 0; y < underlay.height; y+= squareSize * 1.5) {
  //    underlay.pushMatrix();
  //    underlay.translate(x + (frameIndex * squareSize / FRAMES),y);
  //    underlay.rotate((TWO_PI / FRAMES) * frameIndex);
  //    underlay.rect(0, 0, _squareSize, _squareSize);
  //    underlay.popMatrix();
  //  }
  //}
  
  /* Draw a crazy sun thing */
  //underlay.stroke(0);
  //underlay.strokeWeight(10);
  //underlay.noFill();
  //underlay.rectMode(CENTER);
  //underlay.pushMatrix();
  //underlay.translate(underlay.width / 2, underlay.height / 2);
  //underlay.rotate(map(frameIndex, 0, FRAMES, 0, TWO_PI));
  //int numRings = 5;
  //int minSize = 20;
  //int maxSize = 40;
  //for (int i = 0; i < numRings; i++) {
  //  float radius = map(i, 0, numRings, 20, width / 2);
  //  float numTriangles = map(i, 0, numRings, 3, 28);
    
  //  for (int j = 0; j < numTriangles; j++) {
  //    float ringAngle = map(j, 0, numTriangles, 0, TWO_PI);
  //    float x = radius * cos(ringAngle);
  //    float y = radius * sin(ringAngle);
  //    float size;
  //    if (frameIndex <= FRAMES / 2) {
  //      if (i % 2 == 0) {
  //        size = map(frameIndex, 0, FRAMES / 2, minSize, maxSize);
  //      } else {
  //        size = map(frameIndex, 0, FRAMES / 2, maxSize, minSize);
  //      }
  //    } else {
  //      if (i % 2 == 0) {
  //        size = map(frameIndex, FRAMES / 2, FRAMES, maxSize, minSize);
  //      } else {
  //        size = map(frameIndex, FRAMES / 2, FRAMES, minSize, maxSize);
  //      }
  //    }
      
  //    float triangleRotation;
  //    if (i % 2 == 0) {
  //      triangleRotation = ringAngle;
  //    } else {
  //      triangleRotation = -ringAngle;
  //    }
  //    underlay.triangle(
  //      x + size * cos(triangleRotation),
  //      y + size * sin(triangleRotation),
  //      x + size * cos(triangleRotation + TWO_PI / 3.0),
  //      y + size * sin(triangleRotation + TWO_PI / 3.0),
  //      x + size * cos(triangleRotation + TWO_PI / 1.5),
  //      y + size * sin(triangleRotation + TWO_PI / 1.5)
  //    );
  //  }
  //}
  //underlay.popMatrix();
  
  /* Draw a spiral */
  underlay.rectMode(CENTER);
  
  underlay.pushMatrix();
  underlay.translate(underlay.width / 2, underlay.height / 2);
  
  int numSquares = 100;
  for (int i = 0; i < numSquares; i++) {
    float r = map(i, 0, numSquares, 0, 5 * numSquares);
    float x = cos(i) * r;
    float y = sin(i) * r;
    float circleSize = map(i, 0, numSquares, 10, 50);
    
    underlay.pushMatrix();
    underlay.rotate(map(frameIndex, 0, FRAMES, 0, TWO_PI));
    underlay.translate(x, y);
    underlay.rotate(map(frameIndex, 0, FRAMES, 0, PI));
    
    if (i <= numSquares / 3) {
      underlay.noStroke();
      underlay.fill(0);
    } else {
      underlay.stroke(0);
      underlay.strokeWeight(7);
      underlay.noFill();
    }
    underlay.rect(0, 0, circleSize, circleSize);
    underlay.popMatrix();
  }
  
  underlay.popMatrix();
  
  underlay.endDraw();
}