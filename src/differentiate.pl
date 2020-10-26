% prolog module to implement differentiation

% constant -> 0
diff(X,_,0):- number(X).

% other variables not derived
diff(X,Y,X):-
    atom(X),
    X \== Y.