; Ana Tian Villanueva Conde 100405817
; Yolanda Luque Hazañas 100405948

; Tutorial de CLIPS. Parte 1 de 2

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

; Regla de salida: indica cuándo el sistema de producción ha alcanzado el estado final.
; Es la primera regla que se comprueba, ya que si satisface esta condición significa que el
; problema ha terminado.

(defrule acabar
  (declare (salience 10))
  ?jarra1 <- (jarra (capacidad ?c1) (litros ?l1)) 
  ?jarra2 <- (jarra (capacidad ?c2) (litros ?l2)) 
  (test (> ?c1 ?c2))
  (test ( = ?l1 2))
  =>
  (printout t "Fin" crlf)
  (retract ?jarra1)
  (retract ?jarra2)
  (halt)
)


; Llenar jarra: ponemos los litros al mismo valor que la capacidad. Hemos asumido que solo
; se llena una jarra si la otra está vacia para poder pasar agua de una jarra a otra. 
; y siempre se llena la jarra si esta esta vacia y si es la más grande.

(defrule llenar_jarra
    (not (jarra (capacidad ?c) (litros ?c)))
    ?jarra1 <- (jarra (capacidad ?c1) (litros ?l1)) 
    ?jarra2 <- (jarra (capacidad ?c2) (litros ?l2))
    (test (neq ?jarra1 ?jarra2)) 
    (test (> ?c1 ?c2))
    (test (= ?l1 0))
    =>
    (modify ?jarra1 (litros ?c1))
)

; Vaciar jarra: ponemos los litros a 0. Solo vaciamos la jarra si no está vacia
; ya que no tendria sentido vaciar una jarra vacia. Siempre vaciamos la jarra pequea si
; esta está llena.

(defrule vaciar_jarra 
    (not (jarra (capacidad ?c) (litros 0)))
    ?jarra1 <- (jarra (capacidad ?c1) (litros ?l1)) 
    ?jarra2 <- (jarra (capacidad ?c2) (litros ?l2))
    (test (neq ?jarra1 ?jarra2)) 
    (test (> ?c2 ?c1))
    (test (= ?l1 ?c1))
    => 
    (modify ?jarra1 (litros 0))
)

; Volcar jarra: vuelca el contenido de una jarra en la otra cuando cabe.
; Comprobamos que las dos jarras no están vacias, ya que si es así no se podría volcar
; Comprobamos que el contenido de la jarra1 y el de la jarra2 caben en la jarra, por tanto
; que el contenido de ambas jarras en litros sea menor a la capacidad.
; Siempre se vuelca la que tiene mayor contenido sobre la que tiene menor contenido.
; Comprobamos que la jarra1 es mayor que la jarra2.
; Finalmente obtenemos que la jarra1 ahora tiene 0 litros pues ya están vertidos en la otra jarra;
; y la otra jarra tiene la suma de los litros de ambas.

(defrule volcar_jarra
    ?jarra1 <- (jarra (capacidad ?c1) (litros ?l1)) 
    ?jarra2 <- (jarra (capacidad ?c2) (litros ?l2)) 
    (test (neq (+ ?l1 ?l2) 0))
    (test (neq ?jarra1 ?jarra2))
    (test (<= (+ ?l1 ?l2) ?c2))
    (test (> ?l1 ?l2))
    (test (> ?c1 ?c2))
    =>
    (modify ?jarra1 (litros 0))
    (modify ?jarra2 (litros (+ ?l1 ?l2)))
)

; Verter jarra: vierte todo lo que quepa de una jarra en la otra.
; En este caso también comprobamos que ambas jarras son distintas y
; que caben los litros de ambas jarras en la jarra2.
; Finalmente restamos los litros de las jarras: en la jarra1 quedarían los restos 
; que no han cabido en la otra jarra, mientras que en la jarra2 estaría llena

(defrule verter_jarra 
    ?jarra1 <- (jarra (capacidad ?c1) (litros ?l1)) 
    ?jarra2 <- (jarra (capacidad ?c2) (litros ?l2)) 
    (test (neq ?jarra1 ?jarra2)) 
    ; comprobamos que no caben todos los litros de una jarra en la otra
    (test (> (+ ?l1 ?l2) ?c2))
    => 
    (modify ?jarra1 (litros (- ?l1 (- ?c2 ?l2))))
    (modify ?jarra2 (litros ?c2))
)

; Solución a las preguntas:

; 1. Cuántos ciclos de ejecución tarda en llegar a la solución?
; Con la estrategia por defecto (profundidad), tarda 7 ciclos en llegar a la solución.
; Una posible solución al problema de la jarra de 4L y la jarra de 3L sería:
; 1       Llenar(Jarra_4L)    4               0
; 2       Verter(Jarra_4L)    1               3
; 3       Vaciar(Jarra_3L)    1               0
; 4       Volcar(Jarra_4L)    0               1
; 5       Llenar(Jarra_4L)    4               1
; 6       Verter(Jarra_4L)    2               3
; 7       Acabar

; 2. Cambiar la estrategia de control a random, volver a ejecutar, cambia algo? Por qué?
; Con la estraregia de random, las reglas cambian de orden en la agenda, lo cual altera el número de ciclos.
; Como llenar, vaciar y verter tienen la misma prioridad (salience 5) al ejecutar la regla se puede ejecutar
; aleatoriamente una de ellas, lo cual hace que cambie completamente el problema.
; Por ejemplo:
; 1       Llenar(Jarra_4L)    4               0
; 2       Verter(Jarra_4L)    1               3
; 3       Verter(Jarra_3L)    4               0
; 4       Verter(Jarra_4L)    1               3
; 6       Verter(Jarra_4L)    2               3
; 7       Volcar(Jarra_4L)    0               1
; 8       Llenar(Jarra_4L)    4               1
; 9       Verter(Jarra_4L)    2               3
; 10      Acabar

; Como podemos observar, al ejecutar aleatoriamente se produce un bucle en verter. 
; Antes tenían la misma prioridad pero como seguía la estrategia de depth, verter era 
; la ultima regla que se ejecutaba (por tanto solo se ejecutaba si no había otra regla)
; pero ahora como es aleatorio, se ejecuta antes que vaciar.
; Por tanto, la solución a la que llegamos es la misma, pero con random tarda más ciclos.
; En los ejemplos que he utilizado, la estrategia con depth siempre se realiza en 7 ciclos mientras
; que con random se realiza con 10 ciclos en este caso pero si volvemos a ejecutarlo puede 
; ejecutarse entre 7 e infinitas veces, aunque esto es bastante improbable ya que siempre tendría
; que salir en el random que se ejecute verter y no vaciar. En algún momento, saldrá vaciar por
; cuestion de probabilidad.
; Una posible solución a esto sería poner prioridad a todas las reglas. Por ejemplo; acabar(100)
; volcar(10), llenar(9), vaciar(8), verter(7). Así nunca se ejecutaria aleatoriamente, sino que seguiría
; el orden de las prioridades.
