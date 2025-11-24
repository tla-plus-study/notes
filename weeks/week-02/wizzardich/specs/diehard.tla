------------------------------ MODULE diehard ------------------------------
EXTENDS Integers
VARIABLES small, big

Init == (small = 0) /\ (big = 0)

TypeOK == /\ (small \in 0..3)
          /\ (big \in 0..5) 

FillSmall == (small' = 3) /\ (big' = big)
FillBig == (big' = 5) /\ (small' = small)
EmptySmall == (small' = 0) /\ (big' = big)
EmptyBig == (big' = 0) /\ (small' = small)

SmallToBig == \/ /\ (big + small <= 5) 
                 /\ (big' = big + small) 
                 /\ (small' = 0)
              \/ /\ (big + small > 5)
                 /\ (big' = 5) 
                 /\ (small' = small - (5 - big))



BigToSmall == \/ /\ (big + small <= 3) 
                 /\ (big' = 0) 
                 /\ (small' = big + small)
              \/ /\ (big + small > 3)
                 /\ (big' = big - (3 - small)) 
                 /\ (small' = 3)

Next == \/ FillSmall
        \/ FillBig
        \/ EmptySmall
        \/ EmptyBig
        \/ SmallToBig
        \/ BigToSmall

=============================================================================
\* Modification History
\* Last modified Mon Nov 24 21:05:59 CET 2025 by wizzardich
\* Created Mon Nov 24 20:40:29 CET 2025 by wizzardich
