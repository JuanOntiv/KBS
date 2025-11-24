;;Recomendaciones 

;;Recomendaciones por tipo de producto
(defrule regla-sugerir-accesorios-smartphone
   (orden (type smartphone) (modelo ?m))
   =>
   (assert (recomendacion (texto "Sugerencia: Añadir funda y mica (18% descuento).")))
   (printout t "Sugerencia: Añadir funda y mica (18% descuento) para tu smartphone." crlf)
)

(defrule regla-sugerir-extra-laptop
   (orden (type computadora) (modelo ?m))
   =>
   (assert (recomendacion (texto "Sugerencia: Agrega ratón pro y mochila con descuento.")))
   (printout t "Sugerencia: Ratón pro y mochila con descuento para tu laptop." crlf)
)

;;Descuento adicional por compras mayores (ajustado)
(defrule regla-descuento-por-cantidad
   (orden (modelo ?m) (qty ?q&:(> ?q 1)))
   =>
   (bind ?porc (if (> ?q 5) then 0.12 else 0.06))
   (assert (descuento (porcentaje ?porc) (texto "Descuento por volumen en mismo producto.")))
   (printout t "Promo: " (* ?porc 100) "% de descuento por comprar más de una unidad del mismo producto." crlf)
)

;;Recomendación AppleCare con control para no duplicar
(defrule regla-applecare-unica
   (declare (salience 10))
   (orden (marca apple) (modelo ?m))
   (not (recomendacion (texto ?t&:(str-index "AppleCare" ?t))))
   (not (control-hecho (tipo applecare)))
   =>
   (assert (recomendacion (texto "Sugerencia: Añade AppleCare para protección extendida.")))
   (assert (control-hecho (tipo applecare)))
   (printout t "Sugerencia: Añade AppleCare para protección extendida." crlf)
)

;;Imprimir recomendaciones, descuentos y ofertas finales (se retiran para evitar duplicados)
(defrule print-recomendaciones
   ?r <- (recomendacion (texto ?rt))
   =>
   (printout t ">>> Recomendación Final: " ?rt crlf)
   (retract ?r)
)

(defrule print-descuentos
   ?d <- (descuento (porcentaje ?p) (texto ?dt))
   =>
   (printout t ">>> Descuento Final: " ?dt " (" (* ?p 100) "%)" crlf)
   (retract ?d)
)

(defrule print-ofertas
   ?o <- (oferta (texto ?ot))
   =>
   (printout t ">>> Oferta Final: " ?ot crlf)
   (retract ?o)
)
