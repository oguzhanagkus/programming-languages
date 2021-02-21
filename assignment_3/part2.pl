:-style_check(-singleton).

% Facts
flight(istanbul, izmir).
flight(izmir, istanbul).
flight(istanbul, antalya).
flight(antalya, istanbul).
flight(istanbul, gaziantep).
flight(gaziantep, istanbul).
flight(istanbul, ankara).
flight(ankara, istanbul).
flight(istanbul, van).
flight(van, istanbul).
flight(istanbul, rize).
flight(rize, istanbul).
flight(edirne, edremit).
flight(edremit, edirne).
flight(erzincan, edremit).
flight(edremit, erzincan).
flight(izmir, ısparta).
flight(ısparta, izmir).
flight(burdur, ısparta).
flight(ısparta, burdur).
flight(konya, antalya).
flight(antalya, konya).
flight(konya, ankara).
flight(ankara, konya).
flight(antalya, gaziantep).
flight(gaziantep, antalya).
flight(van, ankara).
flight(ankara, van).
flight(van, rize).
flight(rize, van).

distance(istanbul, izmir, 329).
distance(izmir, istanbul, 329).
distance(istanbul, antalya, 483).
distance(antalya, istanbul, 483).
distance(istanbul, gaziantep, 847).
distance(gaziantep, istanbul, 847).
distance(istanbul, ankara, 352).
distance(ankara, istanbul, 352).
distance(istanbul, van, 1262).
distance(van, istanbul, 1262).
distance(istanbul, rize, 968).
distance(rize, istanbul, 968).
distance(edirne, edremit, 244).
distance(edremit, edirne, 244).
distance(erzincan, edremit, 1027).
distance(edremit, erzincan, 1027).
distance(izmir, ısparta, 309).
distance(ısparta, izmir, 309).
distance(burdur, ısparta, 25).
distance(ısparta, burdur, 25).
distance(konya, antalya, 192).
distance(antalya, konya, 192).
distance(konya, ankara, 227).
distance(ankara, konya, 227).
distance(antalya, gaziantep, 592).
distance(gaziantep, antalya, 592).
distance(van, ankara, 920).
distance(ankara, van, 920).
distance(van, rize, 373).
distance(rize, van, 373).

% Rules
sroute(X, Y, D) :- shortest_route(X, Y, D).

shortest_route(X, Y, D) :-
	route_distance(X, Y, Route, Minimum_Distance),
	not(shorter_route(X, Y, _, _, Minimum_Distance)),
  D is Minimum_Distance,
	!.

shorter_route(X, Y, Route, Cost, Min_Cost) :-
	route_distance(X, Y, Route, Cost),
	Cost < Min_Cost.

route_distance(X, Y, Route, Distance) :-
	route_one_distance(X, [Y], 0, Route, Distance).

route_one_distance(X, [X | Route1], Distance1, [X | Route1], Distance1).
route_one_distance(X, [Y | Route1], Distance1, Route, Distance) :-
	distance(N, Y, D),
	not(member(N, Route1)),
	Distance2 is Distance1 + D,
	route_one_distance(X, [N, Y | Route1], Distance2, Route, Distance).

member(X,[X | _]).
member(X,[_ | T]) :-
	member(X, T).