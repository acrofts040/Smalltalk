(******************** COMP 105 SML ASSIGNMENT ********************)
(* natural.sml
 * COMP 105 - hw11 sml
 * Fall 2020

 * Name: Ann Marie Burke (aburke04)
 * Partner: Andrew Crofts
 *)

signature NATURAL = sig
   type nat
   exception Negative     (* the result of an operation is negative *)
   exception BadDivisor   (* divisor zero or negative *)


   val ofInt : int -> nat          (* could raise Negative *)
   val /+/   : nat * nat -> nat
   val /-/   : nat * nat -> nat    (* could raise Negative *)
   val /*/   : nat * nat -> nat
   val sdiv  : nat * int -> { quotient : nat, remainder : int }
     (* Contract for "Short division" sdiv:

        Provided 0 < d <= K,
          sdiv (n, d) returns { quotient = q, remainder = r }
        such that
          n == q /*/ ofInt d /+/ ofInt r
          0 <= r < d

        Given a d <= 0, sdiv (n, d) raises BadDivisor.

        Given d > K, the program halts with a checked run-time error.
        The constant K depends on the number of bits in a machine integer,
        so it is not specified, but it is known to be at least 10.
     *)
        
   val compare : nat * nat -> order

   val decimal : nat -> int list

     (* decimal n returns a list giving the natural decimal
        representation of n, most significant digit first.
        For example,  decimal (ofInt 123) = [1, 2, 3]
                      decimal (ofInt 0)   = [0]
        It must never return an empty list.
        And when it returns a list of two or more digits,
        the first digit must not be zero.
     *)

  val invariant : nat -> bool  (* representation invariant---instructions below *)

end



