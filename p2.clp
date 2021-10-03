; La clase JARRA es la clase inicial.
; De esta clase heredan las subclases Jarra_pequeña y jarra_grande.

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

; Declaramos las instancias con las condiciones inicales, en las que
; ambas jarras están vacias.

(definstances estado_inicial_jarras
  (of JARRA_PEQUEÑA (litros 0))
  (of JARRA_GRANDE (litros 0))
)

; Regla de salida: indica cuándo el sistema de producción ha alcanzado el estado final
; Es la primera regla en ejecutarse, ya que al no poder usar prioridades y al usar estrategia
; depth sería la primera regla que compara. Si se cumple la condición significa que se termina el problema.

(defrule acabar
  ?jarra <- (object (is-a JARRA) (litros 2))
  =>
  (printout t "Fin" crlf)
  (unmake-instance ?jarra)
  (halt)
)

; La siguiente regla en ejecutarse es volcar jarra.
; Las reglas son las mismas que en el ejemplo anterior de las jarras. 
; Sin embargo diferenciamos las jarras utilizando is a Jarra_grande o is a Jarra_pequeña
; para comprobar si el objeto jarra pertenece a esas dos clases
; Al hacer esta diferencia no tendriamos que comprobar que jarra es más grande, ya que
; sabemos que la jarra grande es la que mayor capacidad tiene mientras que la jarra pequeña
; tiene menos capacidad.
; Sin embargo las comprobaciones de que ninguna de que al menos una de las jarras tengua agua
; y que la suma de los litros de la jarra sea menor o igual que la capacidad son necesarias.

(defrule volcar_jarra
    ?jarra1 <- (object (is-a JARRA_GRANDE) (capacidad ?c1) (litros ?l1))
    ?jarra2 <- (object (is-a JARRA_PEQUEÑA) (capacidad ?c2) (litros ?l2))
    (test (neq (+ ?l1 ?l2) 0))
    (test (neq ?jarra1 ?jarra2))
    (test (<= (+ ?l1 ?l2) ?c2))
    (test (> ?l1 ?l2))
    (test (> ?c1 ?c2))
    =>
    (modify-instance ?jarra1 (litros 0))
    (modify-instance ?jarra2 (litros (+ ?l1 ?l2)))
)

; Llenar jarra: ponemos los litros al mismo valor que la capacidad.
; Suponemos que solo se llena si esta está vacía.
; Utilizamos modify-instance en vez de modify fact jarra como anteriormente.

(defrule llenar_jarra
  (not (object (is-a JARRA) (capacidad ?c) (litros ?c)))
  ?jarra <- (object (is-a JARRA) (capacidad ?c) (litros ?l))
  (test (= ?l 0))
  =>
  (modify-instance ?jarra (litros ?c))
)

; Vaciar jarra: ponemos los litros a 0.
; Comprobamos que ninguna de las jarras tiene 0 litros, ya que si es así entonces
; no hay nada que vaciar. 
; No vaciamos si la otra jarra ya está vacía (volveríamos al estado inicial).

(defrule vaciar_jarra 
    (not (object (is-a JARRA) (capacidad ?c) (litros 0)))
    ?jarra <- (object (is-a JARRA_PEQUEÑA) (capacidad ?c) (litros ?l))
    (test (= ?l ?c))
    => 
    (modify-instance ?jarra (litros 0))
)

; Verter jarra: vierte todo lo que quepa de una jarra en la otra.
; Al igual que las anteriores reglas de la jarra, comprobamos que ambas jarras son distintas.
; Comprobamos que los litros de ambas caben en la jarra.

(defrule verter_jarra 
    ?jarra1 <- (object (is-a JARRA_GRANDE) (capacidad ?c1) (litros ?l1))
    ?jarra2 <- (object (is-a JARRA_PEQUEÑA) (capacidad ?c2) (litros ?l2))
    (test (> (+ ?l1 ?l2) ?c2))
    => 
    (modify-instance ?jarra1 (litros (- ?l1 (- ?c2 ?l2))))
    (modify-instance ?jarra2 (litros ?c2))
)

; Esta regla es una regla rapida para cuando se rellena la jarra pequeña
; Sin embargo nunca se llega a cumplir ya que tiene prioridad baja

(defrule solucion-rapida
    ?jarra <- (object (is-a JARRA_PEQUEÑA) (capacidad ?c))
    =>
    (modify-instance ?jarra (litros ?c))
)