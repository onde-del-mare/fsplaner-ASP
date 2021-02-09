#program base.
%fs - elevators, et - floors 
fs(0..fsn-1).                
et(0..etn-1).                

#program gen(t).
%at(ELEVATOR,FLOOR,TIME) generates all possible paths for the elevators
fsn{ at(F,E,t) : fs(F), et(E) }fsn.
:- at(F,E1,t-1), at(F,E2,t), |E1-E2| > 1, fs(F), et(E1), et(E2).
:- at(F,E1,t), at(F,E2,t), not E1 = E2, fs(F), et(E1), et(E2).
:- not at(F,0,0), fs(F).
time(t).

#program gett(t,i).
#external extt(t,i).
%external atom for the request time extt

#program gets(s,i).
#external exts(s,i).
%external atom for the request start floor exts

#program getz(z,i).
#external extz(z,i).
%external atom for the request goal floor extz

#program s(i).
%set rule for a new starting point of a request
%atrs(ELEVATOR,FLOOR,TIME,ID) at atom for a request id ID, with starting floor s
%ri(ID) request id
ri(I) :- extt(T,I).
atrs(F,E,T,i) : fs(F), exts(E,i), time(T), extt(V,i), T > V.
:- not at(F,E,T), atrs(F,E,T,i).

#program z(i).
%set rule for a new ending point of a request
%atrz(ELEVATOR,FLOOR,TIME,ID) at atom for a request id ID, with goal floor z
%rule for entering/leaving an elevator which takes one time step 
atrz(F,E,T,i) : fs(F), extz(E,i), time(T), atrs(F,E1,V,i), T > V.
:- not at(F,E,T), atrz(F,E,T,i).
:- at(F,E,T), atrs(F,E,T,i), at(F,E1,T+1), not E=E1, extz(Z,I), ri(I), not E=Z.
:- at(F,E,T), atrz(F,E,T,i), at(F,E1,T+1), not E=E1, exts(S,I), ri(I), not E=S.
:- at(F,E,T), at(F,E1,T+1), atrz(F,E,T,I), atrs(F,E,T,I), ri(I), not E=E1. 

#program stepopt.
%optimize the program with the sum of all steps the elevators made sumstep and
%the sum of the time differences between a request time and reaching goal time sumrtime 
maxtime(X) :- X = #max{ T : time(T) }.
step(F,0,0) :- fs(F). 
step(F,T+1,S+|Y-Y1|) :- step(F,T,S), at(F,Y,T), at(F,Y1,T+1).
sumstepi(0,N) :- step(0,Z,N), maxtime(Z).
sumstepi(X+1,Y+N) :- sumstepi(X,Y), step(X+1,Z,N), maxtime(Z).
sumstepii(Y) :- sumstepi(X,Y).
sumstep(X) :-  X = #max{ Y : sumstepii(Y) }.
rtime(I,T) :- extt(T1,I), atrz(F,E,T2,I), T = T2 - T1.
sumrtimei(0,N) :- rtime(0,N).
sumrtimei(X+1,Y+N) :- sumrtimei(X,Y), rtime(X+1,N).
sumrtimeii(Y) :- sumrtimei(X,Y).
sumrtime(X) :- X = #max{ Y : sumrtimeii(Y) }.
score(N) :- sumstep(X), sumrtime(Y), N = X+Y.

#minimize{X : score(X)}.
#show at/3.
#show score/1.







