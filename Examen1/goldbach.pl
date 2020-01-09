% 1(a) Complete the following predicate prime(P) which, given a natural number P
% holds iff P is prime (that is, P > 1 and P is divisible only by 1 and by P itself).
% Hint: the built-in predicate "between" can be useful.

prime(P) :-  P2 is P-1,  between(2,P2, X), 0 is P mod X, !, fail.
prime(P):- P > 1.


% 1(b) Goldbach's conjecture (nobody knows if it is true) claims that any EVEN
% natural number N with N > 2 can be decomposed as the sum of two prime numbers.
% Write a predicate goldbach(N) which, given an even natural number N, with N > 2,
% writes all possible ways of decomposing N as the sum of two prime numbers
% P1 and P2 such that P1 <= P2 (and N = P1 + P2), in increasing lexicographic order.
% The predicate must succeed on any input.
% For example:
%   ?- goldbach(32).
%   32=3+29
%   32=13+19
%   true.

goldbach(N) :-
    between(1, N, P1),
    between(1,N, P2),
    prime(P1),
    prime(P2),
    P1 =< P2,
    N is P1 + P2,
    write(N = P1 + P2), nl,
    fail.
goldbach(_).

