:- [../src/differentiate].

wrap_test(Name,ToCall):-
    ( time(call(ToCall)) ->
    	ansi_format([bold,fg(green)], 'Passed ~w~n', [Name]);
        ansi_format([bold,fg(red)], 'Failed ~w~n', [Name]),
        false
    ).


test_constant:-
    wrap_test('constant',diff(1,x,0)).
test_variable:-
    wrap_test('variable',diff(x,x,1)).
test_power_2:-
    wrap_test('power_2',diff(x^2,x,2x)).
test_power_3:-
    wrap_test('power_3',diff(x^3,x,3x^2)).
test_power_no_var:-
    wrap_test('power_no_var',diff(x^3,y,0)).
test_power_mul:-
    wrap_test('power_no_var',diff(y*x^3,y,x^3)).

