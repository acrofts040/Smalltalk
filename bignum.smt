(class Magnitude
    [subclass-of Object] ; abstract class
    (method =  (x) (self subclassResponsibility)) ; may not inherit
    (method <  (x) (self subclassResponsibility))
    (method >  (y) (y < self))
    (method <= (x) ((self > x) not))
    (method >= (x) ((self < x) not))
    (method min: (aMagnitude)
       ((self < aMagnitude) ifTrue:ifFalse: {self} {aMagnitude}))
    (method max: (aMagnitude)
       ((self > aMagnitude) ifTrue:ifFalse: {self} {aMagnitude}))
)
(class Number
    [subclass-of Magnitude]  ; abstract class
    ;;;;;;; arithmetic
    (method +   (aNumber)     (self subclassResponsibility))
    (method *   (aNumber)     (self subclassResponsibility))
    (method negated    ()     (self subclassResponsibility))
    (method reciprocal ()     (self subclassResponsibility))
    
    ;;;;;;; coercion
    (method asInteger  ()     (self subclassResponsibility))
    (method asFraction ()     (self subclassResponsibility))
    (method asFloat    ()     (self subclassResponsibility))
    (method coerce: (aNumber) (self subclassResponsibility))
    (method -  (y) (self + (y  negated)))
    (method abs () ((self isNegative) ifTrue:ifFalse: {(self negated)} {self}))
    (method /  (y) (self * (y reciprocal)))

    (method isNegative         () (self  < (self coerce: 0)))
    (method isNonnegative      () (self >= (self coerce: 0)))
    (method isStrictlyPositive () (self  > (self coerce: 0)))
    (method squared () (self * self))
    (method raisedToInteger: (anInteger)
        ((anInteger = 0) ifTrue:ifFalse:
            {(self coerce: 1)}
            {((anInteger = 1) ifTrue:ifFalse: {self}
                {(((self raisedToInteger: (anInteger div: 2)) squared) *
                    (self raisedToInteger: (anInteger mod: 2)))})}))
    (method sqrt () (self sqrtWithin: (self coerce: (1 / 100))))
    (method sqrtWithin: (epsilon) [locals two x<i-1> x<i>]
        ; find square root of receiver within epsilon
        (set two    (self coerce: 2))
        (set x<i-1> (self coerce: 1))
        (set x<i>   ((x<i-1> + (self / x<i-1>)) / two))
        ({(((x<i-1> - x<i>) abs) > epsilon)} whileTrue:
               {(set x<i-1> x<i>)
                (set x<i> ((x<i-1> + (self / x<i-1>)) / two))})
        x<i>)
)
(class Integer
    [subclass-of Number] ; abstract class
    (method div: (n) (self subclassResponsibility))
    (method mod: (n) (self - (n * (self div: n))))
    (method gcd: (n) ((n = (self coerce: 0))
                      ifTrue:ifFalse: {self} {(n gcd: (self mod: n))}))
    (method lcm: (n) (self * (n div: (self gcd: n))))
    (method reciprocal () (Fraction num:den: 1 self)) 
    (method / (aNumber) ((self asFraction) / aNumber))
    (method asFraction () (Fraction num:den:  self 1))
    (method asFloat    () (Float    mant:exp: self 0))
    (method asInteger () self)
    (method coerce: (aNumber) (aNumber asInteger))


    (method timesRepeat: (aBlock) [locals count]
        ((self isNegative) ifTrue: {(self error: 'negative-repeat-count)})
        (set count self)
        ({(count != 0)} whileTrue:
             {(aBlock value)
              (set count (count - 1))}))
)
; starter code copied from COMP 105 spec
(class Natural
    [subclass-of Magnitude]

    (class-method fromSmall: (anInteger)
      ((anInteger = 0) ifTrue:ifFalse:
        {(NatZero new)}
        {(NatNonzero first:rest:
          (anInteger mod: (self base)) ; integer d
            (Natural fromSmall: (anInteger div: (self base))))})) ; nat m


    ;;;; private class methods ;;;;

    ;; Answers b, the base of Natural numbers
    (class-method base () 16)

    ;;;; end private class methods ;;;;


    (method = (aNatural) (self subclassResponsibility))
    (method < (aNatural) (self subclassResponsibility))

    (method + (aNatural) (self subclassResponsibility))
    (method * (aNatural) (self subclassResponsibility))
    (method - (aNatural)
      (self subtract:withDifference:ifNegative:
            aNatural
            [block (x) x]
            {(self error: 'Natural-subtraction-went-negative)}))
    (method subtract:withDifference:ifNegative: (aNatural diffBlock exnBlock)
      ((self < aNatural) ifTrue:ifFalse:
        {exnBlock}
        {(diffBlock value: (self minus:borrow: aNatural 0))}))

    (method sdiv: (n) (self sdivmod:with: n [block (q r) q]))
    (method smod: (n) (self sdivmod:with: n [block (q r) r]))
    (method sdivmod:with: (n aBlock) (self subclassResponsibility))

    ; Answer a List containing the decimal digits of the receiver,
    ; most significant digit first.
    (method decimal () (self subclassResponsibility))

    (method isZero  () (self subclassResponsibility))

    (method print   () ((self decimal) do: [block (x) (x print)]))

    ; private method printrep for debugging
    (method printrep () ((self base-rep) do: [block (x) (x print) ('/ print)]))
    (method base-rep () (self subclassResponsibility)) ; private


    ;;;; private instance methods ;;;;

    ; Answers a small integer whose value is the
    ; receiver modulo the base of Natural numbers.
    (method modBase () d)

    ; Answers a Natural whose value is the
    ; receiver divided by the base of Natural numbers.
    (method divBase () m)

    ; Answers a Natural whose value is the
    ; receiver multiplied by the base of Natural numbers.
    (method timesBase () (NatNonzero first:rest: 0 self))

    ; Compares self with aNatural.
    ; If self is smaller than aNatural evaluate ltBlock.
    ; If they are equal, evaluate eqBlock.
    ; If self is greater, evaluate gtBlock.
    (method compare:withLt:withEq:withGt: (aNatural ltBlock eqBlock gtBlock)
      ((self < aNatural) ifTrue:ifFalse:
        {ltBlock}
        {((self = aNatural) ifTrue:ifFalse:
          {eqBlock}
          {gtBlock})}))

    ; Answer the sum self + aNatural + c, where c is a carry bit (either 0 or 1).
    (method plus:carry: (aNatural c) (self subclassResponsibility))

    ; Compute the difference self − (aNatural + c),
    ; where c is a borrow bit (either 0 or 1).
    ; If the difference is nonnegative, answer the difference,
    ; otherwise, halt the program with a checked run-time error.
    (method minus:borrow: (aNatural c) (self subclassResponsibility))

    ;;;; end private instance methods ;;;;

)

(class NatZero
    [subclass-of Natural]

    (method = (aNatural) (aNatural isZero))
    (method < (aNatural) ((aNatural isZero) not))

    (method + (aNatural) (self plus:carry: aNatural 0))
    (method * (aNatural) (NatZero new))

    (method sdivmod:with: (n aBlock)
      ((n = 0) ifTrue:ifFalse:
        {(self error: 'Cannot-perform-division-or-mod-by-0)}
        {(aBlock value:value: (NatZero new) 0)}))

    (method decimal () ((List new) addFirst: 0))

    ; private decimal helper
    (method decimal-helper: (aList) aList)

    ; private method
    ; analogous to decimal but uses the base of Natural
    (method base-rep () ((List new) addFirst: 0))

    ; private base-rep-helper
    (method base-rep-helper: (aList) aList)

    (method isZero () true)

    ;;;; private instance methods ;;;;

    ; Answer the sum self + aNatural + c, where c is a carry bit (either 0 or 1).
    (method plus:carry: (aNatural c)
      (self carryIntoNatural:carry: aNatural c))


    ; private helper method carryIntoNatural
    ; if c is 0, return aNatural
    ; if c is 1, add to aNatural
    (method carryIntoNatural:carry: (aNatural c)
      [locals d2 fst rst]

      ((c = 0) ifTrue:ifFalse:
        ; if c = 0, return aNatural
        {aNatural}
        ; else, check if aNatural is zero
        {((aNatural isZero) ifTrue:ifFalse:

          ; if aNatural is zero, return c
          {(Natural fromSmall: c)}

          ; else, add aNatural + c
          {(set d2 (aNatural modBase))

            ; first = (d2 + 1) mod base
            (set fst ((d2 + 1) mod: (Natural base)))

            ; rest = carryIntoNatural:carry: m ((d2 + 1) div base)
            (set rst (self carryIntoNatural:carry: 
                      (aNatural divBase)
                        ((d2 + 1) div: (Natural base))))

            (NatNonzero first:rest: fst rst)})}))

    ; Compute the difference self − (aNatural + c),
    ; where c is a borrow bit (either 0 or 1).
    ; If the difference is nonnegative, answer the difference;
    ; otherwise, halt the program with a checked run-time error.
    (method minus:borrow: (aNatural c)
      ((aNatural isZero) ifTrue:ifFalse:
        {(self borrowFromNat:borrow: aNatural c)}
        {(self error: 'Natural-subtraction-went-negative)}))

    ; private helper method borrowFromNat
    (method borrowFromNat:borrow: (aNatural c)
      ((c = 0) ifTrue:ifFalse:
        {(NatZero new)}
        {(self error: 'Natural-subtraction-went-negative)}))

    ;;;; end private instance methods ;;;;
)

(class NatNonzero
    [subclass-of Natural]

    ; instance variables
    [ivars b d m]

    ;;;; private class methods ;;;;

    ; Answers a Natural number representing anInteger + aNatural · b
    (class-method first:rest: (anInteger aNatural)
      (((aNatural isZero) and: {(anInteger = 0)}) ifTrue:ifFalse:
        {(NatZero new)}
        {(NatNonzero initFirst:rest: anInteger aNatural)}))

    (class-method initFirst:rest: (anInteger aNatural)
      ((self new) setFirst:rest: anInteger aNatural))

    ;;;; end private class methods ;;;;

    ; private method
    (method setFirst:rest: (anInteger aNatural) 
      (set d anInteger)
      (set m aNatural)
      self)

    (method = (aNatural)
      ((aNatural isZero) ifTrue:ifFalse:
        {false}
        {((m = (aNatural divBase)) and: {(d = (aNatural modBase))})}))
      
    (method < (aNatural)
      ((aNatural isZero) ifTrue:ifFalse:
        {false}
        {((m < (aNatural divBase)) ifTrue:ifFalse:
          {true}
          {((m = (aNatural divBase)) ifTrue:ifFalse:
            {(d < (aNatural modBase))}
            {false})})}))

    (method + (aNatural) (self plus:carry: aNatural 0))

    (method * (aNatural) 
      [locals m1 m2 d1 d2 b]
      ((aNatural isZero) ifTrue:ifFalse:
        {(NatZero new)}
        {(set m1 m)
         (set m2 (aNatural divBase))
         (set d1 d)
         (set d2 (aNatural modBase))
         (set b (Natural base))
          (((Natural fromSmall: (d1 * d2))
            + (((m1 * (Natural fromSmall: d2)) + (m2 * (Natural fromSmall: d1))) timesBase))
            + (((m1 * m2) timesBase)timesBase))}))


    ; X = d + m· b
    ; m / n = Q' · n + r'
    ; X / n = Q  · n + r
    ;  Q = q0 + Q′· b
    ;    q0 = (d + r′ · b) div n
    ;    r = (d + r′ · b) mod n
    (method sdivmod:with: (n aBlock)
      [locals Q r Q' r' q0]
      ((n = 0) ifTrue:ifFalse:
        {(self error: 'Cannot-perform-division-or-mod-by-0)}
        {(set r' (m smod: n))
          (set Q' (m sdiv: n))

          ((r' = 0) ifTrue:ifFalse:
            {(set q0 (d div: n))
             (set r  (d mod: n))}
            
            {(set q0 (((r' * (Natural base)) + d) div: n))
             (set r  (((r' * (Natural base)) + d) mod: n))})

          ((Q' isZero) ifTrue:ifFalse:
            {(set Q (Natural fromSmall: q0))}
            {(set Q ((Q' timesBase) + (Natural fromSmall: q0)))})
         
          (aBlock value:value: Q r)}))


    (method decimal () (self decimal-helper: (List new)))

    ; private decimal helper
    (method decimal-helper: (aList)
      ((self sdiv: 10) decimal-helper: (aList addFirst: (self smod: 10))))

    ; private method
    ; analogous to decimal but uses the base of Natural
    (method base-rep () (self base-rep-helper: (List new)))

    ; private base-rep-helper
    (method base-rep-helper: (aList)
      ((self divBase) base-rep-helper: (aList addFirst: (self modBase))))

    (method isZero () false)

    ;;;; private instance methods ;;;;

    ; Answer the sum self + aNatural + c, where c is a carry bit (either 0 or 1).
    ; if aNatural is zero, send message plus:carry: to aNatural with self and c as args
    ; else add self + aNatural + c
    (method plus:carry: (aNatural c)
      [locals m1 m2 d1 d2 d' c']
      
      ((aNatural isZero) ifTrue:ifFalse:

        ; if aNatural is zero, add self + c
        {(aNatural plus:carry: self c)}

        ; else, return first:rest: (d') (m1 plus:carry: m2 c')
        {(set m1 m)
          (set m2 (aNatural divBase))
          (set d1 d)
          (set d2 (aNatural modBase))
          (set d' (((d1 + d2) + c) mod: (Natural base))) ; d' = (d1 + d2 + c) mod base
          (set c' (((d1 + d2) + c) div: (Natural base))) ; c’ = (d1 + d2 + c) div base

          (return (NatNonzero first:rest: d' (m1 plus:carry: m2 c')))}))

    ; Compute the difference self − (aNatural + c),
    ; where c is a borrow bit (either 0 or 1).
    ; If the difference is nonnegative, answer the difference;
    ; otherwise, halt the program with a checked run-time error.
    (method minus:borrow: (aNatural c)
      [locals m1 m2 d1 d2 d' c'] 
      ((aNatural isZero) ifTrue:ifFalse:

        ; if aNatural is zero, self - c
        {(self borrowFromNat:borrow: self c)}

        ; else, self - aNatural - c
        ; c’ = if d1 - d2 - c < 0 then 1 else 0
        ; return first:rest: (m1 minus:borrow: m2 c’) d
        {(set m1 m)
          (set m2 (aNatural divBase))
          (set d1 d)
          (set d2 (aNatural modBase))
          (set d' (((d1 - d2) - c) mod: (Natural base))) ; d' = (d1 - d2 - b) mod base
          ((((d1 - d2) - c) < 0) ifTrue:ifFalse: 
              {(set c' 1)}
              {(set c' 0)})
          (NatNonzero first:rest: d' (m1 minus:borrow: m2 c') )}))

    ; private helper method borrowFromNat
    (method borrowFromNat:borrow: (aNatural c)
      ((c = 0) ifTrue:ifFalse:
        {aNatural}  ;; NOTE IS IT SELF or ANAT
        {(((aNatural modBase) = 0) ifTrue:ifFalse: 
                {(NatNonzero first:rest: (self borrowFromNat:borrow: 
                (aNatural divBase) 1) ((Natural base) - 1))}
                {(NatNonzero first:rest: ((aNatural modBase) - 1) (aNatural divBase) )})}))

    ;;;; end private instance methods ;;;;

)
; starter code copied from COMP 105 spec
(class LargeInteger
  [subclass-of Integer]
  [ivars magnitude]

  (class-method withMagnitude: (aNatural)
      ((self new) magnitude: aNatural))
  (method magnitude: (aNatural) ; private, for initialization
      (set magnitude aNatural)
      self)

  (method magnitude () magnitude)

  (class-method fromSmall: (anInteger)
     ((anInteger isNegative) ifTrue:ifFalse: 
        {(((self fromSmall: 1) + (self fromSmall: ((anInteger + 1) negated)))
          negated)}
        {((LargePositiveInteger new) magnitude: (Natural fromSmall: anInteger))}))
  
  (method asLargeInteger () self)
  (method isZero () (magnitude isZero))
  (method = (anInteger) ((self - anInteger)     isZero))
  (method < (anInteger) ((self - anInteger) isNegative))

  (method +   (anInteger)     (self subclassResponsibility))
  (method *   (anInteger)     (self subclassResponsibility))
  (method negated    ()     (self subclassResponsibility))

  ; Answer the sum of the argument and the receiver.
  (method addSmallIntegerTo: (aSmallInteger) (self subclassResponsibility))

  ; Answer the sum of the argument and the receiver.
  (method addLargePositiveIntegerTo: (aLargePositiveInteger) (self subclassResponsibility))

  ; Answer the sum of the argument and the receiver.
  (method addLargeNegativeIntegerTo: (aLargeNegativeInteger) (self subclassResponsibility))

  ; Answer the product of the argument and the receiver.
  (method multiplyBySmallInteger: (aSmallInteger) (self subclassResponsibility))

  ; Answer the product of the argument and the receiver.
  (method multiplyByLargePositiveInteger: (aLargePositiveInteger) (self subclassResponsibility))

  ; Answer the product of the argument and the receiver.
  (method multiplyByLargeNegativeInteger: (aLargeNegativeInteger) (self subclassResponsibility))


  ;(method div: (_) (self error: 'long-division-not-supported))
  (method div: (n) (self sdiv: n))
  (method mod: (_) (self error: 'long-division-not-supported))

  ; Answer the largest natural number whose value is
  ; at most the quotient of the receiver and the argument.
  (method sdiv: (aSmallInteger) (self subclassResponsibility))

  ; Answer a small integer which is the remainder
  ; when the receiver is divided by the argument.
  (method smod: (aSmallInteger) (self leftAsExercise))

  (method isNegative         () (self subclassResponsibility))
  (method isNonnegative      () (self subclassResponsibility))
  (method isStrictlyPositive () (self subclassResponsibility))

  (method smallIntegerGreaterThan: (anInteger)
    (self > (anInteger asLargeInteger)))

  (method decimal () [locals decimals]
    (set decimals (magnitude decimal))
    ((self isNegative) ifTrue:
      {(decimals addFirst: ’-)})
    decimals)

  (method print () ((self decimal) do: [block (x) (x print)]))
)
(class LargePositiveInteger
  [subclass-of LargeInteger]

  (method + (anInteger) (anInteger addLargePositiveIntegerTo: self))
  (method * (anInteger) (anInteger multiplyByLargePositiveInteger: self))
  (method negated ()
    ((magnitude isZero) ifTrue:ifFalse:
      {(LargePositiveInteger withMagnitude: magnitude)}
      {(LargeNegativeInteger withMagnitude: magnitude)}))

  (method sdiv: (anInteger)
    ((anInteger isStrictlyPositive) ifTrue:ifFalse: 
       {(LargePositiveInteger withMagnitude:  (magnitude sdiv: anInteger))}
       {((((self - (LargeInteger fromSmall: anInteger)) - (LargeInteger fromSmall: 1))
             sdiv: (anInteger negated))
            negated)}))

  ;;;; private methods ;;;;

  ; Answer the sum of the argument and the receiver.
  (method addSmallIntegerTo: (aSmallInteger) (self + (aSmallInteger asLargeInteger)))

  ; Answer the sum of the argument and the receiver.
  (method addLargePositiveIntegerTo: (aLargePositiveInteger)
    (LargePositiveInteger withMagnitude: (magnitude + (aLargePositiveInteger magnitude))))

  ; Answer the sum of the argument and the receiver.
  (method addLargeNegativeIntegerTo: (aLargeNegativeInteger)
    [locals p n]
    (set p magnitude)
    (set n (aLargeNegativeInteger magnitude))

    ((p >= n) ifTrue:ifFalse:
      {(LargePositiveInteger withMagnitude: (p - n))}
      {(LargeNegativeInteger withMagnitude: (n - p))}))

  ; Answer the product of the argument and the receiver.
  (method multiplyBySmallInteger: (aSmallInteger) (self * (aSmallInteger asLargeInteger)))

  ; Answer the product of the argument and the receiver.
  (method multiplyByLargePositiveInteger: (aLargePositiveInteger)
    (LargePositiveInteger withMagnitude: (magnitude * (aLargePositiveInteger magnitude))))

  ; Answer the product of the argument and the receiver.
  (method multiplyByLargeNegativeInteger: (aLargeNegativeInteger)
    (LargeNegativeInteger withMagnitude: (magnitude * (aLargeNegativeInteger magnitude))))

  (method isNegative         () false)
  (method isNonnegative      () true)
  (method isStrictlyPositive () ((magnitude isZero) not))

  ;;;; end private methods ;;;;

)
(class LargeNegativeInteger
  [subclass-of LargeInteger]

  (method + (anInteger) (anInteger addLargeNegativeIntegerTo: self))
  (method * (anInteger) (anInteger multiplyByLargeNegativeInteger: self))
  (method negated ()
    (LargePositiveInteger withMagnitude: magnitude))

  (method sdiv: (anInteger)
    ((self negated) sdiv: (anInteger negated)))

  ;;;; private methods ;;;;

  ; Answer the sum of the argument and the receiver.
  (method addSmallIntegerTo: (aSmallInteger) (self + (aSmallInteger asLargeInteger)))

  ; Answer the sum of the argument and the receiver.
  (method addLargePositiveIntegerTo: (aLargePositiveInteger)
    (aLargePositiveInteger addLargeNegativeIntegerTo: self))

  ; Answer the sum of the argument and the receiver.
  (method addLargeNegativeIntegerTo: (aLargeNegativeInteger)
    (LargeNegativeInteger withMagnitude: (magnitude + (aLargeNegativeInteger magnitude))))

  ; Answer the product of the argument and the receiver.
  (method multiplyBySmallInteger: (aSmallInteger) (self * (aSmallInteger asLargeInteger)))

  ; Answer the product of the argument and the receiver.
  (method multiplyByLargePositiveInteger: (aLargePositiveInteger)
    (LargeNegativeInteger withMagnitude: (magnitude * (aLargePositiveInteger magnitude))))

  ; Answer the product of the argument and the receiver.
  (method multiplyByLargeNegativeInteger: (aLargeNegativeInteger)
    (LargePositiveInteger withMagnitude: (magnitude * (aLargeNegativeInteger magnitude))))

  (method isNegative         () true)
  (method isNonnegative      () (magnitude isZero))
  (method isStrictlyPositive () false)

  ;;;; end private methods ;;;;

)
(class SmallInteger
    [subclass-of Integer] ; primitive representation
    (class-method new: (n) (primitive newSmallInteger self n))
    (class-method new  ()  (self new: 0))
    (method negated    ()  (0 - self))
    (method print      ()  (primitive printSmallInteger self))
    (method +          (n) (primitive + self n))
    (method -          (n) (primitive - self n))
    (method *          (n) (primitive * self n))
    (method div:       (n) (primitive div self n))
    (method =          (n) (primitive sameObject self n))
    (method <          (n) (primitive < self n))
    (method >          (n) (primitive > self n))
)
