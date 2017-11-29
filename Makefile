.PHONY: run-test

example: aip.s example.c
	gcc $^ -o $@

test: aip.s aip_test.c
	gcc $^ -lcheck -o $@

run-test: test
	./$^
