mkdir build
cd build
g++ --version
qmake-qt5 --version
qmake-qt5 ../SigLAB.pro
make -j 4
