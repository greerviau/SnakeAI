final int SIZE = 20;
int highscore = 0;
int fps = 100;  //15 is ideal for self play, increasing for AI does not increase speed, snake still takes time to thin each move
boolean humanPlaying = false;  //false for AI, true to play yourself
boolean replayBest = true;  //shows only the best of each generation
boolean seeVision = false;  //see the snakes vision
float mutationRate = 0.01;
PFont font;

Snake snake;
Population pop;

void setup() {
  font = createFont("agencyfb-bold.ttf",32);
  size(1200,800);
  frameRate(fps);
  if(humanPlaying) {
    snake = new Snake();
  } else {
    pop = new Population(2000); //adjust size of population
  }
}

void draw() {
  background(0);
  noFill();
  stroke(255);
  line(400,0,400,height);
  rect(400 + SIZE,SIZE,width-400-40,height-40);
  textAlign(CENTER);
  textFont(font);
  if(humanPlaying) {
    snake.move();
    snake.show();
    fill(150);
    textSize(20);
    text("SCORE : "+snake.score,500,50);
    if(snake.dead) {
       snake = new Snake(); 
    }
  } else {
    if(pop.done()) {
        highscore = pop.bestSnake.score;
        pop.calculateFitness();
        pop.naturalSelection();
    } else {
        pop.update();
        pop.show(); 
    }
    fill(150);
    textSize(20);
    textAlign(LEFT);
    text("GEN : "+pop.gen,150,30);
    text("BEST FITNESS : "+pop.bestFitness,150,50);
    text("MOVES LEFT : "+pop.bestSnake.lifeLeft,150,70);
    text("MUTATION RATE : "+mutationRate,150,90);
    textSize(18);
    fill(255,0,0);
    text("RED < 0",140,height-100);
    fill(0,0,255);
    text("BLUE > 0",220,height-100);
    textSize(30);
    fill(150);
    text("SCORE : "+pop.bestSnake.score,140,height-60);
    text("HIGHSCORE : "+highscore,140,height-20);
    
  }

}


void keyPressed() {
  if(humanPlaying) {
    if(key == CODED) {
       switch(keyCode) {
          case UP:
            snake.moveUp();
            break;
          case DOWN:
            snake.moveDown();
            break;
          case LEFT:
            snake.moveLeft();
            break;
          case RIGHT:
            snake.moveRight();
            break;
       }
    }
  }
}
