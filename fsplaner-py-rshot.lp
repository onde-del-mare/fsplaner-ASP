#script(python)
import clingo
import sys
from clingo import Function
def main(prg):
    
    # --------------- CONFIG --------------- 
    fsn = 2  #int: how many elevators. ex: 2 = {0,1}  
    etn = 4  #int: how many floors. ex: 4 = {0,1,2,3}
    #[[int,int,int]]: request time, start floor, goal floor 
    #ex: [[0,3,0]] request at time 0 from floor 3 to floor 0
    requests = [[0,3,0],[0,0,3],[2,1,0],[7,1,0]]
    #int: static time window for the program to find a solution 
    #ex: time 10 will set a time window from 0 to 10
    time = 10
    # --------------- CONFIG ---------------
    
    ri = 1
    sol = prg.solve()
    while ri < (len(requests)+1):
    
        prgx = clingo.Control(["--warn=none"])
        prgx.load("fsplaner-asp.lp")   
        prgx.add("base", [], f"#const fsn={fsn}.") 
        prgx.add("base", [], f"#const etn={etn}.")
        prgx.ground([("base", [])])
    
        for t in range(0, time+1):
    
            prgx.ground([("gen", [t])])
    
    
        for i in range(0,ri):
            
            req = requests[i]
            t = req[0]
            s = req[1]
            z = req[2]
            prgx.ground([("gett", [t,i])])
            prgx.ground([("gets", [s,i])])
            prgx.ground([("getz", [z,i])])
            prgx.assign_external(clingo.Function("extt", [t,i]), True)
            prgx.assign_external(clingo.Function("exts", [s,i]), True)
            prgx.assign_external(clingo.Function("extz", [z,i]), True)
            prgx.ground([("s", [i])])
            prgx.ground([("z", [i])])
    
        prgx.ground([("stepopt", [])])
        sol = prgx.solve(on_model=lambda m: print(f"Req:{ri}---------------{m}")) 
        ri += 1
    
#end. 

















