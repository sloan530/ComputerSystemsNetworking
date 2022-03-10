#include <stdio.h>
#include <stdlib.h> 

struct node {
	int num;
	struct node *next;
};

struct node *head=NULL;
struct node *tail=NULL;

void create(int n);
void display();
void delete();

void create(int n){
	struct node *temp;
	head = (struct node *)malloc(sizeof(struct node));
	head->num=1;
	temp=head; //segfault
	for(int i=1; i<n; i++){
		struct node *newNode;
		newNode = (struct node *)malloc(sizeof(struct node));
		newNode->num=i+1;
		newNode->next=NULL;
		temp->next=newNode;
		temp=temp->next;
	}
	tail=temp;
	tail->next=head;
}

void display(){
	if(head==NULL) printf("Empty List");
   	else{
      		struct node *temp = head;
      		printf("The circular linked list is: \n");
      		for(;temp!=tail;temp=temp->next){
         		printf("%d -> ",temp->num);
      		}		
      	printf("%d -> %d\n", temp->num, head->num);
   	}
}

void delete(){
	tail->next=NULL;
	if(head==NULL) printf("Empty List\n");
	else{
		struct node* temp=head;
		while(head!=NULL){
			temp=head;
			head=head->next;
			//free(temp); //memory leak
		}
	}
}

int main() {
	create(10);
	display();
	//printf("%d", tail->next->next->num);
	delete();
	
}
