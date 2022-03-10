#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>

int putToken(char player, int col);
bool checkWin(int row, int col);
bool count(int i, int j, int di, int dj);
bool valCol(int col);
void print_board();
int user_input();
uint32_t random_in_range(uint32_t low, uint32_t high);
uint32_t get_random();


char **myArray;
uint32_t m_w = 50000;
uint32_t m_z = 60000;
char winner = 'n';

int main () {
	// Allocate a 1xROWS array to hold pointers to more arrays
	myArray = calloc(6, sizeof(char *));
  
  	// Allocate each row in that column
  	for (int i = 0; i < 6; i++) {
    		myArray[i] = calloc(9, sizeof(char));
  	}
  	
  	//fill myArray
  	for (int i=0; i<6; i++){
  		for (int j=0; j<9; j++){
  			myArray[i][j]='-';
  		}
  	}
  	
  	for (int i=0; i<6; i+=2){
  		myArray[i][0]='C';
  		myArray[i][8]='C';
  		myArray[i+1][0]='H';
  		myArray[i+1][8]='H';
  	}
  
  	printf("Welcome to Connect Four, Five-in-a-Row variant!\n");
  	printf("\nEnter two positive numbers to initialize the random number generator.\n");
  	
  	printf("Number 1: ");
  	int num1;
  	char buffer1[100];
	fgets(buffer1, 99, stdin);
     	sscanf(buffer1, "%d", &num1);
  	
  	printf("Number 2: ");
  	int num2;
  	char buffer2[100];
	fgets(buffer2, 99, stdin);
     	sscanf(buffer2, "%d", &num2);
     	
     	m_w=num1;
     	m_z=num2;
     	
     	//reason the range is 0 to 2 is when I do 0 to 1, it is most likey to be 0 for some reason
     	int HorC = random_in_range(0,2);
  	printf("\nHuman player (H) or Computer player (C)\nCoin toss... ");
  	
  	if (HorC==0){
  		printf("HUMAN goes first\n");
  	}else {
  		printf("COMPUTER goes first\n");
  	}
  	
   	print_board();
   	
   	while(1){
		int i;
		int col;
		int comCol=random_in_range(1,7);

		while(!valCol(comCol)){
			comCol=random_in_range(1,7);
		}

   		if(HorC==0){
			col=user_input();
			i=putToken('H',col);
			
			if(checkWin(i,col)){break;}
		   	
		   	i=putToken('C', comCol);
			printf("Computer player selected column %d\n", comCol);

			if(checkWin(i,comCol)){break;}
		}else{ 
			i=putToken('C', comCol);
			printf("Computer player selected column %d\n", comCol);

			if(checkWin(i,comCol)){break;}

			col=user_input();
			i=putToken('H', col);

			if(checkWin(i,col)){break;}

		}
		print_board();
	}
	
	print_board();
	
	if(winner=='H'){
		printf("Congratulations, You Won!\n");
	}else if (winner == 'C'){
		printf("Booooo, You Lost!\n");
	}else{
		printf("Tie!\n");
	}
   	
   	for (int i = 0; i < 6; i++) {
    		free(myArray[i]);
  	}
  	free(myArray);
  	
   	return(0);
}

int putToken(char player, int col){
	int i;
	for(i=5; i>=0; i--){
		if(myArray[i][col]=='-'){
			myArray[i][col]=player;
			break;
		}
	}
	return i;
}

bool checkWin(int row, int col){
	char player = myArray[row][col];
	if(count(row,col, 1,0) || count(row,col, -1,-1) || count(row,col, 1,-1) ||count(row,col, 0,-1)){
		winner=player;
		return true;
	}
	return false;
}

bool count(int i, int j, int di, int dj){
	int count=0;
	int x = i+di;
	int y = j+dj;
	char player = myArray[i][j];
	
	while(x> -1 && y>-1 && x<6 && y < 9 && myArray[x][y] == player){
			count++;
			x+=di;
			y+=dj;
	}
	x= i-di;
	y= j-dj;
	while(x> -1 && y> -1 && x<6 && y< 9 && myArray[x][y] == player){
			count++;
			x-=di;
			y-=dj;
	
	}
	if (count>3){
		return true;
	}

	return false;
}

bool valCol(int col){

	//full column?
	if (myArray[0][col] != '-'){
		return false;
	}
	
	return true;
}

uint32_t random_in_range(uint32_t low, uint32_t high){

	uint32_t range = high-low+1;
	uint32_t rand_num = get_random();

	return (rand_num % range) + low;
}

uint32_t get_random(){

	uint32_t result;
	m_z = 36969 * (m_z & 65535) + (m_z >> 16);
	m_w = 18000 * (m_w & 65535) + (m_w >> 16);
	result = (m_z << 16) + m_w;  /* 32-bit result */
	//printf("%d",result);
	return result;
}

int user_input(){

	int col;
	bool valid = false;
	//problem: it does not catch input like '2dof'. it receives just 2. 
	while(valid==false){
		printf("What column would you like to drop token into? Enter 1-7: ");
		//scanf(" %d", &col);
		//while(getchar() != '\n');
		char buffer[100];
		fgets(buffer, 99, stdin);
     		sscanf(buffer, "%d", &col);
		if (col / 10 > 0) {
			printf("Wrong Input. Try Again.\n");
		}else if (col<1 || col>7){
			printf("Wrong Input. Try Again.\n");
		}else if(!valCol(col)){
			printf("Full Column. Try Again.\n");
		}else{
			valid=true;
		}
	}
	return col;	
}


void print_board(){
  	
	printf("\n     1 2 3 4 5 6 7  \n");
	printf("   -----------------\n");
	
	for (int i=0; i<6; i++){
		printf("   ");
  		for (int j=0; j<9; j++){
  			printf("%c ",myArray[i][j]);
  		}
  		printf("\n");
  	}
	printf("   -----------------\n\n");
}
