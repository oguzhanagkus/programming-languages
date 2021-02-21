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

% Rules
route(X, Y) :- 
  route_(X, Y, []).
route_(X, Y, R) :-  
  flight(X, Z),
  not(member(Z, R)),
  (Y = Z; route_(Z, Y, [X | R])).