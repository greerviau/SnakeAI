# SnakeAI

## Snake
Each snake contains a neural network. The neural network has an input layer of 24 neurons, 2 hidden layers of 18 neurons, and one output layer of 4 neurons. The snake can see in 8 directions: UP, DOWN, LEFT, RIGHT, DIAGONALS. In each of these directions the snake looks for 3 things: distance to food, distance to its own body and distance to a wall. 3 x 8 is 24 inputs. The 4 outputs are simply the directions the snake can move.

## Population
Each generation a population of 2000 snakes is created. For the first generation, all of the neural nets in each of the snakes is initialized randomly. Once the entire population is dead, a fitness score is calculated for each of the snakes. Using these fitness scores, some of the best snakes are selected to reproduce. In reproduction two snakes are slected and the neural nets of each snake are crossed over. Once a new generation of snakes is created the process is repeated.


