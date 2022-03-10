# The variable CC specifies which compiler will be used.
# (because different unix systems may use different compilers)
CC=gcc

# The variable CFLAGS specifies compiler options
#   -c :    Only compile (don't link)
# You can add additional options on this same line..
# WARNING: Never remove the -c Flag, it is essential to proper operation
CFLAGS=-c -Wall -lm -std=c99 -O3 -g

# All of the .h header files to use as dependencieis
HEADERS=

# All of the object files to produce as intermediary work 
OBJECTS=main.o

# The final program to build
EXECUTABLE=linkedlist

#--------------------------------------------------
all: $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(OBJECTS) -o $(EXECUTABLE)

%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm $(EXECUTABLE) $(OBJECTS)cd ..
