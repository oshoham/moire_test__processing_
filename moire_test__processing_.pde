// reference: https://wewanttolearn.files.wordpress.com/2015/10/brief-01_moire-system-analysis_linear-animation-page-001.jpg

// PDF Output
import processing.pdf.*;

// Overlay params
PGraphics underlay;
int patternSize;

ArrayList<PVector> frameList = new ArrayList<PVector>();
 
void setup() {
  // Change this if you want to preview
  size(1000, 1000);
  //size(600, 600, PDF, "moire.pdf");

  patternSize = SLIT_SIZE * FRAMES * FRAMES;
  
  noSmooth();
  
  // set up the frame
  underlay = createGraphics(patternSize, patternSize);
  underlay.beginDraw();
  setupFrame(patternSize, patternSize);
  
  PGraphics frames = createGraphics(patternSize, patternSize);
  
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
  image(underlay, 0, 0, width, height);
  
  PImage overlay = generateOverlay(patternSize, patternSize, FRAMES, SLIT_SIZE);
  
  if(IS_EXPORT){
    noLoop(); // Only draw once
    PGraphicsPDF pdf = (PGraphicsPDF) g;  // Get the renderer
    pdf.nextPage();
    image(overlay, 0, 0, width, height);
    exit(); // exit the program
  } else {
    image(overlay, 0, 0, width, height);
  }
}


/*
  DRAW YOUR FRAME HERE
*/

// Sketch Configuration
boolean IS_EXPORT = false; // Preview or export to PDF?
int FRAMES = 20;           // The number of frames in the sequence
int SLIT_SIZE = 1;         // Slit size, must be an int >= 1

// Example draw params
int circleSize = 100;
//int circleSpacing = 25;

// Generate the animation sequence
void setupFrame(int w, int h) {
  int circleSpacing = w / (FRAMES - 1);
  
  for (int i = 0; i < FRAMES; i++) {
    frameList.add(new PVector(
      w / 2 + w / 4 * cos(map(i * circleSpacing, 0, w, 0, TWO_PI)),
      h / 2 + w / 4 * sin(map(i * circleSpacing, 0, w, 0, TWO_PI))
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