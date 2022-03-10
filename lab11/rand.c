#include <stdio.h>
#include<stdint.h>

uint32_t random_in_range(uint32_t low, uint32_t high);
uint32_t get_random();


uint32_t m_w = 50000;
uint32_t m_z = 60000;

int main(){
	int a;
	for(int i=0; i<20; i++){
		a = random_in_range(0,1);
		printf("%d", a);
	}
	
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
	return result;
}
