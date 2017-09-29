#!/usr/bin/env bash

# Run uncrustify on all C source files
files=`find ../ -name '*.c' -o -name '*.h'`
uncrustify -c uncrustify.cfg -l C --replace --no-backup $files

# Run emacs/list on all Fortran source files
format_fortran () {
    echo "Parsing $1 as language Fortran"
    emacs --batch -l ./emacs-fortran-formating-script.lisp \
        -f f90-batch-indent-region $1
}
export -f format_fortran
find .. -iregex ".*\.F[0-9]*" -exec bash -c 'format_fortran "$0"' {} \;

# run autopep8 over all Python source files
find .. -name '*.py' -exec autopep8 --in-place '{}' \;
