#include <iostream>
using namespace std;

void outputArray(int arr[],int len) {
    while (len-- >0) {
        printf("%d ",*arr++);
    }
    printf("\n");
}



int main(int argc, char*argv[]) {
    int a[] = {5, 9, 20, 31, 8, 89, 1, 15, 100, 2};
    cout<<"before sorting"<<endl;
    outputArray(a, 10);
    cout<<"after sorting"<<endl;
    outputArray(a, 10);

    return 0;
}
