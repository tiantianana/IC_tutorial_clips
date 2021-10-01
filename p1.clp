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
(defrule llena_jarra
    ?jarra <- (jarra (capacidad ?c) (litros ?l))
    (test (< ?l ?c))
    =>
    (modify ?jarra (litros ?c))
)

; Regla vaciar_jarra: pongo los litros a 0
(defrule vaciar_jarra 
    ?jarra <- (jarra (litros ?l)) 
    (test (> ?l 0))
    => 
    (modify ?jarra (litros 0))
)

; Regla volcar_jarra: (vuelca el contenido de una jarra en la otra cuando cabe)
(defrule volcar_jarra
    ?jarra1 <- (jarra (capacidad ?c1) (litros ?l1)) 
    ?jarra2 <- (jarra (capacidad ?c2) (litros ?l2)) 
    ; compruebo que jarra 1 y jarra 2 son distintas
    (test (neq ?jarra1 ?jarra2))
    ; compruebo que el contenido de la jarra 1 es mayor que el contenido de la jarra 2
    ; pero tengo que comprobar que cabe
    (test (<= (+ ?l1 ?l2) ?c2)) 
    =>
    ; comprobar que la jarra 1 tiene 0 litros ya que vuelco todo en la jarra 2
    (modify ?jarra1 (litros 0))
    ; sumo los litros de la jarra 1 a la jarra 2.
    (modify ?jarra2 (litros (+ ?l1 ?l2)))
)

; Regla verter_jarra: (vuelca todo lo que quepa de una jarra en la otra)
(defrule verter_jarra 
    ?jarra1 <- (jarra (capacidad ?c1) (litros ?l1)) 
    ?jarra2 <- (jarra (capacidad ?c2) (litros ?l2)) 
    (test (neq ?jarra1 ?jarra2)) 
    (test (> (+ ?l1 ?l2) ?c2))
    ; creo que aqui hay q comprobar que si la suma de lo q hay en ambas jarras
    ; es menor a la capacidad total de la jarra 1.
    ; if ( la suma es menor que la capacidad significa que puedo volcar todo)
        ; por tanto igual que la anterior regla
    ; else (no cabe todo en la jarra, entonces tengo que llenar solo X)
    ; ¿hay que crear dos reglas?
    => 
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

