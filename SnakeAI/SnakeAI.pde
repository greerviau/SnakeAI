final int SIZE = 20;
int highscore = 0;
int fps = 100;  //15 is ideal for self play, increasing for AI does not increase speed, snake still takes time to thin each move
boolean humanPlaying = false;  //false for AI, true to play yourself
boolean replayBest = true;  //shows only the best of each generation
boolean seeVision = true;  //see the snakes vision
float mutationRate = 0.1;
PFont font;
Button graphButton;
EvolutionGraph graph;

Snake snake;
Population pop;

public void settings() {
  size(1200,800);
}

void setup() {
  font = createFont("agencyfb-bold.ttf",32);
  graphButton = new Button(329,15,140,30,"Evolution Graph");
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
  rectMode(CORNER);
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
    textSize(30);
    textAlign(LEFT);
    text("GEN : "+pop.gen,120,55);
    //text("BEST FITNESS : "+pop.bestFitness,120,50);
    //text("MOVES LEFT : "+pop.bestSnake.lifeLeft,120,70);
    text("MUTATION RATE : "+mutationRate*100+"%",120,90);
    textSize(18);
    fill(255,0,0);
    text("RED < 0",120,height-80);
    fill(0,0,255);
    text("BLUE > 0",200,height-80);
    textSize(30);
    fill(150);
    text("SCORE : "+pop.bestSnake.score,120,height-45);
    text("HIGHSCORE : "+highscore,120,height-10);
    graphButton.show();
  }

}

void mousePressed() {
   if(graphButton.collide(mouseX,mouseY)) {
       graph = new EvolutionGraph();
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
