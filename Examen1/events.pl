:-dynamic(varNumber / 3).
symbolicOutput(0).  % set to 1 to see symbolic output only; 0 otherwise.


%% This problem you already know. Here we provide a solution to it:
%%   We want to schedule a series of events within the next few days.
%%   Due to the nature of the events, each event should have a moderator
%%   assigned to it. There is a limit on the number of events per day
%%   and also on the amount of days where events with the same moderator
%%   can take place. Finally, we have a list of possible moderators and
%%   days for every event.
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% For this exam, you have to extend/modifiy THIS solution (not yours) as follows:
%% - Now there is also a minimum number of events to be scheduled each day.
%% - The events have to be sorted by day. For example, event 5 must be
%%   on the same day as event 3, or on a later day after event 3's day.
%% Deliver only this file, named events.pl
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%% input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numEvents(15).
numDays(6).
numModerators(4).
minEventsPerDay(1).
maxEventsPerDay(4).
maxDaysPerModerator(2).

%event(id,listPossibleModerators,listPossibleDays).
event(1, [1,2  ,4],[1,2,3,4    ]).
event(2, [1  ,3  ],[1,2,3,4,5,6]).
event(3, [1,2  ,4],[  2,3,4,5  ]).
event(4, [1  ,3,4],[1,2  ,4,  6]).
event(5, [1,2,3,4],[    3,4,5,6]).
event(6, [1  ,3,4],[  2,3  ,5  ]).
event(7, [1,2    ],[1,2  ,4,5,6]).
event(8, [1,2  ,4],[    3,4,5  ]).
event(9, [1,2,3  ],[    3  ,5,6]).
event(10,[1  ,3,4],[  2  ,4,5  ]).
event(11,[1,2  ,4],[    3  ,5,6]).
event(12,[1,2,3  ],[1  ,3,4,5  ]).
event(13,[1  ,3,4],[1,2    ,5,6]).
event(14,[1,2,3  ],[1  ,3,4,5,6]).
event(15,[1,2  ,4],[  2,3  ,5,6]).

%%%%%% Some helpful definitions to make the code cleaner:
event(E):-              event(E,_,_).
canModerateEvent(E,M):- event(E,Moderators,_), member(M,Moderators).
dayForEvent(E,D):-      event(E,_,Days), member(D,Days).
day(D):-                numDays(N), between(1,N,D).
moderator(M):-          numModerators(N), between(1,N,M).
nextevent(E,E2):-  numEvents(NumEvents), E3 is E+1, between(E3,NumEvents, E2).
consecutiveDays(D1,D2):-    numDays(N),  between(D1,N,D2).

%%%%%%  SAT Variables:


satVariable( ed(E,D) ):- event(E), day(D).        % ed(E,D) means "event E scheduled on day D"
satVariable( em(E,M) ):- event(E), moderator(M).  % en(E,N) means "event E assigned to moderator M"
satVariable( md(M,D) ):- moderator(M), day(D).    % md(M,D) means "moderator M works on day D"


writeClauses:-
    eachEventOnExactlyOneDay,
    eachEventOnlyOnAllowedDay,
    eachEventExactlyOneModerator,
    eachEventOnlyWithAllowedModerator,
    eachDayAtMostKEvents,
    eachDayAtLeastKEvents,
    secondrestriction,
    defineMD,
    eachModeratorAtMostKDays,
    true,!.                    % this way you can comment out ANY previous line of writeClauses
writeClauses:- told, nl, write('writeClauses failed!'), nl,nl, halt.

secondrestriction:- event(E), day(D), nextevent(E,E2), findall(ed(E2,D2), consecutiveDays(D,D2), Lits), Lits \= [], append([-ed(E,D)], Lits, R), writeClause(R), fail. 
secondrestriction.

eachEventOnExactlyOneDay:- 
    event(E), findall( ed(E,D), day(D), Lits ), exactly(1,Lits), fail.
eachEventOnExactlyOneDay.

eachEventOnlyOnAllowedDay:- 
    event(E), day(D), \+dayForEvent(E,D), writeClause([ -ed(E,D) ]), fail.
eachEventOnlyOnAllowedDay.


