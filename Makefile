CXX = g++
CXXFLAGS = -std=c++11 -fPIC
SOFLAGS = -shared -O3
INCLUDE = -I"./"
LIB = -L"./lib/"

ROOT_LIB := `root-config --libs --glibs`
ROOT_FLAGS := `root-config --cflags --ldflags`


DEPS = interface/CfgManager.h interface/WFClass.h interface/RecoTree.h interface/WFTree.h interface/H4Tree.h interface/HodoUtils.h
DEPS_OBJ = lib/CfgManager.o lib/WFClass.o lib/HodoUtils.o lib/H4lib.so
DICT_OBJ = lib/CfgManager.o 

lib/%.o: interface/%.cc $(DEPS)
	$(CXX) $(CXXFLAGS) -c -o $@ $< $(INCLUDE) $(ROOT_LIB) $(ROOT_FLAGS)

all: lib/LinkDef.cxx lib/H4lib.so bin/H4Reco

lib/LinkDef.cxx: interface/CfgManager.h interface/LinkDef.h 
	rootcling -f $@ -c $^

lib/H4lib.so: lib/LinkDef.cxx $(DICT_OBJ)
	$(CXX) $(CXXFLAGS) $(SOFLAGS) -o $@ $^ $(INCLUDE) $(ROOT_LIB) $(ROOT_FLAGS) $(LIB)

bin/H4Reco: src/H4Reco.cpp $(DEPS_OBJ)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(INCLUDE) $(ROOT_LIB) $(ROOT_FLAGS) $(LIB)

clean:
	rm -f tmp/*
	rm -f lib/*
	rm -f bin/*
