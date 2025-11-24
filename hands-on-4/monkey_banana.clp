;;; =============================================
;;; MONKEY AND BANANA PROBLEM IN CLIPS - CORREGIDO
;;; =============================================

;;; DEFINICION DE TEMPLATES
(deftemplate estado
  (slot id (type INTEGER))
  (slot mono-pos (allowed-symbols a b c))
  (slot caja-pos (allowed-symbols a b c))  
  (slot sobre-caja (type SYMBOL) (allowed-symbols si no))
  (slot tiene-banano (type SYMBOL) (allowed-symbols si no))
  (slot padre (type INTEGER) (default -1))
)

(deftemplate accion
  (slot tipo (allowed-symbols caminar empujar subir agarrar))
  (slot desde (allowed-symbols a b c))
  (slot hacia (allowed-symbols a b c))
  (slot estado-id (type INTEGER))
)

(deftemplate plan-solucion
  (multislot acciones)
)

(deftemplate reconstruir-plan
  (slot estado-id (type INTEGER))
)

;;; HECHOS INICIALES
(deffacts inicializacion
  (banano-pos c)
  (ultimo-id 1)
  (estado (id 1) (mono-pos a) (caja-pos b) (sobre-caja no) (tiene-banano no) (padre -1))
)

;;; REGLAS CORREGIDAS

;; Regla para caminar a otra posición
(defrule caminar
  (declare (salience 10))
  ?estado <- (estado (id ?id) (mono-pos ?mono-pos) (caja-pos ?caja-pos) 
             (sobre-caja no) (tiene-banano no))
  ?ultimo <- (ultimo-id ?last)
  (test (neq ?mono-pos ?caja-pos))
  (not (estado (mono-pos ?caja-pos) (caja-pos ?caja-pos) (sobre-caja no) (tiene-banano no)))
  =>
  (bind ?new-id (+ ?last 1))
  (assert (estado (id ?new-id) (mono-pos ?caja-pos) (caja-pos ?caja-pos) 
                  (sobre-caja no) (tiene-banano no) (padre ?id)))
  (assert (accion (tipo caminar) (desde ?mono-pos) (hacia ?caja-pos) (estado-id ?new-id)))
  (retract ?ultimo)
  (assert (ultimo-id ?new-id))
  (printout t "ACCION " ?new-id ": Mono camina de " ?mono-pos " a " ?caja-pos crlf)
)

;; Regla para empujar la caja
(defrule empujar
  (declare (salience 20))
  ?estado <- (estado (id ?id) (mono-pos ?pos) (caja-pos ?pos) 
             (sobre-caja no) (tiene-banano no))
  ?ultimo <- (ultimo-id ?last)
  (banano-pos ?banano-pos)
  (test (neq ?pos ?banano-pos))
  (not (estado (mono-pos ?banano-pos) (caja-pos ?banano-pos) (sobre-caja no) (tiene-banano no)))
  =>
  (bind ?new-id (+ ?last 1))
  (assert (estado (id ?new-id) (mono-pos ?banano-pos) (caja-pos ?banano-pos) 
                  (sobre-caja no) (tiene-banano no) (padre ?id)))
  (assert (accion (tipo empujar) (desde ?pos) (hacia ?banano-pos) (estado-id ?new-id)))
  (retract ?ultimo)
  (assert (ultimo-id ?new-id))
  (printout t "ACCION " ?new-id ": Mono empuja caja de " ?pos " a " ?banano-pos crlf)
)

;; Regla para subir a la caja
(defrule subir
  (declare (salience 30))
  ?estado <- (estado (id ?id) (mono-pos ?pos) (caja-pos ?pos) 
             (sobre-caja no) (tiene-banano no))
  ?ultimo <- (ultimo-id ?last)
  (banano-pos ?banano-pos)
  (test (eq ?pos ?banano-pos))
  (not (estado (mono-pos ?pos) (caja-pos ?pos) (sobre-caja si) (tiene-banano no)))
  =>
  (bind ?new-id (+ ?last 1))
  (assert (estado (id ?new-id) (mono-pos ?pos) (caja-pos ?pos) 
                  (sobre-caja si) (tiene-banano no) (padre ?id)))
  (assert (accion (tipo subir) (desde ?pos) (hacia ?pos) (estado-id ?new-id)))
  (retract ?ultimo)
  (assert (ultimo-id ?new-id))
  (printout t "ACCION " ?new-id ": Mono se sube a la caja en posicion " ?pos crlf)
)

