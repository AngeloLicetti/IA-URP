;BAGGER.LSP: PROGRAMA DE AGENTE REFLEJO SIMPLE.
;PROGRAMA DE ENCADENAMIENTO PROGRESIVO.
;POR FINES PRACTICOS PARA LA INSTRUCCION, MANEJA UNA BASE DE CONOCIMIENTOS
;INCORPORADA AL MISMO CODIGO.
;EL CONOCIMIENTO PUEDE TRASLADARSE A ARCHIVOS.

(defun EMPACA ()
  (DO ((BC (lee_bc)) (PASO 'INIC))
      (progresivo)
      ((eq PASO '*fin*))))

(defun PROGRESIVO (B R)
  (setq B BC)
  (loop ((null B) NIL)
	(setq R (pop B))
	((apply 'AND (car R))
	 (apply 'PROGN (cdr R)))))

(defun LEE_BC ()
  (defun SIG_P (P)
    ( ((setq P (car (intersection LPE GRANDES))))
      ((setq P (car (intersection LPE MEDIANOS))))
      ((setq P (car (intersection LPE CHICOS)))) )
    ((null P) NIL)
    (setq LPE (remove P LPE))
    (car P))

  (defun mensaje L
    ((null L) NIL)
    (terpri)
    (loop ((null L))
	  (princ (pop L))))

  '( (((not (eq PASO 'INIC))			;antecedentes	{ 1 }
       (not (eq PASO 'VO))
       (not (eq PASO 'EPG))
            (eq PASO 'EPM)
	    (member SP MEDIANOS)
	    (< CPB 12)
	    (member SP CONGELADOS)
            (eq EE 'T))
      (incq CPB)				;consecuentes
      (push SP BOLSA)
      (setq SP (sig_p))
      (setq EE NIL))

     (((not (eq PASO 'INIC))			;antecedentes   { 2 }
       (not (eq PASO 'VO))
       (not (eq PASO 'EPG))
            (eq PASO 'EPM)
	    (member SP MEDIANOS)
	    (< CPB 12)
	    (member SP CONGELADOS))
      (setq EE 'T))				;consecuentes

     (((not (eq PASO 'INIC))			;antecedentes   { 3 }
       (not (eq PASO 'VO))
       (not (eq PASO 'EPG))
            (eq PASO 'EPM)
	    (member SP MEDIANOS)
	    (< CPB 12))
      (incq CPB)				;consecuentes
      (push SP BOLSA)
      (setq SP (sig_p)))

     (((not (eq PASO 'INIC))			;antecedentes   { 4 }
       (not (eq PASO 'VO))
       (not (eq PASO 'EPG))
            (eq PASO 'EPM)
       (not (zerop CPB)))
      (mensaje N-BOLSA ") " BOLSA)		;consecuentes
      (setq BOLSA '())
      (incq N-BOLSA)
      (setq CPB 0))

     (((not (eq PASO 'INIC))			;antecedentes   { 5 }
       (not (eq PASO 'VO))
       (not (eq PASO 'EPG))
            (eq PASO 'EPM))
      (setq PASO 'EPCH))			;consecuentes

     (((not (eq PASO 'INIC))			;antecedentes   { 6 }
       (not (eq PASO 'VO))
       (not (eq PASO 'EPG))
            (eq PASO 'EPCH)
	    (member SP CHICOS)
	    (< CPB 18))
      (incq CPB)				;consecuentes
      (push SP BOLSA)
      (setq SP (sig_p)))

     (((not (eq PASO 'INIC))			;antecedentes   { 7 }
       (not (eq PASO 'VO))
       (not (eq PASO 'EPG))
            (eq PASO 'EPCH)
	    (member SP CHICOS))
      (mensaje N-BOLSA ") " BOLSA)		;consecuentes
      (setq BOLSA '())
      (incq N-BOLSA)
      (setq CPB 0))

     (((not (eq PASO 'INIC))			;antecedentes   { 8 }
       (not (eq PASO 'VO))
       (not (eq PASO 'EPG))
            (eq PASO 'EPCH)
	    (> CPB 0))
      (mensaje N-BOLSA ") " BOLSA)		;consecuentes
      (setq PASO '*fin*))

     (((not (eq PASO 'INIC))			;antecedentes   { 9 }
       (not (eq PASO 'VO))
       (not (eq PASO 'EPG))
            (eq PASO 'EPCH))
      (setq PASO '*fin*))			;consecuentes

     (((not (eq PASO 'INIC))			;antecedentes   { 10 }
       (not (eq PASO 'VO))
            (member SP GRANDES)
            (< CPB 6)
       (not (member SP BOTELLAS))
       (intersection LPE (intersection GRANDES BOTELLAS)))
      (nconc LPE (list SP))			;consecuentes
      (setq SP (sig_p)))

     (((not (eq PASO 'INIC))			;antecedentes   { 11 }
       (not (eq PASO 'VO))
            (member SP GRANDES)
            (< CPB 6))
      (incq CPB)				;consecuentes
      (push SP BOLSA)
      (setq SP (sig_p)))

     (((not (eq PASO 'INIC))			;antecedentes   { 12 }
       (not (eq PASO 'VO))
       (not (zerop CPB)))
      (mensaje N-BOLSA ") " BOLSA)		;consecuentes
      (setq BOLSA '())
      (incq N-BOLSA)
      (setq CPB 0))

     (((not (eq PASO 'INIC))			;antecedentes   { 13 }
       (not (eq PASO 'VO)))
      (setq PASO 'EPM))				;consecuentes

     (((not (eq PASO 'INIC))			;antecedentes   { 14 }
            (member 'PAPAS-FRITAS LPE)
       (not (member 'PEPSI LPE))
            (progn (mensaje "quiere pepsi (S/N)? ")
                   (member (read) (list "S" "s"))))
      (push 'PEPSI LPE)				;consecuentes
      (setq PASO 'EPG))

     (((not (eq PASO 'INIC)))			;antecedentes   { 15 }
      (setq PASO 'EPG))				;consecuentes

     (()					;antecedentes	{ 16 }
      (setq BOLSA '())
      (setq N-BOLSA 1)
      (setq CPB 0)
      (setq LPE '(ACEITE AJO-MOLIDO ARROZ AVENA AZUCAR
		  BALDE BETUN
		  CEPILLO-DE-DIENTES CEPILLO-DE-ROPA CEPILLO-DE-ZAPATOS
		    CHAMPU CHATA-DE-RON CIGARROS COCACOLA
		    CUCHILLAS-DE-AFEITAR
		  DESINFECTANTE DESODORANTE
		  FANTA FELPUDO FIDEOS FOCO FREJOLES
		  GRANOLA
		  HELADO HILO-DENTAL
		  INCACOLA
		  JABON
		  LEJIA LENTEJAS
		  MANTEQUILLA MANTEQUILLA-DE-MANI MAQUINA-DE-AFEITAR MELON
		    MOSTAZA
		  PALLARES PAN PANETON PAPALLA PAPAS-FRITAS PASTA-DE-DIENTES
		    PAVO PILA
		  QUESO
		  SANDIA SPRITE
                  TORTA-HELADA
		  VAINILLA VINAGRE VINO
		  WISKY
		  YOGURT
		  ZAPALLO ZARDINAS))
      (setq CONGELADOS '(HELADO TORTA-HELADA))
      (setq BOTELLAS '(CHATA-DE-RON COCACOLA FANTA INCACOLA PEPSI SPRITE
		       VINO WISKY))
      (setq GRANDES '(BALDE
		      CANASTA COCACOLA
		      FANTA FELPUDO
		      GRANOLA
		      INCACOLA
		      MELON
		      PANETON PAPALLA PEPSI PAVO
		      SANDIA SPRITE
		      VINO
		      WISKY
		      ZAPALLO))
      (setq MEDIANOS '(ACEITE ACIDO-MURIATICO ARROZ AVENA AZUCAR
		       CHAMPU
		       DESINFECTANTE
                       FIDEOS FREJOLES
		       HELADO
		       LEJIA LENTEJAS
		       PALLARES PAN PAPAS-FRITAS
		       QUESO
                       TORTA-HELADA
		       VINAGRE))
      (setq CHICOS '(AJO-MOLIDO ATUN
		     BETUN
		     CHATA-DE-RON CEPILLO-DE-DIENTES CEPILLO-DE-ROPA
		       CEPILLO-DE-ZAPATOS CIGARROS CUCHILLAS-DE-AFEITAR
		     DESODORANTE
		     FOCO
		     HILO-DENTAL
		     JABON
		     MANTEQUILLA MANTEQUILLA-DE-MANI MAQUINA-DE-AFEITAR
		       MOSTAZA
		     PASTA-DE-DIENTES PILA
		     VAINILLA
		     YOGURT
		     ZARDINAS))
      (setq SP (sig_p))
      (setq PASO 'VO)
      (setq EE NIL)) ))

(rds)
