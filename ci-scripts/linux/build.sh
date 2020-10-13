mkdir build
cd build
g++ --version
qmake --version
$QTDIR/bin/qmake ../SigLAB.pro
make -j 4
