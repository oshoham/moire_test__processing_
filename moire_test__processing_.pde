// reference: https://wewanttolearn.files.wordpress.com/2015/10/brief-01_moire-system-analysis_linear-animation-page-001.jpg

// PRINT AT 65%!!!!!


// Overlay params
PGraphics underlay;
 
boolean IS_EXPORT = true; // Preview or export to PDF?
void setup() {
  // Change this if you want to preview
  size(1000, 1000);
  
  noSmooth();
  
  // set up the frame
  underlay = createGraphics(width, height);
  underlay.beginDraw();
  setupFrame(width, height);
  
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
int FRAMES = 8;           // The number of frames in the sequence
int SLIT_SIZE = 1;         // Slit size, must be an int >= 1

  //ArrayList<PVector> frameList = new ArrayList<PVector>();
// Generate the animation sequence
void setupFrame(int w, int h) {
  // Example draw params
  //int circleSize = 150;

 //float circleSpacing = w / (FRAMES);
  
 // for (int i = 0; i < FRAMES; i++) {
 //   frameList.add(new PVector(
 //     w / 2 + w / 4 * cos(map(i * circleSpacing, 0, w, 0, TWO_PI)),
 //     h / 2 + w / 4 * sin(map(i * circleSpacing, 0, w, 0, TWO_PI))
 //   ));
 // }
 
}

// Draw each frame
void drawFrame(PGraphics underlay, int frameIndex, int w, int h) {
  underlay.beginDraw();
  underlay.clear();
  underlay.stroke(0);
  underlay.strokeWeight(20);
  underlay.noFill();
  
  underlay.rectMode(CENTER);
  
  int squareSize = 100;
  float squareCount = underlay.width / (squareSize * 1.5);
 
  for(int x = 0; x < underlay.width; x+= squareSize * 1.5) {
    float _squareSize = map(x, 0, underlay.width, squareSize / 3, squareSize);
    underlay.strokeWeight(map(x, 0, underlay.width, 10, 20));
    for(int y = 0; y < underlay.height; y+= squareSize * 1.5) {
      underlay.pushMatrix();
      underlay.translate(x + (frameIndex * squareSize / FRAMES),y);
      underlay.rotate((TWO_PI / FRAMES) * frameIndex);
      underlay.rect(0, 0, _squareSize, _squareSize);
      underlay.popMatrix();
    }
  }
  
  //underlay.ellipse(w - p.x, h - p.y, circleSize, circleSize);
  underlay.endDraw();
}