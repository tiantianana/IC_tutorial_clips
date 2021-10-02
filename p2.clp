(defclass JARRA 
  (is-a INITIAL-OBJECT)
  (slot capacidad (type INTEGER) (default 3))
  (slot litros (type INTEGER) (default 0))
)

(defclass JARRA_PEQUEÑA 
  (is-a JARRA)
  (slot capacidad (default 2))
)

(defclass JARRA_GRANDE 
  (is-a JARRA)
  (slot capacidad (default 4))
)

(definstances estado_inicial_jarras
  (of JARRA_PEQUEÑA (litros 0))
  (of JARRA_GRANDE (litros 0))
)

(defrule volcar_jarra
    ?jarra1 <- (object (is-a JARRA_GRANDE) (capacidad ?c1) (litros ?l1))
    ?jarra2 <- (object (is-a JARRA_PEQUEÑA) (capacidad ?c2) (litros ?l2))
    ; comprobamos que no están las 2 vacías, y que el contenido de ambas cabe en una
    (test (neq (+ ?l1 ?l2) 0))
    (test (neq ?jarra1 ?jarra2))
    (test (<= (+ ?l1 ?l2) ?c2))
    ; Se vuelca la que mayor tiene en la que menor tiene
    (test (> ?l1 ?l2))
    (test (> ?c1 ?c2))
    =>
    (modify-instance ?jarra1 (litros 0))
    (modify-instance ?jarra2 (litros (+ ?l1 ?l2)))
)

; Llenar jarra
(defrule llenar_jarra
  (not (object (is-a JARRA) (capacidad ?c) (litros ?c)))
  ?jarra <- (object (is-a JARRA) (capacidad ?c) (litros ?l))
  ; solo se llena si la jarra 1 esta vacia
  (test (= ?l 0))
  =>
  (modify-instance ?jarra (litros ?c))
)

; Vaciar jarra: ponemos los litros a 0.

(defrule vaciar_jarra 
    ; No vaciamos si la otra jarra ya está vacía (volveríamos al estado inicial)
    (not (object (is-a JARRA) (capacidad ?c) (litros 0)))
    ?jarra1 <- (object (is-a JARRA_PEQUEÑA) (capacidad ?c1) (litros ?l1))
    ?jarra2 <- (object (is-a JARRA_GRANDE) (capacidad ?c2) (litros ?l2))
    (test (neq ?jarra1 ?jarra2)) 
    ; siempre se vacia la jarra más pequeña
    (test (> ?c2 ?c1))
    ; solo vaciar si esta llena
    (test (= ?l1 ?c1))
    => 
    (modify-instance ?jarra1 (litros 0))
)

(defrule verter_jarra 
    ?jarra1 <- (object (is-a JARRA_GRANDE) (capacidad ?c1) (litros ?l1))
    ?jarra2 <- (object (is-a JARRA_PEQUEÑA) (capacidad ?c2) (litros ?l2))
    (test (neq ?jarra1 ?jarra2)) 
    ; comprobamos que no caben todos los litros de una jarra en la otra
    (test (> (+ ?l1 ?l2) ?c2))
    => 
    (modify-instance ?jarra1 (litros (- ?l1 (- ?c2 ?l2))))
    (modify-instance ?jarra2 (litros ?c2))
)

; Regla de salida: indica cuándo el sistema de producción ha alcanzado el estado final

(defrule acabar
  ?jarra <- (object (is-a JARRA) (capacidad 4) (litros 2))
  =>
  (printout t "Fin" crlf)
  (unmake-instance ?jarra)
  (halt)
)