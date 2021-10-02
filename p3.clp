(defclass Animal
	(is-a USER)
	(slot DNI (type STRING))
	(slot infectado (type SYMBOL) (allowed-symbols Si No) (default No))
	(slot tipo-profesion (type SYMBOL) (allowed-symbols Emergencias Indispensable Otra))
	(slot tipo-subprofesion (type SYMBOL) )
)

(defclass Mamifero
	(is-a Persona)
	(slot tipo-subprofesion (allowed-symbols Policia Bomberos Medicina))
)

(defclass Indispensable
	(is-a Persona)
	(slot tipo-subprofesion (allowed-symbols Reponedor Transportista))
)

(defclass Otra
	(is-a Persona)
	(slot tipo-subprofesion (allowed-symbols Docente Estudiante))
)

(definstances personal-inicial
    (of Emergencias (tipo-subprofesion Bomberos)(infectado Si)(DNI 1)(tipo-profesion Emergencias))
    (of Emergencias (tipo-subprofesion Medicina)(infectado Si)(DNI 2)(tipo-profesion Emergencias))
    (of Indispensable (tipo-subprofesion Reponedor)(infectado Si)(DNI 3)(tipo-profesion Indispensable))
    (of Otra (tipo-subprofesion Docente)(infectado Si)(DNI 4)(tipo-profesion Otra))
    (of Otra (tipo-subprofesion Estudiante)(infectado Si)(DNI 5)(tipo-profesion Otra))
)

(deffacts hechos-iniciales 
    ;tenemos 3 curas en un inicio.
    (curas-virus 3)
    ;aqui estan los hechos de las subprofesiones.
    (siguiente Emergencias Indispensable)
    (siguiente Indispensable Otra)
    ;medicina siempre aparece la primera subprofesion.
    ;mientras que policia es la ultima subprofesion.
    (siguiente-subprofesion Medicina Policia)
    (siguiente-subprofesion Policia Bomberos)
    (siguiente-subprofesion Reponedor Transportista)
    (siguiente-subprofesion Docente Estudiante)
    ;primero hay que curar a medicos.
    (curando-primero-a Medicina)
)

(defrule curar-persona
    ;curamos primero a medicos
	(curando-primero-a ?sp)
    ?hp <- (object (is-a Persona) (tipo-subprofesion ?sp)(infectado Si))
    ?cv <- (curas-virus ?c)
    (test (> ?c 0))
    =>
    (retract ?cv)
    (modify-instance ?hp (infectado No))
	(assert (curas-virus (- ?c 1)))
    (printout t "Persona de subprofesion " ?sp " curada "  crlf)
)

(defrule curada-categoria
    ?cpa <- (curando-primero-a ?sp)
    (not (object (is-a Persona) (tipo-subprofesion ?sp)(infectado Si)))	
	;He llegado al final de mis subprofesiones. Por tanto tengo que cambiar de profesión.
    ;sp es la ultima subprofesión.
    (not (siguiente-subprofesion ?sp ?x))
	(object (is-a Persona) (tipo-subprofesion ?sp)(tipo-profesion ?p))
    ;Siguiente profesión es...
	(siguiente ?p ?nextp)
    ;Busco entre la base de "indispensables" y cojo la variable de subprofesiones indispensables.
	(object (is-a Persona) (tipo-subprofesion ?nextsp)(tipo-profesion ?nextp))
    ;primera subprofesion y necesito la siguiente subprofesion, ya que no hay ninguna profesión que la anteceda.
	(not (siguiente-subprofesion ?y ?nextsp))
    ?cv <- (curas-virus ?c)
    (test (> ?c 0))
    =>
    (retract ?cpa)
	(assert (curando-primero-a ?nextsp))
    (printout t "Subrofesion " ?sp " ya curada, procedemos con la profesion " ?nextsp " de nueva profesion " ?nextp crlf)
)

(defrule curada-subcategoria
    ?cpa <- (curando-primero-a ?sp)
    (not (object (is-a Persona) (tipo-subprofesion ?sp)(infectado Si)))	
	(siguiente-subprofesion ?sp ?nextsp)
    ?cv <- (curas-virus ?c)
    (test (> ?c 0))
    =>
    (retract ?cpa)
	(assert (curando-primero-a ?nextsp))
    (printout t "Subprofesion " ?sp " ya curada, procedemos con la subprofesion " ?nextsp crlf)
)

