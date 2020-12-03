;;;;;;;;;;;;;;;;;;; COMP 105 SMALL ASSIGNMENT ;;;;;;;;;;;;;;;
;; regression-mixnum.smt
;; COMP 105 - hw9 small
;; Fall 2020

;; Name: Ann Marie Burke (aburke04)
;; Partner: Andrew Crofts

(use mixnum.smt)

;;;;;;;;;; TESTING FOR MIXNUM ;;;;;;;;;;

; (check-assert ((LargeInteger fromSmall: 22) = ((SmallInteger new: 22) asLargeInteger)))

(check-print (SmallInteger new: 0) 0)
(check-print (SmallInteger new: 1) 1)
(check-print (SmallInteger new: 10) 10)
(check-print (SmallInteger new: 16) 16)
(check-print (SmallInteger new: 26) 26)
(check-print (SmallInteger new: 100) 100)

(check-print ((SmallInteger new: 0) asLargeInteger) 0)
(check-print ((SmallInteger new: 0) asLargeInteger) 0)
(check-print ((SmallInteger new: 1) asLargeInteger) 1)
(check-print ((SmallInteger new: 9) asLargeInteger) 9)
; (check-print ((SmallInteger new: 10) asLargeInteger) 10)
; (check-print ((SmallInteger new: 15) asLargeInteger) 15)
; (check-print ((SmallInteger new: 16) asLargeInteger) 16)




;;;;;;;;;; END TESTING FOR MIXNUM ;;;;;;;;;;