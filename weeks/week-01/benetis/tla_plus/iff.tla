-------------------------------- MODULE iff --------------------------------

EXTENDS Naturals

VARIABLES Numbers

IsEven(n) == (n % 2 = 0)
IsDivisibleBy4(n) == (n % 4 = 0)
IsDivisibleBy2(n) == (n % 2 = 0)

\*Fails, because not correct
Example1 == \A n \in Numbers : IsDivisibleBy4(n) <=> IsEven(n)

Example2 == \A n \in Numbers : IsEven(n) <=> IsDivisibleBy2(n)

Init == Numbers = 0..10
Next == UNCHANGED Numbers
Spec == Init /\ [][Next]_Numbers

=============================================================================
