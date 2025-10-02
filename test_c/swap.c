#include <stdio.h>

void swap (int *a, int *b);

int main () {
    int arr[6] = {4, 1, 0, 2, 3};   // 5 -> 6
    int size = 5;
    for (int i = 0; i < size-1; i++) {
        for (int j = 0; j < size-i-1; j++) {
            if (arr[j] > arr[j+1])
                swap(&arr[j], &arr[j+1]);
        }
    }
    return 0;
}

void swap (int *a, int *b) {
    int temp;
    temp = *a;
    *a = *b;
    *b = temp;
}