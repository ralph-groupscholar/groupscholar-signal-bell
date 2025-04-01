BIN=bin/signal-bell
SRC=src/signal_bell.s
OBJ=build/signal_bell.o

all: build

build: $(BIN)

$(BIN): $(OBJ)
	mkdir -p bin
	clang $(OBJ) -o $(BIN)

$(OBJ): $(SRC)
	mkdir -p build
	clang -c $(SRC) -o $(OBJ)

clean:
	rm -rf build bin

.PHONY: all build clean
