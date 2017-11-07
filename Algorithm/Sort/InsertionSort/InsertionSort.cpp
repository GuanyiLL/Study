#include <iostream>
using namespace std;

void outputArray(int arr[],int len) {
    while (len-- >0) {
        printf("%d ",*arr++);
    }
    printf("\n");
}

void insetion_sort(int arr[], int len) {
    for (int i = 1, j= 0; i < len; ++i) {
        int temp = arr[i];
        for (j = i - 1; j >= 0 && arr[j] > temp; --j) {
            arr[j + 1] = arr[j];
        }
        arr[j + 1] = temp;
    }
}

int main(int argc, char*argv[]) {
    int a[] = {5, 9, 20, 31, 8, 89, 1, 15, 100, 2};
    cout<<"before sorting"<<endl;
    outputArray(a, 10);
    cout<<"after sorting"<<endl;
    insetion_sort(a,10);
    outputArray(a, 10);

    return 0;
}
