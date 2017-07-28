class starE {
  float speed;
  float gravity;
  float xBase;
  float yBase;
  float square = height * .01;
  float fillAlpha = 255;
  float speedMod;
  boolean deadState;
  boolean onGround;
  boolean onSide;
  boolean starCheckUpChar;
  boolean starCheckSideChar;
  boolean starCheckUpEnemy;
  boolean starCheckSideEnemy;

  float x = width;
  float y = -height;

  void display() {
    fill (255, 240, 200, fillAlpha);
    rect(x, y, square, -square);
    noFill();
  }

  void move() {
    if (Char.deadState && y < 0) {
    }
    else {
      if (fillAlpha == 255) {
        xBase += speed;
        yBase += gravity;
      }
      else {
        xBase += speedMod;
      }
    }

    x = xBase - Char.xRange;
    y = yBase - Char.yRange;

    if (fillAlpha < 0 || yBase > height * 1.5) {
      death();
    }
    if (y <= -height * .2) {
      fillAlpha = 255;
    }
  }

  void death() {
    yBase = random(-height, -height * .2);
    xBase = random(-height, height * 2);
    square = height * .03;
    speed = random(-3, 3) + map(xBase, -height, height * 2, 3, -3);
    gravity = 12;
    speedMod = 0;
    starCheckUpChar = false;
    starCheckSideChar = false;
    starCheckUpEnemy = false;
    starCheckSideEnemy = false;
  }

  void collision() {

    onGround = false;
    onSide = false;

    for (int i = 0; i < plat.length; i++) {
      for (int g = 0; g < plat[i].length; g++) {
        if (x + square > plat[i][g].x && x < plat[i][g].x + plat[i][g].square && plat[i][g].fillAlpha > 0) {
          if (y >= plat[i][g].y && y < plat[i][g].y + (plat[i][g].square2)) {
            gravity = 0;
            onGround = true;
            fillAlpha--;
            speedMod = (plat[i][g].speed * 1) * plat[i][g].direction;
          }
        }
      }
    }
    for (int e = 0; e < Enemy.length; e++) {
      if (x + square > Enemy[e].x && x < Enemy[e].x + Enemy[e].square) {
        if (y < Enemy[e].y + Enemy[e].square2 && y > Enemy[e].y && starCheckUpEnemy == false) {
          starCheckUpEnemy = true;
          gravity = 0;
          fillAlpha--;
          if (Enemy[e].onGround == false) {
            Enemy[e].gravity += 2 + (fillAlpha * .1);
          }
          else {
            Enemy[e].gravity -= 2 + (fillAlpha * .1);
          }
        }
        if (y - square > Enemy[e].y && y - square < Enemy[e].y + Enemy[e].square2 && starCheckUpEnemy == false) {
          starCheckUpEnemy = true;
          gravity = 0;
          fillAlpha--;
          if (Enemy[e].onGround == false) {
            Enemy[e].gravity -= 2 + (fillAlpha * .1);
          }
          else {
            Enemy[e].gravity -= 2 + (fillAlpha * .1);
          }
        }
        if (y - square > Enemy[e].y && y < Enemy[e].y + Enemy[e].square2 && starCheckSideEnemy == false) {
          if (x < Enemy[e].x + Enemy[e].square && x > Enemy[e].x) {
            starCheckSideEnemy = true;
            gravity = 0;
            fillAlpha--;
            Enemy[e].speed += 2 + (fillAlpha * .1);
          }
          if (x + square > Enemy[e].x && x + square < Enemy[e].x + Enemy[e].square && starCheckSideEnemy == false) {
            starCheckSideEnemy = true;
            gravity = 0;
            fillAlpha--;
            Enemy[e].speed += 2 + (fillAlpha * .1);
          }
        }
      }
      if (x + square > Char.x && x < Char.x + Char.square) {
        if (y < Char.y + Char.square2 && y > Char.y && starCheckUpChar == false) {
          starCheckUpChar = true;
          gravity = 0;
          fillAlpha--;
          if (Char.onGround == false) {
            Char.gravity += 2 + (fillAlpha * .1);
          }
          else {
            Char.gravity -= 2 + (fillAlpha * .1);
          }
        }
        if (y - square > Char.y && y - square < Char.y + Char.square2 && starCheckUpChar == false) {
          starCheckUpChar = true;
          gravity = 0;
          fillAlpha--;
          Char.gravity -= 2 + (fillAlpha * .1);
        }
        if (y - square > Char.y && y < Char.y + Char.square2 && starCheckSideChar == false) {
          if (x < Char.x + Char.square && x > Char.x) {
            starCheckSideChar = true;
            gravity = 0;
            fillAlpha--;
            Char.speed -= 2 + (fillAlpha * .1);
          }
          if (x + square > Char.x && x + square < Char.x + Char.square && starCheckSideChar == false) {
            starCheckSideChar = true;
            gravity = 0;
            fillAlpha--;
            Char.speed += 2 + (fillAlpha * .1);
          }
        }
      }
    }

    if (fillAlpha < 255) {
      square += 3;
      xBase -= 1.5;
      fillAlpha -= 10;
      if (onGround == false) {
        yBase += 1.5;
      }
    }
  }
}

