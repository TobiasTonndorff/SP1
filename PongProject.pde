
/******** VARIABLES *************/
// 0: initial Screen
// 1: game screen
// 2: game-over Screen


int gameScreen = 0;

//gameplay settings
float gravity = 1;
float airfriction = 0.0001;
float friction = 0.1;

// Scoring
int score = 0;
int maxHealth = 100;
float health = 100;
float healthDecrease = 1;
int healthBarWidth = 60;

//ball settings
float ballX, ballY;
float ballSize = 20;
float ballColor = color(0);
float ballSpeedVert = 0;
float ballSpeedHorizon = 0;

// racket settings
color racketColor = color(0);
float racketWidth = 100;
float racketHeight = 10;
int racketBounceRate = 20;

// wall settings
int wallSpeed = 5;
int wallInterval = 1000;
float lastAddTime = 0;
int minGapHeight = 200;
int maxGapHeight = 300;
int wallWidth = 80;
color wallColors = color(0);





//float gravity = 1;
//float ballSpeedVert = 0;
//float airfriction = 0.0001;
//float friction = 0.1;


/********* SETUP BLOCK **********/
void setup() {
  size(1000,1000);
  ballX=width/4;
  ballY=height/5;
  smooth();
  wallColors = color(44, 62, 80);
}
/******** DRAW BLOCK *******/
void draw() { 
  if (gameScreen == 0) {
    initScreen();
  } else if (gameScreen == 1) {
    gameScreen();
  } else if (gameScreen == 2) {
    gameOverScreen();
  }
}

/********** SCREEN CONTENTS *******/

void initScreen() {
  // codes of initial screen
  background(236, 240, 241);
  textAlign(CENTER);
  fill(52, 73, 94);
  text("Flappy Pong", width/2, height/2);
  textSize(15);
  text("Click to start", width/2, height-30);
}










ArrayList<int[]> walls = new ArrayList<int[]>();
void gameScreen() {
  // codes of game screen
  background(236, 240, 241);
  drawRacket();
  drawBall();
  applyGravity();
  keepInScreen();
  watchRacketBounce();
  applyHorizontalSpeed();
  wallAdder();
  wallHandler();
  drawHealthBar();
  printScore();
  
}
void gameOverScreen() {
  // codes for game over screen
  background(44, 62, 80);
  textAlign(CENTER);
  fill(236, 240, 241);
  textSize(12);
  text("your Score", width/2, height/2-120);
  textSize(30);
  text("GAME OVER", height/2, width/2 - 20);
  textSize(15);
  text("CLick to restart", height/2, width/2 + 10);
 
}

/************ INPUTS ************/
public void mousePressed() {
  // if we are on the initial screen when clicked, start the game
  if(gameScreen==0) {
    startGame();
  }
    if (gameScreen==2){
      restart();
  }
}

void restart() {
  score = 0;
  health = maxHealth;
  ballX=width/4;
  ballY=height/5;
  lastAddTime = 0;
  walls.clear();
  gameScreen = 0;
}
/*color racketColor = color(0);
float racketWidth = 100;
float racketHeight = 10;*/
/********* OTHER FUNCTIONS ********/
// this method sets the necessary variables to start the game
void startGame() {
  gameScreen = 1;
}
void gameOver() {
  gameScreen=2;
}
void drawHealthBar() {
  // Make it borderless:
  noStroke();
  fill(236, 240, 241);
  rectMode(CORNER);
  rect(ballX-(healthBarWidth/2), ballY - 30, healthBarWidth, 5);
  if (health > 60) {
    fill(46, 204, 113);
  } else if (health > 30) {
    fill(230, 126, 34);
  } else {
    fill(231, 76, 60);
  }
  rectMode(CORNER);
  rect(ballX-(healthBarWidth/2), ballY - 30, healthBarWidth*(health/maxHealth), 5);
}
void decreaseHealth(){
  health -= healthDecrease;
  if (health <= 0){
    restart();
  }
}
void drawBall() {
  fill(ballColor);
  ellipse(ballX, ballY, ballSize, ballSize);
}



