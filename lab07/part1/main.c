#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>



int main(int argc, char *argv[])
{
	//malloc 2d array
	int row=4;
	int col=5;
	uint32_t **twoD=(uint32_t **)malloc(sizeof(uint32_t *)*row);
	for (int i=0; i<row; i++){
		twoD[i]=(uint32_t *)malloc(sizeof(uint32_t)*col);
		for (int j=0; j<col; j++){
			twoD[i][j]=i*col+j+1;
			//printf("twoD[%d][%d]: %d\n", i, j, twoD[i][j]);
		}
	}
	
	//print 2d array
	printf("two-dimensional array[%d][%d]: \n",row,col);
	for(int i=0; i<row; i++){
		printf("row %d: %d %d %d %d %d\n", i, twoD[i][0], twoD[i][1], twoD[i][2], twoD[i][3], twoD[i][4]);
	}
	printf("\n");
	
	printf("There are 4 rows and 5 columns.\nHowever, the memory is linear and C is row major which means the each row will be stored in order.\n\n");
	
	//store 2d array address in memory
	uint32_t **memory=(uint32_t **)malloc(sizeof(uint32_t *)*row*col);
	for(int i=0; i<row; i++){
		for (int j=0; j<col; j++){
			memory[i*col+j]=&twoD[i][j];
		}
	}

	//print memory
	for (int i=0; i<row*col; i++){
		printf("Memory[%d]: %p is the address of twoD array element %d\n",i, memory[i], *memory[i]);
		if((1+i)%5==0){
			printf("row %d has been stored\n",i/5);
		}
	}
	
	//free 2d array
	for(int i=0; i<row; i++){
		free(twoD[i]);
	}
	free(twoD);
	
	//free memory
	free(memory);
	
	//malloc 3d array
	int twoDs=2;
	uint32_t ***threeD=(uint32_t ***)malloc(sizeof(uint32_t **)*twoDs);
	for (int i=0; i<twoDs; i++){
		threeD[i]=(uint32_t **)malloc(sizeof(uint32_t *)*row);
		for (int j=0; j<row; j++){
			threeD[i][j]=(uint32_t *)malloc(sizeof(uint32_t)*col);
			for (int k=0; k<col; k++){
				threeD[i][j][k]=i*row*col+j*col+k+1;
				//printf("threeD[%d][%d][%d]: %d\n", i, j, k, threeD[i][j][k]);
			}
		}
	}
	
	//print 3d array
	printf("\nthree-dimensional array[%d][%d][%d]: \n", twoDs, row, col);
	for(int i=0; i<twoDs; i++){
		printf("Array %d: \n",i);
		for (int j=0; j<row; j++){
			printf("row %d: %d %d %d %d %d\n", j, threeD[i][j][0], threeD[i][j][1], threeD[i][j][2], threeD[i][j][3], threeD[i][j][4]);
		}
		printf("\n");
	}
	
	//store 3d array address in memory
	uint32_t **memory1=(uint32_t **)malloc(sizeof(uint32_t *)*twoDs*row*col);
	for(int i=0; i<twoDs; i++){
		for (int j=0; j<row; j++){
			for (int k=0; k<col; k++){
				memory1[i*row*col+j*col+k]=&threeD[i][j][k];
				//printf("Memory[%d]: %p\n", i*row*col+j*col+k,memory1[i*row*col+j*col+k]);
			}
		}
	}
	
	printf("There are 2 two-dimensional arrays of 4 rows and 5 columns.\nHowever, the memory is linear so two-dimensional arrays will be stored in order and each row of two-dimensional array in order.\n\n");
	
	//print memory
	for (int i=0; i<twoDs*row*col; i++){
		printf("Memory[%d]: %p is the address of threeD array element %d\n",i, memory1[i], *memory1[i]);
		if((i+1)%5==0 && i<20){
			printf("Array %d row %d has been stored\n", i/20, i/5);
		}
		if((i+1)%5==0 && i>=20){
			printf("Array %d row %d has been stored\n", i/20, i/5-4);
		}
	}
	
	//free 3d array
	for(int i=0; i<twoDs; i++){
		for(int j=0; j<row; j++){
			free(threeD[i][j]);
		}
		free(threeD[i]);
	}
	free(threeD);
	
	//free memory
	free(memory1);
	
	
}





