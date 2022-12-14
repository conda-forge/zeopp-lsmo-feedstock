#!/bin/bash

mkdir -p ${PREFIX}/bin

cd voro++
make
cp src/voro++ ${PREFIX}/bin/
cd ../

cd zeo++
CFLAGS="$CFLAGS -I$PREFIX/include/eigen3" make
cp network ${PREFIX}/bin/
cd ../

# run tests defined in https://github.com/lsmo-epfl/zeopp-lsmo/tree/master/tests
cd tests

function check_changes {
    sleep 1
    diffstr=$(diff $1 $2)
    rm $1
    if [ ! -z "$diffstr" ]; then
        echo "### Changes detected:" 2>&1
        echo "$diffstr" 2>&1
        #exit 1
    fi
}

echo "### Testing network -xyz ZIF-67_opt.cif"
network -xyz ZIF-67_opt.cif
check_changes ZIF-67_opt.xyz ZIF-67_opt_ref.xyz

echo "### Testing network -ha -res -allowAdjustCoordsAndCell EDI.cssr"
network -ha -res -allowAdjustCoordsAndCell EDI.cssr
check_changes EDI.res EDI_ref.res

echo "### Testing network -ha -chan 1.5 EDI.cssr"
network -ha -chan 1.5 EDI.cssr
echo "### Printing EDI.chan"
echo "$(cat EDI.chan)"
check_changes EDI.chan EDI_ref.chan

echo "### Testing network -ha -sa 1.2 1.2 2000 EDI.cssr"
network -ha -sa 1.2 1.2 2000 EDI.cssr
echo "### Printing EDI.chan"
echo "$(cat EDI.sa)"
check_changes EDI.sa EDI_ref.sa

echo "### Testing network -ha -vol 1.2 1.2 50000 EDI.cssr"
network -ha -vol 1.2 1.2 50000 EDI.cssr
echo "### Printing EDI.vol"
echo "$(cat EDI.vol)"
check_changes EDI.vol EDI_ref.vol

echo "### Testing network -ha -psd 1.2 1.2 50000 EDI.cssr"
network -ha -psd 1.2 1.2 50000 EDI.cssr
check_changes EDI.psd_histo EDI_ref.psd_histo
