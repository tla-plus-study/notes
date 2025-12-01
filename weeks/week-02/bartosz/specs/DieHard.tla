------------------------------ MODULE DieHard ------------------------------
EXTENDS Integers

VARIABLES small, big   
          
TypeOK == /\ small \in 0..3 
          /\ big   \in 0..5

Init == small = 0 /\ big = 0

FillSmall == small' = 3 /\ big' = big

FillBig == big' = 5 /\ small' = small

EmptySmall == small' = 0 /\ big' = big

EmptyBig == big' = 0 /\ small' = small

SmallToBig == IF big + small =< 5
              THEN /\ big' = big + small
                   /\ small' = 0
              ELSE /\ big' = 5
                   /\ small' = small - (5 - big)

BigToSmall == IF big + small =< 3
              THEN /\ big' = 0
                   /\ small' = big + small
              ELSE /\ big' = big - (3 - small)
                   /\ small' = 3                  

Next == \/ FillSmall 
        \/ FillBig    
        \/ EmptySmall 
        \/ EmptyBig    
        \/ SmallToBig    
        \/ BigToSmall   


=============================================================================
\* Modification History
\* Last modified Sat Nov 29 12:20:40 CET 2025 by bartosz
\* Created Fri Nov 28 16:08:43 CET 2025 by bartosz
