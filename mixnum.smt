;;;;;;;;;;;;;;;;;;; COMP 105 SMALL ASSIGNMENT ;;;;;;;;;;;;;;;
;; mixnum.smt
;; COMP 105 - hw9 small
;; Fall 2020

;; Name: Ann Marie Burke (aburke04)
;; Partner: Andrew Crofts

(use bignum.smt)

(SmallInteger addSelector:withMethod: '+
  (compiled-method (aNumber) (aNumber addSmallIntegerTo: self)))
(SmallInteger addSelector:withMethod: 'addSmallIntegerTo:
  (compiled-method (anInteger)
    ((primitive addWithOverflow self anInteger
        {((self asLargeInteger) + anInteger)}) value)))

(SmallInteger addSelector:withMethod: '*
  (compiled-method (aNumber) (aNumber multiplyBySmallInteger: self)))
(SmallInteger addSelector:withMethod: 'multiplyBySmallInteger:
  (compiled-method (anInteger)
    ((primitive mulWithOverflow self anInteger
        {((self asLargeInteger) * anInteger)}) value)))

(SmallInteger addSelector:withMethod: '-
  (compiled-method (aNumber) ((aNumber negated) addSmallIntegerTo: self)))

(SmallInteger addSelector:withMethod: 'negated
  (compiled-method ()
    ((primitive subWithOverflow 0 self
        {(0 - (self asLargeInteger))}) value)))

(SmallInteger addSelector:withMethod: 'addLargePositiveIntegerTo:
  (compiled-method (aLargePositiveInteger) 
                    (aLargePositiveInteger addSmallIntegerTo: self)))

(SmallInteger addSelector:withMethod: 'addLargeNegativeIntegerTo:
  (compiled-method (aLargeNegativeInteger) 
                    (aLargeNegativeInteger addSmallIntegerTo: self)))

(SmallInteger addSelector:withMethod: 'multiplyByLargePositiveInteger:
  (compiled-method (aLargePositiveInteger) 
                    (aLargePositiveInteger multiplyBySmallInteger: self)))

(SmallInteger addSelector:withMethod: 'multiplyByLargeNegativeInteger:
  (compiled-method (aLargeNegativeInteger) 
                    (aLargeNegativeInteger multiplyBySmallInteger: self)))

; (SmallInteger addSelector:withMethod: '<
;   (compiled-method (anInteger) 
;              (anInteger smallIntegerGreaterThan: self)))

; (SmallInteger addSelector:withMethod: 'lessThanLargeInt:
;   (compiled-method (aLargeInteger) 
;                      (aLargeInteger smallIntegerGreaterThan: self)))

; (SmallInteger addSelector:withMethod: 'smallIntegerGreaterThan:
;   (compiled-method (aSmallInteger) 
;                      (primitive > aSmallInteger self)))

; (SmallInteger addSelector:withMethod: '>
;   (compiled-method (anInteger) (anInteger < self)))

; (SmallInteger addSelector:withMethod: '=
;   (compiled-method (anInteger) (self leftAsExercise)))

; (SmallInteger addSelector:withMethod: 'isZero
;   (compiled-method () (self leftAsExercise)))





