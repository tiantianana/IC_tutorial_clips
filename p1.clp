(deftemplate jarra 
(slot litros 
(type INTEGER) 
(default 0))
) 

(deffacts jarra-estrucurada-en-0  
(jarra (litros 0))  
(jarra (litros 1)) 
(jarra (litros 101)) 
)

;añadir un litros
(defrule un-litro-mas
?jarra <- (jarra (litros ?l)) 
=> 
(modify ?jarra (litros (+ ?l 1)))
) 

;añadir dos litros
(defrule dos-litros-mas 
?jarra <- (jarra (litros ?l)) 
=> 
(modify ?jarra (litros (+ ?l 2)))
)

;; Termina 
(defrule acabar 
(jarra (litros 3)) 
=> 
(printout t "Lo he conseguido" crlf) ) 

