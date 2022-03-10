# The variable CC specifies which compiler will be used.
CC=gcc

# The variable CFLAGS specifies compiler options
#      -c :  Only compile (don't link)
#   -Wall :  Enable all warnings about lazy / dangerous C programming
#-std=c99 :  C99 language standard
#      -O :  optimization for code size and execution time - level 1
#      -g :  Ensure the program includes debugging info linking specific instructions in the 	      compiled program back to the original lines in the source code - to use Valgrind
CFLAGS=-c -Wall -std=c99 -O -g 

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
	
	
