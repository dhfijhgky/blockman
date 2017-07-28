class enemy {

  float square = (height * .1);
  float square2 = square * 1;
  float gravity;
  float gravMod = 1.2;
  float speed;
  float accel = .5;
  float momentum;
  boolean onGround;
  boolean onSide;
  int jump = 30;
  int respawnDirection;

  float x;
  float y;
  float xBase = random(-height, height);
  float yBase = random(0, height);

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

    fill(75);
    beginShape();
    vertex(x, y + (square * .25));
    vertex(x + (square2 * .15), y + (square * .25));
    vertex(x + (square2 * .15), y);
    vertex(x + (square2 * .85), y);
    vertex(x + (square2 * .85), y + (square * .25));
    vertex(x + square2, y + (square * .25));
    vertex(x + square2, y + (square * .7));
    vertex(x + (square2 * .925), y + (square * .7));
    vertex(x + (square2 * .925), y + (square * (1 - mod)));
    vertex(x + (square2 * .65), y + (square * (1 - mod)));
    vertex(x + (square2 * .65), y + (square * .9));
    vertex(x + (square2 * .35), y + (square * .9));
    vertex(x + (square2 * .35), y + (square * (1 - mod)));
    vertex(x + (square2 * .075), y + (square * (1 - mod)));
    vertex(x + (square2 * .075), y + (square * .7));
    vertex(x, y + (square * .7));
    endShape(CLOSE);
    noFill();

    fill(255, 0, 0);
    beginShape();
    vertex(x + (square2 * .4), y + (square * (.2 - mod + mod2)));
    vertex(x + (square2 * .4), y + (square * (.3 - mod + mod2)));
    vertex(x + (square2 * .3), y + (square * (.3 - mod + mod2)));
    vertex(x + (square2 * .3), y + (square * (.2 - mod + mod2)));
    endShape(CLOSE);
    beginShape();
    vertex(x + (square2 * .6), y + (square * (.2 - mod + mod2)));
    vertex(x + (square2 * .6), y + (square * (.3 - mod + mod2)));
    vertex(x + (square2 * .7), y + (square * (.3 - mod + mod2)));
    vertex(x + (square2 * .7), y + (square * (.2 - mod + mod2)));
    endShape(CLOSE);
    noFill();
  }

  void gravity() {
    if (onGround == false) {
      gravity += gravMod;
      gravity = constrain(gravity, -20, 13);
    }
  }

  void move() {

    speed = constrain(speed, -10, 10);
    xBase += speed;
    xBase = constrain(xBase, -width, width * 2);
    yBase += gravity;

    x = xBase - Char.xRange;
    y = yBase - Char.yRange;

    if (y > height - Char.yRange + height * .5) {
      death();
    }
  }

  void death() {
    gravity = 0;
    yBase = 0 - square;
    xBase += random(-height, height);
  }

  void moveLeft() {
    if (onSide == false && speed > -5.5) {
      if (onGround == true) {
        speed -= accel;
      }
      else {
        speed -= accel * .7;
      }
    }
  }

  void moveRight() {
    if (onSide == false && speed < 5.5) {
      if (onGround == true) {
        speed += accel;
      }
      else {
        speed += accel * .7;
      }
    }
  }

  void moveUp() {
    if (onGround == true) {
      gravity -= jump;
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
  }

  void collision() {

    onGround = false;
    onSide = false;

    for (int i = 0; i < plat.length; i++) {
      for (int g = 0; g < plat[i].length; g++) {
        if (x + square > plat[i][g].x && x < plat[i][g].x + plat[i][g].square && plat[i][g].fillAlpha > 0) {
          if (y <= plat[i][g].y + (plat[i][g].square2) && y > plat[i][g].y && gravity <= 0) {
            y = plat[i][g].y + (plat[i][g].square2);
            gravity = 0;
          }
          if (y + square2 >= plat[i][g].y && y + square2 < plat[i][g].y + (plat[i][g].square2) && gravity >= 0) {
            y = plat[i][g].y - square2;
            gravity = 0;
            onGround = true;
          }
          if (y + square2 > plat[i][g].y && y < plat[i][g].y + (plat[i][g].square2 * .5) && plat[i][g].fillAlpha > 0) {
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

    for (int e = 0; e < Enemy.length; e++) {
      if (x + square > Enemy[e].x && x < Enemy[e].x + Enemy[e].square) {
        if (y < Enemy[e].y + Enemy[e].square2 && y > Enemy[e].y) {
          Enemy[e].gravity -= 20;
          if (onGround == false) {
            gravity += 10;
            jumpCheck = 0;
          }
        }
        if (y + square2 > Enemy[e].y && y + square2 < Enemy[e].y + Enemy[e].square2) {
          if (Enemy[e].onGround == false) {
            Enemy[e].gravity += 10;
          }
          gravity -= 20;
        }
      }
      if (y + square2 > Enemy[e].y && y < Enemy[e].y + Enemy[e].square2) {
        if (x < Enemy[e].x + Enemy[e].square && x > Enemy[e].x) {
          Enemy[e].speed -= 5;
          speed += 5;
        }
        if (x + square > Enemy[e].x && x + square < Enemy[e].x + Enemy[e].square) {
          Enemy[e].speed += 5;
          speed -= 5;
        }
      }
    }

    if (Char.deadState == false) {
      if (x + square > Char.x && x < Char.x + Char.square) {
        if (y < Char.y + Char.square2 && y > Char.y) {
          Char.gravity -= 15;
          if (onGround == false) {
            gravity += 10;
            jumpCheck = 0;
          }
        }
        if (y + square2 > Char.y && y + square2 < Char.y + Char.square2) {
          if (Char.onGround == false) {
            Char.gravity += 3;
          }
          gravity -= 20;
        }
      }
      if (y + square2 > Char.y && y < Char.y + Char.square2) {
        if (x < Char.x + Char.square && x > Char.x) {
          Char.speed -= 15;
          speed += 10;
        }
        if (x + square > Char.x && x + square < Char.x + Char.square) {
          Char.speed += 15;
          speed -= 10;
        }
      }
    }
  }
}

