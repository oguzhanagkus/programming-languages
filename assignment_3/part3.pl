:-style_check(-singleton).

% Facts
when(102, 10).
when(108, 12).
when(341, 14).
when(455, 16).
when(452, 17).

where(102, z23).
where(108, z11).
where(341, z06).
where(455, 207).
where(452, 207).

enrollment(a, 102).
enrollment(a, 108).
enrollment(b, 102).
enrollment(c, 108).
enrollment(d, 341).
enrollment(e, 455).

% Rules
schedule(S, P, T) :-
  enrollment(S, C),
  where(C, P),
  when(C,T).

usage(P, T) :- 
  where(C, P),
  when(C, T).

conflict(X, Y) :- 
  (when(X, T1), when(Y, T2), T1==T2); 
  (where(X, P1), where(Y, P2), P1==P2).

meet(X, Y) :- 
  enrollment(X, C1), 
  enrollment(Y, C2), 
  C1==C2.