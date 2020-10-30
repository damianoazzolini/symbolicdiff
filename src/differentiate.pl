% prolog module to implement differentiation
% https://www.math.it/formulario/derivate.htm

% constant: 0
diff(X,Y,0,[constant],[d/d(Y:X) -> 0]):- number(X).

% d/dx x -> 1 or d/dx y -> 0
diff(X,Y,Res,[single],[d/d(Y:X) -> Res]):-
    atom(X),
    ( X \== Y -> Res = 0; Res = 1).

% constant * function: (k * f)' = k*f'
diff(K * F, Var, K * DF, [constant*function | TN], [d/d(Var : K*F) -> K*DF | TF]):-
    number(K),
    diff(F,Var,DF,TN,TF).

% sum rule: (f + g)' = f' + g'
diff(F + G, Var, DF + DG, [sum_rule, TN1|TN2], [d/d(Var : F + G) -> DF + DG, TF1|TF2]) :-
	diff(F, Var, DF,TN1,TF1),
	diff(G, Var, DG,TN2,TF2).

% product rule: (f*g)' = f'*g + f*g'
diff(F * G, Var, DF * G + DG * F, [product_rule, TN1|TN2], [d/d(Var : F + G) ->  DF * G + DG * F, TF1|TF2]) :-
	diff(F, Var, DF,TN1,TF1),
	diff(G, Var, DG, TN2,TF2).

% quotient rule: (f/g)' = (f'*g + f*g') / g^2
diff(F / G, Var, (DF * G - DG * F) / G^2, [quotient_rule, TN1|TN2], [d/d(Var : F / G) -> (DF * G - DG * F) / G^2, TF1|TF2]) :-
	diff(F, Var, DF,TN1,TF1),
	diff(G, Var, DG,TN2,TF2).

% power function
% d(x^n)/dx -> n*x^{n-1}
diff(F^N,Var,N*F^N1,[power_rule],[d/d(Var:F^N) -> N*F^N1]):-
    Var = F,
    number(N),
    N1 is N - 1.
diff(F^N,Var,0,[power_rule],[d/d(Var:F^N) -> 0]):-
    Var \= F,
    number(N).

% absolute value
% d abs(x) / dx -> abs(x) / x
diff(abs(X),X,abs(X)/X,[absolute_value],[d/d(X:abs(X)) -> abs(X)/X]):-
    atom(X).
diff(abs(X),Var,0,[absolute_value],[d/d(Var:abs(X)) -> 0]):-
    atom(X),
    X \= Var.
% if it is a function, (abs(f)/f) * f'
diff(abs(X),Var,X*DX/abs(X),[absolute_value | TN],[d/d(Var:abs(X)) -> X*DX/abs(X) | TF]):-
    compound(X),
    diff(X,Var,DX,TN,TF).

% logarithm
% d log(x) / dx -> 1/x

% exponential
% d (a^x) / dx -> (a^x) * ln(a)
% d (e^x) / dx -> e^x

% trigonometric functions
% d sin(x) / dx -> cos(x)
diff(sin(X),X,cos(X),[sin],[d/d(X:sin(X)) -> cos(X)]):-
    atom(X).
diff(sin(X),Var,0,[sin],[d/d(Var:sin(X)) -> 0]):-
    atom(X),
    X \= Var.

% d cos(x) / dx -> -sin(x)
diff(cos(X),X,-sin(X),[cos],[d/d(X:cos(X)) -> -sin(X)]):-
    atom(X).
diff(cos(X),Var,0,[cos],[d/d(Var:cos(X)) -> 0]):-
    atom(X),
    X \= Var.


% d tan(x) / dx -> 1 + tan^2(x)
% d cot(x) / dx -> -(1 + cot^2(x))

% composite function

% check if the variable to be integrated is in the expression
% if so, perform the operations, otherwise return 0
quick_check(Expression,DerivVar,Res):-
    term_to_atom(Expression,C),
    atom_chars(C,LC),
    ( memberchk(x,LC) -> true ; Res = 0).

% simplify expression containing 0*_ or 1*_
% 2*1*y+0*(2*x) -> 2*y
remove_zeros_ones(R,R).

differentiate(Formula,Variable,Result,Rules,Operations):-
    diff(Formula,Variable,Result1,Rules,Operations),
    remove_zeros_ones(Result1,Result).