;;Orden de procesamiento de reglas para sistema de ventas de smartphones y laptops''

(defrule procesar-smartphones-operacion
   ?o <- (orden (modelo ?modelo) (qty ?q) (tarjeta ?t&~none))
   (test (or (eq ?modelo iPhone16) (eq ?modelo GalaxyA55) (eq ?modelo RedmiNote12)))
   =>
   (printout t crlf "*** Nueva orden registrada: " ?modelo ", qty=" ?q crlf)

   ;;Clasificación por cantidad (menudista/mayorista)
   (if (< ?q 10)
      then (printout t "Clasificación: Menudista (qty < 10)" crlf)
      else (printout t "Clasificación: Mayorista (qty >= 10)" crlf))

   ;;Ofertas específicas por modelo + tarjeta
   (if (and (eq ?modelo iPhone16) (eq ?t banorte))
      then
      (assert (oferta (texto "iPhone16 pagando con Banorte: 24 meses sin intereses.")))
      (printout t "Oferta aplicada: 24 meses sin intereses (Banorte)." crlf)
   )

   (if (and (eq ?modelo GalaxyA55) (eq ?t banorte))
      then
      (assert (oferta (texto "GalaxyA55 con Banorte: 12 meses sin intereses.")))
      (printout t "Oferta aplicada: 12 meses sin intereses (Banorte - GalaxyA55)." crlf)
   )

   ;;Descuento por cantidad (mayoreo) - fórmula ajustada
   (bind ?pct (if (< ?q 3) then 0.00 else (if (< ?q 6) then 0.04 else (if (< ?q 12) then 0.08 else 0.12))))
   (assert (descuento (porcentaje ?pct) (texto "Descuento escalonado por cantidad.")))
   (printout t "Descuento aplicado: " (* ?pct 100) "%" crlf)

   ;;Recomendación automática (con nuevo texto)
   (assert (recomendacion (texto "Sugerencia: Añade funda y mica con 18% de descuento.")))
   (printout t "Recomendación: funda y mica con 18% descuento." crlf)

   ;;Actualización de stock (busca y actualiza)
   (bind ?found (find-all-facts ((?s stock)) (eq ?s:modelo ?modelo)))
   (if (eq (length$ ?found) 0)
      then
      (printout t "No se encontró stock para " ?modelo crlf)
      else
      (bind ?sf (nth$ 1 ?found))
      (bind ?curQty (fact-slot-value ?sf cantidad))
      (bind ?newQty (max 0 (- ?curQty ?q)))
      (retract ?sf)
      (assert (stock (modelo ?modelo) (cantidad ?newQty)))
      (printout t "Stock actualizado: " ?curQty " -> " ?newQty crlf)
   )
)


;;Pagpo contado
(defrule Promo-combinada-contado
   (orden (modelo MacBookAir) (qty ?q1) (pago contado))
   (orden (modelo iPhone16) (qty ?q2) (pago contado))
   =>
   (bind ?total (+ (* ?q1 42000) (* ?q2 27000)))
   (bind ?vales (* (integer (/ ?total 1000)) 100))
   (printout t "Promo COMBO (contado): MacBookAir + iPhone16 -> Vales por $" ?vales crlf)
   (assert (oferta (texto (str-cat "Vales por $" ?vales " en combo MacBookAir + iPhone16 (contado)."))))
)


;;Recomendaciones adicionales
(defrule sugerencia-para-mayoristas
   (orden (qty ?q&:(>= ?q 10)) (modelo ?m))
   =>
Recomendación   (assert (recomendacion (texto "Recomendación: negociar condiciones mayoristas.")))
)


;; Resumen final 
(defrule resumen-transaccion
   (oferta (texto ?otext))
   (descuento (porcentaje ?pct) (texto ?dtext))
   (recomendacion (texto ?rtext))
   =>
   (printout t crlf "=== RESULTADOS GENERADOS ===" crlf)
   (printout t "Oferta: " ?otext crlf)
   (printout t "Descuento: " ?dtext " (" (* ?pct 100) "%)" crlf)
   (printout t "Recomendación: " ?rtext crlf crlf)
)


;;Stock negativo
(defrule stock-sanitizar
   ?s <- (stock (modelo ?m) (cantidad ?q&:(< ?q 0)))
   =>
   (retract ?s)
   (assert (stock (modelo ?m) (cantidad 0)))
   (printout t "Stock negativo corregido para " ?m crlf)
)
