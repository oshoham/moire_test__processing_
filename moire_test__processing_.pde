// reference: https://wewanttolearn.files.wordpress.com/2015/10/brief-01_moire-system-analysis_linear-animation-page-001.jpg

// PDF Output
import processing.pdf.*;

boolean isExport = true;

// Overlay params
ArrayList<PVector> frames = new ArrayList<PVector>();
int numOverlayLines = 100;
float overlayLineWidth, overlayLineSpacing;
PImage underlay;

// Example draw params
int circleSize = 50;
int circleSpacing = 5;
 
void setup() {
  //size(600, 600);
  size(600, 600, PDF, "moire.pdf");

  for (int i = 0; i < width; i += circleSpacing) {
    frames.add(new PVector(
      width / 2 + width / 4 * cos(map(i, 0, width, 0, TWO_PI)),
      height / 2 + width / 4 * sin(map(i, 0, width, 0, TWO_PI))
    ));
  }
  
  overlayLineWidth = width / numOverlayLines;
  overlayLineSpacing = overlayLineWidth / max(frames.size() - 1, 1);
  
  PGraphics framesBuffer = createGraphics(width, height);
  PGraphics maskBuffer = createGraphics(width, height);
  PGraphics underlayBuffer = createGraphics(width, height);
   
  underlayBuffer.beginDraw();
  for (int j = 0; j < frames.size(); j++) {
    drawCircle(framesBuffer, frames.get(j));
    drawOverlayMask(maskBuffer, j * overlayLineSpacing);

    PImage maskedFrame = framesBuffer.get();
    PImage mask = maskBuffer.get();

    alternateMask(maskedFrame, mask);

    underlayBuffer.image(maskedFrame, 0, 0); 
  }
  underlayBuffer.endDraw();
  underlay = underlayBuffer.get();
}

void draw() {
  background(255);
  image(underlay, 0, 0);
  
  if(isExport){
    PGraphicsPDF pdf = (PGraphicsPDF) g;  // Get the renderer
    pdf.nextPage();
    drawOverlay();
    exit();
  } else {
    drawOverlay();
  }
}

void drawCircle(PGraphics graphics, PVector p) {
  graphics.beginDraw();
  graphics.clear();
  graphics.noStroke();
  graphics.fill(0);
  graphics.ellipse(p.x, p.y, circleSize, circleSize);
  graphics.endDraw();
}

void drawOverlayMask(PGraphics graphics, float offset) {
  graphics.beginDraw();
  graphics.background(0);
  graphics.stroke(255);
  graphics.strokeWeight(overlayLineSpacing);
  for (float i = offset; i < width; i += overlayLineWidth + overlayLineSpacing) {
    graphics.line(i + overlayLineWidth, 0, i + overlayLineWidth, height);
  }
  graphics.endDraw();
}

void drawOverlay() {
  noStroke();
  fill(0);
  for (int i = -numOverlayLines; i < numOverlayLines; i++) {
    float x = i * (overlayLineWidth + overlayLineSpacing);
    rect(mouseX + x, 0, overlayLineWidth, height);
  }
}

void alternateMask(PImage target, PImage mask) {
  target.loadPixels();
  mask.loadPixels();
  for (int i = 0; i < mask.pixels.length; i++) {
    float originalAlpha = alpha(target.pixels[i]);
    if (originalAlpha != 0) {
      float maskAlpha = brightness(mask.pixels[i]);
      float r = red(target.pixels[i]);
      float g = green(target.pixels[i]);
      float b = blue(target.pixels[i]);
      target.pixels[i] = color(r, g, b, maskAlpha);
    }
  }
  target.updatePixels();
}