character Char;
star moon;
enemy[] Enemy = new enemy[2];
starE[] starsE = new starE[6];
star[][] stars = new star[20][8];
platform[][] plat = new platform[9][6];
backdrop[][] bg = new backdrop[20][3];

PFont font;

boolean[] downKeys = new boolean[256];
boolean gameOver = false;
boolean gameStart = true;

int lives;
int livesDefault = 5;
int restartCheck;
int endDelay;
int next;
int initialCheck = 1;
int score;
int scoreCheck;
int direction = 1;
int jumpDelay;
int jumpCheck;
int jumpSticky = 0;

void setup() {
  size(1024, 768);
  noStroke();
  strokeWeight(5);
  textAlign(CENTER);
  noCursor();

  font = loadFont("8BITWONDERNominal-48.vlw");

  Char = new character();

  for (int e = 0; e < Enemy.length; e++) {
    Enemy[e] = new enemy();
  }

  for (int s = 0; s < starsE.length; s++) {
    starsE[s] = new starE();
  }

  for (int i = 0; i < plat.length; i++) {
    for (int g = 0; g < plat[i].length; g++) {
      direction *= -1;
      plat[i][g] = new platform((-height * 1.5) + (height * .5 * i), (height * .22 * (g + 1)) + (height * .25) + (random(-30, 30)), direction, 3.3 - (.5 * g));
    }
  }

  for (int i = 0; i < bg.length; i++) {
    float mod = 1;
    for (int g = 0; g < bg[i].length; g++) {
      float square = ((height * 5) / mod) / bg.length;
      bg[i][g] = new backdrop(((height * .5)) - ((height * 2.5) / mod) + (i * square), (height) - ((height * .2) * g) + 10 * (g + int(random(-5, 15))), 30 + random(-5, 5), 70 + random(-5, 5), 50 * (g + 1) + random(-5, 5), mod, square + 1); //10 * (g + int(random(0, 20))), 10 * (g + int(random(0, 20))), 10 * (g + int(random(0, 20)))
      mod += .5;
    }
  }

  for (int i = 0; i < stars.length; i++) {
    for (int g = 0; g < stars[i].length; g++) {
      float mod = 10;
      float square = height * .01;
      stars[i][g] = new star(Char.xRange + ((height * 2) / stars.length) * i + random(-30, 30), Char.yRange + ((height) / stars[i].length) * g + random(-30, 30), mod, square, 150);
    }
  }

  moon = new star(height * .9, height * .2, 9, height * .08, 255);
}

void draw() {
  background(30);

  for (int i = 0; i < stars.length; i++) {
    for (int g = 0; g < stars[i].length; g++) {
      stars[i][g].display();
    }
  }

  moon.display();

  for (int i = 0; i < bg.length; i++) {
    bg[i][2].display();
  }
  for (int i = 0; i < bg.length; i++) {
    bg[i][1].display();
  }
  for (int i = 0; i < bg.length; i++) {
    bg[i][0].display();
  }

  respawnUI();
  if (gameStart == false) {
    if (gameOver == false) {
      charParent();

      score = int((millis() - scoreCheck) * .01);
    }
  }
  enemyParent();

  for (int i = 0; i < plat.length; i++) {
    for (int g = 0; g < plat[i].length - 1; g++) {
      if (plat[i][g].fillAlpha > 0) {
        plat[i][g].display();
      }
      plat[i][g].move();
      plat[i][g].vanish();
    }
  }

  ui();
  endCheck();
}

void endCheck() {
  if (lives == 0) {
    fill(0, 170);
    rect(0, 0, width, height);
    noFill();

    if (gameStart == true) {
      pushMatrix();
      translate(2, 2);
      fill(0);
      textFont(font, 20);
      text("press any key to start", width * .5, height * .55);
      noFill();
      popMatrix();

      fill(255);
      textFont(font, 20);
      text("press any key to start", width * .5, height * .55);
      noFill();
      
      pushMatrix();
      translate(4, 4);
      fill(0);
      textFont(font, 50);
      text("blockman", width * .5, height * .45);
      noFill();
      popMatrix();
      
      fill(255);
      textFont(font, 50);
      text("blockman", width * .5, height * .45);
      noFill();
    } 
    else { 
      gameOver = true;

      if (endDelay == 0) {
        endDelay++;
        next = millis() + 1000;
      }
      pushMatrix();
      translate(3, 3);
      fill(0);
      textFont(font, 40);
      text("GAME OVER", width * .5, height * .54);
      noFill();
      popMatrix();

      fill(255);
      textFont(font, 40);
      text("GAME OVER", width * .5, height * .54);
      noFill();

      pushMatrix();
      translate(2, 2);
      fill(0);
      textFont(font, 30);
      text("Score   " + score, width * .5, height * .585);
      noFill();
      popMatrix();

      textFont(font, 30);
      fill(255);
      text("Score   " + score, width * .5, height * .585);
      noFill();

      if (millis() > next) {
        pushMatrix();
        translate(2, 2);
        fill(0);
        textFont(font, 20);
        text("press any key to continue", width * .5, height * .62);
        noFill();
        popMatrix();

        fill(255);
        textFont(font, 20);
        text("press any key to continue", width * .5, height * .62);
        noFill();
        restartCheck = 1;
      }
    }
  }
  else if (lives > 0) {
    gameOver = false;
  }
}

