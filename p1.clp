; Plantilla jarra con atributos capacidad y litros

(deftemplate jarra 
(slot capacidad (type INTEGER) (default 0)) 
(slot litros (type INTEGER) (default 0)))

; El estado inicial son dos hechos: las dos jarras vacías

(deffacts jarra_4l_en_0 (jarra (capacidad 4) (litros 0)))
(deffacts jarra_3l_en_0 (jarra (capacidad 3) (litros 0)))

; REGLAS: (generales)
; TODO: emplear hechos semáforos para regular la activación de reglas (por ej si jarra_vacía entonces se activa llenar_jarra)

; Regla llenar_jarra: pongo los litros al mismo valor que la capacidad
(defrule llenar_jarra 
?jarra <- (jarra (capacidad ?c) (litros ?l)) 
=> 
(modify ?jarra (capacidad ?c) (litros ?c)))

; Regla vaciar_jarra: pongo los litros a 0
(defrule llenar_jarra 
?jarra <- (jarra (capacidad ?c) (litros ?l)) 
=> 
(modify ?jarra (capacidad ?c) (litros 0)))

; Regla volcar_jarra: (vuelca el contenido de una jarra en la otra cuando cabe)
(defrule volcar_jarra
?jarra1 <- (jarra (capacidad ?c1) (litros ?l1)) 
?jarra2 <- (jarra (capacidad ?c2) (litros ?l2)) 
; compruebo que jarra 1 y jarra 2 son distintas
(test (neq ?jarra1 ?jarra2))
; compruebo que el contenido de la jarra 1 es mayor que el contenido de la jarra 2
; pero tengo que comprobar que cabe
(test (< (+ ?l1 ?l2) ?c1)) 
=>
; sumo en jarra 1 la cantidad de jarra 2
(modify (?jarra1 (+ ?l1 ?l2)))
; elimino el contenido de la jarra 2 (todo)
(modify (?jarra2 (- ?l2 ?l2)))
)



; Regla verter_jarra: (vuelca todo lo que quepa de una jarra en la otra)
(defrule verter_jarra 
?jarra1 <- (jarra (capacidad ?c1) (litros ?l1)) 
?jarra2 <- (jarra (capacidad ?c2) (litros ?l2)) 
(test (neq ?c1 ?c2)) 
(test (> ?c1 ?c2)) 
; creo que aqui hay q comprobar que si la suma de lo q hay en ambas jarras
; es menor a la capacidad total de la jarra 1.
(test (< (+ ?l1 ?l2) ?c1)) 
; if ( la suma es menor que la capacidad significa que puedo volcar todo)
    ; por tanto igual que la anterior regla
; else (no cabe todo en la jarra, entonces tengo que llenar solo X)
; ¿hay que crear dos reglas?
=> 
(modify (?jarra1 (- ?c1 ?c2)))