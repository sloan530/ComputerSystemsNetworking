//Sloan Kim g_kim22@u.pacific.edu
#include <stdio.h>
#include <string.h>
#include "ship.h"
#include "array.h"
#include <stdlib.h> 
#include <errno.h>   
#include <stdbool.h>
#include <ctype.h>


int playgame(char** grid, char** ships, int size, int *shells);
int game(int wins, int games, int demo, struct ship* shipArr);

int main(int argc, char *argv[]) {
	struct ship* shipArr;
	shipArr = calloc(4, sizeof(struct ship));
	if (argc == 2) {
		FILE *file;
		char buf[1000];
		file = fopen(argv[1], "r");
		struct ship* shipArr;
		shipArr = calloc(4, sizeof(struct ship));
		int i=0;
		while (fgets(buf, 1000, file)!=NULL){
			if(strncmp("#",buf,1)!=0) {
				shipArr[i].type = buf[0];
				shipArr[i].rowcol = buf[2];
				shipArr[i].headCol = buf[4];
				shipArr[i].headRow = buf[5]-'0'-1;
				i=i+1;
			}
		}
		game(0,0,1,shipArr);
		free(shipArr);
		fclose(file);
	}
	else return game(0,0,0,shipArr);
}
	

int game(int wins, int games, int demo, struct ship* shipArr) {
 	int size = 5;
 	int shells = 12;
 	
 	char** grid;
 	char** ships;
 	
  	//create the grid
  	printf("\nWelcome to Frigate!\n\n");
  	LOOP1:printf("How large should I make the grid? ");
  	char sizeInput[10];
  	scanf("%s", sizeInput);
  	
  	for(long unsigned int i=0; i<strlen(sizeInput); i++) {
  		if(!isdigit(sizeInput[i])) {
  			printf("Wrong format of size. Try again.\n\n");
  			goto LOOP1;
  		}
  	}
  	
  	if(strlen(sizeInput)==1){
  		size=sizeInput[0]-'0';
  	}
  	
  	if(strlen(sizeInput)==2){
  		size=(sizeInput[0]-'0')*10+(sizeInput[1]-'0');
  	}
  	
  	if(strlen(sizeInput)>2){
  		printf("The maximum grid size is 20... I'll create one that size.\n\n");
  		size = 20;
  	}
  	
  	printf("\n");
  	
  	if (size<5){
  		printf("The minimum grid size is 5... I'll create one that size.\n\n");
  		size = 5;
  	}
  	
  	if (size>20) {
  		printf("The maximum grid size is 20... I'll create one that size.\n\n");
  		size = 20;
  	}

  	shells = size*size/2;
 	grid = createArray(size, size);
 	ships = createArray(size, size);
 	fillArray(grid,size,size);
 	fillArray(ships, size, size);

 	int cheadCol;
 	int bheadCol;
 	int f1headCol;
 	int f2headCol;
 	
 	//making ships
 	//if there is a demo file
 	if (demo==1){
 		shipArr[0].size=5;
 		cheadCol=shipArr[0].headCol-'0'-49;
 		if(shipArr[0].rowcol=='c'){
	 		for(int i=cheadCol; i<cheadCol+shipArr[0].size; i++) {
		 		ships[shipArr[0].headRow][i] = 'c';
		 		
		 	}
 		}else {
		 	for(int i=shipArr[0].headRow; i<shipArr[0].headRow+shipArr[0].size; i++) {
 				ships[i][cheadCol] = 'c';
 			}
 		}
 		
 		shipArr[1].size=4;
 		bheadCol=shipArr[1].headCol-'0'-49;
 		if(shipArr[1].rowcol=='c'){
 			for(int i=bheadCol; i<bheadCol+shipArr[1].size; i++){
	 			ships[shipArr[1].headRow][i]='b';
	 		}
 		}else{
	 		for(int i=shipArr[1].headRow; i<shipArr[1].headRow+shipArr[1].size; i++){
	 			ships[i][bheadCol]='b';
	 		}
 		}
 		
 		shipArr[2].size=2;
 		f1headCol=shipArr[2].headCol-'0'-49;
 		if(shipArr[2].rowcol=='c'){
 			for(int i=f1headCol; i<f1headCol+shipArr[2].size; i++){
	 			ships[shipArr[2].headRow][i] = 'f';
	 		}
 		}else{
	 		for(int i=shipArr[2].headRow; i<shipArr[2].headRow+shipArr[2].size; i++){
	 			ships[i][f1headCol] = 'f';
	 		}
 		}
 		
 		shipArr[3].size=2;
 		f2headCol=shipArr[3].headCol-'0'-49;
 		if(shipArr[3].rowcol=='c'){
 			for(int i=f1headCol; i<f1headCol+shipArr[3].size; i++){
	 			ships[shipArr[3].headRow][i] = 'f';
	 		}
 		}else{
	 		for(int i=shipArr[3].headRow; i<shipArr[3].headRow+shipArr[3].size; i++){
	 			ships[i][f2headCol] = 'f';
	 		}
 		}
 	}
 	
 	//if there is no demo file - user input
 	if (demo==0){
	 	shipArr[0].type = 'c';
	 	shipArr[0].rowcol = 'c';
	 	shipArr[0].size = 5;
	 	shipArr[0].headRow = rand() % size;
	 	cheadCol = rand() % (size-shipArr[0].size+1);
	 	shipArr[0].headCol = cheadCol + 65;
	 	for(int i=cheadCol; i<cheadCol+shipArr[0].size; i++){
	 		ships[shipArr[0].headRow][i] = 'c';
	 	}

	 	shipArr[1].type = 'b';
	 	shipArr[1].rowcol = 'c';
	 	shipArr[1].size = 4;
	 	shipArr[1].headRow = rand() % size;
	 	bheadCol = rand() % (size-shipArr[1].size+1);
	 	shipArr[1].headCol = bheadCol + 65;
	 	
	 	//generate the random coordination until it finds the empty place
	 	int b=0;
	 	while(b<4){
		 	for(int i=bheadCol; i<bheadCol+shipArr[1].size; i++){
		 		if(ships[shipArr[1].headRow][i]=='-'){
		 			b++;
		 		}
		 		else {
		 			b=0;
		 			shipArr[1].headRow = rand() % size;
	 				bheadCol = rand() % (size-shipArr[1].size+1);
	 				break;
		 		}
		 	}
	 	}

	 	//if found empty place, place the ship
	 	if(b==4){
	 		for(int i=bheadCol; i<bheadCol+shipArr[1].size; i++){
	 			ships[shipArr[1].headRow][i]='b';
	 		}
	 	}else {
	 		printf("b didn't work\n");
	 	}
	 	shipArr[1].headCol = bheadCol + 65;
	 	
	 	 	
	 	shipArr[2].type = 'f';
	 	shipArr[2].rowcol = 'r';
	 	shipArr[2].size = 2;
	 	shipArr[2].headRow = rand() % (size-shipArr[2].size+1); 
		f1headCol = rand() % size;
	 	int f1=0;
	 	
	 	while(f1<2){
		 	for(int i=shipArr[2].headRow; i<shipArr[2].headRow+shipArr[2].size; i++){
		 		if(ships[i][f1headCol]=='-'){
		 			f1++;
		 		}else {
		 			f1=0;
		 			f1headCol = rand() % size;
		 			shipArr[2].headRow = rand() % (size-shipArr[2].size+1);
		 			break;
		 		}
		 	}
	 	}
	 	
	 	if(f1==2){
	 		 for(int i=shipArr[2].headRow; i<(shipArr[2].headRow+shipArr[2].size); i++){
	 			ships[i][f1headCol] = 'f';
	 		}
	 	}else {
	 		printf("f1 didn't work\n");
	 	}
	 	
	 	shipArr[2].headCol = f1headCol + 65;
	 	
	 	shipArr[3].type = 'f';
	 	shipArr[3].rowcol = 'r';
	 	shipArr[3].size = 2;
	 	shipArr[3].headRow = rand() % (size-shipArr[3].size+1); 
		f2headCol = rand() % size;
	 	int f2=0;
	 	
	 	while(f2<2){
		 	for(int i=shipArr[3].headRow; i<shipArr[3].headRow+shipArr[3].size; i++){
		 	 	if(ships[i][f2headCol]=='-'){
					f2++;
		 		}else{
		 			f2=0;
		 			f2headCol= rand() % size;
		 			shipArr[3].headRow = rand() % (size-shipArr[3].size+1);
		 			break;
		 		}
		 	}
	 	}
	 	
	 	if(f2==2){
	 	 	for(int i=shipArr[3].headRow; i<shipArr[3].headRow+shipArr[3].size; i++){
	 			ships[i][f2headCol] = 'f';
	 		}
	 	}else {
	 		printf("f2 didn't work\n");
	 	}
	 	
	 	shipArr[3].headCol = f2headCol + 65;
 	}
 	
 	
 	//print the first empty grid
 	printArray(grid, size, size);
 		
 	int sunkenShip=0;
 	int hit=0;
 	//get the coordination from user to bomb-play the game
 	
 	while(shells>0){
 		playgame(grid, ships, size, &shells);
 		//count how many ships are sunk
 		sunkenShip=0;
 		hit=0;
 		
 		if(shipArr[0].rowcol=='c'){
 			for(int i=cheadCol; i<cheadCol+shipArr[0].size; i++){
				if(grid[shipArr[0].headRow][i] == 'h'){
		 			hit++;
		 		}
	 		}
 		}else{
 			for(int i=shipArr[0].headRow; i<shipArr[0].headRow+shipArr[0].size; i++) {
 				if(grid[i][cheadCol]=='h'){
 					hit++;
 				}
 			}
 		}
		
		if (hit>=4) {
			sunkenShip++;
	 	}
	 
	 	hit=0;
	 	if(shipArr[1].rowcol=='c'){
	 		for(int i=bheadCol; i<bheadCol+shipArr[1].size; i++){
			 	if(grid[shipArr[1].headRow][i]=='h'){
			 		hit++;	
			 	}
			}
	 	}else{
	 		for(int i=shipArr[1].headRow; i<shipArr[1].headRow+shipArr[1].size; i++){
	 			if(grid[i][bheadCol]=='h'){
	 				hit++;
	 			}
	 		}
	 	}
	 	
		if (hit>=3) {
			sunkenShip++;
		}
		
		hit=0;
		
		if(shipArr[2].rowcol=='c'){
			for(int i=f1headCol; i<(f1headCol+shipArr[2].size); i++){
	 			if(grid[shipArr[2].headRow][i] =='h'){
	 				hit++;
	 			}
	 		}
		}else{
			for(int i=shipArr[2].headRow; i<shipArr[2].headRow+shipArr[2].size; i++){
			 	if(grid[i][f1headCol]=='h'){
			 		hit++;
			 	}
			}
		}
		
		if (hit==2) {
			sunkenShip++;
		}
		
		hit=0;
		
		if(shipArr[3].rowcol=='c'){
			for(int i=f1headCol; i<(f1headCol+shipArr[3].size); i++){
	 			if(grid[shipArr[3].headRow][i] =='h'){
	 				hit++;
	 			}
	 		}
		}else{
			for(int i=shipArr[3].headRow; i<shipArr[3].headRow+shipArr[3].size; i++){
			 	if(grid[i][f1headCol]=='h'){
			 		hit++;
			 	}
			}
		}
		
		if (hit==2) {
			sunkenShip++;
 		}
 		
 		if (sunkenShip==4) break;
		
 	}
 	printf("You sunk %d ships.\n\n", sunkenShip); 	
	
	//count how many games you won
	if (sunkenShip==4) {
		wins++;
	}
	
 	games++;
 	printf("You have won %d of %d games\n", wins, games);
 	
 	deleteArray(grid, size);
 	deleteArray(ships,size);
 	
 	//ask if I want to play again
 	char playAgain;
 	printf("\nPlay again (y/N)? ");
 	scanf(" %c", &playAgain);
 	
 	if(playAgain=='Y'||playAgain=='y'){
 		//go to start
 		game( wins, games, 0, shipArr);
 		return 1;	
 	}else{
 		printf("\nThanks for playing!\n");
 	}

	return 0;
}


