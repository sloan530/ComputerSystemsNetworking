# The variable CC specifies which compiler will be used.
# (because different unix systems may use different compilers)
CC=gcc

# The variable CFLAGS specifies compiler options
#   -c :    Only compile (don't link)
#   -Wall:  Enable all warnings about lazy / dangerous C programming 
#   -std=c99: use the more modern C99 standard for the C language
#   -Wextra: by viewing and fixing issues that generate warnings, you will produce better, 		     safer, C code
#  WARNING: NEVER REMOVE THE -c FLAG, it is essential to proper operation
CFLAGS=-c -Wall -std=c99 -Wextra

# All of the .h header files to use as dependencies
HEADERS=ship.h array.h

# All of the object files to produce as intermediary work
OBJECTS=main.o array.o

# The final program to build
EXECUTABLE=frigate

# --------------------------------------------

all: $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(OBJECTS) -o $(EXECUTABLE)

%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -rf *.o $(EXECUTABLE)
