:- ['../src/differentiate'].

test:- test_differentiate, test_evaluate.

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
    wrap_test_differentiate(absolute_4,abs(sin(x^2)),x,cos(x^2)*2*x*sin(x^2)/abs(sin(x^2))),
    wrap_test_differentiate(logarithm,ln(x),x,1/x),
    wrap_test_differentiate(logarithm_abs,ln(abs(x)),x,1/x),
    wrap_test_differentiate(tan,tan(x),x,1+tan(x)^2),
    wrap_test_differentiate(cot,cot(x),x,-(1+cot(x)^2)),
    wrap_test_differentiate(exponential_n,2^x,x,(2^x)*ln(2)),
    wrap_test_differentiate(exponential_e,e^x,x,e^x),
    wrap_test_differentiate(composite_exp_num,3^sin(x),x,(3^sin(x))*ln(3)*cos(x)),
    wrap_test_differentiate(composite_exp_e,e^sin(x),x,(e^sin(x))*cos(x)),
    wrap_test_differentiate(composite_sin_3,sin(x)^3,x,3*(sin(x)^2)*cos(x)).
    % exponential composite
    % reciprocal function
    % composite function (last one)

test_evaluate:- true.

wrap_test_differentiate(TestName,Equation,Variable,ExpectedResult):-
    ( differentiate(Equation,Variable,Fx,_,_),
        ( Fx = ExpectedResult  ->
            ansi_format([bold,fg(green)], 'Passed ~w~n',[TestName]);
            ansi_format([bold,fg(red)], 'Failed ~w: ~w -> ~w~n', [TestName,Fx,ExpectedResult])
        ) ;
        ansi_format([bold,fg(red)], 'Failed ~w: no unification~n', [TestName])
    ).