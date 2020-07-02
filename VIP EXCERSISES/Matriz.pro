domains
  list = integer*
  matrix = list*

predicates
  rotar(matrix,integer,integer,integer,integer,matrix) - nondeterm (i,i,i,i,i,o)
  selecciona_fila(matrix,integer,integer,integer,integer,list) - nondeterm (i,i,i,i,i,o)
  size(list,integer) - nondeterm(i,o)
  append(list,list,list) - nondeterm(i,i,o)
  rotar_fila_en_p(list,integer,integer,integer,list) - nondeterm(i,i,i,i,o)
  incrementar(integer,integer) - nondeterm(i,o)
  rotar_izquierda(list,integer,integer,list) - nondeterm(i,i,i,o)
  rotar_derecha(list,integer,list) - nondeterm(i,i,o)
  nuevo_valor(integer,integer,integer) - nondeterm(i,i,o)
  rotar_lista(list,integer,integer,list) - nondeterm(i,i,i,o)
  reemplazar_fila(matrix,integer,integer,list,matrix) - nondeterm(i,i,i,i,o)
  selecciona_columna(matrix,integer,integer,integer,list) - nondeterm(i,i,i,i,o)
  extraer_columna(list,integer,integer,integer,integer) - nondeterm(i,i,i,i,o)
  rotar_columna_en_p(list,integer,integer,integer,list) - nondeterm(i,i,i,i,o)
  rotar_arriba(list,integer,integer,list) - nondeterm(i,i,i,o)
  rotar_abajo(list,integer,list) - nondeterm(i,i,o)
  reemplazar_columna(matrix,list,integer,integer,integer,matrix) - nondeterm(i,i,i,i,i,o)
  modificar_fila(list,integer,integer,integer,integer,list) - nondeterm(i,i,i,i,i,o)
  imprimir_matriz(matrix,symbol) - nondeterm(i,i)
  seleccionar_fila(matrix) - nondeterm(i)
  imprimir_fila(list) - nondeterm(i)

