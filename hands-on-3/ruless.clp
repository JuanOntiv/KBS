;;reglas


;;iPhone16 con tarjeta Banorte → 24 meses sin intereses
(defrule regla-meses-sin-intereses-iphone
   (orden (modelo iPhone16) (tarjeta banorte))
   =>
   (printout t "Promo: iPhone16 con Banorte tiene 24 meses sin intereses." crlf)
   (assert (oferta (texto "iPhone16 + Banorte: 24 meses sin intereses.")))
)

;;Samsung Note21 (regla genérica; si tu inventario no tiene Note21 no se activará)
(defrule regla-msi-note21-lp
   (orden (modelo GalaxyNote21) (tarjeta liverpool-visa))
   =>
   (printout t "Promo: Samsung Note21 con Liverpool VISA → 12 meses sin intereses." crlf)
   (assert (oferta (texto "Note21 + Liverpool VISA: 12 MSI.")))
)

;;Combo MacBookAir + iPhone16 → vales cada $1000 (precios actualizados)
(defrule regla-combo-apple-premium
   (orden (modelo MacBookAir) (qty ?q1))
   (orden (modelo iPhone16) (qty ?q2))
   =>
   (bind ?total (+ (* ?q1 42000) (* ?q2 27000)))
   (bind ?vales (* (integer (/ ?total 1000)) 100))
   (printout t "Promo: Combo MacBookAir + iPhone16 → $" ?vales " en vales." crlf)
   (assert (oferta (texto (str-cat "Vales por $" ?vales " en combo MacBookAir + iPhone16."))))
)

;;Si compra smartphone → ofrecer funda y mica con 18% de descuento
(defrule regla-accesorio-smartphone-desc
   (orden (type smartphone) (modelo ?m))
   =>
   (printout t "Sugerencia: Añade funda y mica con 18% de descuento." crlf)
   (assert (recomendacion (texto "Funda y mica con 18% descuento.")))
)

;;Compra MacStudioX → recomendar ratón pro (ejemplo)
(defrule regla-sugerencia-macstudio
   (orden (modelo MacStudioX))
   =>
   (printout t "Sugerencia: Ratón Pro con 12% descuento por comprar MacStudioX." crlf)
   (assert (recomendacion (texto "Ratón Pro con 12% descuento.")))
)




;;Combo funda + mica = 7% descuento (si compra ambos accesorios)
(defrule reglas-combo-proteccion
   (orden (modelo funda))
   (orden (modelo mica))
   =>
   (assert (descuento (porcentaje 0.07)
                      (texto "7% de descuento por comprar funda y mica juntas.")))
   (printout t "Promo: Combo funda + mica → 7% de descuento." crlf)
)

;;Scotiabank → 4% cashback en compras mayores a $20,000
(defrule reglas-cashback-scotiabank
   (orden (tarjeta scotiabank) (monto-final ?m&:(> ?m 20000)))
   =>
   (assert (oferta (texto "4% de cashback pagando con tarjeta Scotiabank en compras grandes.")))
   (printout t "Promo: Scotiabank → 4% cashback." crlf)
)

;;ThinkBook15 → incluye ratón pro con 30% descuento
(defrule reglas-thinkbook-raton
   (orden (modelo ThinkBook15))
   =>
   (assert (descuento (porcentaje 0.30)
                      (texto "30% de descuento en ratonpro al comprar ThinkBook15.")))
   (printout t "Promo: ThinkBook15 → 30% descuento en ratonpro." crlf)
)

;;Smartphone Xiaomi → 10% descuento en audífonos
(defrule reglas-xiaomi-audifonos
   (orden (marca xiaomi) (type smartphone))
   =>
   (assert (descuento (porcentaje 0.10)
                      (texto "10% de descuento en audífonos por comprar smartphone Xiaomi.")))
   (printout t "Promo: Xiaomi Smartphone → 10% en audífonos." crlf)
)

;;Cliente con ticket-medio > 2000 → recomendación de Samsung GalaxyA55
(defrule reglas-recom-cliente-premium
   (cliente (id ?cid) (ticket-medio ?t&:(> ?t 2000)))
   =>
   (assert (recomendacion 
              (texto "Recomendación: GalaxyA55 es una opción ideal para clientes con ticket alto.")))
   (printout t "Recomendación: cliente premium → sugerir GalaxyA55." crlf))




;;Compra con Scotiabank y monto > $18,000 → 6 MSI
(defrule regla-msi-scotiabank-monto
   (orden (tarjeta scotiabank) (monto-final ?m))
   (test (> ?m 18000))
   =>
   (printout t "Promo: Scotiabank → 6 meses sin intereses en compras mayores a $18,000." crlf)
   (assert (oferta (texto "Scotiabank: 6 MSI en compras > $18,000.")))
)

;;Compra más de 2 accesorios → 22% descuento
(defrule regla-desc-volumen-accesorios
   (orden (modelo funda) (qty ?c1))
   (orden (modelo mica) (qty ?c2))
   (test (> (+ ?c1 ?c2) 2))
   =>
   (printout t "Promo: 22% de descuento en accesorios por comprar más de 2." crlf)
   (assert (descuento (porcentaje 0.22) (texto "22% en accesorios por volumen.")))
)

