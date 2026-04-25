/*@pjs preload="pacman_collisionmap.gif,pacman_blankmap.png,pacman_RIGHT_half.png,pacman_LEFT_half.png,pacman_UP_half.png,pacman_DOWN_half.png,pacman_RIGHT_closed.png,pacman_LEFT_closed.png,pacman_UP_closed.png,pacman_DOWN_closed.png,pacman_RIGHT_closed.png,pacman_LEFT_closed.png,pacman_UP_closed.png,pacman_DOWN_closed.png";*/
Pacman pacman;
PImage blankMap;
PImage pacMan;
PImage egg;
boolean[][] eggMap;
boolean[][] collisionMap;
PImage colMapImage;
int maxScore = 0;
float highScore = 99;
float timePlay = 0;
boolean start = false;


void setup(){
  size(640,480);
  smooth();  
  egg = loadImage("egg.png");
  pacMan = loadImage("pacman_LEFT_closed.png");
  pacman = new Pacman(320,240);
  blankMap = loadImage("pacman_blankmap.png");
  colMapImage = loadImage("pacman_collisionmap.gif");
  mapProcess();  
  frameRate(60);
}

void draw(){
  //map and pacman
  image(blankMap,0,0);
  image(pacMan,320,244);
  
  //draw egg map
  drawEgg();
  //not all eggs have been eaten
  if ((pacman.getScore() < maxScore)) {
    if (start) timePlay += float(1)/60;
    pacman.update();
    image(blankMap,0,0);
    drawEgg();
    //direction of Pacman is based on the current direction (the last successful keyCode)
    pacman.displayCurrentDirection();
    //score by eggs 
    textSize(24);
    text(pacman.getScore(), 15,100);
    //time played
    textSize(24);
    text(timePlay, 10,150);
    //high score by time
    textSize(24);
    text(highScore, 545,100);
  } else {   //complete the game
    fill(0,0,0, 130);
    rect(0,0,640,480);
    textSize(40);
    fill(255,255,255);
    text("WELL DONE", 210,230);
    //play again
    if (!onButton()) fill(100,100,100);
    else fill(125,125,100);
    rect(250,270,140,30);
    textSize(20);
    fill(255,255,255);
    text("Play Again", 270,293);
    if (timePlay < highScore) {
      textSize(20);
      fill(255,255,255);
      text("New HighScore!", 250,333);
    }
  }
}

boolean onButton() {
  if (mouseX >= 250 && mouseX <= 390 && 
      mouseY >= 270 && mouseY <= 300) {
    return true;
  } else {
    return false;
  }
}

void mapProcess(){
   collisionMap = new boolean[width][height];       
   color black = color(0);
   color white = color(255);
   
   //black is false, white is true
   for (int i = 0; i < width; i++) {  
     for (int j = 0; j < height; j++) {                   
       color c = colMapImage.get(i, j);
       if (c == black) {
         collisionMap[i][j] = false;
       } else if (c == white) {
         collisionMap[i][j] = true;
       } else {}                    
      }
    }
                     
    eggMap = new boolean[width][height];
    for (int i = 0; i < width; i++) 
      for (int j = 0; j < height; j++) 
        eggMap[i][j] = false;
    
    //handiwork of measurement and adjustment here    
    for (int i = 117; i < 530; i+=16 ) {
      for (int j = 30; j < 434;j +=14) {
        if (collisionMap[i][j]&&collisionMap[i][j-1]) {
           eggMap[i][j] = true;
           maxScore += 10;
        }
     }
   }
}
  
  //draw egg map based on the matrix
void drawEgg() {
  for (int i = 0; i < width; i++) 
      for (int j = 0; j < height; j++) 
        if (eggMap[i][j]) {
          image(egg,i,j,5,5);
        }
}
  
//pressed at 'Play Again' button
void mousePressed() {
  if (onButton()) {
    pacman = new Pacman(320,240);
    maxScore= 0;
    image(blankMap,0,0);
    image(pacMan,320,244);
    mapProcess();
    if (timePlay < highScore) highScore = timePlay;
    timePlay = 0.00;
  }
}  

void keyPressed() {
  start = true;
}
 
class Pacman{
  int x,y;
  PImage pacM;
  int maxSpeed = 4;
  int s = 27;
  int half_size = 13;
  int currentDirection = 0;  //0 is up, 1 is right, 2 is bottom, 3 is left
  
  int numFramesR = 8;
  int frameR = 0;
  PImage[] imagesR = new PImage[numFramesR];

  int numFramesL = 8;
  int frameL = 0;
  PImage[] imagesL = new PImage[numFramesL];

  int numFramesU = 8;
  int frameU = 0;
  PImage[] imagesU = new PImage[numFramesU];

  int numFramesD = 8;
  int frameD = 0;
  PImage[] imagesD = new PImage[numFramesD];
  int score;


