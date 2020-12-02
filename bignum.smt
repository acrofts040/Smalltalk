(class Boolean 
    [subclass-of Object]
    (method ifTrue:ifFalse: (trueBlock falseBlock)
                                    (self subclassResponsibility))
    (method ifFalse:ifTrue: (falseBlock trueBlock) 
                                    (self subclassResponsibility))
    (method ifTrue:  (trueBlock)    (self subclassResponsibility))
    (method ifFalse: (falseBlock)   (self subclassResponsibility))

    (method not ()                  (self subclassResponsibility))
    (method eqv: (aBoolean)         (self subclassResponsibility))
    (method xor: (aBoolean)         (self subclassResponsibility))
    (method & (aBoolean)            (self subclassResponsibility))
    (method | (aBoolean)            (self subclassResponsibility))

    (method and: (alternativeBlock) (self subclassResponsibility))
    (method or:  (alternativeBlock) (self subclassResponsibility))
)
(class True 
  [subclass-of Boolean]
  (method ifTrue:ifFalse: (trueBlock falseBlock) (trueBlock value))
  (method ifFalse:ifTrue: (falseBlock trueBlock) (trueBlock value))
  (method ifTrue:  (trueBlock)    (trueBlock value))
  (method ifFalse: (falseBlock)   nil)

  (method not ()                  false)
  (method eqv: (aBoolean)         aBoolean)
  (method xor: (aBoolean)         (aBoolean not))
  (method & (aBoolean)            aBoolean)
  (method | (aBoolean)            self)

  (method and: (alternativeBlock) (alternativeBlock value))
  (method or:  (alternativeBlock) self)
)
(class False
  [subclass-of Boolean]
  (method ifTrue:ifFalse: (trueBlock falseBlock) (falseBlock value))
  (method ifFalse:ifTrue: (falseBlock trueBlock) (falseBlock value))
  (method ifTrue:  (trueBlock)    nil)
  (method ifFalse: (falseBlock)   (falseBlock value))
  (method not ()                  true)
  (method eqv: (aBoolean)         (aBoolean not))
  (method xor: (aBoolean)         aBoolean)
  (method & (aBoolean)            self)
  (method | (aBoolean)            aBoolean)
  (method and: (alternativeBlock) self)
  (method or:  (alternativeBlock) (alternativeBlock value))
)
(class Block
    [subclass-of Object] ; internal representation
    (class-method new () {})
    (method value                    ()            (primitive value self))
    (method value:                   (a1)          (primitive value self a1))
    (method value:value:             (a1 a2)       (primitive value self a1 a2))
    (method value:value:value:       (a1 a2 a3)    (primitive value self a1 a2 a3))
    (method value:value:value:value: (a1 a2 a3 a4) (primitive value self a1 a2 a3 a4))
    (method whileTrue: (body)
        ((self value) ifTrue:ifFalse:
            {(body value)
             (self whileTrue: body)}
            {nil}))
    (method whileFalse: (body) 
         ((self value) ifTrue:ifFalse:
             {nil}
             {(body value) 
              (self whileFalse: body)}))
    (method traceFor: (n) [locals answer]
        (set &trace n)
        (set answer (self value))
        (set &trace 0)
        answer)
    (method trace () (self traceFor: -1))
)
(class Symbol
    [subclass-of Object] ; internal representation
    (class-method new  () (self error: 'can't-send-new-to-Symbol))
    (class-method new: (aSymbol) (primitive newSymbol self aSymbol))
    (method       print  () (primitive printSymbol self))
    (method       hash   () (primitive hash self))
)
(class CompiledMethod
  [subclass-of Object]
)
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
(class Fraction
    [subclass-of Number]
    [ivars num den]
    (method print () (num print) ('/ print) (den print) self)
    (method num () num)  ; private
    (method den () den)  ; private
    (method = (f) ((num = (f num)) and: {(den = (f den))}))
    (method < (f) ((num * (f den)) < ((f num) * den)))
    (method signReduce () ; private
        ((den isNegative) ifTrue:
            {(set num (num negated)) (set den (den negated))})
        self)
    (method divReduce () [locals temp] ; private
        ((num = 0) ifTrue:ifFalse:
            {(set den 1)}
            {(set temp ((num abs) gcd: den))
             (set num  (num div: temp))
             (set den  (den div: temp))})
        self)
    (class-method num:den: (a b) ((self new) initNum:den: a b))
    (method setNum:den: (a b) (set num a) (set den b) self) ; private
    (method initNum:den: (a b) ; private
        (self setNum:den: a b)
        (self signReduce)
        (self divReduce))
    (method * (f)
      (((Fraction new) setNum:den: (num * (f num)) (den * (f den))) divReduce))
    (method + (f) [locals temp]
        (set temp (den lcm: (f den)))
        (((Fraction new) setNum:den:
                         ((num     * (temp div: den)) +
                          ((f num) * (temp div: (f den))))
                         temp)
            divReduce))
    (method reciprocal ()
       (((Fraction new) setNum:den: den num) signReduce))
    (method negated () ((Fraction new) setNum:den: (num negated) den))
    (method isNegative         () (num isNegative))
    (method isNonnegative      () (num isNonnegative))
    (method isStrictlyPositive () (num isStrictlyPositive))
    (method asInteger  () (num div: den))
    (method asFloat    () ((num asFloat) / (den asFloat)))
    (method asFraction () self)
    (method coerce: (aNumber) (aNumber asFraction))
)

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
    (class-method base () 10)

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
      (self minus:borrow: aNatural 0)) ;; TODO

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

    (method sdivmod:with: (n aBlock) (aBlock value:value: 0 0))

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

    ;; OLD ;;
    ; private helper method carryIntoNatural
    ; if c is 0, return aNatural
    ; if c is 1, add to aNatural
    ;(method carryIntoNatural:carry: (aNatural c)
      ;(c = 0) ifTrue:ifFalse:
        ;{aNatural}
        ;{(aNatural isZero) ifTrue:ifFalse:
          ;{(Natural fromSmall: c)}
          ;; first = (d + 1) mod base
          ;; rest = carryIntoNatural:carry: m ((d + 1) div base)
          ;{(NatNonzero first:rest:
            ;(((aNatural modBase) + 1) mod: (self base))
              ;(self carryIntoNatural:carry:
                ;(aNatural divBase)
                  ;(((aNatural modBase) + 1) div: (self base))))}})
    ;; END OLD ;;


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

    ;; In progress
    ; (mb + d) (m'b' + d') = mm'bb' + mbd' + m'b'd + dd'
    (method * (aNatural) 
      [locals m1 m2 d1 d2 b]
      ((aNatural isZero) ifTrue:ifFalse:
        {(NatZero new)}
        { 

          (set m1 m)
          (set m2 (aNatural divBase))
          (set d1 d)
          (set d2 (aNatural modBase))
          (set b (Natural base))
          (((Natural fromSmall: (d1 * d2)) + (((m1 * (Natural fromSmall: d2))  +  (m2 * (Natural fromSmall: d1))) timesBase)) + (((m1 * m2) timesBase)timesBase)
          )})) 





   ;;       (((m1 * m2) * (b * b))) + (self mult:Carry: aNatural 0))
   ;;      + ((aNatural mult:Carry: self 0) * (self modBase)) + (
   ;;(self modBase) * (aNatural modBase)) }))


   ;; (method mult:Carry: (aNatural c)
   ;;  [locals c']
   ;;   (set c' ((  (Natural fromSmall: (self modBase)) * aNatural) ;; + c))
   ;;   return ((c' modBase) + (((self divBase) mult:Carry: aNatural 
   ;; (c' divBase)) multBase)))

    ;; TODO ;;
    ; m * b + d div: n
    ; m * b + d mod: n
    ; (method sdivmod:with: (n aBlock) (aBlock value:value: (m * b + d div: n) (m * b + d mod: n)))
    (method sdivmod:with: (n aBlock) (self leftAsExercise))

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

;;;;;;;;;; TESTING FOR CLASS NATURAL ;;;;;;;;;;

;; tests for creating new natural numbers
;((Natural fromSmall: 0) printrep)
;((Natural fromSmall: 1) printrep)
;((Natural fromSmall: 10) printrep)
((Natural fromSmall: 15) printrep)
((Natural fromSmall: 16) printrep)
;((Natural fromSmall: 17) printrep)
;((Natural fromSmall: 127) printrep)
;((Natural fromSmall: 128) printrep)
;((Natural fromSmall: 129) printrep)
;((Natural fromSmall: 143) printrep)

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

;; tests for adding nat + 0
;(((Natural fromSmall: 0) + (Natural fromSmall: 0)) printrep) ; 0 + 0
;(((Natural fromSmall: 0) + (Natural fromSmall: 1)) printrep) ; 0 + 1
;(((Natural fromSmall: 1) + (Natural fromSmall: 0)) printrep) ; 1 + 0
;(((Natural fromSmall: 0) + (Natural fromSmall: 10)) printrep) ; 0 + 10
;(((Natural fromSmall: 10) + (Natural fromSmall: 0)) printrep) ; 10 + 0
;(((Natural fromSmall: 0) + (Natural fromSmall: 16)) printrep) ; 0 + 16
;(((Natural fromSmall: 16) + (Natural fromSmall: 0)) printrep) ; 16 + 0
;(((Natural fromSmall: 0) + (Natural fromSmall: 143)) printrep) ; 0 + 143
;(((Natural fromSmall: 143) + (Natural fromSmall: 0)) printrep) ; 143 + 0

;; tests for adding nonzero naturals
;(((Natural fromSmall: 1) + (Natural fromSmall: 1)) printrep) ; 1 + 1
;(((Natural fromSmall: 1) + (Natural fromSmall: 2)) printrep) ; 1 + 2
;(((Natural fromSmall: 1) + (Natural fromSmall: 9)) printrep) ; 1 + 9
;(((Natural fromSmall: 9) + (Natural fromSmall: 1)) printrep) ; 9 + 1
;(((Natural fromSmall: 1) + (Natural fromSmall: 15)) printrep) ; 1 + 15
;(((Natural fromSmall: 15) + (Natural fromSmall: 1)) printrep) ; 15 + 1
;(((Natural fromSmall: 1) + (Natural fromSmall: 127)) printrep) ; 1 + 127
;(((Natural fromSmall: 127) + (Natural fromSmall: 1)) printrep) ; 127 + 1
;(((Natural fromSmall: 1) + (Natural fromSmall: 143)) printrep) ; 1 + 143
;(((Natural fromSmall: 143) + (Natural fromSmall: 1)) printrep) ; 143 + 1
;(((Natural fromSmall: 1) + (Natural fromSmall: 1023)) printrep) ; 1 + 1023
;(((Natural fromSmall: 1023) + (Natural fromSmall: 1)) printrep) ; 1023 + 1

;; tests for multiplying nat * 0
(((Natural fromSmall: 0) * (Natural fromSmall: 0)) printrep) ; 0 * 0
(((Natural fromSmall: 0) * (Natural fromSmall: 1)) printrep) ; 0 * 1
(((Natural fromSmall: 1) * (Natural fromSmall: 0)) printrep) ; 1 * 0
(((Natural fromSmall: 0) * (Natural fromSmall: 10)) printrep) ; 0 * 10
(((Natural fromSmall: 10) * (Natural fromSmall: 0)) printrep) ; 10 * 0
(((Natural fromSmall: 0) * (Natural fromSmall: 16)) printrep) ; 0 * 16
(((Natural fromSmall: 16) * (Natural fromSmall: 0)) printrep) ; 16 * 0
(((Natural fromSmall: 0) * (Natural fromSmall: 143)) printrep) ; 0 * 143
(((Natural fromSmall: 143) * (Natural fromSmall: 0)) printrep) ; 143 * 0

(((Natural fromSmall: 1) * (Natural fromSmall: 1)) printrep) ; 1 * 1
(((Natural fromSmall: 1) * (Natural fromSmall: 2)) printrep) ; 1 * 2
(((Natural fromSmall: 2) * (Natural fromSmall: 1)) printrep)
(((Natural fromSmall: 27) * (Natural fromSmall: 1)) printrep)
(((Natural fromSmall: 1) * (Natural fromSmall: 27)) printrep)
(((Natural fromSmall: 2) * (Natural fromSmall: 27)) printrep)
(((Natural fromSmall: 12) * (Natural fromSmall: 12)) printrep)
(((Natural fromSmall: 122) * (Natural fromSmall: 227)) printrep)

;; check-print tests
(check-print (Natural fromSmall: 0)  0)
;(check-print (Natural fromSmall: 1)  1)
;(check-print (Natural fromSmall: 10) 10)
;(check-print (Natural fromSmall: 15) 15)
;(check-print (Natural fromSmall: 16) 16)
;(check-print (Natural fromSmall: 17) 17)
;(check-print (Natural fromSmall: 143) 143)


;;;;;;;;;; END TESTING ;;;;;;;;;;

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
(class Float
    [subclass-of Number]
    [ivars mant exp]
    (class-method mant:exp: (m e) ((self new) initMant:exp: m e))
    (method initMant:exp: (m e) ; private
        (set mant m) (set exp e) (self normalize))
    (method normalize ()    ; private
        ({((mant abs) > 32767)} whileTrue:
               {(set mant (mant div: 10))
                (set exp (exp + 1))})
        self)
    (method mant () mant)  ; private
    (method exp  () exp)   ; private
    (method < (x) ((self - x) isNegative))
    (method = (x) ((self - x)   isZero))
    (method isZero () (mant = 0))  ; private
    (method negated () (Float mant:exp: (mant negated) exp))
    (method + (x-prime) 
        ((exp >= (x-prime exp)) ifTrue:ifFalse:
            {(Float mant:exp: ((mant * (10 raisedToInteger: (exp - (x-prime exp)))) +
                                 (x-prime mant))
                              (x-prime exp))}
            {(x-prime + self)}))
    (method * (x-prime) 
        (Float mant:exp: (mant * (x-prime mant)) (exp + (x-prime exp))))
    (method reciprocal ()
        (Float mant:exp: (1000000000 div: mant) (-9 - exp)))
    (method coerce: (aNumber) (aNumber asFloat))
    (method asFloat () self)
    (method asInteger ()
        ((exp isNegative) ifTrue:ifFalse:
            {(mant div: (10 raisedToInteger: (exp negated)))}
            {(mant    * (10 raisedToInteger: exp))}))
    (method asFraction ()
        ((exp < 0) ifTrue:ifFalse:
            {(Fraction num:den: mant (10 raisedToInteger: (exp negated)))}
            {(Fraction num:den: (mant * (10 raisedToInteger: exp)) 1)}))
    (method isNegative         () (mant isNegative))
    (method isNonnegative      () (mant isNonnegative))
    (method isStrictlyPositive () (mant isStrictlyPositive))
    (method print () 
        (self print-normalize) 
        (mant print) ('x10^ print) (exp print)
        (self normalize))

    (method print-normalize ()
        ({((exp < 0) and: {((mant mod: 10) = 0)})} whileTrue:
            {(set exp (exp + 1)) (set mant (mant div: 10))}))
)
(val &trace 0)
(class Char
   [subclass-of Object]
   [ivars code-point]
   (class-method new: (n) ((self new) init: n))
   (method init:      (n) (set code-point n) self) ;; private
   (method print      ()  (primitive printu code-point))
   (method =          (c) (code-point = (c code-point)))
   (method code-point ()  code-point) ;; private
)
(val newline      (Char new: 10))   (val left-round   (Char new:  40))
(val space        (Char new: 32))   (val right-round  (Char new:  41))
(val semicolon    (Char new: 59))   (val left-curly   (Char new: 123))
(val quotemark    (Char new: 39))   (val right-curly  (Char new: 125))
                                    (val left-square  (Char new:  91))
                                    (val right-square (Char new:  93))
(class Collection
  [subclass-of Object] ; abstract
  (method do:     (aBlock)       (self subclassResponsibility))
  (method add:    (newObject)    (self subclassResponsibility))
  (method remove:ifAbsent: (oldObject exnBlock)
                                 (self subclassResponsibility))
  (method =       (aCollection)  (self subclassResponsibility))
  (class-method with: (anObject)
      ((self new) add: anObject))
  (class-method withAll: (aCollection)
      ((self new) addAll: aCollection))
  (method addAll: (aCollection) 
      (aCollection do: [block (x) (self add: x)])
      self)
  (method remove: (oldObject) 
      (self remove:ifAbsent: oldObject {(self error: 'remove-was-absent)}))
  (method removeAll: (aCollection) 
      (aCollection do: [block (x) (self remove: x)])
      self)
  (method size () [locals n]
      (set n 0)
      (self do: [block (_) (set n (n + 1))])
      n)
  (method occurrencesOf: (anObject) [locals n]
      (set n 0)
      (self do: [block (x) ((x = anObject) ifTrue: {(set n (n + 1))})])
      n)
  (method isEmpty () 
      (self do: [block (_) (return false)])
      true)
  (method includes: (anObject)
      (self do: [block (x) ((x = anObject) ifTrue: {(return true)})])
      false)
  (method detect:ifNone: (aBlock exnBlock)
      (self do: [block (x) ((aBlock value: x) ifTrue: {(return x)})])
      (exnBlock value))
  (method detect: (aBlock)
      (self detect:ifNone: aBlock {(self error: 'no-object-detected)}))
  (method inject:into: (aValue binaryBlock)
     (self do: [block (x) (set aValue (binaryBlock value:value: x aValue))])
     aValue)
  (method select: (aBlock) [locals temp]
     (set temp ((self species) new))
     (self do: [block (x) ((aBlock value: x) ifTrue: {(temp add: x)})])
     temp)
  (method reject: (aBlock)
     (self select: [block (x) ((aBlock value: x) not)]))
  (method collect: (aBlock) [locals temp]
     (set temp ((self species) new))
     (self do: [block (x) (temp add: (aBlock value: x))])
     temp)
  (method species () (self class))
  (method print ()
      (self printName)
      (left-round print)
      (self do: [block (x) (space print) (x print)])
      (space print)
      (right-round print)
      self)
  (method printName () (((self class) name) print))
)
(class KeyedCollection
    [subclass-of Collection]  ; abstract class
    (method associationsDo: (aBlock)           (self subclassResponsibility))
    (method removeKey:ifAbsent: (key exnBlock) (self subclassResponsibility))
    (method at:put: (key value)                (self subclassResponsibility))
    (method do: (aBlock) 
        (self associationsDo: [block (anAssoc) (aBlock value: (anAssoc value))]))
    (method at: (key)    
        (self at:ifAbsent: key {(self error: 'key-not-found)}))
    (method at:ifAbsent: (key exnBlock) 
        ((self associationAt:ifAbsent: key {(return (exnBlock value))}) value))
    (method includesKey: (key) 
        ((self associationAt:ifAbsent: key {}) notNil))
    (method associationAt: (key) 
        (self associationAt:ifAbsent: key {(self error: 'key-not-found)}))
    (method associationAt:ifAbsent: (key exnBlock)
        (self associationsDo: [block (x) (((x key) = key) ifTrue: {(return x)})])
        (exnBlock value))
    (method keyAtValue: (value) 
        (self keyAtValue:ifAbsent: value {(self error: 'value-not-found)}))
    (method keyAtValue:ifAbsent: (value exnBlock)
        (self associationsDo: [block (x) 
            (((x value) = value) ifTrue: {(return (x key))})])
        (exnBlock value))
    (method removeKey: (key)    
        (self removeKey:ifAbsent: key {(self error: 'key-not-found)}))
    (method = (collection)
        (self associationsDo:    ; look for an `assn` not in `collection`
            [block (assn)
               (((assn value) !=
                      (collection at:ifAbsent: (assn key) {(return false)}))
                ifTrue:
                {(return false)})])
        ((self size) = (collection size)))
)
(class SequenceableCollection
    [subclass-of KeyedCollection] ; abstract class
    (method firstKey () (self subclassResponsibility))
    (method lastKey  () (self subclassResponsibility))
    (method last     () (self at: (self  lastKey)))
    (method first    () (self at: (self firstKey)))
    (method at:ifAbsent: (index exnBlock) [locals current]
        (set current (self firstKey))
        (self do: [block (v)
            ((current = index) ifTrue: {(return v)})
            (set current (current + 1))])
        (exnBlock value))
    (method associationsDo: (bodyBlock) [locals i last]
        (set i    (self firstKey))
        (set last (self lastKey))
        ({(i <= last)} whileTrue:
            {(bodyBlock value: (Association withKey:value: i (self at: i)))
             (set i (i + 1))}))
)
(class Cons
    [subclass-of Object]
    [ivars car cdr]
    (method car ()           car)
    (method cdr ()           cdr)
    (method car: (anObject)  (set car anObject) self)
    (method cdr: (anObject)  (set cdr anObject) self)
    (method pred: (aCons)    nil)
    (method deleteAfter () [locals answer]
        (set answer (cdr car))
        (set cdr    (cdr cdr))
        (cdr pred: self)
        answer)
    (method insertAfter: (anObject)
        (set cdr (((Cons new) cdr: cdr) car: anObject))
        ((cdr cdr) pred: cdr)
        anObject)
    (method do: (aBlock)
        (aBlock value: car)
        (cdr do: aBlock))
    (method rejectOne:ifAbsent:withPred: (aBlock exnBlock pred)
        ((aBlock value: self) ifTrue:ifFalse:
            {(pred deleteAfter)}
            {(cdr rejectOne:ifAbsent:withPred: aBlock exnBlock self)}))
)
(class ListSentinel
    [subclass-of Cons]
    [ivars pred]
    (method pred: (aCons)   (set pred aCons))
    (method pred  ()        pred)
    (class-method new ()    
        [locals tmp]
        (set tmp (super new))
        (tmp pred: tmp)
        (tmp  cdr: tmp)
        tmp)
    (method do: (aBlock) nil)
    (method rejectOne:ifAbsent:withPred: (aBlock exnBlock pred)
        (exnBlock value)))
(class List
    [subclass-of SequenceableCollection]
    [ivars sentinel]
    (class-method new ()        ((super new) sentinel: (ListSentinel new)))
    (method sentinel: (s)       (set sentinel s) self) ; private
    (method isEmpty   ()        (sentinel == (sentinel cdr)))
    (method last      ()        ((sentinel pred) car))
    (method do:       (aBlock)  ((sentinel cdr) do: aBlock))
    (method addLast:  (item)   ((sentinel pred) insertAfter: item) self)
    (method addFirst: (item)   (sentinel insertAfter: item)        self)
    (method add:      (item)   (self addLast: item))
    (method removeFirst ()     (sentinel deleteAfter))
    (method removeLast  ()     (self leftAsExercise))
    (method remove:ifAbsent: (oldObject exnBlock)
        ((sentinel cdr)
            rejectOne:ifAbsent:withPred:
            [block (x) (oldObject = (x car))]
            exnBlock
            sentinel))
    (method removeKey:ifAbsent: (n exnBlock) (self leftAsExercise))
    (method firstKey () 0)
    (method lastKey  () ((self size) - 1))
    (method at:put: (n value) [locals tmp]
        (set tmp (sentinel cdr))
        ({(n = 0)} whileFalse:
           {(set n (n - 1))
            (set tmp (tmp cdr))})
        (tmp car: value)
        self)
)
(class Association
   [subclass-of Object]
   [ivars key value]
   (class-method withKey:value: (x y) ((self new) setKey:value: x y))
   (method setKey:value: (x y) (set key x) (set value y) self) ; private
   (method key       ()  key)
   (method value     ()  value)
   (method setKey:   (x) (set key   x))
   (method setValue: (y) (set value y))
   (method =         (a) ((key = (a key)) & (value = (a value))))
)
(class Dictionary
    [subclass-of KeyedCollection]
    [ivars table] ; list of Associations
    (class-method new ()      ((super new) initDictionary))
    (method initDictionary () (set table (List new)) self) ; private
    (method associationsDo: (aBlock) (table do: aBlock))
    (method at:put: (key value) [locals tempassoc]
        (set tempassoc (self associationAt:ifAbsent: key {}))
        ((tempassoc isNil) ifTrue:ifFalse:
             {(table add: (Association withKey:value: key value))}
             {(tempassoc setValue: value)})
        self)
    (method removeKey:ifAbsent: (key exnBlock)
       [locals value-removed] ; value found if not absent
       (set value-removed (self at:ifAbsent: key {(return (exnBlock value))}))
       (set table (table reject: [block (assn) (key = (assn key))])) ; remove assoc
       value-removed)
    (method remove:ifAbsent: (value exnBlock)
       (self error: 'Dictionary-uses-remove:key:-not-remove:))
    (method add: (anAssociation)
      (self at:put: (anAssociation key) (anAssociation value)))
    (method print () [locals print-comma]
        (set print-comma false)
        (self printName)
        (left-round print)
        (self associationsDo:
            [block (x) (space print)
                       (print-comma ifTrue: {(', print) (space print)})
                       (set print-comma true)
                       ((x key) print)   (space print)
                       ('|--> print)     (space print)
                       ((x value) print)])
        (space print)
        (right-round print)
        self)
)
(class Array
    [subclass-of SequenceableCollection] ; representation is primitive
    (class-method new: (size) (primitive arrayNew self size))
    (class-method new  ()     (self error: 'size-of-Array-must-be-specified))
    (method size       ()     (primitive arraySize self))
    (method at:        (key)       (primitive arrayAt self key))
    (method at:put:    (key value) (primitive arrayUpdate self key value) self)
    (method printName  () nil) ; names of arrays aren't printed
    (method add:                (x)   (self fixedSizeError))
    (method remove:ifAbsent:    (x b) (self fixedSizeError))
    (method removeKey:ifAbsent: (x b) (self fixedSizeError))
    (method fixedSizeError      ()    (self error: 'arrays-have-fixed-size))
    (method firstKey () 0)
    (method lastKey  () ((self size) - 1))
    (method do: (aBlock) [locals index]
        (set index (self firstKey))
        ((self size) timesRepeat:
           {(aBlock value: (self at: index))
            (set index (index + 1))}))
)
(class Set
    [subclass-of Collection]
    [ivars members]  ; list of elements [invariant: no repeats]
    (class-method new () ((super new) initSet))
    (method initSet   () (set members (List new)) self) ; private
    (method do: (aBlock) (members do: aBlock))
    (method add: (item)
        ((members includes: item) ifFalse: {(members add: item)})
        self)
    (method remove:ifAbsent: (item exnBlock) 
        (members remove:ifAbsent: item exnBlock)
        self)
    (method =  (s) [locals looks-similar]
       (set looks-similar ((self size) = (s size)))
       (looks-similar ifTrue:
           {(self do: [block (x) ((s includes: x) ifFalse:
                                           {(set looks-similar false)})])})
       looks-similar)
)
