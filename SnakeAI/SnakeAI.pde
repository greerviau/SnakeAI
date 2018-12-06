final int SIZE = 20;

int highscore = 0;
int fps = 100;  //15 is ideal for self play, increasing for AI does not directly increase speed, speed is dependant on processing power
boolean humanPlaying = false;  //false for AI, true to play yourself
boolean replayBest = true;  //shows only the best of each generation
boolean seeVision = false;  //see the snakes vision
boolean modelLoaded = false;
float mutationRate = 0.05;
float defaultmutation = mutationRate;
PFont font;

ArrayList<Integer> evolution;
Button graphButton;
Button loadButton;
Button saveButton;
Button increaseMut;
Button decreaseMut;
EvolutionGraph graph;

Snake snake;
Snake model;
Population pop;

public void settings() {
  size(1200,800);
}

void setup() {
  font = createFont("agencyfb-bold.ttf",32);
  evolution = new ArrayList<Integer>();
  graphButton = new Button(349,15,100,30,"Graph");
  loadButton = new Button(249,15,100,30,"Load");
  saveButton = new Button(149,15,100,30,"Save");
  increaseMut = new Button(340,85,20,20,"+");
  decreaseMut = new Button(365,85,20,20,"-");
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
    if(!modelLoaded) {
      if(pop.done()) {
          highscore = pop.bestSnake.score;
          pop.calculateFitness();
          pop.naturalSelection();
      } else {
          pop.update();
          pop.show(); 
      }
      fill(150);
      textSize(25);
      textAlign(LEFT);
      text("GEN : "+pop.gen,120,65);
      //text("BEST FITNESS : "+pop.bestFitness,120,50);
      //text("MOVES LEFT : "+pop.bestSnake.lifeLeft,120,70);
      text("MUTATION RATE : "+mutationRate*100+"%",120,95);
      text("SCORE : "+pop.bestSnake.score,120,height-45);
      text("HIGHSCORE : "+highscore,120,height-15);
      increaseMut.show();
      decreaseMut.show();
    } else {
      model.look();
      model.think();
      model.move();
      model.show();
      model.brain.show(0,0,400,800,model.vision, model.decision);
      if(model.dead) {
        Snake newmodel = new Snake();
        newmodel.brain = model.brain.clone();
        model = newmodel;
        
     }
     textSize(25);
     fill(150);
     textAlign(LEFT);
     text("SCORE : "+model.score,120,height-45);
    }
    textAlign(LEFT);
    textSize(18);
    fill(255,0,0);
    text("RED < 0",120,height-80);
    fill(0,0,255);
    text("BLUE > 0",200,height-80);
    graphButton.show();
    loadButton.show();
    saveButton.show();
  }

}

void fileSelectedIn(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    String path = selection.getAbsolutePath();
    Table modelTable = loadTable(path,"header");
    float[][] w1 = new float[18][25];
    float[][] w2 = new float[18][19];
    float[][] w3 = new float[4][19];
    for(int i=0; i< 18; i++) {
      for(int j=0; j< 25; j++) {
        w1[i][j] = modelTable.getFloat(j+i*25,"In/H1");
      }  
    }
    for(int i=0; i< 18; i++) {
      for(int j=0; j< 19; j++) {
        w2[i][j] = modelTable.getFloat(j+i*19,"H1/H2");
      }  
    }
    for(int i=0; i< 4; i++) {
      for(int j=0; j< 19; j++) {
        w3[i][j] = modelTable.getFloat(j+i*19,"H2/Out");
      }  
    }
    evolution = new ArrayList<Integer>();
    int g = 0;
    int genscore = modelTable.getInt(g,"Graph");
    while(genscore != 0) {
       evolution.add(genscore);
       g++;
       genscore = modelTable.getInt(g,"Graph");
    }
    modelLoaded = true;
    humanPlaying = false;
    model = new Snake();
    model.brain.load(w1,w2,w3);
  }
}

void fileSelectedOut(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    String path = selection.getAbsolutePath();
    Table modelTable = new Table();
    modelTable.addColumn("In/H1");
    modelTable.addColumn("H1/H2");
    modelTable.addColumn("H2/Out");
    modelTable.addColumn("Graph");
    Snake modelToSave = pop.bestSnake.clone();
    Matrix[] modelWeights = modelToSave.brain.pull();
    int w1i = 0;
    int w2i = 0;
    int w3i = 0;
    int g = 0;
    float[] w1 = modelWeights[0].toArray();
    float[] w2 = modelWeights[1].toArray();
    float[] w3 = modelWeights[2].toArray();
    int maxLen = max(w1.length,w2.length,w2.length);
    for(int i=0; i<maxLen; i++) {
       TableRow newRow = modelTable.addRow();
       if(w1i < w1.length) {
          newRow.setFloat("In/H1",w1[w1i]);
          w1i++;
       }
       if(w2i < w2.length) {
          newRow.setFloat("H1/H2",w2[w2i]);
          w2i++;
       }
       if(w3i < w3.length) {
          newRow.setFloat("H2/Out",w3[w3i]);
          w3i++;
       }
       if(g < evolution.size()) {
          newRow.setInt("Graph",evolution.get(g));
          g++;
       }
    }
    saveTable(modelTable, path);
    
  }
}

void mousePressed() {
   if(graphButton.collide(mouseX,mouseY)) {
       graph = new EvolutionGraph();
   }
   if(loadButton.collide(mouseX,mouseY)) {
       selectInput("Load Snake Model", "fileSelectedIn");
   }
   if(saveButton.collide(mouseX,mouseY)) {
       selectOutput("Save Snake Model", "fileSelectedOut");
   }
   if(increaseMut.collide(mouseX,mouseY)) {
      mutationRate *= 2;
      defaultmutation = mutationRate;
   }
   if(decreaseMut.collide(mouseX,mouseY)) {
      mutationRate /= 2;
      defaultmutation = mutationRate;
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