clauses
  rotar([],_,_,_,_,[]):- 
  	write("Matriz vacía"),!.
  rotar(M,FC,X,P,D,NM):- 
  	X=1,
  	selecciona_fila(M,FC,0,P,D,NF),
  	reemplazar_fila(M,FC,0,NF,NM),!.
  rotar([H|T],FC,X,P,D,NM):-
  	X=2,
  	size(H,S),
  	selecciona_columna([H|T],FC,0,S,NL),
  	rotar_columna_en_p(NL,S,P,D,NC),
  	reemplazar_columna([H|T],NC,FC,0,S,NM),!.
  
  selecciona_fila([H|_],FC,I,P,D,NF):- 
  	FC=I,
  	size(H,S),
  	rotar_fila_en_p(H,S,P,D,NF),!.
  selecciona_fila([_|T],FC,I,P,D,NF):-
  	incrementar(I,NI),
  	selecciona_fila(T,FC,NI,P,D,NF).
  	
  size([],0):-!.
  size([_|T],S):-
  	size(T,NS),
  	incrementar(NS,S).
  	
  incrementar(I,NI):-
  	NI=I+1.

  rotar_fila_en_p(F,S,P,D,NF):- 
    	D=1,
    	rotar_izquierda(F,S,P,NF).
  rotar_fila_en_p(F,_,P,D,NF):- 
    	D=2,
    	rotar_derecha(F,P,NF).

  rotar_derecha(L,P,NF):-
    	rotar_lista(L,P,0,NF),!.
    	
  rotar_izquierda(L,S,P,NF):-
    	nuevo_valor(P,S,C),
    	rotar_lista(L,C,0,NF),!.
    	
  nuevo_valor(P,S,C):-
  	C=S-P.
    	
  rotar_lista([H|T],C,I,NL):-
    	I<C,
    	incrementar(I,NI),
    	append(T,[H],NT),
    	rotar_lista(NT,C,NI,NL).
  rotar_lista(L,C,I,NL):-
    	I=C,
    	NL=L,!.
    	
  append([],L,L).
  append([H|T],L,[H|R]):-
  	append(T,L,R).

  reemplazar_fila([H|T],FC,I,NF,[H1|T1]):-
    	I<FC,
    	incrementar(I,NI),
    	H1=H,
    	reemplazar_fila(T,FC,NI,NF,T1).
  reemplazar_fila([_|T],FC,I,NF,[H1|T1]):-
    	FC=I,
    	H1=NF,
    	T1=T,!.
    	
  selecciona_columna([H|_],FC,I,S,NC):-
  	nuevo_valor(1,S,U),
  	I=U,
  	extraer_columna(H,FC,0,S,EC),
  	NC=[EC],!.
  selecciona_columna([H|T],FC,I,S,[H1|T1]):-
  	I<S,
  	incrementar(I,NI),
  	extraer_columna(H,FC,0,S,EC),
  	H1=EC,
  	selecciona_columna(T,FC,NI,S,T1).
 
  extraer_columna([_|T],FC,I,S,EC):-
  	I<S,
  	incrementar(I,NI),
  	extraer_columna(T,FC,NI,S,EC).
  extraer_columna([H|_],FC,I,_,EC):-
  	FC=I,
  	EC=H,!.
  	
  rotar_columna_en_p(C,S,P,D,NC):- 
    	D=1,
    	rotar_arriba(C,S,P,NC).
  rotar_columna_en_p(C,_,P,D,NC):- 
    	D=2,
    	rotar_abajo(C,P,NC).

  rotar_arriba(L,S,P,NC) :-
  	nuevo_valor(P,S,C),
  	rotar_lista(L,C,0,NC),!.

  rotar_abajo(L,P,NC):-
    	rotar_lista(L,P,0,NC),!.
    
  reemplazar_columna([H|_],[HC|_],FC,I,S,NM):-
  	nuevo_valor(1,S,U),
  	I=U,
  	modificar_fila(H,HC,FC,0,S,NF),
  	NM=[NF],!.
  reemplazar_columna([H|T],[HC|TC],FC,I,S,[H1|T1]):-
  	I<S,
  	incrementar(I,NI),
  	modificar_fila(H,HC,FC,0,S,NF),
  	H1=NF,
  	reemplazar_columna(T,TC,FC,NI,S,T1).
 
  modificar_fila([_|_],EC,FC,I,S,NF):-
    	nuevo_valor(1,S,U),
    	I=U,
    	FC=I,
    	NF=[EC],!.
  modificar_fila([H|_],_,_,I,S,NF):-
    	nuevo_valor(1,S,U),
    	I=U,
    	NF=[H],!.
  modificar_fila([_|T],EC,FC,I,S,[H1|T1]):-
  	FC=I,
  	incrementar(I,NI),
  	H1=EC,
  	modificar_fila(T,EC,FC,NI,S,T1).
  modificar_fila([H|T],EC,FC,I,S,[H1|T1]):-
  	I<S,
  	incrementar(I,NI),
  	H1=H,
  	modificar_fila(T,EC,FC,NI,S,T1).
  	
  imprimir_matriz(M,E):-
  	write(E),nl,
  	seleccionar_fila(M),!.
  	
  seleccionar_fila([]):-
  	nl,!.
  seleccionar_fila([H|T]):-
  	imprimir_fila(H),
  	seleccionar_fila(T).
  
  imprimir_fila([]):-
  	nl,!.
  imprimir_fila([H|T]):-
  	write(H),write("\t"),
  	imprimir_fila(T).
  	
goal
  M=[[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15],[16,17,18,19,20],[21,22,23,24,25]],
  FC=1,
  X=2,
  P=3,
  D=2, 
  rotar(M,FC,X,P,D,NM),
  imprimir_matriz(M,"Antes"),
  imprimir_matriz(NM,"Despues").