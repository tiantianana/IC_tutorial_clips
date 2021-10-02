; Plantilla jarra con atributos capacidad y litros

(deftemplate jarra
  (slot litros
    (type INTEGER)
    (default 0))
  (slot capacidad
    (type INTEGER))
)

; El estado inicial son dos hechos: las dos jarras vacías

(deffacts estado_inicial_jarras
    (jarra (capacidad 3))
    (jarra (capacidad 4))
)

; REGLAS:

; Llenar jarra: ponemos los litros al mismo valor que la capacidad

(defrule llenar_jarra
    (declare (salience 5))
    ; No llenamos si ya hay una jarra totalmente llena
    (not (jarra (capacidad ?c) (litros ?c)))
    ?jarra1 <- (jarra (capacidad ?c1) (litros ?l1))
    ?jarra2 <- (jarra (capacidad ?c2) (litros ?l2))
    (test (neq ?jarra1 ?jarra2)) 
    ; siempre se llena la jarra más grande
    (test (< ?c2 ?c1))
    (test (< ?l1 ?c1))
    =>
    (modify ?jarra1 (litros ?c1))
)

; Vaciar jarra: ponemos los litros a 0.

(defrule vaciar_jarra 
    (declare (salience 5))
    ; No vaciamos si la otra jarra ya está vacía (volveríamos al estado inicial)
    (not (jarra (capacidad ?c) (litros 0)))
    ?jarra1 <- (jarra (capacidad ?c1) (litros ?l1)) 
    ?jarra2 <- (jarra (capacidad ?c2) (litros ?l2))
    (test (neq ?jarra1 ?jarra2)) 
    ; siempre se vacia la jarra más pequeña
    (test (> ?c2 ?c1))
    ; solo vaciar si esta llena
    (test (= ?l1 ?c1))
    => 
    (modify ?jarra1 (litros 0))
)

; Volcar jarra: vuelca el contenido de una jarra en la otra cuando cabe

(defrule volcar_jarra
    (declare (salience 10))
    ?jarra1 <- (jarra (capacidad ?c1) (litros ?l1)) 
    ?jarra2 <- (jarra (capacidad ?c2) (litros ?l2)) 
    ; comprobamos que no están las 2 vacías, y que el contenido de ambas cabe en una
    (test (neq (+ ?l1 ?l2) 0))
    (test (neq ?jarra1 ?jarra2))
    (test (<= (+ ?l1 ?l2) ?c2))
    ; Se vuelca la que mayor tiene en la que menor tiene
    (test (> ?l1 ?l2))
    (test (> ?c1 ?c2))
    =>
    (modify ?jarra1 (litros 0))
    (modify ?jarra2 (litros (+ ?l1 ?l2)))
)

; Verter jarra: vierte todo lo que quepa de una jarra en la otra

(defrule verter_jarra 
    (declare (salience 5))
    ?jarra1 <- (jarra (capacidad ?c1) (litros ?l1)) 
    ?jarra2 <- (jarra (capacidad ?c2) (litros ?l2)) 
    (test (neq ?jarra1 ?jarra2)) 
    ; comprobamos que no caben todos los litros de una jarra en la otra
    (test (> (+ ?l1 ?l2) ?c2))
    => 
    (modify ?jarra1 (litros (- ?l1 (- ?c2 ?l2))))
    (modify ?jarra2 (litros ?c2))
)

; Regla de salida: indica cuándo el sistema de producción ha alcanzado el estado final

(defrule acabar
  (declare (salience 1000))
  ?jarra <- (jarra (capacidad 4) (litros 2))
  =>
  (printout t "Fin" crlf)
  (halt)
)


; Solución a las preguntas:

; 1. Cuántos ciclos de ejecución tarda en llegar a la solución?
; Con la estrategia por defecto (profundidad), tarda 7 ciclos en llegar a la solución.

; 2. Cambiar la estrategia de control a random, volver a ejecutar, cambia algo? Por qué?
; Con la estraregia de random, se tarda 9 ciclos en llegar a la solución.
; Esto se debe a que con esta estrategia se altera el orden de las reglas de la agenda 