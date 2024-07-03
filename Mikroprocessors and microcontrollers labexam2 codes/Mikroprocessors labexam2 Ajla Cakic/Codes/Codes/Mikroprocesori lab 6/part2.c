#include <stdio.h>
	int main()
{
	volatile int * RED_LED_ptr = (int *) 0x10000000;
	
	int i, n;
	int arr[8] = {1, 74, 3, 11, 7, 66, 7, 9};
	n = sizeof(arr)/sizeof(arr[0]);
	
	for(i = 1; i<n; i++)
	{
		if(arr[0] < arr[i])
			arr[0] = arr[i];
	}
	*(RED_LED_ptr) = arr[0];
	printf("The largest element is: %d \n", arr[0]);
	return 0;
}