; Plantilla jarra con atributos capacidad y litros

(deftemplate jarra (slot capacidad (type INTEGER) (default 0)) (slot litros (type INTEGER) (default 0)))

; El estado inicial son dos hechos: las dos jarras vacías

(deffacts jarra_4l_en_0 (jarra (capacidad 4) (litros 0)))
(deffacts jarra_3l_en_0 (jarra (capacidad 3) (litros 0)))

; REGLAS: (generales)
; TODO: emplear hechos semáforos para regular la activación de reglas (por ej si jarra_vacía entonces se activa llenar_jarra)

; Regla llenar_jarra: pongo los litros al mismo valor que la capacidad
(defrule llenar_jarra ?jarra <- (jarra (capacidad ?c) (litros ?l)) => (modify ?jarra (capacidad ?c) (litros ?c)))

; Regla vaciar_jarra: pongo los litros a 0
(defrule llenar_jarra ?jarra <- (jarra (capacidad ?c) (litros ?l)) => (modify ?jarra (capacidad ?c) (litros 0)))

; Regla volcar_jarra: (vuelca el contenido de una jarra en la otra cuando cabe)


; Regla verter_jarra: (vuelca todo lo que quepa de una jarra en la otra)
(defrule verter_jarra ?jarra1 <- (jarra (capacidad ?c1) (litros ?l1)) ?jarra2 <- (jarra (capacidad ?c2) (litros ?l2)) (test (neq ?c1 ?c2)) (test (> ?c1 ?c2)) => (modify .....................)