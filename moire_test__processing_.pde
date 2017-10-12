// reference: https://wewanttolearn.files.wordpress.com/2015/10/brief-01_moire-system-analysis_linear-animation-page-001.jpg

// Overlay params
PGraphics underlay;

ArrayList<PVector> frameList = new ArrayList<PVector>();
 
boolean IS_EXPORT = true; // Preview or export to PDF?
void setup() {
  // Change this if you want to preview
  size(1000, 1000);
  
  noSmooth();
  
  // set up the frame
  underlay = createGraphics(width, height);
  underlay.beginDraw();
  setupFrame(width, height);
  
  PGraphics frames = createGraphics(width, height);
  
  for (int f = 0; f < frameList.size(); f++) {
    // Draw the frame
    drawFrame(frames, frameList.get(f), width, height);

    // Update underlay with new frame
    appendToUnderlay(underlay, frames, f, FRAMES, SLIT_SIZE); 
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
int FRAMES = 10;           // The number of frames in the sequence
int SLIT_SIZE = 1;         // Slit size, must be an int >= 1

// Example draw params
int circleSize = 150;

// Generate the animation sequence
void setupFrame(int w, int h) {
 float circleSpacing = w / (FRAMES);
  
  for (int i = 0; i < FRAMES; i++) {
    frameList.add(new PVector(
      w / 2 + w / 4 * cos(map(i * circleSpacing, 0, w, 0, TWO_PI)),
      h / 2 + w / 4 * sin(map(i * circleSpacing, 0, w, 0, TWO_PI))
    ));
  }
}

// Draw each frame
void drawFrame(PGraphics underlay, PVector p, int w, int h) {
  underlay.beginDraw();
  underlay.clear();
  underlay.noStroke();
  underlay.fill(0);
  underlay.ellipse(p.x, p.y, circleSize, circleSize);
  //underlay.ellipse(w - p.x, h - p.y, circleSize, circleSize);
  underlay.endDraw();
}