;;Producto Apple → ofrecer AppleCare (texto sin duplicar)
(defrule regla-applecare-basica
   (orden (marca apple))
   =>
   (printout t "Sugerencia: Añade AppleCare para protección extendida." crlf)
   (assert (recomendacion (texto "AppleCare disponible para tu producto Apple.")))
)

;;Compra ThinkBook15 → obsequio ratón
(defrule regla-thinkbook-obsequio
   (orden (modelo ThinkBook15))
   =>
   (printout t "Promo: ThinkBook15 → ratón inalámbrico de regalo." crlf)
   (assert (oferta (texto "Ratón inalámbrico gratis con ThinkBook15.")))
)

;;Pago en efectivo → 7% descuento adicional
(defrule regla-descuento-efectivo
   (orden (pago cash))
   =>
   (printout t "Promo: Pago en efectivo → 7% descuento adicional." crlf)
   (assert (descuento (porcentaje 0.07) (texto "7% adicional por pago en efectivo.")))
)

;;Compra HPProBook440 → licencia antivirus 18 meses
(defrule regla-antivirus-hppro
   (orden (modelo HPProBook440))
   =>
   (printout t "Promo: HP ProBook → antivirus gratis por 18 meses." crlf)
   (assert (oferta (texto "Antivirus gratis con HP ProBook por 18 meses.")))
)

;;MacBookAir con VISA → 4 meses sin intereses extra
(defrule regla-macbookair-visa
   (orden (modelo MacBookAir) (tarjeta visa))
   =>
   (printout t "Promo: MacBookAir + VISA → 4 meses sin intereses extra." crlf)
   (assert (oferta (texto "MacBookAir + VISA: 4 MSI extra.")))
)

;;Compras grandes → 12% en vales (umbral ajustado)
(defrule regla-vales-compra-grande
   (orden (monto-final ?m))
   (test (> ?m 50000))
   =>
   (bind ?vales (* 0.12 ?m))
   (printout t "Promo: 12% de tu compra en vales electrónicos (> $50,000)." crlf)
   (assert (oferta (texto (str-cat "12% en vales por compra de $" ?m "."))))
)

;;Productos Samsung (GalaxyA55) → 12% descuento accesorios Samsung
(defrule regla-desc-samsung-accesorios
   (orden (marca samsung))
   =>
   (printout t "Promo: 12% descuento en accesorios Samsung." crlf)
   (assert (oferta (texto "12% descuento accesorios Samsung.")))
)

;;iPhone16 + audífonos → descuento fijo $450
(defrule regla-combo-audio-iphone
   (orden (modelo iPhone16))
   (orden (modelo audifonos))
   =>
   (printout t "Promo: Combo iPhone + audífonos → $450 descuento." crlf)
   (assert (descuento (porcentaje 0.017) (texto "Descuento combo iPhone + audífonos ($450 aprox).")))
)

;;ThinkBook15 + HSBC → 6 MSI
(defrule regla-msi-thinkbook-hsbc
   (orden (modelo ThinkBook15) (tarjeta hsbc))
   =>
   (printout t "Promo: ThinkBook15 + HSBC → 6 meses sin intereses." crlf)
   (assert (oferta (texto "ThinkBook15 + HSBC: 6 MSI.")))
)

;;Apple premium → vales 8%
(defrule regla-premium-vales-apple
   (orden (marca apple) (modelo ?p) (monto-final ?m))
   (test (and (or (eq ?p MacStudioX) (eq ?p iPhone16)) (> ?m 40000)))
   =>
   (printout t "Promo: Compra Apple premium → 8% en vales adicionales." crlf)
   (assert (oferta (texto "Apple premium: 8% en vales.")))
)

;;Descuento por volumen genérico (ajustado)
(defrule regla-descuento-por-volumen
   (orden (modelo ?m) (qty ?q&:(> ?q 1)))
   =>
   (bind ?porc (if (> ?q 5) then 0.12 else (if (> ?q 2) then 0.08 else 0.04)))
   (printout t "Promo: " (* ?porc 100) "% de descuento por volumen en " ?m crlf)
   (assert (descuento (porcentaje ?porc) (texto "Descuento por volumen en mismo producto.")))
)

;;Tarjeta generica (ejemplo informativo)
(defrule regla-tarjeta-gen
   (orden (tarjeta hsbc))
   =>
   (printout t "INFO: Cliente paga con tarjeta HSBC (regla informativa)." crlf)
)

;;Oferta por paquete de audífonos
(defrule regla-oferta-personalizada
   (orden (modelo audifonos) (qty ?q&:(>= ?q 2)))
   =>
   (printout t "Promo: Audífonos x2 → 18% de descuento por paquete." crlf)
   (assert (oferta (texto "18% OFF en paquete de audífonos x2.")))
)