void ui() {

  if (gameOver == false && gameStart == false) {
    textFont(font, 17);
    textAlign(RIGHT);
    fill(0);
    text(score, Char.right - height * .015 + 2, height * .035 + 2);
    fill(255);
    text(score, Char.right - height * .015, height * .035);
    noFill();
  }

  if (Char.deadState == true && gameOver == false && gameStart == false) {
    fill(30);
    stroke(255);
    beginShape();
    vertex(Char.x, Char.y + (Char.square2 * .25) - Char.yRange);
    vertex(Char.x + (Char.square2 * .15), Char.y + (Char.square2 * .25) - Char.yRange);
    vertex(Char.x + (Char.square2 * .15), Char.y - Char.yRange);
    vertex(Char.x + (Char.square2 * .85), Char.y - Char.yRange);
    vertex(Char.x + (Char.square2 * .85), Char.y + (Char.square2 * .25) - Char.yRange);
    vertex(Char.x + Char.square2, Char.y + (Char.square2 * .25) - Char.yRange);
    vertex(Char.x + Char.square2, Char.y + (Char.square2 * .7) - Char.yRange);
    vertex(Char.x + (Char.square2 * .925), Char.y + (Char.square2 * .7) - Char.yRange);
    vertex(Char.x + (Char.square2 * .925), Char.y + (Char.square2) - Char.yRange);
    vertex(Char.x + (Char.square2 * .65), Char.y + (Char.square2) - Char.yRange);
    vertex(Char.x + (Char.square2 * .65), Char.y + (Char.square2 * .9) - Char.yRange);
    vertex(Char.x + (Char.square2 * .35), Char.y + (Char.square2 * .9) - Char.yRange);
    vertex(Char.x + (Char.square2 * .35), Char.y + (Char.square2) - Char.yRange);
    vertex(Char.x + (Char.square2 * .075), Char.y + (Char.square2) - Char.yRange);
    vertex(Char.x + (Char.square2 * .075), Char.y + (Char.square2 * .7) - Char.yRange);
    vertex(Char.x, Char.y + (Char.square2 * .7) - Char.yRange);
    endShape(CLOSE);
    noStroke();

    textAlign(CENTER);
    textFont(font, 30);
    fill(0);
    text((int((Char.deadTimer - millis()) * .001) + 1), width * .5 + 4, -Char.yRange + Char.y + Char.square2 * .625 + 2);
    fill (255, 80, 80);
    text((int((Char.deadTimer - millis()) * .001) + 1), width * .5 + 2, -Char.yRange + Char.y + Char.square2 * .625);
  }
  textAlign(CENTER);
  noFill();
}

void respawnUI() {
  for (int i = 0; i < lives; i++) {
    pushMatrix();
    translate(2, 2);
    fill(0);
    arc(Char.right - height * .03 - 30 * i, height * .06, height * .0295, height * .0295, 0, PI);
    ellipse((Char.right - height * .03 - 30 * i) - (height * .0075), height * .06, height * .02, height * .02);
    ellipse((Char.right - height * .03 - 30 * i) + (height * .0075), height * .06, height * .02, height * .02);
    beginShape();
    vertex((Char.right - height * .03 - 30 * i) - (height * .0175), height * .06);
    vertex((Char.right - height * .03 - 30 * i) + (height * .0175), height * .06);
    vertex((Char.right - height * .03 - 30 * i), height * .08);
    endShape(CLOSE);
    popMatrix();
    fill(255, 80, 80);
    arc(Char.right - height * .03 - 30 * i, height * .06, height * .0295, height * .0295, 0, PI);
    ellipse((Char.right - height * .03 - 30 * i) - (height * .0075), height * .06, height * .02, height * .02);
    ellipse((Char.right - height * .03 - 30 * i) + (height * .0075), height * .06, height * .02, height * .02);
    beginShape();
    vertex((Char.right - height * .03 - 30 * i) - (height * .0175), height * .06);
    vertex((Char.right - height * .03 - 30 * i) + (height * .0175), height * .06);
    vertex((Char.right - height * .03 - 30 * i), height * .08);
    endShape(CLOSE);
    noFill();
  }
}

