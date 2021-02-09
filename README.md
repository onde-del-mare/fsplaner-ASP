This program uses Answer Set Planning and multi-shot solving
with a Clingo 5 Python API for a domain of parallel working elevators to find
an optimal model for some requirements:
1. shortest path of the elevators trough all requested floors
2. shortest sum of times from requesting an elevator to arriving at the goal floor

Configuration:
Each program has a configuration block:
# --------------- CONFIG --------------- 
-
-
# --------------- CONFIG ---------------
where you can set desired parameters

There are two options to run:

1. Multi-shot with time iteration: 
The program will start from time = 0, and then tries to find a best path for all
requests given. If the path is not found, then the time will go up 1 step until 
a solution is found or the maximum time limit has been reached.

clingo fsplaner-py-tshot.lp

2. Multi-shot with requests iteration:
With a given time window, the program will start with the first request and chooses
the best path for the elevators. Then the next request will be added to the list
and again a path will be computed, until all requests have been added to the list.
The solution will only show up if a viable path can be found with the current number 
of requests. 

clingo fsplaner-py.rshot.lp


Example solution:

Req:4---------------
at(0,0,0) at(1,0,0) 
at(0,0,1) at(1,0,1) 
at(0,0,2) at(1,1,2) 
at(0,1,3) at(1,1,3) 
at(0,2,4) at(1,1,4) 
at(0,3,5) at(1,0,5) 
at(0,3,6) at(1,0,6) 
at(0,2,7) at(1,0,7) 
at(0,1,8) at(1,0,8) 
at(0,1,9) at(1,0,9) 
at(0,0,10) at(1,0,10) 
score(29)

A Solution will show a list of groups of the at/3 literal. These groups are 
seperated by "Req:STEP---------------" to mark the current iteration step.
The LAST solution with the current STEP is always the optimal one, which 
has the lowest score literal, shown at the end of each group.
The at/3 literal has the arguments: (ELEVATOR,FLOOR,TIME)
As you can see in the example, the elevator 0 has moved from floor 0 to 3 at 
time 2-5, then moved back to 0 from time 6-10, while elevator 1 has only moved
from floor 0 to 1 at time 1-2 and went back to 0 at time 4-5.

 







 