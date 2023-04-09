#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(){
	
	int x1,x2,x3,x4,x5;
	
	x1 = 5;//rand() % 10;
	x2 = 7;//rand() % 10;
	x3 = 1;//rand() % 10;
	x4 = 3;//rand() % 10;
	x5 = 4;//rand() % 10;
	
	for (int i=0; i<10; i++){ // pipeline test (test 1)
		x1 = x1 + x2;
		x2 = x2 + x3;
		x3 = x3 + x4;
		x4 = x4 + x5;
		x5 = x5 + x1;
	}
	
	x1 = 4;//rand() % 10;
	x2 = 3;//rand() % 10;
	x3 = 1;//rand() % 10;
	x4 = 7;//rand() % 10;
	x5 = 5;//rand() % 10;
	
	for (int i=0; i<10; i++){ // RAW test (test 3)
		x1 = x1 + x5;
		x2 = x2 + x1;
		x3 = x3 + x2;
		x4 = x4 + x3;
		x5 = x5 + x4;
	}
	
	return 0;
}