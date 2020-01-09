%Exercici2
prod([X],X):-!.
prod([X|L],P):- prod(L,P2), P is P2*X. 
%Exercici3
pescalar([X],[X2],R):- R is X*X2,!. 
pescalar([X|L1],[X2|L2],R):-pescalar(L1,L2,R2), R is R2+X*X2.
%Exercici4
interseccion([],_,[]):-!.
interseccion([X|L1],L2,[X|R]):- member(X,L2), interseccion(L1,L2,R),!.
interseccion([_|L1],L2,R):- interseccion(L1,L2,R).

union([],L,L):-!.
union([X|L1],L2,[X|R]):- not(member(X,L2)), union(L1,L2,R),!.
union([_|L1],L2,R):- union(L1,L2,R).

%Exercici5 
ultimolista(L,X):- append(_,[X],L),!.

inversolista([],[]):-!.
inversolista(L,[X|L2]):- append(L1,[X], L) , inversolista(L1,L2). 

%Exercici6
fib(1, 1):-!.
fib(2, 1):-!.
fib(N,S):- N1 is N-1, N2 is N-2, fib(N1,S1), fib(N2,S2), S is S1+S2.

%Exercici7


dados(0,0,[]):-!.
dados(P,N,[X|L]):- member(X,[1,2,3,4,5,6]), N2 is N-1, P2 is P-X, P2>= 0, dados(P2, N2, L).   


%Exercici8

suma_demas(L) :- suma_lista(L,S), suma_demas_aux(L,S).

suma_demas_aux([X|_],S) :- X is S-X, !.
suma_demas_aux([_|L],S):- suma_demas_aux(L,S).

suma_lista([X], X):-!.
suma_lista([X|L],R):- suma_lista(L,R2), R is X+R2.

%Exercici9

suma_ants(L):- suma_ants_aux(0,L).

suma_ants_aux(R,[R|_]):-!.
suma_ants_aux(R,[X|L]):- R2 is R+X, suma_ants_aux(R2, L).

%Exercici10
%card( [1,2,1,5,1,3,3,7] ).

card(L):- card_aux(L,R), write(R).

card_aux([],[]):-!.
card_aux([X|L], [[X,S]|R]):- numero_aparciones(X, [X|L], S), lista_sin_X(X, L, W), card_aux(W,R).

numero_aparciones(_, [], 0):-!.
numero_aparciones(X, [X|L], S):- numero_aparciones(X, L, S2), S is S2+1,!.
numero_aparciones(X, [_|L], S):- numero_aparciones(X, L, S).


lista_sin_X(_, [], []):-!.
lista_sin_X(X, [X|L] , W):- lista_sin_X(X,L,W),!.
lista_sin_X(X, [Y|L], [Y|W]):- lista_sin_X(X,L,W).

%Exercici11
%esta_ordenada([3,67,45]).
esta_ordenada([_]):-!.
esta_ordenada([X,Y|L]):- X=<Y, esta_ordenada([Y|L]).

%Exercici12

permutacion([],[]):-!.
permutacion(L1,[X|L]):- append(L4,[X|L5],L1), append(L4,L5,L6), permutacion(L6,L).

ordenacion(L1,L2):- permutacion(L1,L2), esta_ordenada(L2),!.

%Exercici14

insercion(X,[],[X]):-!.
insercion(X,[Y|L1],[X,Y|L1]):- X<Y,!.
insercion(X,[Y|L1],[Y|L2]):-insercion(X,L1,L2). 

ordenacion_insercion([],[]):-!.
ordenacion_insercion([X|L1],L4):- ordenacion_insercion(L1,L3), insercion(X,L3,L4).   

%Exercici16
ordenacion_merge_sort([],[]):-!.
ordenacion_merge_sort([X],[X]):-!.
ordenacion_merge_sort(L1,S3):- append(L3,L4,L1), length(L1, Length), Length2 is integer(Length/2),  length(L3,Length2), ! , ordenacion_merge_sort(L3,S1), ordenacion_merge_sort(L4,S2), merge(S1,S2,S3).

merge([],L1,L1):-!.
merge(L1,[],L1):-!.
merge([X|L1],[Y|L2],[X|L3]):- X<Y, merge(L1,[Y|L2],L3),!.
merge([X|L1],[Y|L2],[Y|L3]):- merge([X|L1],L2, L3).


%Exercici17
%diccionario( [ga,chu,le],2)
nmembers(_,0,L):- write_word(L), nl,!,fail.
nmembers(A,N,L):- member(X,A), N2 is N-1, append(L,[X],L2), nmembers(A,N2,L2).
diccionario(A,N):- nmembers(A,N,[]).


write_word(L):- member(X,L), write(X),fail.
write_word(_).

%Exercici17
%d(X,X,1).
%d(C,X,0):- atomic(C)
%d(A+B,X,U+V):- d(A,X,U), D(B,X,V).
%d(A*B,X,A*V+B*U):-  d(A,X,U), D(B,X,V).

%Exercici18
%palindromos([a,a,c,c])
palíndromos(L):- permutacion(L,R), inversolista(R, R2), R = R2, write(R).

%Exercici19

iscorrect([S,E,N,D,M,O,R,Y]):- getexpression([S,E,N,D],T), getexpression([M,O,R,Y],T2), getexpression2([M,O,N,E,Y],T3),T3 is T+T2.

getexpression([X,Y,Z,W] , T):- T is X*1000+Y*100+Z*10+W.
getexpression2([V,X,Y,Z,W],T):- T is V*10000+X*1000+Y*100+Z*10+W.
sendmoryaux(0,R):- !, iscorrect(R), write(R), nl, fail.
sendmoryaux(N,R):- between(0,9,X), N2 is N-1, sendmoryaux(N2, [X|R]).
sendmory:- sendmoryaux(8,[]).








