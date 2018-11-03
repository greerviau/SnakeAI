# SnakeAI

## Download and Run
To run the program you will need [Processing](https://processing.org/)

## Snake
### Neural Network
Each snake contains a neural network. The neural network has an input layer of 24 neurons, 2 hidden layers of 18 neurons, and one output layer of 4 neurons. 
### Vision
The snake can see in 8 directions. In each of these directions the snake looks for 3 things:
+ Distance to food
+ Distance to its own body
+ Distance to a wall

3 x 8 directions = 24 inputs. The 4 outputs are simply the directions the snake can move.

![snakeai-2](https://user-images.githubusercontent.com/36581610/47884783-85299680-de08-11e8-9c0f-cc597d8b2b3b.gif)

## Evolution
### Natural Selection
Each generation a population of 2000 snakes is created. For the first generation, all of the neural nets in each of the snakes are initialized randomly. Once the entire population is dead, a fitness score is calculated for each of the snakes. Using these fitness scores, some of the best snakes are selected to reproduce. In reproduction two snakes are selected and the neural nets of each are crossed and then the resulting child is mutated. This is repeated to create a new population of 2000 new snakes.

### Fitness
A snakes fitness is dependant on how long the snake stays alive as well as its score. However they are not equally important, having a higher score does reward a higher fitness than a snake who simply stays alive. There is the possibility however that a snake may evolve a strategy where it loops in a certain pattern and never dies. Even though having a high score is prioritized more, if a snake can stay alive forever then that is a clear problem. To avoid this each snake is giving 200 starting moves at the beginning of its life. Every time it eats a piece of food, it gains 100 more moves. This means that snakes who evolve to go in loops will eventually die, and snakes who go for the food will not only have a higher score, but stay alive longer.

### Crossover & Mutation
When two snakes are selected for reproduction, what happens is that the snakes brains are crossed with each other. What this means is that part of one parents brain is mixed with part of the second parents and the resulting brain is assigned to the child. After the crossover the brain is also mutated according to a mutation rate (initially set to 1%). The mutation rate determines how much of the brain will be randomly altered.


![snakeai-4](https://user-images.githubusercontent.com/36581610/47884972-3defd580-de09-11e8-9c30-a85c5cd41611.gif)
