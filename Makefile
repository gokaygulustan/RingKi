CXX := i686-w64-mingw32-g++
WINDRES := i686-w64-mingw32-windres
CXXFLAGS := -std=c++14 -Os -Wall -Wextra -municode -mwindows -static -static-libgcc -static-libstdc++ -D_WIN32_WINNT=0x0601 -DWINVER=0x0601 -Ithird_party/minimp3
LDFLAGS := -Wl,--subsystem,windows:6.01 -lcomctl32 -lcomdlg32 -lwinmm -lshell32
OUT := build/RingKi.exe

.PHONY: all clean
all: $(OUT)

build:
	mkdir -p build

build/ringki-res.o: ringki.rc resources/ringki.ico | build
	$(WINDRES) ringki.rc -O coff -o $@

$(OUT): src/main.cpp build/ringki-res.o $(wildcard resources/*.wav)
	$(CXX) $(CXXFLAGS) src/main.cpp build/ringki-res.o -o $@ $(LDFLAGS)
	mkdir -p build/resources
	cp resources/*.wav build/resources/

clean:
	rm -rf build