;; Regla para agarrar el banano
(defrule agarrar
  (declare (salience 40))
  ?estado <- (estado (id ?id) (mono-pos ?pos) (caja-pos ?pos) 
             (sobre-caja si) (tiene-banano no))
  ?ultimo <- (ultimo-id ?last)
  (banano-pos ?banano-pos)
  (test (eq ?pos ?banano-pos))
  (not (estado (mono-pos ?pos) (caja-pos ?pos) (sobre-caja si) (tiene-banano si)))
  =>
  (bind ?new-id (+ ?last 1))
  (assert (estado (id ?new-id) (mono-pos ?pos) (caja-pos ?pos) 
                  (sobre-caja si) (tiene-banano si) (padre ?id)))
  (assert (accion (tipo agarrar) (desde ?pos) (hacia ?pos) (estado-id ?new-id)))
  (retract ?ultimo)
  (assert (ultimo-id ?new-id))
  (printout t "ACCION " ?new-id ": Mono agarra el banano en posicion " ?pos crlf)
)

;; Regla para detectar cuando se alcanza la solucion
(defrule solucion-encontrada
  (declare (salience 50))
  (estado (id ?id) (tiene-banano si))
  (not (plan-solucion))
  =>
  (printout t crlf "=== SOLUCION ENCONTRADA ===" crlf)
  (printout t "Estado final ID: " ?id crlf)
  (printout t "El mono ha conseguido el banano!" crlf)
  (assert (plan-solucion (acciones)))
  (assert (reconstruir-plan (estado-id ?id)))
)

;; Regla para reconstruir el plan desde el estado final
(defrule reconstruir-camino
  (declare (salience 60))
  ?reconstruir <- (reconstruir-plan (estado-id ?estado-id))
  ?accion <- (accion (estado-id ?estado-id) (tipo ?tipo) (desde ?desde) (hacia ?hacia))
  ?estado <- (estado (id ?estado-id) (padre ?padre-id))
  ?plan <- (plan-solucion (acciones $?acciones-actuales))
  =>
  (bind ?accion-str (str-cat (sym-cat ?tipo) " de " (sym-cat ?desde) " a " (sym-cat ?hacia)))
  (modify ?plan (acciones (create$ ?accion-str $?acciones-actuales)))
  (if (neq ?padre-id -1) then
    (assert (reconstruir-plan (estado-id ?padre-id)))
  )
  (retract ?reconstruir)
)

;; Regla para mostrar el plan final
(defrule mostrar-plan-final
  (declare (salience 70))
  ?plan <- (plan-solucion (acciones $?acciones))
  (not (reconstruir-plan))
  =>
  (printout t crlf "=== PLAN DE ACCIONES ===" crlf)
  (bind ?count 1)
  (bind ?total 0)
  (foreach ?accion ?acciones
    (printout t ?count ". " ?accion crlf)
    (bind ?count (+ ?count 1))
    (bind ?total (+ ?total 1))
  )
  (printout t crlf "Total de acciones: " ?total crlf)
  (printout t "=== EJECUCION COMPLETADA ===" crlf crlf)
  (halt)
)

;; Regla de seguridad para evitar bucles infinitos
(defrule limite-ejecucion
  (declare (salience -10))
  ?ultimo <- (ultimo-id ?id)
  (test (> ?id 20))
  =>
  (printout t crlf "=== LIMITE DE EJECUCION ALCANZADO ===" crlf)
  (printout t "No se encontro solucion en 20 pasos." crlf)
  (halt)
)