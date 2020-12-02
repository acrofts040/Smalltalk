;;;;;;;;;;;;;;;;;;; COMP 105 SMALL ASSIGNMENT ;;;;;;;;;;;;;;;
;; regression-nat.smt
;; COMP 105 - hw9 small
;; Fall 2020

;; Name: Ann Marie Burke (aburke04)
;; Partner: Andrew Crofts

(use bignum.smt)

;;;;;;;;;; TESTING FOR CLASS NATURAL ;;;;;;;;;;

;; check-assert tests for =
(check-assert ((Natural fromSmall: 0) = (Natural fromSmall: 0)))
(check-assert ((Natural fromSmall: 1) = (Natural fromSmall: 1)))
(check-assert ((Natural fromSmall: 15) = (Natural fromSmall: 15)))
(check-assert ((Natural fromSmall: 16) = (Natural fromSmall: 16)))
(check-assert ((Natural fromSmall: 17) = (Natural fromSmall: 17)))
(check-assert ((Natural fromSmall: 22) = (Natural fromSmall: 22)))

(check-assert (((Natural fromSmall: 0) = (Natural fromSmall: 22)) not))
(check-assert (((Natural fromSmall: 1) = (Natural fromSmall: 15)) not))
(check-assert (((Natural fromSmall: 2) = (Natural fromSmall: 1)) not))

;; check-assert tests for <
(check-assert ((Natural fromSmall: 0) < (Natural fromSmall: 1)))
(check-assert ((Natural fromSmall: 0) < (Natural fromSmall: 536)))
(check-assert ((Natural fromSmall: 1) < (Natural fromSmall: 2)))
(check-assert ((Natural fromSmall: 15) < (Natural fromSmall: 16)))
(check-assert ((Natural fromSmall: 16) < (Natural fromSmall: 26)))
(check-assert ((Natural fromSmall: 17) < (Natural fromSmall: 1352)))

(check-assert (((Natural fromSmall: 0) < (Natural fromSmall: 0)) not))
(check-assert (((Natural fromSmall: 1) < (Natural fromSmall: 1)) not))
(check-assert (((Natural fromSmall: 2) < (Natural fromSmall: 1)) not))

;; check-assert tests for >
(check-assert ((Natural fromSmall: 1) > (Natural fromSmall: 0)))
(check-assert ((Natural fromSmall: 15) > (Natural fromSmall: 10)))
(check-assert ((Natural fromSmall: 1565) > (Natural fromSmall: 16)))

(check-assert (((Natural fromSmall: 0) > (Natural fromSmall: 0)) not))
(check-assert (((Natural fromSmall: 1) > (Natural fromSmall: 1)) not))
(check-assert (((Natural fromSmall: 1) > (Natural fromSmall: 7)) not))

;; check-assert tests for <=
(check-assert ((Natural fromSmall: 0) <= (Natural fromSmall: 0)))
(check-assert ((Natural fromSmall: 0) <= (Natural fromSmall: 1)))
(check-assert ((Natural fromSmall: 1) <= (Natural fromSmall: 1)))
(check-assert ((Natural fromSmall: 1) <= (Natural fromSmall: 2)))
(check-assert ((Natural fromSmall: 15) <= (Natural fromSmall: 15)))
(check-assert ((Natural fromSmall: 15) <= (Natural fromSmall: 16)))
(check-assert ((Natural fromSmall: 16) <= (Natural fromSmall: 26)))
(check-assert ((Natural fromSmall: 127) <= (Natural fromSmall: 128)))
(check-assert ((Natural fromSmall: 127) <= (Natural fromSmall: 127)))
(check-assert ((Natural fromSmall: 17) <= (Natural fromSmall: 1352)))

(check-assert (((Natural fromSmall: 24) <= (Natural fromSmall: 0)) not))
(check-assert (((Natural fromSmall: 100) <= (Natural fromSmall: 1)) not))
(check-assert (((Natural fromSmall: 16) <= (Natural fromSmall: 1)) not))
(check-assert (((Natural fromSmall: 127) <= (Natural fromSmall: 126)) not))

;; check-assert tests for >=
(check-assert ((Natural fromSmall: 0) >= (Natural fromSmall: 0)))
(check-assert ((Natural fromSmall: 1) >= (Natural fromSmall: 0)))
(check-assert ((Natural fromSmall: 15) >= (Natural fromSmall: 15)))
(check-assert ((Natural fromSmall: 16) >= (Natural fromSmall: 15)))
(check-assert ((Natural fromSmall: 1565) >= (Natural fromSmall: 16)))

(check-assert (((Natural fromSmall: 0) >= (Natural fromSmall: 1)) not))
(check-assert (((Natural fromSmall: 1) >= (Natural fromSmall: 5)) not))
(check-assert (((Natural fromSmall: 1) >= (Natural fromSmall: 798)) not))

;; printrep tests for adding nat + 0
(check-print ((Natural fromSmall: 0) + (Natural fromSmall: 0)) 0)
(check-print ((Natural fromSmall: 0) + (Natural fromSmall: 1)) 1)
(check-print ((Natural fromSmall: 1) + (Natural fromSmall: 0)) 1)
(check-print ((Natural fromSmall: 0) + (Natural fromSmall: 10)) 10)
(check-print ((Natural fromSmall: 10) + (Natural fromSmall: 0)) 10)
(check-print ((Natural fromSmall: 0) + (Natural fromSmall: 16)) 16)
(check-print ((Natural fromSmall: 16) + (Natural fromSmall: 0)) 16)
(check-print ((Natural fromSmall: 0) + (Natural fromSmall: 143)) 143)
(check-print ((Natural fromSmall: 143) + (Natural fromSmall: 0)) 143)

