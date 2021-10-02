(defclass JARRA 
  (is-a OBJECT)
  (slot litros (type INTEGER) (default 0))
  (slot capacidad (type INTEGER) (default 3))
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
  (of JARRA_PEQUEÑA)
  (of JARRA_GRANDE (litros 0))
)

; Llenar jarra
(defrule llenar_jarra
  (not (object(is-a JARRA (capacidad ?c) (litros ?c))))
  ?jarra <- (object (is-a JARRA) (capacidad ?c) (litros ?l))
  (test (< ?l ?c))
  (test (= ?c 4))
  =>
  (modify-instance ?jarra (litros ?c))
)
