
;;templates

(deftemplate smartphone
   (slot marca)
   (slot modelo)
   (slot color)
   (slot precio))

(deftemplate computadora
   (slot marca)
   (slot modelo)
   (slot color)
   (slot precio))

(deftemplate accesorio
   (slot nombre)
   (slot tipo)
   (slot precio))

(deftemplate cliente
   (slot id)
   (slot nombre)
   (slot edad)
   (slot correo)
   (slot telefono)
   (slot patron-de-compra)
   (slot ticket-medio)
   (slot metodo-pago)
   (slot categorias-habituadas))

(deftemplate orden
   (slot id)
   (slot cliente-id)
   (slot type)          
   (slot marca)
   (slot modelo)
   (slot qty)
   (slot pago)
   (slot tarjeta)       
   (slot monto-final))

(deftemplate tarjetacred
   (slot banco)
   (slot grupo)
   (slot exp-date))

(deftemplate vale
   (slot codigo)
   (slot descuento)
   (slot valido-hasta))

(deftemplate stock
   (slot modelo)
   (slot cantidad))

(deftemplate oferta
   (slot texto))

(deftemplate descuento
   (slot porcentaje)
   (slot texto))

(deftemplate recomendacion
   (slot texto))

(deftemplate control-hecho
   (slot tipo)) ;;evita duplicados de sugerencias



;; deffacts
(deffacts productos-iniciales
   (smartphone (marca apple) (modelo iPhone16) (color rojo) (precio 27000))
   (smartphone (marca samsung) (modelo GalaxyA55) (color negro) (precio 18990))
   (smartphone (marca xiaomi) (modelo RedmiNote12) (color azul) (precio 12990))

   (computadora (marca apple) (modelo MacBookAir) (color plata) (precio 42000))
   (computadora (marca apple) (modelo MacStudioX) (color gris) (precio 52000))
   (computadora (marca hp) (modelo HPProBook440) (color negro) (precio 17500))
   (computadora (marca lenovo) (modelo ThinkBook15) (color plata) (precio 19500))

   (accesorio (nombre audifonos) (tipo bluetooth) (precio 1150))
   (accesorio (nombre ratonpro) (tipo gamer) (precio 950))
   (accesorio (nombre funda) (tipo protector) (precio 380))
   (accesorio (nombre mica) (tipo protector-pantalla) (precio 180))
)

(deffacts clientes-iniciales
   (cliente (id c1) (nombre "Juan Pérez") (edad 28) (correo "juanp@gmail.com") (telefono "3312345678")
            (patron-de-compra mensual) (ticket-medio 1500) (metodo-pago tarjeta) (categorias-habituadas "tecnología"))
   (cliente (id c2) (nombre "María López") (edad 35) (correo "maria.lopez@gmail.com") (telefono "3322334455")
            (patron-de-compra semanal) (ticket-medio 1800) (metodo-pago tarjeta) (categorias-habituadas "tecnología"))
   (cliente (id c3) (nombre "José Gómez") (edad 40) (correo "josegomez@hotmail.com") (telefono "3333456789")
            (patron-de-compra quincenal) (ticket-medio 1200) (metodo-pago efectivo) (categorias-habituadas "accesorios"))
)

(deffacts tarjetas-iniciales
   ;; Bancos: scotiabank, hsbc, banorte
   (tarjetacred (banco scotiabank) (grupo visa) (exp-date 01-12-26))
   (tarjetacred (banco hsbc) (grupo mastercard) (exp-date 15-09-25))
   (tarjetacred (banco banorte) (grupo visa) (exp-date 10-11-27))
)

(deffacts vales-iniciales
   (vale (codigo V123) (descuento 18) (valido-hasta 2025)) 
   (vale (codigo V456) (descuento 22) (valido-hasta 2026))
   (vale (codigo V789) (descuento 12) (valido-hasta 2024))
)

(deffacts ordenes-iniciales
   (orden (id o1) (cliente-id c1) (type smartphone) (marca apple) (modelo iPhone16) (qty 1) (monto-final 27000) (pago tarjeta) (tarjeta scotiabank))
   (orden (id o2) (cliente-id c2) (type smartphone) (marca samsung) (modelo GalaxyA55) (qty 1) (monto-final 18990) (pago tarjeta) (tarjeta banorte))
   (orden (id o3) (cliente-id c3) (type accesorio) (marca xiaomi) (modelo audifonos) (qty 2) (monto-final 2300) (pago efectivo))
)

;; stock inicial
(deffacts stock-inicial
   (stock (modelo iPhone16) (cantidad 120))
   (stock (modelo GalaxyA55) (cantidad 60))
   (stock (modelo MacBookAir) (cantidad 25))
   (stock (modelo MacStudioX) (cantidad 10))
   (stock (modelo funda) (cantidad 420))
   (stock (modelo mica) (cantidad 480))
)
