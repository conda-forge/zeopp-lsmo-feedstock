#!/bin/bash

mkdir -p ${PREFIX}/bin

cd zeo++
CFLAGS="$CFLAGS -I$PREFIX/include/eigen3" make
cp network ${PREFIX}/bin/
cd ../

# run tests defined in https://github.com/lsmo-epfl/zeopp-lsmo/tree/master/tests
cd tests && bash run_tests.sh
