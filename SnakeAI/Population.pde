class Population {
   
   Snake[] snakes;
   Snake bestSnake;
   float bestFitness;
   float fitnessSum;
   int gen = 0;
   int samebest = 0;
   
   Population(int size) {
      snakes = new Snake[size]; 
      for(int i = 0; i < snakes.length; i++) {
         snakes[i] = new Snake(); 
      }
      bestSnake = snakes[0].clone();
      bestSnake.replay = true;
   }
   
   boolean done() {  //check if all the snakes in the population are dead
      for(int i = 0; i < snakes.length; i++) {
         if(!snakes[i].dead)
           return false;
      }
      if(!bestSnake.dead) {
         return false; 
      }
      return true;
   }
   
   void update() {  //update all the snakes in the generation
      if(!bestSnake.dead) {  //if the best snake is not dead update it, this snake is a replay of the best from the past generation
         bestSnake.look();
         bestSnake.think();
         bestSnake.move();
      }
      for(int i = 0; i < snakes.length; i++) {
        if(!snakes[i].dead) {
           snakes[i].look();
           snakes[i].think();
           snakes[i].move(); 
        }
      }
   }
   
   void show() {  //show either the best snake or all the snakes
      if(showBest) {
        bestSnake.show();
        bestSnake.brain.show(0,0,400,800,bestSnake.vision, bestSnake.decision);  //show the brain of the best snake
      } else {
         for(int i = 0; i < snakes.length; i++) {
            snakes[i].show(); 
         }
      }
   }
   
   void setBestSnake() {  //set the best snake of the generation
       float max = 0;
       int maxIndex = 0;
       for(int i = 0; i < snakes.length; i++) {
          if(snakes[i].fitness > max) {
             max = snakes[i].fitness;
             maxIndex = i;
          }
       }
       if(max > bestFitness) {
         bestFitness = max;
         bestSnake = snakes[maxIndex].cloneForReplay();
         samebest = 0;
         globalMutationRate = 0.1;
       } else {
         bestSnake = bestSnake.cloneForReplay(); 
         samebest++;
         if(samebest > 3) {  //if the best snake has remained the same for 3 generations, raise the mutation rate
            globalMutationRate *= 2; 
            samebest = 0;
         }
       }
   }
   
   Snake selectParent() {  //selects a random number in range of the fitnesssum and if a snake falls in that range then select it
      float rand = random(fitnessSum);
      float runningSum = 0;
      for(int i = 0; i < snakes.length; i++) {
         runningSum += snakes[i].fitness;
         if(runningSum > rand) {
           return snakes[i];
         }
      }
      return snakes[0];
   }
   
   void naturalSelection() {
      Snake[] newSnakes = new Snake[snakes.length];
      
      setBestSnake();
      calculateFitnessSum();
      
      newSnakes[0] = bestSnake.clone();  //add the best snake of the prior generation into the new generation
      for(int i = 1; i < snakes.length; i++) {
         Snake child = selectParent().crossover(selectParent());
         child.mutate();
         newSnakes[i] = child;
      }
      snakes = newSnakes.clone();
      gen+=1;
   }
   
   void mutate() {
       for(int i = 1; i < snakes.length; i++) {  //start from 1 as to not override the best snake placed in index 0
          snakes[i].mutate(); 
       }
   }
   
   void calculateFitness() {  //calculate the fitnesses for each snake
      for(int i = 0; i < snakes.length; i++) {
         snakes[i].calculateFitness(); 
      }
   }
   
   void calculateFitnessSum() {  //calculate the sum of all the snakes fitnesses
       fitnessSum = 0;
       for(int i = 0; i < snakes.length; i++) {
         fitnessSum += snakes[i].fitness; 
      }
   }
}
