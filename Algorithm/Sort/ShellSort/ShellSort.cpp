#include <iostream>
using namespace std;
template <typename T>

void shell_sort(T arr[], int len) {
    int gap, i, j;
    T temp;
    for (gap = len >> 1; gap > 0; gap >>= 1)
	for (i = gap; i < len; i++) {
		temp = arr[i];
		for (j = i - gap; j >= 0 && arr[j] > temp; j -= gap)
			arr[j + gap] = arr[j];
		arr[j + gap] = temp;
	}
}


void outputArray(int arr[], int len) {
    while (len-- > 0) {
        printf("%d",*arr++);
    }
    printf("\n");
}

int main() {

    int arr[] = {22, 9, 87, 38, 49, 1, 55, 98, 76, 97};
    int *p = arr;
  
    cout<<"before sorting"<<endl;
    outputArray(p, 10);  
    cout<<"after sorting"<<endl;
    shell_sort(p,10);
    outputArray(p, 10);
    return 0;
}

