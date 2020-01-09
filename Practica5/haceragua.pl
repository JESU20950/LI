%%%%%Hacer Aguas
solucionOptima:- nat(N), % Buscamos solución de "coste" 0; si no, de 1, etc.
                camino([0,0],[0,4],[[0,0]],C), % En "hacer aguas": -un estado es [cubo5,cubo8], y
                length(C,N), % -el coste es la longitud de C.
                write(C).

nat(0).
nat(N):- nat(N1), N is N1+1.

camino( E,E, C,C ):-!.
camino( EstadoActual, EstadoFinal, CaminoHastaAhora, CaminoTotal ):-
unPaso( EstadoActual, EstSiguiente ),
\+member(EstSiguiente,CaminoHastaAhora),
camino( EstSiguiente, EstadoFinal, [EstSiguiente|CaminoHastaAhora], CaminoTotal ).

unPaso([_,Y],[0,Y]).
unPaso([X,_],[X,0]).
unPaso([_,Y],[5,Y]).
unPaso([X,_],[X,8]).
%verter cubo1 a cubo2
unPaso([Cubo1,Cubo2],[Cubo1r,8]):-  (8-Cubo2) =< Cubo1, Cubo1r is Cubo1-(8-Cubo2).
unPaso([Cubo1,Cubo2],[0,Cubo2r]):- (8-Cubo2) > Cubo1,  Cubo2r is Cubo2+Cubo1.



%verter cubo2 a cubo1

unPaso([Cubo1,Cubo2],[5,Cubo2r]):-  (Cubo1+Cubo2) >= 5, Cubo2r is Cubo2-(5-Cubo1).
unPaso([Cubo1,Cubo2],[Cubo1r,0]):- (Cubo1+Cubo2) < 5, Cubo1r is Cubo2+Cubo1.



