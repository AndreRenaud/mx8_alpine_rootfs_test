BUILDROOT=../buildroot
CROSS_COMPILE=$(BUILDROOT)/output/host/bin/aarch64-none-linux-gnu-
PKG_CONFIG=$(BUILDROOT)/output/host/bin/pkg-config

CC=$(CROSS_COMPILE)gcc
CXX=$(CROSS_COMPILE)g++

default: hello_triangle simple_example

hello_triangle: hello_triangle.cpp
	$(CXX) -o $@ $< $(shell $(PKG_CONFIG) --libs sdl2) $(shell $(PKG_CONFIG) --libs glesv2)

simple_example: simple_example.c
	$(CC) -o $@ $< $(shell $(PKG_CONFIG) --libs sdl2)

clean:
	rm -f hello_triangle simple_example