void applyGravity() {
  ballSpeedVert += gravity;
  ballY += ballSpeedVert;
  ballSpeedVert -= (ballSpeedVert * airfriction);
}
void makeBounceBottom(int surface) {
  ballY = surface-(ballSize/2);
  ballSpeedVert*=-1;
  ballSpeedVert -= (ballSpeedVert * friction);
}
void makeBounceTop(int surface) {
  ballY = surface+(ballSize/2);
  ballSpeedVert*=-1;
  ballSpeedVert -= (ballSpeedVert * friction);
}
void drawRacket() {
  fill(racketColor);
  rectMode(CENTER);
  rect(mouseX, mouseY, racketWidth, racketHeight);
}
// keep ball in the screen
void keepInScreen() {
  // ball hits floor
if(ballY+(ballSize/2) > height) {
  makeBounceBottom(height);
 
  if(ballX-(ballSize/2) < 0){
     makeBounceLeft(0);
  }
  if(ballX+(ballSize/2) > width) {
    makeBounceRight(width);
  }
}
// ball hits ceiling
if(ballY-(ballSize/2) < 0) {
  makeBounceTop(0);
 }
}
void watchRacketBounce() {
  float overhead = mouseY - pmouseY;
  if ((ballX+(ballSize/2) > mouseX-(racketWidth/2)) && (ballX-(ballSize/2) < mouseX+(racketWidth/2))) {
    if (dist(ballX, ballY, ballX, mouseY)<=(ballSize/2)+abs(overhead)) {
      makeBounceBottom(mouseY);
      //racket moving up
      if (overhead<0) {
        ballSpeedHorizon = (ballX - mouseX)/5;
        ballY+=overhead;
        ballSpeedVert+=overhead;
      }
    }
  }
}
void applyHorizontalSpeed () {
  ballX += ballSpeedHorizon;
  ballSpeedHorizon -= (ballSpeedHorizon * airfriction);
}
void makeBounceLeft(float surface) {
  ballX = surface+(ballSize/2);
  ballSpeedHorizon*=-1;
  ballSpeedHorizon -= (ballSpeedHorizon * friction);
}
void makeBounceRight(float surface) {
  ballX = surface -(ballSize/2);
  ballSpeedHorizon*=-1;
  ballSpeedHorizon -= (ballSpeedHorizon * friction);
}
void wallAdder() {
  if(millis()-lastAddTime > wallInterval) {
    int randHeight = round(random(minGapHeight, maxGapHeight));
    int randY = round(random(0, height-randHeight));
    //{gapWallX, gapWallY, gapWallWidth, gapWallHeight}
    int[] randWall = {width, randY, wallWidth, randHeight, 0};
    walls.add(randWall);
    lastAddTime = millis();
   
  }
}
void wallHandler() {
  for(int i=0; i < walls.size(); i++) {
    wallRemover(i);
    wallMover(i);
    wallDrawer(i);
    watchWallCollision(i);
  }
}
void wallDrawer(int index) {
  int[] wall = walls.get(index);
  // get gap wall settings
  int gapWallX = wall [0];
  int gapWallY = wall [1];
  int gapWallWidth = wall [2];
  int gapWallHeight = wall [3];
  //draw actual walls
  rectMode(CORNER);
  fill(wallColors);
  rect(gapWallX, 0, gapWallWidth, gapWallY);
  rect(gapWallX, gapWallY+gapWallHeight, gapWallWidth, height-(gapWallY+gapWallHeight));
}
void wallMover(int index) {
  int[] wall = walls.get(index);
 wall[0] -= wallSpeed;
}
void wallRemover(int index) {
  int[] wall = walls.get(index);
  if (wall[0]+wall[2] <= 0) {
    walls.remove(index);
  }
}
void watchWallCollision(int index) {
  int[] wall = walls.get(index);
  //get gap wall settings
  int gapWallX = wall[0];
  int gapWallY = wall[1];
  int gapWallWidth = wall[2];
  int gapWallHeight = wall[3];
  int wallScored = wall[4];
  int wallTopX = gapWallX;
  int wallTopY = 0;
  int wallTopWidth = gapWallWidth;
  int wallTopHeight = gapWallY;
  int wallBottomX = gapWallX;
  int wallBottomY = gapWallY+gapWallHeight;
  int wallBottomWidth = gapWallWidth;
  int wallBottomHeight = height-(gapWallY+gapWallHeight);
  
  if (
    (ballX+(ballSize/2)>wallTopX) &&
    (ballX-(ballSize/2)<wallTopX+wallTopWidth) &&
    (ballY+(ballSize/2)>wallTopY) &&
    (ballY-(ballSize/2)<wallTopY+wallTopHeight)
    ) {
    // collides with upper wall
    decreaseHealth();
  }
  
  if (
    (ballX+(ballSize/2)>wallBottomX) &&
    (ballX-(ballSize/2)<wallBottomX+wallBottomWidth) &&
    (ballY+(ballSize/2)>wallBottomY) &&
    (ballY-(ballSize/2)<wallBottomY+wallBottomHeight)
    ) {
    // collides with lower wall
    decreaseHealth();
  }
  if(ballX > gapWallX+(gapWallWidth/2) && wallScored==0) {
    wallScored=1;
    wall[4]=1;
    score();
   
  }
} 
void score() {
  score++;
}
void printScore() {
  textAlign(CENTER);
  fill(0);
  textSize(30);
  text(score, height/2, 50);
}
  
  
  
