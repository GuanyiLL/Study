#include <iostream>
#include <algorithm>
using namespace std;

void outputArray(int arr[],int len) {
    while (len-- >0) {
        printf("%d ",*arr++);
    }
    printf("\n");
}

void bubble_sort(int arr[], int len) {
	for (int i = 0; i < len - 1; i++)
		for (int j = 0; j < len - 1 - i; j++)
			if (arr[j] > arr[j + 1])
				swap(arr[j], arr[j + 1]);
}

int main() {
  int a[] = {5, 9, 20, 31, 8, 89, 1, 15, 100, 2};
  cout<<"before sorting"<<endl;
  outputArray(a, 10);
  cout<<"after sorting"<<endl;
  bubble_sort(a,10);
  outputArray(a, 10);

  return 0;
}
