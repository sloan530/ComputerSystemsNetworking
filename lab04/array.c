//Sloan Kim g_kim22@u.pacific.edu
#include <stdio.h>   // Allows printf, ...
#include <string.h>
#include <stdlib.h>  // Allows malloc, ...
#include <errno.h>   // Allows errno
#include "array.h"

char** createArray(int rows, int cols) {
	char **myArray;
  
  // Allocate a 1xROWS array to hold pointers to more arrays
  myArray = calloc(rows, sizeof(char *));
  if (myArray == NULL) {
    printf("FATAL ERROR: out of memory: %s\n", strerror(errno));
    exit(EXIT_FAILURE);
  }
  
  // Allocate each row in that column
  for (int i = 0; i < rows; i++) {
    myArray[i] = calloc(cols, sizeof(char));
    if (myArray[i] == NULL) {
      printf("FATAL ERROR: out of memory: %s\n", strerror(errno));
      exit(EXIT_FAILURE);
    }
  }
  
  return myArray;
}


void fillArray(char** myArray, int rows, int cols) {
  
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      myArray[i][j] = '-';
    }
  }
  
  
  
  
  return;
}

void printArray(char** myArray, int rows, int cols) {
	
	printf("    ");
	for (int i=0; i<cols; i++) {
		char col = i+65;
		printf("%c ", col);
  		
	}
	printf("\n   ");
	for (int i=0; i<cols*2; i++) {
		printf("-");
	}
	printf("\n");
	for (int i = 0; i < rows; i++) {
		if(i<9){
			printf("%d  |", i+1);
		}else{
			printf("%d |", i+1);
		}
	  	
		for (int j = 0; j < cols; j++) {
      			printf("%c ", myArray[i][j]);
      			
      			
    		}
    		printf("\n");
  	}
  	printf("\n");
}

void deleteArray(char** myArray, int rows) {
  for (int i = 0; i < rows; i++) {
    free(myArray[i]);
  }
  free(myArray);
  
  return;
}


