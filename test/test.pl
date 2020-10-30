:- ['../src/differentiate'].

test:-
    test_constant,test_variable,test_power_2,test_power_3,test_power_no_var,
    test_absolute_1,test_absolute_2,test_absolute_3,test_absolute_4.

test_constant:-
    differentiate(1,x,Fx,_,_),
    ( Fx = 0 ->
    	ansi_format([bold,fg(green)], 'Passed constant~n',[]);
        ansi_format([bold,fg(red)], 'Failed constant: ~w -> ~w~n', [Fx,0])
    ).

test_variable:-
    differentiate(x,x,Fx,_,_),
    ( Fx = 1 ->
    	ansi_format([bold,fg(green)], 'Passed variable~n',[]);
        ansi_format([bold,fg(red)], 'Failed variable: ~w -> ~w~n', [Fx,1])
    ).

test_power_2:-
    differentiate(x^2,x,Fx,_,_),
    ( Fx = 2*x^1 ->
    	ansi_format([bold,fg(green)], 'Passed power 2~n',[]);
        ansi_format([bold,fg(red)], 'Failed power 2: ~w -> ~w~n', [Fx,2*x])
    ).

test_power_3:-
    differentiate(x^3,x,Fx,_,_),
    ( Fx = 3*x^2 ->
    	ansi_format([bold,fg(green)], 'Passed power 3~n',[]);
        ansi_format([bold,fg(red)], 'Failed power 3: ~w -> ~w~n', [Fx,3*x^2])
    ).

test_power_no_var:-
    differentiate(x^3,y,Fx,_,_),
    ( Fx = 0 ->
    	ansi_format([bold,fg(green)], 'Passed power no var 2~n',[]);
        ansi_format([bold,fg(red)], 'Failed power no var: ~w -> ~w~n', [Fx,0])
    ).

test_absolute_1:-
    differentiate(abs(x),x,Fx,_,_),
    ( Fx = abs(X)/X ->
    	ansi_format([bold,fg(green)], 'Passed absolute 1~n',[]);
        ansi_format([bold,fg(red)], 'Failed absolute 1: ~w -> ~w~n', [Fx,abs(X)/X])
    ).

test_absolute_2:-
    differentiate(abs(x),y,Fx,_,_),
    ( Fx = 0 ->
    	ansi_format([bold,fg(green)], 'Passed absolute 2~n',[]);
        ansi_format([bold,fg(red)], 'Failed absolute 2: ~w -> ~w~n', [0])
    ).

test_absolute_3:-
    ( differentiate(abs(sin(x)),x,Fx,_,_) ->
        ( Fx = sin(x)*cos(x)/abs(sin(x)) ->
            ansi_format([bold,fg(green)], 'Passed absolute 3~n',[]);
            ansi_format([bold,fg(red)], 'Failed absolute 3: ~w -> ~w~n', [Fx,sin(x)*cos(x)/abs(sin(x))])
        ) ;
        ansi_format([bold,fg(red)], 'Failed absolute 3: no unification~n', [])
    ).

test_absolute_4:-
    ( differentiate(abs(sin(x^2)),x,Fx,_,_),
        ( Fx = cos(x^2)*2*x*sin(x^2)/abs(sin(x^2) ) ->
            ansi_format([bold,fg(green)], 'Passed absolute 4~n',[]);
            ansi_format([bold,fg(red)], 'Failed absolute 4: ~w -> ~w~n', [Fx,cos(x^2)*2*x*sin(x^2)/abs(sin(x^2))])
        ) ;
        ansi_format([bold,fg(red)], 'Failed absolute 4: no unification~n', [])
    ).

% test_power_mul:-
%     wrap_test('power_no_var',differentiate(y*x^3,y,x^3)).