int playgame(char** grid, char** ships, int size, int* shells) {
	if(*shells==0){
		printf("You do not have enough shells left to sink the remaining ships.\nHere is the original ship locations.\n\n");
		printArray(ships, size, size);
		return-1;
	}
	
	LOOP:printf("\nEnter the coordinate for your shot (%d shots remaining): ", *shells);
 	char col;
 	int row;
 	//receive the input char column and int row
 	char coorInput[10];
 	scanf("%s", coorInput); 
	
	//check if the format of input is correct
	if(strlen(coorInput)<2){
		printf("Wrong coordination. Try again.\n");
 		goto LOOP;
	}
	
	if(strlen(coorInput)==2){
		if(isalpha(coorInput[0])&&isdigit(coorInput[1])){
			col=coorInput[0];
			row=coorInput[1]-'0';
		}else if(isalpha(coorInput[1])&&isdigit(coorInput[0])){
			col=coorInput[1];
			row=coorInput[0]-'0';
		}else {
			printf("Wrong coordination. Try again.\n");
 			goto LOOP;
		}
	}
	
	if(strlen(coorInput)==3){
		if(isalpha(coorInput[0])&&isdigit(coorInput[1])&&isdigit(coorInput[2])){
			col=coorInput[0];
			row=(coorInput[1]-'0')*10+(coorInput[2]-'0');
		}else if(isalpha(coorInput[2])&&isdigit(coorInput[0])&&isdigit(coorInput[1])){
			col=coorInput[2];
			row=(coorInput[0]-'0')*10+(coorInput[1]-'0');
		}else {
			printf("Wrong coordination. Try again.\n");
 			goto LOOP;
		}
	}
	
	if(strlen(coorInput)>3){
		printf("Wrong coordination. Try again.\n");
 		goto LOOP;
	}
 	
 	int actCol;
 	int actRow = row-1;
 	
 	//translate the char column to the integer corresponding to the char column
 	if (col >= 'A' && col <= 'Z'){
  		actCol = col - 'A';
	}else if (col >= 'a' && col <= 'z'){
  		actCol = col - 'a';
  	}
 	
 	//check if actCol and row is in the bound
 	if(actCol>=size || actCol<0 || actRow>=size || actRow<0){
 		printf("Wrong coordination. Try again.\n");
 		goto LOOP;//so freakin cool! go back to line 252!
 		
 	}
 	
 	//check if the coordination is already bombed
 	if(grid[actRow][actCol]!='-'){
 		printf("You already bombed at this coordination. Try again.\n");
 		goto LOOP;
 	}
 	
 	//mark the shot on the grid
 	if(ships[actRow][actCol]!='-'){
 		grid[actRow][actCol] = 'h';
 		printf("\n%c%d was a hit!\n\n",col, row);
 		*shells=*shells-1;
 	}else{
 		grid[actRow][actCol] = 'm';
 		printf("\n%c%d was a miss\n\n",col, row);
 		*shells=*shells-1;
 	}
 	
 	printArray(grid,size,size);
 	
 	return *shells;
}
