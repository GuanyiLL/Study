#include <iostream>
using namespace std;

void outputArray(int arr[],int len) {
    while (len-- >0) {
        printf("%d ",*arr++);
    }
    printf("\n");
}

void selection_sort(int arr[], int len) {
    for (int i = 0; i < len - 1; i++) {
        int min = i;
        for (int j = i + 1; j < len; j++)
            if (arr[j] < arr[min])
                min = j;
        swap(arr[i], arr[min]);
    }
}

int main(int argc, char*argv[]) {
    int a[] = {5, 9, 20, 31, 8, 89, 1, 15, 100, 2};
    cout<<"before sorting"<<endl;
    outputArray(a, 10);
    cout<<"after sorting"<<endl;
    selection_sort(a,10);
    outputArray(a, 10);

    return 0;
}
