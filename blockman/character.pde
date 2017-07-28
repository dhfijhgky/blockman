class character {

  float square = (height * .1);
  float square2 = (height * .1);
  float gravity;
  float gravMod = 1.2;
  float speed;
  float speedMod;
  float speedFinal;
  float accel = 5;
  float momentum;
  float xThresh;
  float yThresh;
  float xRange;
  float yRange = 0;
  boolean onGround;
  boolean onSide;
  boolean deadState;
  int jump = 22;
  int deadTimer;

  float x; 
  float y;

  float left = (width * .5) - (width * .5);
  float right = (width * .5) + (width * .5);

  void display() {
    float mod;
    float mod2;
    if (gravity < 0) {
      mod = .07;
    }
    else {
      mod = 0;
    }
    if (gravity > 5) {
      mod2 = .07;
    }
    else {
      mod2 = 0;
    }

    fill(150);
    beginShape();
    vertex(x, y + (square2 * .25));
    vertex(x + (square * .15), y + (square2 * .25));
    vertex(x + (square * .15), y);
    vertex(x + (square * .85), y);
    vertex(x + (square * .85), y + (square2 * .25));
    vertex(x + square, y + (square2 * .25));
    vertex(x + square, y + (square2 * .7));
    vertex(x + (square * .925), y + (square2 * .7));
    vertex(x + (square * .925), y + (square2 * (1 - mod)));
    vertex(x + (square * .65), y + (square2 * (1 - mod)));
    vertex(x + (square * .65), y + (square2 * .9));
    vertex(x + (square * .35), y + (square2 * .9));
    vertex(x + (square * .35), y + (square2 * (1 - mod)));
    vertex(x + (square * .075), y + (square2 * (1 - mod)));
    vertex(x + (square * .075), y + (square2 * .7));
    vertex(x, y + (square2 * .7));
    endShape(CLOSE);
    noFill();

    fill(30);
    beginShape();
    vertex(x + (square * .4), y + (square2 * (.2 - mod + mod2)));
    vertex(x + (square * .4), y + (square2 * (.3 - mod + mod2)));
    vertex(x + (square * .3), y + (square2 * (.3 - mod + mod2)));
    vertex(x + (square * .3), y + (square2 * (.2 - mod + mod2)));
    endShape(CLOSE);
    beginShape();
    vertex(x + (square * .6), y + (square2 * (.2 - mod + mod2)));
    vertex(x + (square * .6), y + (square2 * (.3 - mod + mod2)));
    vertex(x + (square * .7), y + (square2 * (.3 - mod + mod2)));
    vertex(x + (square * .7), y + (square2 * (.2 - mod + mod2)));
    endShape(CLOSE);
    noFill();
  }

  void gravity() {
    if (onGround == false ) {
      gravity += gravMod;
      gravity = constrain(gravity, -20, 18);
    }
  }

  void boundaries() {
    float boundaryLeft = (width * .5) - (width * .5);
    float boundaryRight = (width * .5) + (width * .5) - square;
    float boundaryBottom = height;
    float boundaryTop = 0 - square2;

    if (y > boundaryBottom ) {
      death();
    }
    if (x < boundaryLeft ) {
      x = boundaryLeft;
      speed = 0;
      speedMod = 0;
    }
    if (x > boundaryRight ) {
      x = boundaryRight;
      speed = 0;
      speedMod = 0;
    }
  }

  void move() {
    speedFinal = speed + speedMod;
    x += speedFinal;
    y += gravity;
  }

  void respawn() {
    if (deadState == true) {
      x = width * .5 - square2 * .5;
      y = square2;
      if (yRange > 0) {
        yRange -= 5;
      }
    }

    if (millis() > deadTimer && deadState == true) {
      deadState = false;
      speed = 0;
      gravity = 0;
    }
  }

  void death() {
    deadState = true;
    speedMod = 0;
    speed = 0;
    gravity = 0;
    lives--;
    deadTimer = millis() + 3000;
    for (int e = 0; e < Enemy.length; e++) {
      Enemy[e].onGround = false;
      if (Enemy[e].x > width * .5) {
        Enemy[e].respawnDirection = 1;
      }
      else {
        Enemy[e].respawnDirection = 0;
      }
    }
  }

  void moveLeft() {
    if (onSide == false && speed > -10) {
      if (onGround == true) {
        speed -= accel;
      }
      else {
        speed -= accel * .7;
      }
    }
  }

  void moveRight() {
    if (onSide == false && speed < 10) {
      if (onGround == true) {
        speed += accel;
      }
      else {
        speed += accel * .7;
      }
    }
  }

  void moveUp() {
    if (onGround == true ) {
      gravity -= jump;
      jumpSticky = 0;
      onGround = false;
    }
  }

  void decel() {

    if (speed > 0) {
      if (onGround == true) {
        speed -= accel * .2;
      }
      else {
        speed -= accel * .1;
      }
    }
    else if (speed < 0) {
      if (onGround == true) {
        speed += accel * .2;
      }
      else {
        speed += accel * .1;
      }
    }

    if (gravity != 0) {
      if (speedMod < 0) {
        speedMod += accel * .01;
      }
      if (speedMod > 0) {
        speedMod -= accel * .01;
      }
    }

    speed = constrain(speed, -15, 15);
  }

  void scroll() {
    float boundaryLeft = width * .3;
    float boundaryRight = width * .7 - square2;
    float boundaryTop = height * .3;
    float boundaryBottom = height * .45;

    xThresh = 0;
    yThresh = 0;

    if (deadState == false) {
      if (xRange > -height) {
        if (x < boundaryLeft) {
          if (speedFinal < 0) {
            xThresh = speed + speedMod;
          }
        }
      }
      if (xRange < height) {
        if (x > boundaryRight) {
          if (speedFinal > 0) {
            xThresh = speed + speedMod;
          }
        }
      }
      if (yRange > 0) {
        if (y < boundaryTop) {
          if (gravity < 0) {
            yThresh = gravity;
          }
        }
      }
      if (yRange < height * .5) {
        if (y > boundaryBottom) {
          if (gravity > 0) {
            yThresh = gravity;
          }
        }
      }

      y -= yThresh;
      x -= xThresh;
      xRange += xThresh;
      yRange += yThresh;
    }
  }

  void collision() {

    onGround = false;
    onSide = false;

    for (int i = 0; i < plat.length; i++) {
      for (int g = 0; g < plat[i].length; g++) {
        if (x + square > plat[i][g].x && x < plat[i][g].x + plat[i][g].square && plat[i][g].fillAlpha > 0) {
          if (y < plat[i][g].y + (plat[i][g].square2) && y > plat[i][g].y && gravity <= 0) {
            y = plat[i][g].y + (plat[i][g].square2);
            gravity *= .3;
          }
          if (y + square2 >= plat[i][g].y && y + square2 < plat[i][g].y + (plat[i][g].square2) && gravity >= 0) {
            y = plat[i][g].y - square2;
            gravity = 0;
            onGround = true;
            speedMod = (plat[i][g].speed * 1) * plat[i][g].direction;
            if (plat[i][g].fillAlpha > 200) {
              plat[i][g].vanish = true;
            }
          }
        }
        if (y + square2 > plat[i][g].y && y < plat[i][g].y + (plat[i][g].square2) && plat[i][g].fillAlpha > 0) {
          if (x <= plat[i][g].x + plat[i][g].square && x > plat[i][g].x) {
            speed = 0;
            x = plat[i][g].x + plat[i][g].square;
            onSide = true;
          }
          if (x + square >= plat[i][g].x && x + square < plat[i][g].x + plat[i][g].square) {
            speed = 0;
            x = plat[i][g].x - square;
            onSide = true;
          }
        }
      }
    }
  }
}

