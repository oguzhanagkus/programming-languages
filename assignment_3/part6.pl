test_case(
	1,
	[[3], [2,1], [3,2], [2,2], [6], [1,5], [6], [1], [2]],
	[[1,2], [3,1], [1,5], [7,1], [5], [3], [4], [3]]
	).

test_case(
	2,
	[[3,1], [2,4,1], [1,3,3], [2,4], [3,3,1,3], [3,2,2,1,3],
	 [2,2,2,2,2], [2,1,1,2,1,1], [1,2,1,4], [1,1,2,2], [2,2,8],
	 [2,2,2,4], [1,2,2,1,1,1], [3,3,5,1], [1,1,3,1,1,2],
	 [2,3,1,3,3], [1,3,2,8], [4,3,8], [1,4,2,5], [1,4,2,2],
	 [4,2,5], [5,3,5], [4,1,1], [4,2], [3,3]],
	[[2,3], [3,1,3], [3,2,1,2], [2,4,4], [3,4,2,4,5], [2,5,2,4,6],
	 [1,4,3,4,6,1], [4,3,3,6,2], [4,2,3,6,3], [1,2,4,2,1], [2,2,6],
	 [1,1,6], [2,1,4,2], [4,2,6], [1,1,1,1,4], [2,4,7], [3,5,6],
	 [3,2,4,2], [2,2,2], [6,3]]
	).

test_case(
	3,
	[[5], [2,3,2], [2,5,1], [2,8], [2,5,11], [1,1,2,1,6], [1,2,1,3],
	 [2,1,1], [2,6,2], [15,4], [10,8], [2,1,4,3,6], [17], [17],
	 [18], [1,14], [1,1,14], [5,9], [8], [7]],
	[[5], [3,2], [2,1,2], [1,1,1], [1,1,1], [1,3], [2,2], [1,3,3],
	 [1,3,3,1], [1,7,2], [1,9,1], [1,10], [1,10], [1,3,5], [1,8],
	 [2,1,6], [3,1,7], [4,1,7], [6,1,8], [6,10], [7,10], [1,4,11],
	 [1,2,11], [2,12], [3,13]]
	).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

main(CaseNo) :-
   test_case(CaseNo, RowNumbers, ColumnNumbers),
   puzzle(RowNumbers, ColumnNumbers, Solution), nl,
   open('output.txt', write, OutputStream),
   print_solution(RowNumbers, ColumnNumbers, Solution, OutputStream),
   close(OutputStream).

puzzle(RowNumbers, ColumnNumbers, Solution) :-
   length(RowNumbers, RowCount),
   length(ColumnNumbers, ColumnCount),
   make_rectangle(RowCount, ColumnCount, Rows, Columns),
   append(Rows, Columns, Lines),
   append(RowNumbers, ColumnNumbers, LineNumbers),
   maplist(make_runs, LineNumbers, LineRuns),
   combine(Lines, LineRuns, LineTasks),
   optimize(LineTasks, OptimizedLineTasks),
   solve(OptimizedLineTasks),
   Solution = Rows.

combine([], [], []).
combine([L1|Ls], [N1|Ns], [task(L1, N1)|Ts]) :-
   combine(Ls, Ns, Ts).

solve([]).
solve([task(Line, LineRuns)|Tasks]) :-
   place_runs(LineRuns, Line),
   solve(Tasks).

make_rectangle(RowCount, ColumnCount, Rows, Columns) :-
   RowCount > 0,
   ColumnCount > 0,
   length(Rows, RowCount),
   Prediction1 =.. [inv_length, ColumnCount],
   checklist(Prediction1, Rows),
   length(Columns, ColumnCount),
   Prediction2 =.. [inv_length, RowCount],
   checklist(Prediction2, Columns),
   unify_rectangle(Rows, Columns).

inv_length(Len,List) :-
   length(List,Len).

unify_rectangle(_,[]).
unify_rectangle([],_).
unify_rectangle([[X|Row1]|Rows] , [[X|Column1]|Columns]) :-
  unify_row(Row1, Columns, ColumnsRight), 
  unify_rectangle(Rows, [Column1|ColumnsRight]).   

