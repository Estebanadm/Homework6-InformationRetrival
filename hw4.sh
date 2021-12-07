#! /bin/bash

echo
echo
flex query.lex
g++ -o query lex.yy.c -lfl
./query $@
echo
echo