eachEventExactlyOneModerator:-
    event(E), findall( em(E,M), moderator(M), Lits ), exactly(1,Lits), fail.
eachEventExactlyOneModerator.

eachEventOnlyWithAllowedModerator:- 
    event(E), moderator(M), \+canModerateEvent(E,M), writeClause([ -em(E,M) ]), fail.
eachEventOnlyWithAllowedModerator.


eachDayAtMostKEvents:-
    maxEventsPerDay(Max), day(D), findall(ed(E,D), event(E), Lits), atMost(Max,Lits), fail.
eachDayAtMostKEvents.

eachDayAtLeastKEvents:-
    minEventsPerDay(Max), day(D), findall(ed(E,D), event(E), Lits), atLeast(Max,Lits), fail.
eachDayAtLeastKEvents.


defineMD:-
    moderator(M), day(D), event(E), writeClause([-ed(E,D), -em(E,M), md(M,D)]), fail.
defineMD.

eachModeratorAtMostKDays:-
    maxDaysPerModerator(Max), moderator(M), findall(md(M,D), day(D), Lits), atMost(Max,Lits), fail.
eachModeratorAtMostKDays.


%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% show the solution. Here M contains the literals that are true in the model:

displaySol(M):-
    day(D), nl, write('Day '), write(D), write(': '),
    findall(E-Mod,(member(ed(E,D),M), member(em(E,Mod),M)), L),
    member(E-Mod,L), write(' event('), write(E), write(')-mod('), write(Mod), write(') '), fail.
displaySol(M):-nl,
    moderator(Mod), nl, findall(D,(member(ed(E,D),M), member(em(E,Mod),M)), L),
    write('Moderator '), write(Mod), write( ' works: '), sort(L,L1), write(L1), fail.
displaySol(M):-nl,
    day(D), nl, write('Day '), write(D), write(' events: '),
    findall(E, member(ed(E,D),M), L), sort(L,L1), write(L1), fail.
displaySol(_).

%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Everything below is given as a standard library, reusable for solving 
%    with SAT many different problems.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Express that Var is equivalent to the disjunction of Lits:
expressOr( Var, Lits) :- symbolicOutput(1), write( Var ), write(' <--> or('), write(Lits), write(')'), nl, !. 
expressOr( Var, Lits ):- member(Lit,Lits), negate(Lit,NLit), writeClause([ NLit, Var ]), fail.
expressOr( Var, Lits ):- negate(Var,NVar), writeClause([ NVar | Lits ]),!.

% Express that Var is equivalent to the conjunction of Lits:
expressAnd( Var, Lits) :- symbolicOutput(1), write( Var ), write(' <--> and('), write(Lits), write(')'), nl, !. 
expressAnd( Var, Lits):- member(Lit,Lits), negate(Var,NVar), writeClause([ NVar, Lit ]), fail.
expressAnd( Var, Lits):- findall(NLit, (member(Lit,Lits), negate(Lit,NLit)), NLits), writeClause([ Var | NLits]), !.

%%%%%% Cardinality constraints on arbitrary sets of literals Lits:

exactly(K,Lits):- symbolicOutput(1), write( exactly(K,Lits) ), nl, !.
exactly(K,Lits):- atLeast(K,Lits), atMost(K,Lits),!.

atMost(K,Lits):- symbolicOutput(1), write( atMost(K,Lits) ), nl, !.
atMost(K,Lits):-   % l1+...+ln <= k:  in all subsets of size k+1, at least one is false:
	negateAll(Lits,NLits),
	K1 is K+1,    subsetOfSize(K1,NLits,Clause), writeClause(Clause),fail.
atMost(_,_).

atLeast(K,Lits):- symbolicOutput(1), write( atLeast(K,Lits) ), nl, !.
atLeast(K,Lits):-  % l1+...+ln >= k: in all subsets of size n-k+1, at least one is true:
	length(Lits,N),
	K1 is N-K+1,  subsetOfSize(K1, Lits,Clause), writeClause(Clause),fail.
atLeast(_,_).

negateAll( [], [] ).
negateAll( [Lit|Lits], [NLit|NLits] ):- negate(Lit,NLit), negateAll( Lits, NLits ),!.

