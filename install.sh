#!/bin/sh
# This is the installation script for DSS compiler
# Written by Jianyi Cheng, 22/02/2020

# This is the script in case you do not have dynamatic
# If you have installed dynamatic, please change the directory in the env.tcl file

sudo apt install python-pip clang-tools
pip install cxxfilt
if ! grep -q "DSS" env.tcl; then
  echo "DSS="$PWD >> env.tcl
else
  sed -i "s|DSS=.*|DSS=$PWD|" env.tcl
fi
. env.tcl

git clone https://github.com/lana555/dynamatic.git
bash dhls_install.sh

# Installing DSS analysis pass
if ! grep -q "add_subdirectory(DSSAnalysis)" $DHLS/elastic-circuits/CMakeLists.txt; then
  echo "add_subdirectory(DSSAnalysis)" >> $DHLS/elastic-circuits/CMakeLists.txt
fi
cp -r src/DSSAnalysis $DHLS/elastic-circuits/
cp -r src/include/DSSAnalysis $DHLS/elastic-circuits/include/
if ! grep -q "\/\*DASS\*\/std::string func_name = demangle(fname.c_str());" $DHLS/elastic-circuits/MyCFGPass/MyCFGPass.cpp; then
  sed -i 's|circuitGen->sanityCheckVanilla(enode_dag);|circuitGen->sanityCheckVanilla(enode_dag);\n/*DASS*/std::string func_name = demangle(fname.c_str());\n\t\tDASS(enode_dag, bbnode_dag, (opt_cfgOutdir+\"/\"+func_name.substr(0, func_name.find(\"(\"))+\"_\").c_str());\n|' $DHLS/elastic-circuits/MyCFGPass/MyCFGPass.cpp
  sed -i 's|#include "OptimizeBitwidth/OptimizeBitwidth.h"|#include "OptimizeBitwidth/OptimizeBitwidth.h"\n#include "DSSAnalysis/DSSAnalysis.h"\n|' $DHLS/elastic-circuits/MyCFGPass/MyCFGPass.cpp
fi
cd $DHLS/elastic-circuits/_build/
make clean
make

if ! grep -q "\-load ..\/_build\/DSSAnalysis\/libDSSAnalysis.so \-load ..\/_build\/MyCFGPass\/libMyCFGPass.so" $DHLS/elastic-circuits/examples/Makefile; then
  sed -i 's|-load ../_build/MyCFGPass/libMyCFGPass.so|-load ../_build/DSSAnalysis/libDSSAnalysis.so -load ../_build/MyCFGPass/libMyCFGPass.so|g' $DHLS/elastic-circuits/examples/Makefile 
fi

echo "============= DSS Pass installed =============="
