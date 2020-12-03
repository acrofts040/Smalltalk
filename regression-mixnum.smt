;;;;;;;;;;;;;;;;;;; COMP 105 SMALL ASSIGNMENT ;;;;;;;;;;;;;;;
;; regression-mixnum.smt
;; COMP 105 - hw9 small
;; Fall 2020

;; Name: Ann Marie Burke (aburke04)
;; Partner: Andrew Crofts

(use mixnum.smt)

;;;;;;;;;; TESTING FOR MIXNUM ;;;;;;;;;;



(class Factorial
  [subclass-of Object]
  (class-method printUpto: (limit) [locals n nfac]
    (set n 1)
    (set nfac 1)
      ({(n <= limit)} whileTrue:
        {(n print) ('! print) (space print) ('= print)
                              (space print) (nfac println)
    (set n (n + 1))
    (set nfac (n * nfac))}))
)

(Factorial printUpto: 20)



; Summary: 20 factorial
(define factorial (n)
  ((n isStrictlyPositive) ifTrue:ifFalse: 
     {(n * (factorial value: (n - 1)))}
     {1}))

;;; (check-print (factorial value: 20) 2432902008176640000)

; Summary: 10 to the tenth power, linear time, mixed arithmetic
(class Test10Power
  [subclass-of Object]
  (class-method run: (power)
     [locals n 10-to-the-n]
     (set n 0)
     (set 10-to-the-n 1)
     ({(n < power)} whileTrue:
         {(set n (n + 1))
          (set 10-to-the-n (10 * 10-to-the-n))})
     10-to-the-n)
)
;;; (check-print (Test10Power run: 10) 10000000000)

; Summary: 10 to the 30th power, mixed arithmetic
;;; (check-print (Test10Power run: 30) 
;;;              1000000000000000000000000000000)



;;;;;;;;;; END TESTING FOR MIXNUM ;;;;;;;;;;