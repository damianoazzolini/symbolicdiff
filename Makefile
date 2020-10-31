all:
	gcc src/main.c -o symdiff

clean:
	rm symdiff

check:
	@echo "running prolog tests"
	swipl -s test/test.pl -g test -t halt