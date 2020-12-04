;;;;;;;;;;;;;;;;;;; COMP 105 SMALL ASSIGNMENT ;;;;;;;;;;;;;;;
;; bigtests.smt
;; COMP 105 - hw9 small
;; Fall 2020

;; Name: Ann Marie Burke (aburke04)
;; Partner: Andrew Crofts

;; 3 tests for class Natural ;;

;; Summary: Tests the +, -, and * operations
(check-print
    (((Natural fromSmall: 53857) + (Natural fromSmall: 1023))
        * ((Natural fromSmall: 32770) - (Natural fromSmall: 2)))
    1798307840)

;; Summary: Tests the *, -, sdiv:, and smod: operations
(check-print
    (((((Natural fromSmall: 2049) * (Natural fromSmall: 1025))
        - (Natural fromSmall: 1587))
            sdiv: 149) smod: 16) 4)

;; Summary: Tests *, -, sdiv:, and smod:, specifically 0 mod x
(check-print
    ((((((Natural fromSmall: 42895) * (Natural fromSmall: 1))
        - (Natural fromSmall: 2495))
            sdiv: 40400) - (Natural fromSmall: 1)) smod: 10) 0)


;; 3 tests for class LargeInteger ;;

;; Summary: Tests *, -, +, smod:, specifically mod with negative

(check-print
    (((((LargeInteger fromSmall: 2436175) * (LargeInteger fromSmall: -100))
        - (LargeInteger fromSmall: 243617500))
            + (LargeInteger fromSmall: -4095)) smod: 7) 0)

;; Summary: tests sdiv, and smodding by negatives
(check-print
    ((((LargeInteger fromSmall: 32767) sdiv: 10) sdiv: 1) smod: -5) -4)

;; Summary: tests multiplying large negative integers,
;;          adding large negative integers
;;          negating large integers, and multiplying negatives by positives
(check-print
    (((((LargeInteger fromSmall: -2147483647) * (LargeInteger fromSmall: -1))
        + (LargeInteger fromSmall: -15869))
            + ((LargeInteger fromSmall: 157) negated))
                * (LargeInteger fromSmall: 400))
                858987048400)


;; 3 tests for mixed arithmetic involving both small and large integers ;;

;; Summary: tests adding largeintegers to smallintegers, mulitplying smalls,
;;          and dividing larges by smalls
(check-print ((((SmallInteger new: 4) + (LargeInteger fromSmall: 32748))
                + ((SmallInteger new: 4600) * (SmallInteger new: 4)))
                    sdiv: (SmallInteger new: 17)) 3008)

;; Summary: tests multiplying larges and smalls, negation,
;;          and dividing by negatives
(check-print ((((LargeInteger fromSmall: 3248) * (SmallInteger new: 784))
    * ((SmallInteger new: 666) negated)) 
        sdiv: ((SmallInteger new: 9998) negated)) 169626)

;; Summary: test sdiv, subtracting negatives, negation,
;;          and multiplying by negated largeIntegers
(check-print ((((LargeInteger fromSmall: 474747) sdiv: (SmallInteger new: 4100))
    - ((SmallInteger new: 3417) negated)) 
        * ((LargeInteger fromSmall: 8734) negated)) -30848488)


