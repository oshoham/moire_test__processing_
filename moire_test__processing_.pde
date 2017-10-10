// reference: https://wewanttolearn.files.wordpress.com/2015/10/brief-01_moire-system-analysis_linear-animation-page-001.jpg

// PDF Output
import processing.pdf.*;

// Overlay params
PGraphics underlay;

ArrayList<PVector> frameList = new ArrayList<PVector>();
 
void setup() {
  // Change this if you want to preview
  size(1000, 1000);
  //size(600, 600, PDF, "moire.pdf");

  noSmooth();
  
  // set up the frame
  underlay = createGraphics(width, height);
  underlay.beginDraw();
  setupFrame();
  
  PGraphics frames = createGraphics(width, height);
  
  for (int f = 0; f < frameList.size(); f++) {
    // Draw the frame
    drawFrame(frames, frameList.get(f));

    // Update underlay with new frame
    appendToUnderlay(underlay, frames, f, FRAMES, SLIT_SIZE); 
  }
  
  underlay.endDraw();
}

void draw() {
  background(255);
  image(underlay, 0, 0);
  
  PImage overlay = generateOverlay(width, height, FRAMES, SLIT_SIZE);
  
  if(IS_EXPORT){
    noLoop(); // Only draw once
    PGraphicsPDF pdf = (PGraphicsPDF) g;  // Get the renderer
    pdf.nextPage();
    image(overlay, 0, 0);
    exit(); // exit the program
  } else {
    image(overlay, 0, 0);
  }
}


/*
  DRAW YOUR FRAME HERE
*/

// Sketch Configuration
boolean IS_EXPORT = false; // Preview or export to PDF?
int FRAMES = 100;           // The number of frames in the sequence
int SLIT_SIZE = 1;         // Slit size, must be an int >= 1


// Example draw params
int circleSize = 50;
//int circleSpacing = 25;

// Generate the animation sequence
void setupFrame() {
  //for (int i = 0; i <= width; i += circleSpacing) {
  //  frameList.add(new PVector(
  //    width / 2 + width / 4 * cos(map(i, 0, width, 0, TWO_PI)),
  //    height / 2 + width / 4 * sin(map(i, 0, width, 0, TWO_PI))
  //  ));
  //}
  
  int circleSpacing = width / (FRAMES - 1);
  
  for (int i = 0; i < FRAMES; i++) {
    frameList.add(new PVector(
      width / 2 + width / 4 * cos(map(i * circleSpacing, 0, width, 0, TWO_PI)),
      height / 2 + width / 4 * sin(map(i * circleSpacing, 0, width, 0, TWO_PI))
    ));
  }
}

// Draw each frame
void drawFrame(PGraphics underlay, PVector p) {
  underlay.beginDraw();
  underlay.clear();
  underlay.noStroke();
  underlay.fill(0);
  underlay.ellipse(p.x, p.y, circleSize, circleSize);
  underlay.endDraw();
}