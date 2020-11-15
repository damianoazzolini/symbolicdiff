% prolog module to implement differentiation
% https://www.math.it/formulario/derivate.htm

:- module(differentiate,[
    differentiate/2,
    differentiate/3,
    differentiate/5,
    differentiate_steps/2,
    evaluate/2,
    evaluate/3,
    evaluate_expr/2,
    evaluate_expr/3,
    jacobian/1,
    jacobian/3,
    hessian/1,
    hessian/3,
    gradient/1,
    gradient/3,
    gradient_steps/1,
    evaluate_nth/1,
    list_to_compound/2,
    remove_elements/2]).
:- discontiguous differentiate:diff/5.

reserved_words([sin,cos,tan,cot,sqrt,ln,e,pi,abs]).
functions([sin,cos,tan,cot,sqrt,ln,abs]).
builtin_values([e,pi]).
operators([+,-,*,/,^,(,),sqrt]).

% remove everything that is not a variable
remove_elements([],[]).
remove_elements([H|T],L):-
    functions(FN),
    operators(Op),
    builtin_values(Val),
    (   memberchk(H,FN) ; number(H) ; memberchk(H,Op) ; memberchk(H,Val) ), !,
    remove_elements(T,L).
remove_elements([H|T],[H|T1]):- !,
    remove_elements(T,T1).

% TODO: wrap all cases where the variable derivation is not the one 
% in the function (0)

% constant: 0
diff(X,Y,0,[constant],[d/d(Y:X) -> 0]):- number(X).

% d/dx x -> 1 or d/dx y -> 0
diff(X,Y,Res,[one_variable],[d/d(Y:X) -> Res]):-
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
diff(sqrt(X),X,1/(2*sqrt(X)),[power_rule],[d/d(X:sqrt(X)) -> 1/(2*sqrt(X))]):-
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

% exponential composite
diff((FX)^(GX),X,(FX)^(GX)*(DG*ln(FX) + (GX*DF)/FX),[exponential_composite, TN1 | TN2],[d/d(X:FX^GX) -> (FX)^(GX)*(DG*ln(FX) + (GX*DF)/FX), TF1 | TF2]):-
    compound(FX),
    compound(GX),
    diff(FX,X,DF,TN1,TF1),
    diff(GX,X,DG,TN2,TF2).

% reciprocal function
diff(1/FX,X,-(DF)/((FX)^2),[reciprocal | TN],[d/d(X:1/FX) -> -(DF)/((FX)^2) | TF]):-
    compound(FX),
    diff(FX,X,DF,TN,TF).

diff(cos,-sin).
diff(sin,cos).
diff(ln(A),1/A).
diff(sqrt(A),1/(2*sqrt(A))).

% composite function (last one): TODO
diff(A,X,Composite*DG,[reciprocal, TN1 | TN2],[d/d(X:A) -> Composite*DG, TF1 | TF2]):-
    compound(A),
    A =..[FX|GX],
    functions(LF),
    member(FX,LF),
    FuncFX =..[FX,X], 
    diff(FuncFX,X,DF,TN1,TF1),
    GX = [FuncGX],
    diff(FuncGX,X,DG,TN2,TF2),
    DF =..[DFF,_],
    Composite =..[DFF,FuncGX].

% check if the variable to be integrated is in the expression
% if so, perform the operations, otherwise return 0
quick_check(Expression,DerivVar,Res):-
    term_to_atom(Expression,C),
    atom_chars(C,LC),
    ( memberchk(DerivVar,LC) -> true ; Res = 0).

% simplify expression containing 0*_ or 1*_
% 2*1*y+0*(2*x) -> 2*y
remove_zeros_ones(In,In).

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

% compute symbolic derivative
differentiate(Formula,Variable,Result,Rules,Operations):-
    diff(Formula,Variable,Result1,Rules,Operations),
    remove_zeros_ones(Result1,Result).

% TODO: use maplist
differentiate(Formula,V):-
    ( V = [Var] ; atom(V), Var = V ),
    diff(Formula,Var,Result1,_,_), !,
    remove_zeros_ones(Result1,Result),
    write('d'),write(Var),write(': '),writeln(Result).
