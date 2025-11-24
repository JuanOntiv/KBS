(clear)

(load "templates.clp")
(load "ruless.clp")
(load "ordenes.clp")
(load "rs.clp")

(reset)

(assert
   (orden (type smartphone) (marca apple) (modelo iPhone16) (qty 30) (pago tarjeta) (tarjeta banorte))
   (cliente (id cx1) (nombre "María Fernández") (patron-de-compra semanal)
            (ticket-medio 1900)
            (metodo-pago tarjeta)
            (categorias-habituadas "tecnología"))
)


(assert
   (orden (id o4) (cliente-id c2) (type computadora) (marca lenovo)
          (modelo ThinkBook15) (qty 1) (monto-final 19500)
          (pago tarjeta) (tarjeta hsbc))
   (cliente (id c2) (nombre "María López") (edad 35)
            (correo "maria.lopez@gmail.com") (telefono "3322334455")
            (patron-de-compra semanal) (ticket-medio 1800)
            (metodo-pago tarjeta) (categorias-habituadas "tecnología"))
)


(run)

(printout t crlf "=== Ejecución finalizada ===" crlf)