void charParent() {
  if (Char.deadState == false) {
    for (int i = 0; i < downKeys.length; i++) {
      if (downKeys[i]) {
        if (Char.deadState == false) {
          if (((char)i == 'i' || (char)i == 'w') && jumpSticky != 0) {
            Char.moveUp();
          }
          if ((char)i == 'j' || (char)i == 'a') {
            Char.moveLeft();
          }
          if ((char)i == 'l' || (char)i == 'd') {
            Char.moveRight();
          }
          if ((char)i == 'k' || (char)i == 's') {
            //Char.xRange = random(-height, height);
          }
        }
      }
    }
    Char.gravity();
    Char.decel();
    Char.move();
    Char.collision();
    Char.boundaries();
    Char.display();
  }

  for (int e = 0; e < Enemy.length; e++) {
    Enemy[e].gravity();
    Enemy[e].move();
    Enemy[e].collision();
    Enemy[e].display();
  }
  for (int s = 0; s < starsE.length; s++) {
    starsE[s].move();
    starsE[s].collision();
    starsE[s].display();
  }
  Char.scroll();

  Char.respawn();
}

void enemyParent() {
  for (int e = 0; e < Enemy.length; e++) {
    if (Char.x < Enemy[e].x) {
      if (Char.deadState == false) {
        Enemy[e].moveLeft();
      }
    }
    if (Char.x > Enemy[e].x) {
      if (Char.deadState == false) {
        Enemy[e].moveRight();
      }
    }
    if (Char.deadState == true) {
      if (Enemy[e].respawnDirection == 0) {
        Enemy[e].moveLeft();
      }
      else {
        Enemy[e].moveRight();
      }
    }
    if (Char.y + Char.square2 * .5 < Enemy[e].y && Char.deadState == false) {
      if (jumpCheck == 0 && Enemy[e].onGround == true) {
        jumpDelay = millis() + 100;
        jumpCheck = 1;
      }
    }
    if (Enemy[e].onGround == true && millis() >= jumpDelay && jumpCheck == 1) {
      for (int i = 0; i < plat.length; i++) {
        for (int g = 0; g < plat[i].length; g++) {
          if (Enemy[e].y + Enemy[e].square == plat[i][g].y) {
            if ((Enemy[e].x < plat[i][g].x && Enemy[e].x + Enemy[e].square > plat[i][g].x && Enemy[e].speed < 0) || (Enemy[e].x < plat[i][g].x + plat[i][g].square && Enemy[e].x + Enemy[e].square > plat[i][g].x + plat[i][g].square && Enemy[e].speed > 0)) {
              if (Char.y - Char.square2 < Enemy[e].y) {
                Enemy[e].moveUp();
              }
              jumpCheck = 0;
            }
          }
        }
      }
    }
  }
}


void keyPressed() {
  if (key < 256) {
    downKeys[key] = true;
    if (gameOver == true && restartCheck == 1) {
      lives = livesDefault + 1;
      restartCheck = 0;
      endDelay = 0;
      scoreCheck = millis();
      Char.x = Char.left + (height * .5) - Char.square2;
      Char.xRange = 0;
      Char.death();
      jumpSticky = 1;
      for (int e = 0; e < Enemy.length; e++) {
        Enemy[e].death();
      }
      for (int s = 0; s < starsE.length; s++) {
        starsE[s].death();
      }
    }
    if (gameStart == true) {
      lives = livesDefault + 1;
      gameStart = false;
      scoreCheck = millis();
      Char.death();
      jumpSticky = 1;
      for (int s = 0; s < starsE.length; s++) {
        starsE[s].death();
      }
    }
  }
}

void keyReleased() {
  if (key < 256) {
    downKeys[key] = false;
    if ((char)key == 'i') {
      jumpSticky = 1;
    }
    if ((char)key == 'w') {
      jumpSticky = 1;
    }
  }
}

