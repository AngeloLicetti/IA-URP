domains
	ls = symbol*

database
	regla(ls)
	obj(symbol)
	xpos(symbol)
	xneg(symbol)
	
predicates
	ejecuta(symbol)
	procede(ls)
	imprime_resultado
	encadenamiento(symbol)
	prueba_y(ls)
	prueba_reglas(symbol)

clauses
	ejecuta(Na) :-
		existfile(Na), !,
		consult(Na),
		procede([zebra,jirafa,guepardo,tigre]),
		imprime_resultado.
	ejecuta(Na) :-
		write("no existe el archivo ", Na).
		
	procede([]) :-
		retract(obj(_)), !.
	procede([]) :- !.
	procede([Obj|_]) :-
		assert(obj(Obj)),
		encadenamiento(Obj), !.
	procede([Obj|T]) :-
		retract(obj(Obj)), !,
		procede(T).

	encadenamiento(Obj) :-
		xpos(Obj), !.
	encadenamiento(Obj) :-
		xneg(Obj), !, fail.
	encadenamiento(Obj) :-
		regla([Obj|_]), !,
		prueba_reglas(Obj),
		%prueba_y(T),
		assert(xpos(Obj)).
	encadenamiento(Obj) :-
		regla([Obj|_]), !,
		assert(xneg(Obj)), fail.
	encadenamiento(Obj) :-
		write(Obj, "? "),
		readchar(C),
		write(C), nl,
		C = 's', !,
		assert(xpos(Obj)).
	encadenamiento(Obj) :-
		assert(xneg(Obj)),
		fail.
		
	prueba_reglas(Obj) :-
		regla([Obj|T]),	%backtracking
		prueba_y(T), !.
		
	prueba_y([]) :- !.
	prueba_y(["*no*",H|T]) :-
		NOT(encadenamiento(H)), !,
		prueba_y(T).
	prueba_y(["*no*",_|_]) :- !, fail.
	prueba_y([H|T]) :-
		encadenamiento(H), !,
		prueba_y(T).

	imprime_resultado :-
		obj(Obj), !,
		write("el objetivo puede ser ", Obj).
	imprime_resultado :-
		write("no se pudo alcanzar un objetivo").
goal
  %write("nombre de archivo: "),
  %readln(Na),
  ejecuta("C:\\Users\\Pc\\source\\repos\\urp-code\\ia\\e_regresivo\\anim.dat").