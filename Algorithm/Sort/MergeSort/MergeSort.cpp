#include <iostream>
using namespace std;

void outputArray(int arr[],int len) {
    while (len-- >0) {
        printf("%d ",*arr++);
    }
    printf("\n");
}

void merge_sort_recursive(int arr[], int reg[], int start, int end) {
    if (start >= end)
        return;
    int len = end - start, mid = (len >> 1) + start;
	  int start1 = start, end1 = mid;
	  int start2 = mid + 1, end2 = end;
	  merge_sort_recursive(arr, reg, start1, end1);
	  merge_sort_recursive(arr, reg, start2, end2);
	  int k = start;
	  while (start1 <= end1 && start2 <= end2)
		    reg[k++] = arr[start1] < arr[start2] ? arr[start1++] : arr[start2++];
	  while (start1 <= end1)
		    reg[k++] = arr[start1++];
	  while (start2 <= end2)
		    reg[k++] = arr[start2++];
	  for (k = start; k <= end; k++)
		    arr[k] = reg[k];
}

void merge_sort(int arr[], int len) {
    int* a = arr;
	  int* b = new int[len];
	  for (int seg = 1; seg < len; seg += seg) {
		    for (int start = 0; start < len; start += seg + seg) {
			      int low = start, mid = min(start + seg, len), high = min(start + seg + seg, len);
			      int k = low;
			      int start1 = low, end1 = mid;
			      int start2 = mid, end2 = high;
			      while (start1 < end1 && start2 < end2)
				    b[k++] = a[start1] < a[start2] ? a[start1++] : a[start2++];
			      while (start1 < end1)
				        b[k++] = a[start1++];
			      while (start2 < end2)
				        b[k++] = a[start2++];
        }
		    int* temp = a;
		    a = b;
		    b = temp;
    }
	  if (a != arr) {
		    for (int i = 0; i < len; i++)
			      b[i] = a[i];
		    b = a;
	  }
	  delete[] b;
}

int main(int argc, char*argv[]) {
    int a[] = {5, 9, 20, 31, 8, 89, 1, 15, 100, 2};
    cout<<"before sorting"<<endl;
    outputArray(a, 10);
    cout<<"after sorting"<<endl;
    merge_sort(a,10);
    outputArray(a, 10);

    return 0;
}
