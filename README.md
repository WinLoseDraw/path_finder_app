# path_finder_app

A minimalistic app created with Flutter that demonstrates the A* path finding algorithm in an interactive medium. 

## Basic Guide

The user begins by selecting the size for a square grid of cells. This is followed by the selection of the start cell marked by cyan color. 
Next, the user selects a goal cell marked by green. Further, the user may optionally add some invalid cells marked by red. The path finder is not allowed to visit these cells.
Selecting the begin button initializes the search algorithm. The latest active cell has a cyan accent color and can be seen changing positions continuously. 

The search algorithm terminates when it finds the goal state, or there is no possible path to the goal state for the given configuration. 
In the former case, the optimal path found by the algorithm is highlighted in yellow.
The user may use the reset button to start a new search from scratch.
