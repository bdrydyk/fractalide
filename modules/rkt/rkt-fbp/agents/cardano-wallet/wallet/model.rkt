#lang racket

(require fractalide/modules/rkt/rkt-fbp/agent
         fractalide/modules/rkt/rkt-fbp/def)

(require/edge ${cardano-wallet.model})

(define-agent
  #:input '("in") ; in array port
  #:output '("out" "update" "summary" "receive" "settings") ; out port
  (define msg (recv (input "in")))
  (define acc (try-recv (input "acc")))
  (match msg
    [(cons 'init w) #:when (wallet? w)
                         (set! acc w)
                         (send (output "update") (struct-copy wallet w))
                         (send (output "out") '(display . #t))]
    [(cons 'set w)
     (set! acc w)
     (send (output "summary") (cons 'init w))
     (send (output "receive") (cons 'init w))
     (send (output "settings") (cons 'init w))]
    [(cons 'display #t)
     (send (output "summary") (cons 'display #t))
     (send (output "out") (cons 'display #t))]
    [else (send (output "out") msg)])
    (send (output "acc") acc))