unify_row([],[],[]).
unify_row([X|Row] , [[X|Col1]|Cols] , [Col1|ColsR]) :-
   unify_row(Row,Cols,ColsR).

make_runs([] , []) :- !.
make_runs([Len1|Lens] , [Run1-T|Runs]) :-
   put_x(Len1, Run1, T),
   make_runs2(Lens, Runs).

make_runs2([],[]).
make_runs2([Len1|Lens], [[' '|Run1]-T|Runs]) :-
   put_x(Len1, Run1, T),
   make_runs2(Lens, Runs).

put_x(0,T,T) :- !.
put_x(N, ['x'|Xs],T) :- N > 0, N1 is N-1, put_x(N1,Xs,T).

place_runs([],[]).
place_runs([Line-Rest|Runs], Line) :- place_runs(Runs,Rest).
place_runs(Runs, [' '|Rest]) :- place_runs(Runs, Rest).

optimize(LineTasks, OptimizedLineTasks) :-
   label(LineTasks, LabelledLineTasks),
   sort(LabelledLineTasks, SortedLineTasks),
	unlabel(SortedLineTasks, OptimizedLineTasks).
   
label([],[]).
label([task(Line, LineRuns)|Tasks], [task(Count, Line, LineRuns)|LTasks]) :-
   length(Line, N),   
   findall(L, (length(L, N),
   place_runs(LineRuns, L)), Ls),
   length(Ls, Count),
   label(Tasks, LTasks).

unlabel([],[]).
unlabel([task(_, Line, LineRuns)|LTasks], [task(Line,LineRuns)|Tasks]) :-
   unlabel(LTasks, Tasks).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

print_solution([], ColNums, [], OutputStream) :-
   print_colnums(ColNums, OutputStream).
print_solution([RowNums1|RowNums], ColNums, [Row1|Rows], OutputStream) :-
   print_row(Row1, OutputStream),
   print_rownums(RowNums1, OutputStream),
   print_solution(RowNums, ColNums, Rows, OutputStream).

print_row([], OutputStream) :-
   write('  '),
   write(OutputStream, '  ').
print_row([X|Xs], OutputStream) :-
   print_replace(X, Y),
   write(' '),
   write(OutputStream, ' '),
   write(Y),
   write(OutputStream, Y),
   print_row(Xs, OutputStream).
   
print_replace(' ',' ') :- !.
print_replace(x,'X').

print_rownums([], OutputStream) :- 
   nl,
   write(OutputStream, '\n').
print_rownums([N|Ns], OutputStream) :-
   write(N),
   write(OutputStream, N),
   write(' '),
   write(OutputStream, ' '),
   print_rownums(Ns, OutputStream).

print_colnums(ColNums, OutputStream) :-
   maxlength(ColNums, M, 0),
	print_colnums(ColNums, ColNums, 1, M, OutputStream).
print_colnums(_, [], M, M, OutputStream) :- 
   !,
   nl,
   write(OutputStream, '\n').
print_colnums(ColNums, [], K, M, OutputStream) :-
   K < M, !, 
   nl,
   write(OutputStream, '\n'),
   K1 is K+1, 
   print_colnums(ColNums, ColNums, K1, M, OutputStream).
print_colnums(ColNums, [Col1|Cols], K, M, OutputStream) :-
   K =< M, 
   write_kth(K, Col1, OutputStream),
   print_colnums(ColNums, Cols, K, M, OutputStream).

maxlength([],M,M).
maxlength([L|Ls], M, A) :-
   length(L, N),
   B is max(A, N),
   maxlength(Ls,M,B). 

write_kth(K, List, OutputStream) :-
   nth1(K, List, X),
   !,
   writef('%2r', [X]),
   write(OutputStream, ' '),
   write(OutputStream, X).
write_kth(_, _, OutputStream) :-
   write('  '),
   write(OutputStream, '  ').