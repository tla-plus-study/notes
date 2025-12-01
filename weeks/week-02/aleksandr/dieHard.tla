------------------------------- MODULE dieHard -------------------------------
EXTENDS Integers
VARIABLES tank3, tank5

TypeSpec == (tank3 \in 0..3) /\ (tank5 \in 0..5)
SuccessSpec == tank5 /= 4

Init == (tank3 = 0) /\ (tank5 = 0)


FillTank3 ==    /\ (tank3 = 0) 
                /\ (tank3' = 3) 
                /\ (tank5' = tank5)
                
FillTank5 ==    /\ (tank5 = 0) 
                /\ (tank5' = 5) 
                /\ (tank3' = tank3)
                

EmptyTank3 ==   /\ (tank3' = 0)
                /\ (tank5' = tank5)
 
EmptyTank5 ==   /\ (tank5' = 0)
                /\ (tank3' = tank3)               

PourOverFrom3to5 == IF tank5 + tank3 > 5 
                        THEN
                            /\ tank5' = 5
                            /\ tank3' = (tank5 + tank3 - 5)
                        ELSE
                            /\ tank5' = (tank5 + tank3)
                            /\ tank3' = 0

PourOverFrom5to3 == IF tank5 + tank3 > 3
                        THEN
                            /\ tank3' = 3
                            /\ tank5' = (tank5 + tank3 - 3)
                        ELSE
                            /\ tank3' = (tank5 + tank3)
                            /\ tank5' = 0


Next == \/ FillTank3
        \/ FillTank5
        \/ EmptyTank3
        \/ EmptyTank5
        \/ PourOverFrom3to5
        \/ PourOverFrom5to3
       

=============================================================================
\* Modification History
\* Last modified Sun Nov 30 23:46:55 EET 2025 by alx
\* Created Sun Nov 30 15:55:37 EET 2025 by alx
