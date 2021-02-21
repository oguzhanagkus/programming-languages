:-style_check(-singleton).

% Element
element(E, S) :-
  member(E, S).

% Union
union(S1, S2, S3) :-
  cover_1(S1, S3), 
  cover_1(S2, S3),
  cover_both_1(S1, S2, S3).

% Intersect
intersect(S1,S2,S3) :-
  cover_2(S1, S2, S3),
  cover_both_2(S1, S2, S3).  

% Equivalent
equivalent(S1, S2) :-
  cover_1(S1, S2), 
  cover_1(S2, S1).

% Helpers
cover_1(X, Y) :-
  foreach(element(I, X), element(I, Y)).

cover_both_1(X, Y, Z) :-
  foreach(element(I, Z), element(I, X); element(I, Y)).

cover_2(X, Y, Z) :-
  foreach((element(I, X), element(I, Y)), element(I, Z)).

cover_both_2(X, Y, Z) :-
  foreach(element(I, Z), (element(I, X), element(I, Y))).