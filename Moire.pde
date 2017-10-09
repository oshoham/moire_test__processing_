/*
** Moire utilities 
*/

int decimalPlace = 2;

float roundToDecimalPlace(float number, int decimal) {
  return (float)(round(pow(10, decimal) * number)) / pow(10, decimal);
}

PImage generateOverlay(int w, int h, int lines, int frames) {
  float lineWidth = roundToDecimalPlace(w / lines, decimalPlace);
  float lineSpacing = roundToDecimalPlace(lineWidth / max(frames, 1), decimalPlace);
  println(frames);
  println(lines);
  println(lineSpacing);
  PGraphics overlay = createGraphics(w, h);
  overlay.noSmooth();
  overlay.beginDraw();
  overlay.noStroke();
  overlay.fill(0);
  
  float xOffset = lineWidth + lineSpacing;
  float x = -lines * xOffset;
  
  for (int i = 0; i < lines * 2; i++) {
    overlay.rect(roundToDecimalPlace(mouseX, decimalPlace) + x, 0, lineWidth, h);
    x += xOffset;
  }
  
  overlay.endDraw();

  return overlay.get();
}

PGraphics generateOverlayMask(int w, int h, float offset, float lineWidth, float lineSpacing) {
  PGraphics mask = createGraphics(w, h);
  mask.noSmooth();
  mask.beginDraw();
  mask.background(0);
  mask.noStroke();
  mask.fill(255);
  
  lineWidth = roundToDecimalPlace(lineWidth, decimalPlace);
  lineSpacing = roundToDecimalPlace(lineSpacing, decimalPlace);
  
  float xOffset = roundToDecimalPlace(lineWidth + lineSpacing, decimalPlace);
  for (float i = offset; i < w; i += xOffset) {
    mask.rect(i + lineWidth, 0, lineSpacing, h);
  }
  
  mask.endDraw();
  
  return mask;
}

void appendToUnderlay(PGraphics underlay, PGraphics frame, int frameIndex, int lines) {
  float lineWidth = roundToDecimalPlace(underlay.width / lines, decimalPlace);
  float lineSpacing = roundToDecimalPlace(lineWidth / max(frameList.size() - 1, 1), decimalPlace);
  float overlayOffset = frameIndex * lineSpacing;
  
  PImage maskedFrame = frame.get();
  PGraphics overlay = generateOverlayMask(underlay.width, underlay.height, overlayOffset, lineWidth, lineSpacing);
  PImage mask = overlay.get();
  
  alternateMask(maskedFrame, mask);
  underlay.image(maskedFrame, 0, 0); 
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