(* starter code "convenient code" given in homework spec *)
(* our structure is based on previous ml assignment from this semester *)
structure ExposedNatural = struct

  (* TODO REMOVE *)
  exception LeftAsExercise (* stuff we have left to implement *)

  val base = 16

  datatype nat = ZERO
               | TIMESBASEPLUS of nat * int

  (* abstraction function: A (ZERO)                 = 0
   *                       A (TIMESBASEPLUS (m, d)) = m * b + d
   *)

  (* invariants for TIMESBASEPLUS (m, d):
   *  m and d are not both zero.
   *  d is a machine integer in the range 0 ≤ d < 10.
   *)
  fun (* invariant (TIMESBASEPLUS (m, d)) = raise LeftAsExercise *)
          (*case m 
            of ZERO        => (d < 10) andalso (d > 0)
             | TIMESBASEPLUS (m,d) => (invariant m) andalso (d < 10)
                                       andalso (d >= 0) *)
             (*| _ => false*)
    invariant _ = false



  exception Negative       (* the result of an operation is negative *)
  exception BadDivisor     (* divisor zero or negative *)
  exception InvariantError (* when natural number invariant does not hold *)
  exception Match          (* bad carry/borrow bit *)
    


  (* private *)
  fun timesbaseplus (ZERO, 0) = ZERO
    | timesbaseplus (n, d) = TIMESBASEPLUS (n, d)

  (* private *)
  (* timesbase : nat -> nat *)
  fun timesbase n = timesbaseplus (n, 0)

  (* create nat of int *)
  fun ofInt 0 = ZERO
    | ofInt i = if (i > 0)
                  then timesbaseplus(ofInt (i div base), i mod base)
                else raise Negative


  (*** addition ***)

  (* private *)
  fun carryIntoNat (n, 0)                    = n
    | carryIntoNat (ZERO, 1)                 = ofInt 1 
    | carryIntoNat (TIMESBASEPLUS (m, d), 1) =
            timesbaseplus (carryIntoNat (m, (d + 1) div base), (d + 1) mod base)
    | carryIntoNat _                         = raise Match (* bad carry bit *)


  (* private *)
  fun addWithCarry (n1, ZERO, c) = carryIntoNat (n1, c)
    | addWithCarry (ZERO, n2, c) = carryIntoNat (n2, c)
    | addWithCarry (TIMESBASEPLUS (m1, d1), TIMESBASEPLUS (m2, d2), c) =
        let val d      = (d1 + d2 + c) mod base
            val cprime = (d1 + d2 + c) div base
        in timesbaseplus (addWithCarry (m1, m2, cprime), d)
        end

  fun /+/ (n1, n2) =
    case (invariant n1, invariant n2)
        of (true, true) => addWithCarry(n1, n2, 0)
         | _            => raise InvariantError


  (*** subtraction ***)

  (* private *)
  fun borrowFromNat (n, 0) = n
    | borrowFromNat (TIMESBASEPLUS (m, 0), 1) =
        timesbaseplus(borrowFromNat (m, 1), 9) 
    | borrowFromNat (TIMESBASEPLUS (m, d), 1) =
        timesbaseplus(m, d - 1)
    | borrowFromNat (ZERO, 1)               = raise Negative
    | borrowFromNat _                       = raise Match (* bad borrow bit *)

  (* private *)
  fun subWithBorrow (n1, ZERO, b)                = borrowFromNat (n1, b)
    | subWithBorrow (TIMESBASEPLUS (m1, d1),
                      TIMESBASEPLUS (m2, d2), b) = 
                        let
                          val d      = (d1 - d2 - b) mod base
                          val bprime = if d1 - d2 - b < 0 then 1 else 0
                        in 
                          timesbaseplus (subWithBorrow (m1, m2, bprime), d)
                        end
    | subWithBorrow (ZERO, TIMESBASEPLUS _, b)   = raise Negative 

  (* could raise Negative *)
  fun /-/ (n1, n2) =
    case (invariant n1, invariant n2)
        of (true, true) => subWithBorrow(n1, n2, 0)
         | _            => raise InvariantError


  (*** multiplication ***)

  (* private *)
  fun mulNats (ZERO, _) = ZERO
    | mulNats (_, ZERO) = ZERO
    | mulNats (TIMESBASEPLUS (m1, d1), TIMESBASEPLUS (m2, d2)) =
        /+/ (ofInt (d1 * d2),
        /+/ (timesbase (/+/ (mulNats (m1, ofInt d2),
                                        mulNats(m2, ofInt d1))),
                       timesbase (timesbase (mulNats (m1, m2)))))
  
  fun /*/ (n1, n2) =
    case (invariant n1, invariant n2)
        of (true, true) => mulNats (n1, n2)
         | _            => raise InvariantError 


  (*** division ***)

  (* Contract for "Short division" sdiv:

        Provided 0 < d <= K,
          sdiv (n, d) returns { quotient = q, remainder = r }
        such that
          n == q /*/ ofInt d /+/ ofInt r
          0 <= r < d

        Given a d <= 0, sdiv (n, d) raises BadDivisor.

        Given d > K, the program halts with a checked run-time error.
        The constant K depends on the number of bits in a machine integer,
        so it is not specified, but it is known to be at least 10.
   *)
  (* val sdiv  : nat * int -> { quotient : nat, remainder : int } *)
  fun sdiv (n, d) = 
    if (k <= 0)
      then raise BadDivisor
    else
      case n of ZERO => { quotient = ZERO, remainder = 0 }
              | TIMESBASEPLUS (m, d) =>
                  let
                    val { quotient = qprime , remainder = rprime } = sdiv (m, k)
                    val x  = (rprime * base) + d
                    val q0 = x div k
                    val r  = x mod k
                  in
                    { quotient = timesbaseplus(qprime, q0), remainder = r }
                  end
   


  infix 6 /+/ /-/
  infix 7 /*/ sdiv
     
        
  fun compare (ZERO, TIMESBASEPLUS(m,d2)) = LESS
              | compare (TIMESBASEPLUS(m,d1), ZERO) =  
                    GREATER
              | compare (n1,n2) = (n1-n2 handle Negative) 
                                    => LESS
              | compare (n1, n2) = 
                    case (n1 - n2)
                      of 0 => EQUAL
                      | _ => GREATER
        


  (* decimal n returns a list giving the natural decimal
        representation of n, most significant digit first.
        For example,  decimal (ofInt 123) = [1, 2, 3]
                      decimal (ofInt 0)   = [0]
        It must never return an empty list.
        And when it returns a list of two or more digits,
        the first digit must not be zero.
   *)
  (* val decimal : nat -> int list *)
  fun decimal n = case reverse(decimal-help 
                                (/sdiv/ n (ofInt 10),[]) , [])
                      of [] => [0]
                      | _ => 
                        reverse(decimal-help (n,[]) , [])


  fun decimal-help (0 , ls) = ls
        | decimal-help (q, r) = (/sdiv/ q (ofInt 10) , r::ls)
 

fun reverse ([],rs) = rs
      | reverse (l::ls, rs) = reverse(ls, l::rs) 


  
  



end

structure Natural :> NATURAL = ExposedNatural   (* the module is sealed here *)
