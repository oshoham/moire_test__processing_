// reference: https://wewanttolearn.files.wordpress.com/2015/10/brief-01_moire-system-analysis_linear-animation-page-001.jpg

// PDF Output
import processing.pdf.*;

// Overlay params
PGraphics underlay;

/*
  Configure sketch here
*/

int numOverlayLines = 100; // number of slits
boolean isExport = false;   // Preview or export to PDF?

ArrayList<PVector> frameList = new ArrayList<PVector>();
 
void setup() {
  // Change this if you want to preview
  size(600, 600);
  //size(600, 600, PDF, "moire.pdf");

  // set up the frame
  underlay = createGraphics(width, height);
  underlay.beginDraw();
  setupFrame();
  
  PGraphics frames = createGraphics(width, height);
  
  for (int f = 0; f < frameList.size(); f++) {
    drawFrame(frames, frameList.get(f));

    // Update underlay with new frame
    appendToUnderlay(underlay, frames, f, numOverlayLines); 
  }
  
  underlay.endDraw();
}

void draw() {
  background(255);
  image(underlay, 0, 0);
  
  PImage overlay = generateOverlay(width, height, numOverlayLines);
  
  if(isExport){
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

// Example draw params
int circleSize = 50;
int circleSpacing = 5;

// Calculate number of frames
void setupFrame() {
  for (int i = 0; i < width; i += circleSpacing) {
    frameList.add(new PVector(
      width / 2 + width / 4 * cos(map(i, 0, width, 0, TWO_PI)),
      height / 2 + width / 4 * sin(map(i, 0, width, 0, TWO_PI))
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