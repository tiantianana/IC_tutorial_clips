(defclass Animal
	(is-a USER)
	(slot nombre (type STRING))
	(slot piel (type SYMBOL) (allowed-symbols Pelo Pluma))
	(slot vuela (type SYMBOL) (allowed-symbols Si No))
	(slot razona (type SYMBOL Si No) )
)

(defclass Mamifero
	(is-a Persona)
)

(defclass Ave
	(is-a Persona)
)

(defclass Hombre
	(is-a Persona)
)


(defclass Albatros
	(is-a Animal)
)


(defclass Pinguino
	(is-a Animal)
)
