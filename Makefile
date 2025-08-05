SRC = \
src/CoordCube.java \
src/CubieCube.java \
src/Search.java \
src/Util.java \
src/Tools.java

MAINPROG = example/MainProgram.java

TESTSRC = test/test.java

DEMO = example/demo.java

ifndef probe
	probe = 0
endif

ifndef maxl 
	maxl = 30
endif

ifndef ntest
	ntest = 1000
endif

DIST = dist/twophase.jar

DISTTEST = dist/test.class

.PHONY: build clean run testRnd testRndMP testRndStd testSel demo

build: $(DIST)

$(DIST): $(SRC) $(MAINPROG)
	@if not exist dist/ mkdir dist
	@javac -d dist -cp . $(SRC) $(MAINPROG) -Xlint:all
	@cd dist && jar cfe twophase.jar ui.MainProgram ui/* cs/*

run: $(DIST)
	@java -jar $(DIST)

testRnd: $(DISTTEST)
	@java -ea -cp dist;$(DIST) test 40 $(ntest) $(maxl) 10000000 $(probe) 0

testRndMP: $(DISTTEST)
	@java -ea -cp dist;$(DIST) test 72 $(ntest) $(maxl) 10000000 $(probe) 0

testRndStd: $(DISTTEST)
	@java -ea -cp dist;$(DIST) test 40 $(ntest) 30 10000000 $(probe) 0 | grep AvgT
	@java -ea -cp dist;$(DIST) test 40 $(ntest) 21 10000000 $(probe) 0 | grep AvgT
	@java -ea -cp dist;$(DIST) test 40 $(ntest) 20 10000000 $(probe) 0 | grep AvgT

testSel: $(DISTTEST)
	@java -ea -cp dist;$(DIST) test 24

demo: $(DIST)
	@javac -d dist -cp dist;$(DIST) example/demo.java
	@java -ea -cp dist;$(DIST) demo

$(DISTTEST): $(DIST) $(TESTSRC)
	@javac -d dist -cp dist;$(DIST) $(TESTSRC)

rebuild: clean build

clean:
	@rm -rf dist/
	@if exist m2pT.data rm -f m2pT.data
	