negate( -Var,  Var):-!.
negate(  Var, -Var):-!.

subsetOfSize(0,_,[]):-!.
subsetOfSize(N,[X|L],[X|S]):- N1 is N-1, length(L,Leng), Leng>=N1, subsetOfSize(N1,L,S).
subsetOfSize(N,[_|L],   S ):-            length(L,Leng), Leng>=N,  subsetOfSize( N,L,S).


%%%%%% main:

main:-  symbolicOutput(1), !, writeClauses, halt.   % print the clauses in symbolic form and halt
main:-  initClauseGeneration,
	tell(clauses), writeClauses, told,          % generate the (numeric) SAT clauses and call the solver
	tell(header),  writeHeader,  told,
	numVars(N), numClauses(C),
	write('Generated '), write(C), write(' clauses over '), write(N), write(' variables. '),nl,
	shell('cat header clauses > infile.cnf',_),
	write('Calling solver....'), nl,
	shell('picosat -v -o model infile.cnf', Result),  % if sat: Result=10; if unsat: Result=20.
	treatResult(Result),!.

treatResult(20):- write('Unsatisfiable'), nl, halt.
treatResult(10):- write('Solution found: '), nl, see(model), symbolicModel(M), seen, displaySol(M), nl,nl,halt.
treatResult( _):- write('cnf input error. Wrote anything strange in your cnf?'), nl,nl, halt.
    

initClauseGeneration:-  %initialize all info about variables and clauses:
	retractall(numClauses(   _)),
	retractall(numVars(      _)),
	retractall(varNumber(_,_,_)),
	assert(numClauses( 0 )),
	assert(numVars(    0 )),     !.

writeClause([]):- symbolicOutput(1),!, nl.
writeClause([]):- countClause, write(0), nl.
writeClause([Lit|C]):- w(Lit), writeClause(C),!.
w(-Var):- symbolicOutput(1), satVariable(Var), write(-Var), write(' '),!. 
w( Var):- symbolicOutput(1), satVariable(Var), write( Var), write(' '),!. 
w(-Var):- satVariable(Var),  var2num(Var,N),   write(-), write(N), write(' '),!.
w( Var):- satVariable(Var),  var2num(Var,N),             write(N), write(' '),!.
w( Lit):- told, write('ERROR: generating clause with undeclared variable in literal '), write(Lit), nl,nl, halt.


% given the symbolic variable V, find its variable number N in the SAT solver:
var2num(V,N):- hash_term(V,Key), existsOrCreate(V,Key,N),!.
existsOrCreate(V,Key,N):- varNumber(Key,V,N),!.                            % V already existed with num N
existsOrCreate(V,Key,N):- newVarNumber(N), assert(varNumber(Key,V,N)), !.  % otherwise, introduce new N for V

writeHeader:- numVars(N),numClauses(C), write('p cnf '),write(N), write(' '),write(C),nl.

countClause:-     retract( numClauses(N0) ), N is N0+1, assert( numClauses(N) ),!.
newVarNumber(N):- retract( numVars(   N0) ), N is N0+1, assert(    numVars(N) ),!.

% Getting the symbolic model M from the output file:
symbolicModel(M):- get_code(Char), readWord(Char,W), symbolicModel(M1), addIfPositiveInt(W,M1,M),!.
symbolicModel([]).
addIfPositiveInt(W,L,[Var|L]):- W = [C|_], between(48,57,C), number_codes(N,W), N>0, varNumber(_,Var,N),!.
addIfPositiveInt(_,L,L).
readWord( 99,W):- repeat, get_code(Ch), member(Ch,[-1,10]), !, get_code(Ch1), readWord(Ch1,W),!. % skip line starting w/ c
readWord(115,W):- repeat, get_code(Ch), member(Ch,[-1,10]), !, get_code(Ch1), readWord(Ch1,W),!. % skip line starting w/ s
readWord(-1,_):-!, fail. %end of file
readWord(C,[]):- member(C,[10,32]), !. % newline or white space marks end of word
readWord(Char,[Char|W]):- get_code(Char1), readWord(Char1,W), !.
%========================================================================================
