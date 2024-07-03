#include <stdio.h>
int main()
{
	int i, n;
	int arr[8] = {3, 2, 3, 45, 6, 44, 1, 5};
	n = sizeof(arr)/sizeof(arr[0]);
	
	for (i=1; i<n; i++)
	{
		if(arr[0] < arr[i])
			arr[0] = arr[i];
	}
	printf("The largest element is: %d \n", arr[0]);
	return 0;
}