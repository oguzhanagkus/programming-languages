:-style_check(-singleton).

main :-
  open('input.txt', read, InputStream),
  read(InputStream, Line),
  close(InputStream),
  string_to_list(Line, List),
  open('output.txt', write, OutputStream),
  calculate(List, OutputStream),
  close(OutputStream).

calculate(List, OutputStream) :- 
  equation(List, LeftTerm, RightTerm),
  write(OutputStream, LeftTerm),
  write(OutputStream, '='),
  write(OutputStream, RightTerm),
  write(OutputStream, '\n'),
  fail.
calculate(_, OutputStream).

equation(List, LeftTerm, RightTerm) :-
  split(List, LeftList, RightList),
  term(LeftList, LeftTerm),
  term(RightList, RightTerm),
  LeftTerm =:= RightTerm.

split(List, List1, List2) :-
  append(List1, List2, List), List1 = [_|_], List2 = [_|_].

term([X], X).
term(List, Term) :-
   split(List, LeftList, RightList),
   term(LeftList, LeftTerm),
   term(RightList, RightTerm),
   combine(LeftTerm, RightTerm, Term).

combine(LeftTerm, RightTerm, LeftTerm + RightTerm).
combine(LeftTerm, RightTerm, LeftTerm - RightTerm).
combine(LeftTerm, RightTerm, LeftTerm * RightTerm).
combine(LeftTerm, RightTerm, LeftTerm / RightTerm) :- RightTerm =\= 0.