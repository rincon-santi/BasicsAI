%Practica6, Santiago Rincón Martínez

%hechos

%clasificacion de las enfermedades
tipo_enfermedad("meningitis bacteriana", "infecciosa bacteriana").
tipo_enfermedad("faringitis bacteriana", "infecciosa bacteriana").
tipo_enfermedad("rinitis alergica", "alergica").

%clasificacion de los componentes
tipo_componente("triprolidina", "antihistaminico").
tipo_componente("ebastina", "antihistaminico").
tipo_componente("amoxicilina", "antibiotico").
tipo_componente("ampicilina", "antibiotico").
tipo_componente("paracetamol", "analgesico").
tipo_componente("metoclopramida", "antiemetico").
tipo_componente("acidoacetilsalicilico", "analgesico").

%ingredientes de los medicamentos
ingrediente("iniston", "triprolidina").
ingrediente("clamoxil", "amoxicilina").
ingrediente("gelocatil", "paracetamol").
ingrediente("ebastel", "ebastina").
ingrediente("britapen", "ampicilina").
ingrediente("primperan", "metoclopramida").

%tratamientos enfermedades diagnosticadas
tratamiento("infecciosa bacteriana", "antibiotico").
tratamiento("alergica", "antihistaminico").

%tipos de componentes para paliar sintomas
alivio("fiebre", "analgesico").
alivio("dolor de cabeza", "analgesico").
alivio("congestion nasal", "antihistaminico").
alivio("congestion ocular", "antihistaminico").

%reglas

%para diagnosticar enfermedades
diagnosticada("rinitis alergica") :-
  sintoma("picor de nariz"),
  sintoma("congestion nasal"),
  sintoma("congestion ocular").

diagnosticada("faringitis bacteriana") :-
  sintoma("dolor de garganta"),
  sintoma("fiebre"),
  sintoma("malestar").

diagnosticada("meningitis bacteriana") :-
  sintoma("fiebre"),
  sintoma("dolor de cabeza"),
  sintoma("rigidez en la nuca"),
  sintoma("nauseas").

diagnosticada("meningitis bacteriana") :-
  sintoma("fiebre"),
  sintoma("dolor de cabeza"),
  sintoma("rigidez en la nuca"),
  sintoma("vomitos").

%para decidir tratamiento de una enfermedad diagnosticada
medicina_recomendada(X, Z) :-
  tipo_enfermedad(X, Y),
  tratamiento(Y, W),
  tipo_componente(C, W),
  ingrediente(Z, C).

%para ver si puede tomar un medicamento
permitido(Y) :-
  \+perm_aux(Y).
perm_aux(Y) :-
  ingrediente(Y, Z),
  alergia(Z).

%reglas de lectura de sintomas y alergias (una es sobre sintomas y otra sobre componentes, por lo que no se solapan) (I/O) (Usando los métodos vistos en clase)
sintoma(X) :-
  pregunta_si(X).

alergia(X) :-
  pregunta_si_b(X).

pregunta_si(X) :-
  confirma(X, R),
  respuesta_positiva(X, R).

pregunta_si_b(X) :-
  confirma_b(X, R),
  respuesta_positiva(X, R).

:- dynamic preguntado/2.

confirma(X, R) :-
  preguntado(X, R).
confirma(X, R) :-
  \+preguntado(X,R),
  nl,
  write("¿Sientes "),
  write(X),
  write("? (si(s)/no(n)) "),
  read(R),
  asserta(preguntado(X, R)).

confirma_b(X, R) :-
  preguntado(X, R).
confirma_b(X, R) :-
  \+preguntado(X,R),
  nl,
  write("¿Tienes alergia a "),
  write(X),
  write("? (si(s)/no(n)) "),
  read(R),
  asserta(preguntado(X, R)).

respuesta_positiva(_, R) :- afirmativo(R).
respuesta_positiva(X, R) :-
  \+afirmativo(R),
  \+negativo(R),
  write("Por favor, conteste si/s o no/n y termine con .: "),
  read(R2),
  retract(preguntado(X,R)),
  asserta(preguntado(X,R2)),
  respuesta_positiva(X,R2).

%hechos auxiliares para la lectura de sintomas y alergias
afirmativo(si).
afirmativo(s).
negativo(no).
negativo(n).

%metarreglas

%metarreglas para tratar y paliar. Aplican las reglas pertinentes. I/O.
tratar :-
  diagnosticada(X),
  medicina_recomendada(X, M),
  permitido(M),
  write("Hemos visto que tienes la siguiente enfermedad: "),
  write(X),
  nl,
  write("Te recomendamos tratarla con: "),
  write(M).

paliar :-
    alivio(X, Y),
    sintoma(X),
    tipo_componente(C, Y),
    ingrediente(Z, C),
    permitido(Z),
    write("Para paliar "),
    write(X),
    write(" te recomendamos tratarlo con: "),
    write(Z).

%metarregla de recomendacion, para disparar el proceso, borrando lo primero lo assertado antes
recomendacion :-
  retractall(preguntado(X,Y)),
  tratar.

recomendacion :-
  paliar.

recomendacion :-
  write ("No somos capaces de recetarte nada, te recomendamos que acudas presurosamente a un centro médico").
