:- ['../src/differentiate'].

test:- test_differentiate, test_evaluate, test_utility, !.

test_differentiate:-
    wrap_test_differentiate(constant,1,x,0),
    wrap_test_differentiate(variable,x,x,1),
    wrap_test_differentiate(power_2,x^2,x,2*x^1),
    wrap_test_differentiate(power_3,x^3,x,3*x^2),
    wrap_test_differentiate(power_no_var,x^3,y,0),
    wrap_test_differentiate(sqrt_2,sqrt(x),x,1/(2*sqrt(x))),
    wrap_test_differentiate(absolute_1,abs(x),x,abs(x)/x),
    wrap_test_differentiate(absolute_2,abs(x),y,0),
    wrap_test_differentiate(absolute_3,abs(sin(x)),x,sin(x)*cos(x)/abs(sin(x))),
    wrap_test_differentiate(absolute_4,abs(sin(x^2)),x,sin(x^2)*(cos(x^2)*(2*x^1))/abs(sin(x^2))),
    wrap_test_differentiate(logarithm,ln(x),x,1/x),
    wrap_test_differentiate(logarithm_abs,ln(abs(x)),x,1/x),
    wrap_test_differentiate(tan,tan(x),x,1+tan(x)^2),
    wrap_test_differentiate(cot,cot(x),x,-(1+cot(x)^2)),
    wrap_test_differentiate(exponential_n,2^x,x,(2^x)*ln(2)),
    wrap_test_differentiate(exponential_e,e^x,x,e^x),
    wrap_test_differentiate(composite_exp_num,3^sin(x),x,(3^sin(x))*ln(3)*cos(x)),
    wrap_test_differentiate(composite_exp_e,e^sin(x),x,(e^sin(x))*cos(x)),
    wrap_test_differentiate(composite_sin_3,sin(x)^3,x,3*(sin(x)^2)*cos(x)),
    wrap_test_differentiate(reciprocal,1/sin(x),x,(0*sin(x)-cos(x)*1)/sin(x)^2).
    % reciprocal function

test_evaluate:- 
    wrap_test_evaluate_expr(one_var_a,3*x,[[x,1]],3),
    wrap_test_evaluate_expr(two_vars,3*x*y,[[x,2],[y,2]],12).

test_utility:-
    wrap_test_list_to_compound(list_to_compound,[(+),[(*),[(^),x,2],[(^),3,3]],y], x^2*3^3+y),
    wrap_test_list_to_compound(list_to_compound,[(+),[(+),[(+),[(*),[cos,[(^),x,2]],[(^),3,3]],y],pi],[(^),e,[cos,pi]]],cos(x^2)*3^3+y+pi+e^cos(pi)),
    wrap_test_remove_elements(remove_elements_1,[(+),(*),(^),x,2,(^),3,3,y],[x,y]),
    wrap_test_remove_elements(remove_elements_2, [(+),(+),(+),(*),cos,(^),x,2,(^),3,3,y,pi,(^),e,cos,pi],[x,y]).

wrap_test_evaluate_expr(TestName,Formula,Vars,ExpectedResult):-
    ( evaluate_expr(Formula,Vars,Res),
        ( Res = ExpectedResult  ->
            ansi_format([bold,fg(green)], 'Passed ~w~n',[TestName]);
            ansi_format([bold,fg(red)], 'Failed ~w: ~w -> ~w~n', [TestName,Res,ExpectedResult])
        ) ;
        ansi_format([bold,fg(red)], 'Failed ~w: no unification~n', [TestName])
    ).

wrap_test_list_to_compound(TestName,In,ExpectedResult):-
    ( list_to_compound(In,Res),
        ( Res = ExpectedResult  ->
            ansi_format([bold,fg(green)], 'Passed ~w~n',[TestName]);
            ansi_format([bold,fg(red)], 'Failed ~w: ~w -> ~w~n', [TestName,Res,ExpectedResult])
        ) ;
        ansi_format([bold,fg(red)], 'Failed ~w: no unification~n', [TestName])
    ).

wrap_test_remove_elements(TestName,In,ExpectedResult):-
    ( remove_elements(In,Res),
        ( Res = ExpectedResult  ->
            ansi_format([bold,fg(green)], 'Passed ~w~n',[TestName]);
            ansi_format([bold,fg(red)], 'Failed ~w: ~w -> ~w~n', [TestName,Res,ExpectedResult])
        ) ;
        ansi_format([bold,fg(red)], 'Failed ~w: no unification~n', [TestName])
    ).

wrap_test_differentiate(TestName,Equation,Variable,ExpectedResult):-
    ( differentiate(Equation,Variable,Fx,_,_),
        ( Fx = ExpectedResult  ->
            ansi_format([bold,fg(green)], 'Passed ~w~n',[TestName]);
            ansi_format([bold,fg(red)], 'Failed ~w: ~w -> ~w~n', [TestName,Fx,ExpectedResult])
        ) ;
        ansi_format([bold,fg(red)], 'Failed ~w: no unification~n', [TestName])
    ).