;; tests for adding nonzero naturals
(check-print ((Natural fromSmall: 1)   + (Natural fromSmall: 1)) 2)
(check-print ((Natural fromSmall: 1)   + (Natural fromSmall: 2)) 3)
(check-print ((Natural fromSmall: 1)   + (Natural fromSmall: 9)) 10)
(check-print ((Natural fromSmall: 9)   + (Natural fromSmall: 1)) 10)
(check-print ((Natural fromSmall: 1)   + (Natural fromSmall: 15)) 16)
(check-print ((Natural fromSmall: 15)  + (Natural fromSmall: 1)) 16)
(check-print ((Natural fromSmall: 1)   + (Natural fromSmall: 127)) 128)
(check-print ((Natural fromSmall: 127) + (Natural fromSmall: 1)) 128)
(check-print ((Natural fromSmall: 1)   + (Natural fromSmall: 143)) 144)
(check-print ((Natural fromSmall: 143) + (Natural fromSmall: 1)) 144)
(check-print ((Natural fromSmall: 1)   + (Natural fromSmall: 1023)) 1024)
(check-print ((Natural fromSmall: 1023) + (Natural fromSmall: 1)) 1024)

;; check-print tests for multiplying nat * 0
(check-print ((Natural fromSmall: 0)  * (Natural fromSmall: 0)) 0)
(check-print ((Natural fromSmall: 0)  * (Natural fromSmall: 1))  0)
(check-print ((Natural fromSmall: 1)  * (Natural fromSmall: 0))  0)
(check-print ((Natural fromSmall: 0)  * (Natural fromSmall: 10)) 0)
(check-print ((Natural fromSmall: 10) * (Natural fromSmall: 0))  0)
(check-print ((Natural fromSmall: 0)  * (Natural fromSmall: 16)) 0)
(check-print ((Natural fromSmall: 16) * (Natural fromSmall: 0))  0)
(check-print ((Natural fromSmall: 0)  * (Natural fromSmall: 143)) 0)
(check-print ((Natural fromSmall: 143) * (Natural fromSmall: 0)) 0)

;; check-print tests for multiplying nat * nat
(check-print ((Natural fromSmall: 1) * (Natural fromSmall: 1)) 1)     
(check-print ((Natural fromSmall: 1) * (Natural fromSmall: 2)) 2)     
(check-print ((Natural fromSmall: 2) * (Natural fromSmall: 2)) 4)     
(check-print ((Natural fromSmall: 27) * (Natural fromSmall: 1)) 27)
(check-print ((Natural fromSmall: 1) * (Natural fromSmall: 27)) 27)
(check-print ((Natural fromSmall: 2) * (Natural fromSmall: 27)) 54)
(check-print ((Natural fromSmall: 12) * (Natural fromSmall: 12)) 144)
(check-print ((Natural fromSmall: 122) * (Natural fromSmall: 227)) 27694)

;; check-print tests for sdiv:
(check-print ((Natural fromSmall: 0) sdiv: 1) 0)
(check-print ((Natural fromSmall: 0) sdiv: 194) 0)

(check-print ((Natural fromSmall: 1) sdiv: 10) 0)
(check-print ((Natural fromSmall: 1) sdiv: 16) 0)
(check-print ((Natural fromSmall: 15) sdiv: 10) 1)
(check-print ((Natural fromSmall: 16) sdiv: 10) 1)
(check-print ((Natural fromSmall: 16) sdiv: 1) 16)
(check-print ((Natural fromSmall: 25) sdiv: 10) 2)

(check-error ((Natural fromSmall: 0) sdiv: 0))
(check-error ((Natural fromSmall: 16) sdiv: 0))

;; test for smod:
(check-expect ((Natural fromSmall: 0) smod: 1) 0)
(check-expect ((Natural fromSmall: 0) smod: 186) 0)
(check-expect ((Natural fromSmall: 1) smod: 10) 1)
(check-expect ((Natural fromSmall: 1) smod: 16) 1)
(check-expect ((Natural fromSmall: 15) smod: 10) 5)
(check-expect ((Natural fromSmall: 16) smod: 10) 6)
(check-expect ((Natural fromSmall: 16) smod: 1) 0)
(check-expect ((Natural fromSmall: 25) smod: 10) 5)

(check-error ((Natural fromSmall: 0) smod: 0))
(check-error ((Natural fromSmall: 16) smod: 0))

;; check-expect tests
(check-expect ((Natural fromSmall: 0) decimal)     '( 0 ))
(check-expect ((Natural fromSmall: 1) decimal)     '( 1 ))
(check-expect ((Natural fromSmall: 15) decimal)    '( 1 5 ))
(check-expect ((Natural fromSmall: 12345) decimal) '( 1 2 3 4 5 ))
(check-expect (((Natural fromSmall: 12345) + (Natural fromSmall: 1)) decimal) '( 1 2 3 4 6 ))

;; check-print tests
(check-print (Natural fromSmall: 0)  0)
(check-print (Natural fromSmall: 1)  1)
(check-print (Natural fromSmall: 10) 10)
(check-print (Natural fromSmall: 15) 15)
(check-print (Natural fromSmall: 16) 16)
(check-print (Natural fromSmall: 17) 17)
(check-print (Natural fromSmall: 143) 143)
(check-print ((Natural fromSmall: 5824) + (Natural fromSmall: 1000)) 6824)
(check-print ((Natural fromSmall: 256492) * (Natural fromSmall: 666481))
             170947044652)

;;;;;;;;;; END TESTING FOR NATURAL ;;;;;;;;;;

