; Ana Tian Villanueva Conde 100405817
; Yolanda Luque Hazañas 100405948

; Tutorial de CLIPS. Parte 2 de 2

; La superclase animal es el initial object con los atributos nombre, piel, vuela y razona.
; Estos atributos son comunes a todas las subclases pero no estan inicalizadas en la clase
; ya que cada clase tiene sus propias caracteristicas.

(defclass ANIMAL
	(is-a INITIAL-OBJECT)
	(slot nombre (type STRING))
	(slot piel (type SYMBOL) (allowed-symbols Pelo Plumas))
	(slot vuela (type SYMBOL) (allowed-symbols Si No))
	(slot razona (type SYMBOL ) (allowed-symbols Si No))
    (slot subclase (type SYMBOL))
)

; La clase mamifero tiene las caracteristicas de animal, pero tiene pelo, no vuela y no razona por default.
; Dentro de esta clase se encuentra la subclase hombre que si que razona.

(defclass MAMIFERO
	(is-a ANIMAL)
	(slot piel (default Pelo))
	(slot vuela (default No))
    (slot razona (default No))
    (slot subclase (allowed-symbols Hombre))
)

; La clase ave hereda las caracteristicas de animal.
; Dentro de la clase ave se encuetran dos subclases: 
; Albatros y Pinguinos.

(defclass AVE
	(is-a ANIMAL)
    (slot piel (default Pluma))
	(slot vuela (default Si))
    (slot razona (default No))
    (slot subclase (allowed-symbols Albatros Pinguino))
)

; He creado varias instancias. Las 3 primeras con Hombre, Albatros y Pinguino 
; y sus correspondientes nombres como indica en el enunciado.
; Y he añadido 2 subclases pinguino más para realizar las pruebas.
; Además he añadido los atributos correspondientes que caracterizan a cada animal
; por ejemplo, los Hombres razonan, las Albatros tienen las caracteristicas default
; mientras que los pinguinos no vuelan.

(definstances animal_instancias
    (of MAMIFERO (subclase Hombre) (nombre Pepe) (razona Si) )
    (of AVE (subclase Albatros) (nombre Alf))
    (of AVE (subclase Pinguino) (nombre Chilly) (vuela No))
)
; La base de hechos con los nombres de los pinguinos a imprimir.
; Imprimiría Adam, Fran y Elena.

(deffacts hechos-inicales
    (Pinguino Adam)
    (Pinguino Fran)
    (Albatros Robin)
    (Hombre Lola)
    (Pinguino Elena)
)

; Esta regla imprime exclusivamente la clase Ave y dentro de la clase
; especificamente el nombre de los pinguinos. 

(defrule imprimir
    ?p <- (Pinguino ?n)
    =>
    (printout t ?n  crlf)
)