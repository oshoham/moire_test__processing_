/*
** Moire utilities 
*/

PImage generateOverlay(int w, int h, int lines) {
  float lineWidth = w / lines;
  float lineSpacing = lineWidth / max(frameList.size() - 1, 1);

  PGraphics overlay = createGraphics(w, h);
 
  overlay.beginDraw();
  overlay.noStroke();
  overlay.fill(0);
 
  for (int i = -lines; i < lines; i++) {
    float x = i * (lineWidth + lineSpacing);
    overlay.rect(mouseX - x, 0, lineWidth, h);
  }
  
  overlay.endDraw();
  
  return overlay.get();
}

PGraphics generateOverlayMask(int w, int h, float offset, float lineWidth, float lineSpacing) {
  PGraphics mask = createGraphics(w, h);
  mask.beginDraw();
  mask.background(0);
  mask.stroke(255);
  mask.strokeWeight(lineSpacing);
  
  for (float i = offset; i < w; i += lineWidth + lineSpacing) {
    mask.line(i + lineWidth, 0, i + lineWidth, h);
  }
  
  mask.endDraw();
  
  return mask;
}

void appendToUnderlay(PGraphics underlay, PGraphics frame, int frameIndex, int lines) {
  float lineWidth = underlay.width / lines;
  float lineSpacing = lineWidth / max(frameList.size() - 1, 1);
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