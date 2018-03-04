%Practica6, Santiago Rincón Martínez

%hechos para definir estados inicial y objetivos (el estado representa la cantidad de arena en la parte superior de cada reloj)

estado_inicial(0, 0).

%objetivos: todos los estados con 3 minutos en alguna parte de algún reloj
estado_objetivo(estado(3,_)).
estado_objetivo(estado(_,3)).
estado_objetivo(estado(4,_)).
estado_objetivo(estado(_,8)).


%reglas para definir los movimientos

%girar el primer reloj
movimiento(estado(X,Y), estado(W,Y), "gira el primer reloj", 0) :-
  W is 7-X.

%girar el segundo reloj
movimiento(estado(X,Y), estado(X,W), "gira el segundo reloj", 0) :-
  W is 11-Y.

%girar ambos hasta que uno pare, con los casos de que X sea menor o igual que Y o lo contrario
movimiento(estado(X,Y), estado(0, W), "dejar caer la arena hasta que uno acabe", X) :-
  X =< Y,
  W is Y-X.
movimiento(estado(X,Y), estado(W, 0), "dejar caer la arena hasta que uno acabe", Y) :-
  X > Y,
  W is X-Y.

%metarreglas para encontrar la solución, aplicando el resto de reglas. Para la traza de movimientos realizados utilizo el método visto en clase.
%Para contabilizar el tiempo utilizo una variable de entrada que se va unificando con el tiempo transcurrido en las llamadas sucesivas para en el caso base unificar la variable de salida con la anterior.

busca_camino(estado(X,Y), _, [],Tent, Tsal) :- %caso base, fija el tiempo como tiempo de salida
  estado_objetivo(estado(X,Y)),
  Tsal is Tent.

busca_camino(estado(X,Y), Visitados, [Operador|Operadores], Tent, Tsal) :- %caso recursivo,va acumulando la suma de tiempos consumidos en el tiempo de entrada
  movimiento(estado(X,Y), estado(Z,W), Operador, G),
  \+ member(estado(Z,W), Visitados),
  Taux is Tent+G,
  busca_camino(estado(Z,W), [estado(Z,W)|Visitados], Operadores, Taux, Tsal).


%metarregla para inicializar la búsqueda, lanzarla y recoger y notificar la salida. Con I/O.
busca :-
  estado_inicial(X,Y),
  busca_camino(estado(X,Y), [estado(X,Y)], Operadores, 0, T),
  write("SOLUCION ENCONTRADA"),
  nl,
  write("Se debe seguir la secuencia: "),
  write(Operadores),
  nl,
  write("Mediante ésta se termina el proceso en tiempo: "),
  write(T).
