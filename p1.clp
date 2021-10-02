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

; REGLAS: (generales)
; TODO: emplear hechos semáforos para regular la activación de reglas (por ej si jarra_vacía entonces se activa llenar_jarra)

; Regla llenar_jarra: pongo los litros al mismo valor que la capacidad
; No interesa llenar una jarra si la otra ya lo está (alguna tendremos que vaciar luego)
(defrule llenar_jarra
    (declare (salience 5))
    (not (jarra (capacidad ?c) (litros ?c)))
    ?jarra <- (jarra (capacidad ?c) (litros ?l))
    ?jarra2 <- (jarra (capacidad ?c2) (litros ?l2))
    ; las jarras son distintas
    (test (neq ?jarra ?jarra2)) 
    ; siempre se llena la jarra más grande
    (test (< ?c2 ?c))
    ; comprobamos que caben mas litros
    (test (< ?l ?c))
    =>
    (modify ?jarra (litros ?c))
)

; Regla vaciar_jarra: pongo los litros a 0.
; No interesa vaciar una jarra si la otra ya está vacía (nos quedamos como al principio)
(defrule vaciar_jarra 
    (declare (salience 5))
    (not (jarra (capacidad ?c) (litros 0)))
    ; se rellena la jarra mas pequeña
    ?jarra <- (jarra (capacidad ?c) (litros ?l)) 
    ?jarra2 <- (jarra (capacidad ?c2) (litros ?l2))
    (test (neq ?jarra ?jarra2)) 
    ; siempre se vacia la jarra más pequeña
    (test (> ?c2 ?c))
    ; solo vaciar si esta llena
    (test (= ?l ?c))
    => 
    (modify ?jarra (litros 0))
)

; Regla volcar_jarra: (vuelca el contenido de una jarra en la otra cuando cabe)
(defrule volcar_jarra
    (declare (salience 10))
    ?jarra1 <- (jarra (capacidad ?c1) (litros ?l1)) 
    ?jarra2 <- (jarra (capacidad ?c2) (litros ?l2)) 
    ; compruebo que jarra 1 y jarra 2 son distintas y que no están las 2 vacías
    (test (neq (+ ?l1 ?l2) 0))
    (test (neq ?jarra1 ?jarra2))
    ; comprobar que si sumo ambas caben en la jarra 2
    (test (<= (+ ?l1 ?l2) ?c2))
    ; comprobar que se vierte la que mayor tiene en la que menor tiene
    (test (> ?l1 ?l2))
    (test (< ?c2 ?c1))
    =>
    ; comprobar que la jarra 1 tiene 0 litros ya que vuelco todo en la jarra 2
    (modify ?jarra1 (litros 0))
    ; sumo los litros de la jarra 1 a la jarra 2.
    (modify ?jarra2 (litros (+ ?l1 ?l2)))
)

; Regla verter_jarra: (vuelca todo lo que quepa de una jarra en la otra)
(defrule verter_jarra 
    (declare (salience 5))
    ?jarra1 <- (jarra (capacidad ?c1) (litros ?l1)) 
    ?jarra2 <- (jarra (capacidad ?c2) (litros ?l2)) 
    ; comprobamos que las jarras son distintas
    (test (neq ?jarra1 ?jarra2)) 
    ; comprobamos que caben todos los litros en la jarra
    (test (> (+ ?l1 ?l2) ?c2))
    => 
    ; restamos los litros de la jarra 1
    (modify ?jarra1 (litros (- ?l1 (- ?c2 ?l2))))
    (modify ?jarra2 (litros ?c2))
)

; Comprueba terminacion
(defrule acabar
  (declare (salience 1000))
  ?jarra <- (jarra (capacidad 4) (litros 2))
  =>
  (printout t "Fin" crlf)
  (halt)
)

; 1. Cuántos ciclos de ejecución tarda en llegar a la solución?
; 2. Cambiar la estrategia de control a random, volver a ejecutar, cambia algo? Por qué?