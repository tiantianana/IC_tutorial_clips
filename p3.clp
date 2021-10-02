(defclass ANIMAL
	(is-a INITIAL-OBJECT)
	(slot nombre (type STRING))
	(slot piel (type SYMBOL) (allowed-symbols Pelo Plumas))
	(slot vuela (type SYMBOL) (allowed-symbols Si No))
	(slot razona (type SYMBOL ) (allowed-symbols Si No))
    (slot subclase (type SYMBOL))
)

(defclass MAMIFERO
	(is-a ANIMAL)
	(slot piel (default Pelo))
	(slot vuela (default No))
    (slot razona (default No))
    (slot subclase (allowed-symbols Hombre))
)

(defclass AVE
	(is-a ANIMAL)
    (slot piel (default Pluma))
	(slot vuela (default Si))
    (slot razona (default No))
    (slot subclase (allowed-symbols Albatros Pinguino))
)

(definstances animal_nombre
    (of MAMIFERO (subclase Hombre) (nombre Pepe) (razona Si) )
    (of AVE (subclase Albatros) (nombre Alf))
    (of AVE (subclase Pinguino) (nombre Chilly) (vuela No))
    (of AVE (subclase Pinguino) (nombre Nani) (vuela No))
    (of AVE (subclase Pinguino) (nombre Tatti) (vuela No))
)

(defrule imprimir
    (object (is-a AVE) (subclase Pinguino) (nombre ?n))
    =>
    (printout t "Pinguino: " ?n  crlf)
)