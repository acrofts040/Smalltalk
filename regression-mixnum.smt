;;;;;;;;;;;;;;;;;;; COMP 105 SMALL ASSIGNMENT ;;;;;;;;;;;;;;;
;; regression-mixnum.smt
;; COMP 105 - hw9 small
;; Fall 2020

;; Name: Ann Marie Burke (aburke04)
;; Partner: Andrew Crofts

(use mixnum.smt)

;;;;;;;;;; TESTING FOR MIXNUM ;;;;;;;;;;

;; tests for initializing small int
(check-print (SmallInteger new: 0) 0)
(check-print (SmallInteger new: 1) 1)
(check-print (SmallInteger new: 10) 10)
(check-print (SmallInteger new: 16) 16)
(check-print (SmallInteger new: 26) 26)
(check-print (SmallInteger new: 100) 100)

;; tests for asLargeInteger
(check-print ((SmallInteger new: 0) asLargeInteger) 0)
(check-print ((SmallInteger new: 0) asLargeInteger) 0)
(check-print ((SmallInteger new: 1) asLargeInteger) 1)
(check-print ((SmallInteger new: 9) asLargeInteger) 9)
(check-print ((SmallInteger new: 10) asLargeInteger) 10)
(check-print ((SmallInteger new: 14) asLargeInteger) 14)
(check-print ((SmallInteger new: 15) asLargeInteger) 15)
(check-print ((SmallInteger new: 16) asLargeInteger) 16)
(check-print ((SmallInteger new: 17) asLargeInteger) 17)
(check-print ((SmallInteger new: 100) asLargeInteger) 100)
(check-print ((SmallInteger new: 499) asLargeInteger) 499)
(check-print ((SmallInteger new: 500) asLargeInteger) 500)
(check-print ((SmallInteger new: 501) asLargeInteger) 501)
(check-print ((SmallInteger new: 1001) asLargeInteger) 1001)

;; tests for negated
(check-print ((SmallInteger new: 0) negated) 0)
(check-print ((SmallInteger new: 1) negated) -1)
(check-print ((SmallInteger new: -1) negated) 1)
(check-print ((SmallInteger new: 5) negated) -5)
(check-print ((SmallInteger new: -3) negated) 3)
(check-print ((SmallInteger new: 100) negated) -100)
(check-print ((SmallInteger new: -249) negated) 249)

;; tests for =
(check-assert ((SmallInteger new: 0) = (SmallInteger new: 0)))
(check-assert ((SmallInteger new: 1) = (SmallInteger new: 1)))
(check-assert ((SmallInteger new: 10) = (SmallInteger new: 10)))
(check-assert ((SmallInteger new: 16) = (SmallInteger new: 16)))
(check-assert ((SmallInteger new: 25) = (SmallInteger new: 25)))
(check-assert ((SmallInteger new: 100) = (SmallInteger new: 100)))
(check-assert ((SmallInteger new: 250) = (SmallInteger new: 250)))
(check-assert ((SmallInteger new: 1001) = (SmallInteger new: 1001)))

;; tests for +
(check-expect ((SmallInteger new: 0) + (SmallInteger new: 0)) 0)
(check-expect ((SmallInteger new: 0) + (SmallInteger new: 1)) 1)
(check-expect ((SmallInteger new: 1) + (SmallInteger new: 0)) 1)
(check-expect ((SmallInteger new: 1) + (SmallInteger new: 1)) 2)
(check-expect ((SmallInteger new: 155) + (SmallInteger new: 16)) 171)
(check-expect ((SmallInteger new: 1426) + (SmallInteger new: 0)) 1426)
(check-expect ((SmallInteger new: 1) + (SmallInteger new: 1001)) 1002)

;; tests for *

(check-print ((SmallInteger new: 1)      * (SmallInteger new: 0)) 0)
(check-print ((SmallInteger new: 134656) * (SmallInteger new: 0)) 0)
(check-print ((SmallInteger new: 0)      * (SmallInteger new: 2436075)) 0)

(check-print ((SmallInteger new: 100) * (SmallInteger new: 100)) 10000)
(check-print ((SmallInteger new: 10) * (SmallInteger new: 48)) 480)

(check-print ((SmallInteger new: 100) * (SmallInteger new: -1)) -100)
(check-print ((SmallInteger new: 0) * ((SmallInteger new: 1) negated)) 0)
(check-print ((SmallInteger new: 0) * (SmallInteger new: -12234)) 0)
(check-print ((SmallInteger new: 2465) * (SmallInteger new: -1)) -2465)
(check-print ((SmallInteger new: 4958) * (SmallInteger new: -100)) -495800)
(check-print ((SmallInteger new: 10) * (SmallInteger new: -20)) -200)

(check-print ((SmallInteger new: -1) * (SmallInteger new: 100)) -100)
(check-print ((SmallInteger new: -1) * (SmallInteger new: 0)) 0)
(check-print ((SmallInteger new: -12234) * (SmallInteger new: 0)) 0)
(check-print ((SmallInteger new: -12234) * (SmallInteger new: 1)) -12234)
(check-print ((SmallInteger new: -12234) * (SmallInteger new: 325)) -3976050)
(check-print ((SmallInteger new: -100) * (SmallInteger new: 2436175)) -243617500)

(check-print ((SmallInteger new: -1) * (SmallInteger new: -100)) 100)
(check-print ((SmallInteger new: -1) * (SmallInteger new: -1)) 1)
(check-print ((SmallInteger new: -12234) * (SmallInteger new: -1)) 12234)
(check-print ((SmallInteger new: -12234) * (SmallInteger new: -325)) 3976050)
(check-print ((SmallInteger new: -100) * (SmallInteger new: -275)) 27500)

;; tests for -
(check-expect ((SmallInteger new: 0) - (SmallInteger new: 0)) 0)
(check-expect ((SmallInteger new: 1) - (SmallInteger new: 0)) 1)
(check-expect ((SmallInteger new: 5) - (SmallInteger new: 1)) 4)
(check-expect ((SmallInteger new: 1) - (SmallInteger new: 1)) 0)
(check-expect ((SmallInteger new: 1556) - (SmallInteger new: 16)) 1540)
(check-expect ((SmallInteger new: 1426) - (SmallInteger new: 0)) 1426)




;;;;;;;;;; END TESTING FOR MIXNUM ;;;;;;;;;;