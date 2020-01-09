programa([begin|L]):- append(Instrucciones,[end], L), instrucciones(Instrucciones),!.
instrucciones(Instrucciones):-instruccion(Instrucciones).
instrucciones(Instrucciones):- append(Instruccion, [;|Instrucciones2],Instrucciones), instruccion(Instruccion), instrucciones(Instrucciones2).




instruccion([X,=,Y,+,Z]):-variable(X),variable(Y), variable(Z).


instruccion([if,X,=,Y,then|L]):-variable(X), variable(Y), append(Instruccion,[else|Instrucciones2],L), instrucciones(Instruccion), append(Instrucciones3,[endif],Instrucciones2),
instrucciones(Instrucciones3).

variable(x).
variable(y).
variable(z).

% programa( [begin, z, =, x, +, y, end] ).
% programa( [begin, z, =, x, +, y, ;, x, =, z, z, end] ).
% programa( [begin, x,=,y,+,z,;, if, z,=,z, then, x,=,x,+,z,;, y,=,y,+,z, else, z,=,z,+,y, endif,;, x,=,x,+,z, end]).
