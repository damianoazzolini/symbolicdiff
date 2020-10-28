:- ['../src/differentiate'].

test:-
    test_constant,test_variable,test_power_2,test_power_3,test_power_no_var.

test_constant:-
    differentiate(1,x,Fx,_,_),
    ( Fx = 0 ->
    	ansi_format([bold,fg(green)], 'Passed constant~n',[]);
        ansi_format([bold,fg(red)], 'Failed constant: ~w -> ~w~n', [Fx,0]),
        false
    ).

test_variable:-
    differentiate(x,x,Fx,_,_),
    ( Fx = 1 ->
    	ansi_format([bold,fg(green)], 'Passed variable~n',[]);
        ansi_format([bold,fg(red)], 'Failed variable: ~w -> ~w~n', [Fx,1]),
        false
    ).

test_power_2:-
    differentiate(x^2,x,Fx,_,_),
    ( Fx = 2*x ->
    	ansi_format([bold,fg(green)], 'Passed power 2~n',[]);
        ansi_format([bold,fg(red)], 'Failed power 2: ~w -> ~w~n', [Fx,2*x]),
        false
    ).

test_power_3:-
    differentiate(x^3,x,Fx,_,_),
    ( Fx = 3*x^2 ->
    	ansi_format([bold,fg(green)], 'Passed power 3~n',[]);
        ansi_format([bold,fg(red)], 'Failed power 3: ~w -> ~w~n', [Fx,3*x^2]),
        false
    ).

test_power_no_var:-
    differentiate(x^3,y,Fx,_,_),
    ( Fx = 0 ->
    	ansi_format([bold,fg(green)], 'Passed power no var 2~n',[]);
        ansi_format([bold,fg(red)], 'Failed power no var: ~w -> ~w~n', [Fx,0]),
        false
    ).


% test_power_mul:-
%     wrap_test('power_no_var',differentiate(y*x^3,y,x^3)).