  //constructor
  Pacman(int _x, int _y){
    x = _x;
    y = _y;
    score = 0;
    keyCode = UP;

    PImage rOpen = loadImage("pacman_RIGHT_open.png");
    PImage rHalf = loadImage("pacman_RIGHT_half.png");
    PImage rClosed = loadImage("pacman_RIGHT_closed.png");
    imagesR[0] = rOpen;
    imagesR[1] = rOpen;
    imagesR[2] = rHalf;
    imagesR[3] = rHalf;
    imagesR[4] = rClosed;
    imagesR[5] = rClosed;
    imagesR[6] = rHalf;
    imagesR[7] = rHalf;

    PImage lOpen = loadImage("pacman_LEFT_open.png");
    PImage lHalf = loadImage("pacman_LEFT_half.png");
    PImage lClosed = loadImage("pacman_LEFT_closed.png");
    imagesL[0] = lOpen;
    imagesL[1] = lOpen;
    imagesL[2] = lHalf;
    imagesL[3] = lHalf;
    imagesL[4] = lClosed;
    imagesL[5] = lClosed;
    imagesL[6] = lHalf;
    imagesL[7] = lHalf;

    PImage uOpen = loadImage("pacman_UP_open.png");
    PImage uHalf = loadImage("pacman_UP_half.png");
    PImage uClosed = loadImage("pacman_UP_closed.png");
    imagesU[0] = uOpen;
    imagesU[1] = uOpen;
    imagesU[2] = uHalf;
    imagesU[3] = uHalf;
    imagesU[4] = uClosed;
    imagesU[5] = uClosed;
    imagesU[6] = uHalf;
    imagesU[7] = uHalf;

    PImage dOpen = loadImage("pacman_DOWN_open.png");
    PImage dHalf = loadImage("pacman_DOWN_half.png");
    PImage dClosed = loadImage("pacman_DOWN_closed.png");
    imagesD[0] = dOpen;
    imagesD[1] = dOpen;
    imagesD[2] = dHalf;
    imagesD[3] = dHalf;
    imagesD[4] = dClosed;
    imagesD[5] = dClosed;
    imagesD[6] = dHalf;
    imagesD[7] = dHalf;
  }

  void update(){
  //update position               
                 if (keyCode == LEFT) {
                   // still in canvas
                   if (x >= maxSpeed)
                   {
                     //try to move
                     if (!move(3)) {
                        //if cannot, move to the same previous direction if possible
                       move(currentDirection);                                             
                     } else {
                         currentDirection = 3;
                     }
                   }
                 }
                 
                 if (keyCode == RIGHT) {
                   if (x <= width  - maxSpeed)
                   {              
                     if (!move(1)) {
                        //move
                       move(currentDirection);                   
                     } else {
                         currentDirection = 1;
                     }
                    }
                  }
                 
                
                 if (keyCode == UP) {
                   if (y >= maxSpeed)
                   {             
                     if (!move(0)) {
                        //move
                       move(currentDirection);                      
                     } else {
                         currentDirection = 0;
                     } 
                   }
                 }
                 
                
                 if (keyCode == DOWN) {
                   if (y <= height  - maxSpeed)
                   {                
                     if (!move(2)) {
                        //move
                       move(currentDirection);                  
                     } else {
                         currentDirection = 2;
                     }
                   }
                 }   
                 eatEgg();                 
  }
  
  
  void displayR(){
        frameR = (frameR+1) % numFramesR;
        image(imagesR[frameR], x + 4, y + 4);      
  }
  void displayL(){
        frameL = (frameL+1) % numFramesL;
        image(imagesL[frameL], x + 4, y+ 4);
  }
  void displayU(){
        frameU = (frameU+1) % numFramesU;
        image(imagesU[frameU], x + 4, y+ 4);
  }
  void displayD(){
        frameD = (frameD+1) % numFramesD;
        image(imagesD[frameD], x + 4, y+ 4);
  }
  
  boolean move(int direction) {
    switch(direction) {
      case 0: //up
        for (int speed = maxSpeed; speed > 0; speed --) {
          if ((collisionMap[x][y - speed])&&
             (collisionMap[x + s][y - speed])&&
             (collisionMap[x + half_size][y - speed])) {
               y -= speed;
               return true;   
           }
        }
        break;
       case 1: //right
         for (int speed = maxSpeed; speed > 0; speed --) {
          if ((collisionMap[x + s + speed][y])&&
             (collisionMap[x + s + speed][y + s])&&
             (collisionMap[x + s + speed][y + half_size])) {
               x += speed;
               //PORTAL
               if(x>=511){
                 x=99;
               }
               return true;
           }
        }
        break;
        case 2: //down
         for (int speed = maxSpeed; speed > 0; speed --) {
          if ((collisionMap[x][y + speed + s])&&
             (collisionMap[x + half_size][y + speed + s])&&
             (collisionMap[x + s][y + speed + s])) {
               y += speed;
               return true;   
           }
        }
        break;
        case 3: //left 
         for (int speed = maxSpeed; speed > 0; speed --) {
          if ((collisionMap[x -speed][y])&&
             (collisionMap[x -speed][y + s])&&
             (collisionMap[x -speed][y + half_size])) {
               x -= speed;
               //PORTAL
               if(x<=99){
                 x=511;
               }
               return true;  
           }
        }
        break;
    }
    return false;
  }  
  
  void displayCurrentDirection() {
    switch (currentDirection) {
      case 0: displayU(); break;
      case 1: displayR(); break;
      case 2: displayD(); break;
      case 3: displayL(); break;
    }
  }

  //to eat an egg
  void eatEgg() {
    for (int i = x + 10; i < x + 18; i ++) {
      for (int j = y + 10; j < y + 18; j ++) {
        if (eggMap[i][j]) {
          eggMap[i][j] = false;
          score += 10;
        }
      }
    }
  }
  
  int getScore() {
    return score;
  }
  
  void resetScore() {
    score = 0;
  }
}


