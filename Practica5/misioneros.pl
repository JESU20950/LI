solucionOptima:- nat(N), % Buscamos solución de "coste" 0; si no, de 1, etc.
                camino([3,3,false],[0,0,true],[[3,3,false]],C), % En "hacer aguas": -un estado es [cubo5,cubo8], y
                length(C,N),% -el coste es la longitud de C.
                write(C).



camino( E,E, C,C ).
camino( EstadoActual, EstadoFinal, CaminoHastaAhora, CaminoTotal ):-
                            unPaso( EstadoActual, EstSiguiente ), 
                            \+member(EstSiguiente,CaminoHastaAhora),
                            camino( EstSiguiente, EstadoFinal, [EstSiguiente|CaminoHastaAhora], CaminoTotal ).



nat(0).
nat(N):- nat(N2), N is N2+1.

is_correct(3,_):-!.
is_correct(0,_):-!.
is_correct(X,Y):- X>=Y, Xaux is 3-X, Yaux is 3-Y, Xaux >= Yaux.                            
                            
%llevar personas a isla 2

%un misionero
unPaso([X,Y,false], [W,Y,true]):- X >=1, W is  X-1, is_correct(W,Y).
%un canibal
unPaso([X,Y,false], [X,Z,true]):- Y >=1 , Z is Y-1, is_correct(X,Z).
%misionero canibal
unPaso([X,Y,false], [W,Z,true]):- X >=1 , Y>=1 , W is X-1, Z is Y-1, is_correct(W,Z).
%misionero misionero
unPaso([X,Y,false], [W,Y,true]):- X >=2 , W is X-2, is_correct(W,Y).
%canibal canibal
unPaso([X,Y,false], [X,Z,true]):- Y >=2 , Z is Y-2, is_correct(X,Z).


%llevar personas a isla 1


%un misionero
unPaso([X,Y,true], [W,Y,false]):-  Xaux is 3-X, Xaux >=1,   W is  X+1, is_correct(W,Y).
%un canibal
unPaso([X,Y,true], [X,Z,false]):-  Yaux is 3-Y , Yaux >=1 ,    Z is Y+1, is_correct(X,Z).
%misionero canibal
unPaso([X,Y,true], [W,Z,false]):-  Yaux is 3-Y, Xaux is 3-X, Xaux >=1 , Yaux >=1 ,  W is X+1, Z is Y+1, is_correct(W,Z).
%misionero misionero
unPaso([X,Y,true], [W,Y,false]):-   Xaux is 3-X, Xaux >=2 ,    W is X+2, is_correct(W,Y).
%canibal canibal
unPaso([X,Y,true], [X,Z,false]):- Yaux is 3-Y , Yaux >=2 , Z is Y+2, is_correct(X,Z).
