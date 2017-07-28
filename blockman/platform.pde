class platform {

  float left = (width * .5) - (height * .5);
  float right = (width * .5) + (height * .5);

  float x;
  float y;
  float yBase;
  float xThresh;
  float yThresh;
  float speed;
  float square = height * .25;
  float square2 = square * .1;
  float fillAlpha = 255;
  int direction;
  int vanishDelay;
  int platVanish;
  boolean vanish = false;

  platform(float xT, float yT, int directionT, float speedT) {
    y = yT;
    yBase = yT;
    xThresh = xT;
    yThresh = yT;
    direction = directionT;
    speed = speedT;
  }

  void display() {
    fill(100, fillAlpha);
    x = xThresh - Char.xRange;
    y = yThresh - Char.yRange;
    rect(x, y, square, square2);
    noFill();
  }

  void move() {
    if (direction == 1) {
      xThresh += speed;
    }
    else {
      xThresh -= speed;
    }

    if (direction == -1) {
      if (xThresh + square < left - (height * 1.5)) {
        xThresh = right + (height * 1.5) + square;
        y = yBase + random(-30, 30);
      }
    }
    else if (direction == 1) {
      if (xThresh > right + (height * 1.5)) {
        xThresh = left - (height * 1.5) - (square * 2);
        y = yBase + random(-30, 30);
      }
    }
  }

  void vanish() {
    if (vanish == true && fillAlpha > 0) {
      if (Char.gravity != 0) {
        fillAlpha -= 20;
      }
      else {
        fillAlpha -= 3;
      }
      if (fillAlpha <= 0) {
        vanishDelay = millis() + 4000;
        vanish = false;
      }
    }
    if (millis() >= vanishDelay && vanish == false) {
      for (int e = 0; e < Enemy.length; e++) {
        if ((x > Char.x + Char.square || x + square < Char.x) && (x > Enemy[e].x + Enemy[e].square || x + square < Enemy[e].x) && fillAlpha <= 0) {
          fillAlpha = 20;
        }
        if (fillAlpha > 0) {
          fillAlpha += 20;
        }
      }
    }
    fillAlpha = constrain(fillAlpha, 0, 255);
  }
}

