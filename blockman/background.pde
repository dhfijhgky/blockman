class backdrop {
  
  float x;
  float y;
  float xThresh;
  float yThresh;
  float red;
  float green;
  float blue;
  float mod;
  float square;
  
  backdrop (float xT, float yT, float redT, float greenT, float blueT, float modT, float squareT) {
    xThresh = xT;
    yThresh = yT;
    y = yT;
    red = redT;
    green = greenT;
    blue = blueT;
    mod = modT;
    square = squareT;
  }
  
  void display() {
    fill(red, green, blue);
    x = xThresh - (Char.xRange / mod);
    y = yThresh - (Char.yRange / mod);
    rect(x, y, square, (height - y));
    noFill();
  }
}

class star {
  
  float x;
  float y;
  float xThresh;
  float yThresh;
  float mod;
  float square;
  float alphaMod;
  
  star (float xT, float yT, float modT, float squareT, float alphaModT) {
    xThresh = xT;
    yThresh = yT;
    y = yT;
    mod = modT;
    square = squareT;
    alphaMod = alphaModT;
  }
  
  void display() {
    fill(255, alphaMod);
    x = xThresh - (Char.xRange / mod);
    y = yThresh - (Char.yRange / mod);
    rect(x, y, square, square);
    noFill();
  }
}

