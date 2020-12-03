;;;;;;;;;;;;;;;;;;; COMP 105 SMALL ASSIGNMENT ;;;;;;;;;;;;;;;
;; mixnum.smt
;; COMP 105 - hw9 small
;; Fall 2020

;; Name: Ann Marie Burke (aburke04)
;; Partner: Andrew Crofts

(use bignum.smt)

(class NewSmallIntegerMethods
  [subclass-of Object]
  (method asLargeInteger () (LargeInteger new: self))
  (method + (aNumber) (aNumber addSmallIntegerTo: self))
  (method addSmallIntegerTo: (anInteger)
    ((primitive addWithOverflow self anInteger
        {((self asLargeInteger) + anInteger)}) value))


  ; computes the sum of the receiver and the argument aSmallInteger.
  ; If this computation overflows, the result is ovBlock;
  ; otherwise it is a block that will answer the sum.
  (primitive addWithOverflow self aSmallInteger ovBlock)

  ; computes the difference of the receiver and the argument aSmallInteger.
  ; If this computation overflows, the result is ovBlock;
  ; otherwise it is a block that will answer the difference.
  (primitive subWithOverflow self aSmallInteger ovBlock)

  ; computes the product of the receiver and the argument aSmallInteger.
  ; If this computation overflows, the result is ovBlock;
  ; otherwise it is a block that will answer the product.
  (primitive mulWithOverflow self aSmallInteger ovBlock)

  (SmallInteger addAllMethodsFrom: NewSmallIntegerMethods)

)


Evaluating(primitiveaddWithOverflowselfaSmallIntegerovBlock) computes the sum of the receiver and the argument aSmallInteger. If this computation overflows, the result is ovBlock; otherwise it is a block that will answer the sum.
