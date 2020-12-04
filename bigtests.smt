;;;;;;;;;;;;;;;;;;; COMP 105 SMALL ASSIGNMENT ;;;;;;;;;;;;;;;
;; bigtests.smt
;; COMP 105 - hw9 small
;; Fall 2020

;; Name: Ann Marie Burke (aburke04)
;; Partner: Andrew Crofts

(use mixnum.smt)

;; 3 tests for class Natural ;;

; Summary: Tests the +, -, and * operations
(check-print
    (((Natural fromSmall: 53857) + (Natural fromSmall: 1023))
        * ((Natural fromSmall: 32770) - (Natural fromSmall: 2)))
    1798307840)

; Summary: Tests the *, -, sdiv:, and smod: operations
(check-print
    (((((Natural fromSmall: 2049) * (Natural fromSmall: 1025))
        - (Natural fromSmall: 1587))
            sdiv: 149) smod: 16) 4)

; Summary: Tests *, -, sdiv:, and smod:, specifically 0 mod x
(check-print
    ((((((Natural fromSmall: 42895) * (Natural fromSmall: 1))
        - (Natural fromSmall: 2495))
            sdiv: 40400) - (Natural fromSmall: 1)) smod: 10) 0)

;; 3 tests for class LargeInteger

; Summary: Tests *, -, +, smod:, specifically mod with negative

(check-print
    (((((LargeInteger fromSmall: 2436175) * (LargeInteger fromSmall: -100))
        - (LargeInteger fromSmall: 243617500))
            + (LargeInteger fromSmall: -4095)) smod: 7) 0)

; Summary: .........
(check-print
    (((LargeInteger fromSmall: 32767) sdiv: 10) 3276)

; Summary: .........


; Summary: .........



;; 3 tests for mixed arithmetic involving both small and large integers

; Summary: .........


; Summary: .........


