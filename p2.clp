defclass JARRA (is-a INITIAL-OBJECT)
  (slot litros
  (type INTEGER)
  (default 0))
  (slot capacidad
  (type INTEGER)
  (default 3))
)
(defclass JARRA_PEQUEÑA (is-a JARRA)
  (slot capacidad
  (default 2))
)
(defclass JARRA_GRANDE (is-a JARRA)
  (slot capacidad
  (default 4))
)

(definstances estado_inicial_jarras
  (j1 of JARRA_PEQUEÑA)
  (j2 of JARRA_GRANDE (litros 0))
)

; Llena jarra
(defrule llena-jarra
  ?jarra <- (object (is-a JARRA) (capacidad ?c) (litros ?l))
  (test (< ?l ?c))
  =>
  (modify-instance ?jarra (litros ?c))
)


