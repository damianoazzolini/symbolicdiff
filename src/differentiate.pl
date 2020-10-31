% prolog module to implement differentiation
% https://www.math.it/formulario/derivate.htm

:- module(differentiate,[differentiate/2,differentiate/5,evaluate/3]).

reserved_words([sin,cos,tan,cot,sqrt,ln,e,pi,abs]).

% TODO: wrap all cases where the variable derivation is not the one 
% in the function (0)

% constant: 0
diff(X,Y,0,[constant],[d/d(Y:X) -> 0]):- number(X).

% d/dx x -> 1 or d/dx y -> 0
diff(X,Y,Res,[single],[d/d(Y:X) -> Res]):-
    atom(X),
    ( X \== Y -> Res = 0; Res = 1).

% constant * function: (k * f)' = k*f'
diff(K * F, Var, K * (DF), [constant*function | TN], [d/d(Var : K*F) -> K*(DF) | TF]):-
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

% derivata del reciproco di una funzione

% power function
% d(x^n)/dx -> n*x^{n-1}
diff(F^N,F,N*(F^N1),[power_rule],[d/d(F:F^N) -> N*(F^N1)]):-
    atom(F),
    number(N),
    N1 is N - 1.
diff(F^N,Var,0,[power_rule],[d/d(Var:F^N) -> 0]):-
    atom(F),
    number(N),
    Var \= F.
diff(sqrt2(X),X,1/(2*sqrt(X)),[power_rule],[d/d(X:sqrt2(X)) -> 1/(2*sqrt(X))]):-
    atom(X).

% absolute value
% d abs(x) / dx -> abs(x) / x
diff(abs(X),X,abs(X)/X,[absolute_value],[d/d(X:abs(X)) -> abs(X)/X]):-
    atom(X).
diff(abs(X),Var,0,[absolute_value],[d/d(Var:abs(X)) -> 0]):-
    atom(X),
    X \= Var.
% if it is a function, (abs(f)/f) * f'
diff(abs(X),Var,(X*DX)/abs(X),[absolute_value | TN],[d/d(Var:abs(X)) -> (X*DX)/abs(X) | TF]):-
    compound(X),
    diff(X,Var,DX,TN,TF).

% logarithm
% d ln(x) / dx -> 1/x
diff(ln(X),X,1/X,[logarithm],[d/d(X:ln(X)) -> 1/X]):-
    atom(X).
diff(ln(X),Var,0,[logarithm],[d/d(Var:ln(X)) -> 0]):-
    atom(X),
    X \= Var.
% ln(abs(x)) -> 1/x
diff(ln(abs(X)),X,1/X,[logarithm_abs],[d/d(X:ln(abs(X))) -> 1/X]):-
    atom(X).
diff(ln(abs(X)),Var,0,[logarithm_abs],[d/d(Var:ln(abs(X))) -> 0]):-
    atom(X),
    X \= Var.

% exponential
% d (a^x) / dx -> (a^x) * ln(a)
diff(A^X,X,(A^X)*ln(A),[exponential],[d/d(X:A^X) -> (A^X)*ln(A)]):-
    number(A),
    atom(X),
    A \= e.
diff(A^X,Y,0,[exponential],[d/d(X:A^X) -> 0]):-
    number(A),
    atom(X),
    X \= Y.
% d (e^x) / dx -> e^x
diff(e^X,X,e^X,[exponential],[d/d(X:e^X) -> e^X]):-
    atom(X).

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
diff(tan(X),X,1+tan(X)^2,[tan],[d/d(X:tan(X)) -> -1+tan(X)^2]):-
    atom(X).
diff(tan(X),Var,0,[tan],[d/d(Var:tan(X)) -> 0]):-
    atom(X),
    X \= Var.

% d cot(x) / dx -> -(1 + cot^2(x))
diff(cot(X),X,-(1+cot(X)^2),[cot],[d/d(X:cot(X)) -> -(1+cot(X)^2)]):-
    atom(X).
diff(tan(X),Var,0,[cot],[d/d(Var:cot(X)) -> 0]):-
    atom(X),
    X \= Var.

% a^f(X)
diff(A^FX,X,(A^FX)*ln(A)*DF,[composite | TN],[d/d(X:A^FX) -> (A^FX)*ln(A)*DF | TF]):-
    number(A),
    A \= e,
    diff(FX,X,DF,TN,TF).
% e^f(X)
diff(e^FX,X,(e^FX)*DF,[composite | TN],[d/d(X:e^FX) -> (e^FX)*DF | TF]):-
    diff(FX,X,DF,TN,TF).
% f(x)^n
diff(FX^N,X,N*(FX^N1)*DF,[composite | TN],[d/d(X:FX^N) -> N*(FX^N1)*DF | TF]):-
    compound(FX),
    number(N),
    N1 is N-1,
    diff(FX,X,DF,TN,TF).

% exponential composite: TODO

% inverse function: TODO

% composite function (last one): TODO


% check if the variable to be integrated is in the expression
% if so, perform the operations, otherwise return 0
quick_check(Expression,DerivVar,Res):-
    term_to_atom(Expression,C),
    atom_chars(C,LC),
    ( memberchk(DerivVar,LC) -> true ; Res = 0).

% simplify expression containing 0*_ or 1*_
% 2*1*y+0*(2*x) -> 2*y
remove_zeros_ones(R,R).

% replace variables
replace(TermFind, TermReplace, Compound, CompOut) :-
    ( Compound == TermFind -> 
        CompOut = TermReplace ;    
            Compound =.. [F|Args0],
            maplist(replace(TermFind,TermReplace), Args0, Args),
            CompOut =.. [F|Args]
    ).

replace_vars(Res,[],Res):- !.
replace_vars(Res,[[Find,Replace]|T],Result):-
    replace(Find,Replace,Res,Res0),
    replace_vars(Res0,T,Result).

% compute symbolic derivation
differentiate(Formula,Variable,Result,Rules,Operations):-
    diff(Formula,Variable,Result1,Rules,Operations),
    remove_zeros_ones(Result1,Result).

differentiate(Formula,Variable):-
    diff(Formula,Variable,Result1,_,_),
    remove_zeros_ones(Result1,Result),
    writeln(Result).


% evaluate the derivative
% VariablesList is a list of lists of the form [[x,1],[y,2]]
evaluate(Formula,VariablesList,Result):-
    % TODO: check that all the variables are in the list
    % TODO: check that the list is well formed
    differentiate(Formula,_,SymbolicResult),
    replace_vars(SymbolicResult,VariablesList,ToEvaluate),
    Result is ToEvaluate.

jacobian(_,_):- true.
hessian(_,_):- true.
evaluate_nth(_):- true.