differentiate(Formula,[Variable|T]):-
    diff(Formula,Variable,Result1,_,_), !,
    remove_zeros_ones(Result1,Result),
    write('d'),write(Variable),write(': '),writeln(Result),
    differentiate(Formula,T).
differentiate(Formula,Variable,Result):-
    diff(Formula,Variable,Result1,_,_),
    remove_zeros_ones(Result1,Result).
differentiate_steps(Formula,V):-
    ( V = [Var] ; atom(V),Var = V ),
    diff(Formula,Var,Result1,Rules,Operations), !,
    remove_zeros_ones(Result1,Result),
    write('d'),write(Var),write(': '),writeln(Result),
    flatten(Rules,RF),
    flatten(Operations,OF),
    writeln(RF),writeln(OF).
differentiate_steps(Formula,[Variable|T]):-
    diff(Formula,Variable,Result1,Rules,Operations), !,
    remove_zeros_ones(Result1,Result),
    write('d'),write(Variable),write(': '),writeln(Result),
    flatten(Rules,RF),
    flatten(Operations,OF),
    writeln(RF),writeln(OF),
    differentiate_steps(Formula,T).

% from: https://stackoverflow.com/questions/19917369/prolog-using-2-univ-in-a-recursive-way
list_to_compound(L, T) :-
    var(T)
    ->  L = [F|Fs], maplist(list_to_compound, Fs, Ts), T =.. [F|Ts]
    ;   atomic(T)
    ->  L = T
    ;   L = [F|Fs], T =.. [F|Ts], maplist(list_to_compound, Fs, Ts), !.
list_to_compound(T, T).

% extract vars from list
% ?- extract_vars(x+y^2+z,V).
extract_vars(Equation,VarsList):-
    list_to_compound(List,Equation),
    flatten(List,LF),
    remove_elements(LF,VarsListD),
    sort(VarsListD,VarsList).

% evaluate the derivative
% VariablesList is a list of the form [[x,1],[y,2]]
evaluate(Formula,VariablesList):-
    evaluate(Formula,VariablesList,Result),
    writeln(Result).
evaluate(Formula,VariablesList,Result):-
    % TODO: check that all the variables are in the list
    % TODO: check that the list is well formed
    findall(V,member([V,_],VariablesList),LV),
    length(LV,NV),
    length(SymbolicResult,NV),
    maplist(differentiate(Formula),LV,SymbolicResult),
    replace_vars(SymbolicResult,VariablesList,ToEvaluate),
    maplist(is,Result,ToEvaluate).

evaluate_expr(Formula,VariablesList):-
    evaluate_expr(Formula,VariablesList,Result),
    writeln(Result).
evaluate_expr(Formula,VariablesList,Result):-
    % TODO: check that all the variables are in the list
    % TODO: check that the list is well formed
    replace_vars(Formula,VariablesList,ToEvaluate),
    Result is ToEvaluate.

my_write(Var,Der):-
    format('d~w: ~w~n',[Var,Der]).

jacobian(Formula):-
    jacobian(Formula,LV,Result),
    maplist(my_write,LV,Result).
jacobian(Formula,LVars,Result):-
    extract_vars(Formula,LVars),
    maplist(differentiate(Formula),LVars,Result).

gradient(Formula):- 
    gradient(Formula,LV,Result), !,
    maplist(my_write,LV,Result).
gradient(Formula,LVars,Result):- 
    extract_vars(Formula,LVars),
    maplist(differentiate(Formula),LVars,Result), !.
gradient_steps(Formula):-
    extract_vars(Formula,LVars),
    maplist(differentiate_steps(Formula),LVars), !.


hessian(_Formula):- true.
    % hessian(Formula,LV,Result),
    % maplist(my_write,LV,Result).
hessian(_Formula,_LVars,_Result):- true.
    % extract_vars(Formula,LVars),
    % maplist(differentiate(Formula),LVars,Result1).

evaluate_nth(_):- true.

