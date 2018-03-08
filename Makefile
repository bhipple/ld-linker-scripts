all: ab emptylinker ablinker ablinker2

clean:
	rm -rf *.o *.so liba.a libb.a a.out emptylinker ab ablinker

################################################################################
# Apps
# Standard app using libb.so and liba.a
all: libb.so liba.a
	g++ '-Wl,-rpath,$$ORIGIN' main.cpp -L. -la -lb
	./a.out

# App using libab.a
ab: libab.a
	g++ main.cpp -L. -lab -o ab
	./ab

# Doing a build with a lib on the linkline that just references an empty linker script
emptylinker: libab.a libemptylinker.a
	g++ main.cpp -L. -lab -lemptylinker -o emptylinker
	./emptylinker

# Doing a build with a linker script that forwards to a static library
ablinker: libab.a libablinker.a
	g++ main.cpp -L. -lablinker -o ablinker
	./ablinker

# Doing a build with a linker script that forwards to 2 libraries
ablinker2: liba.a libb.so
	g++ '-Wl,-rpath,$$ORIGIN' main.cpp -L. -lablinker2 -o ablinker2
	./ablinker2

################################################################################
# Real libs
liba.a: a.cpp
	g++ -fPIC -c a.cpp -o a.o
	ar rvs liba.a a.o

libb.so: b.cpp
	g++ -fPIC -c b.cpp -o b.o
	g++ -shared -Wl,-soname,libb.so -o libb.so b.o

# A libab that provides all the symbols of liba and libb
libab.a: liba.a libb.so
	ar rvs libab.a a.o b.o
