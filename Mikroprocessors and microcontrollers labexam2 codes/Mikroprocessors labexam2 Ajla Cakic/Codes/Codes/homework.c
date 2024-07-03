#include <stdio.h>


int findMax(int arr[], int size) {
    int max = arr[0];
    for (int i = 1; i < size; i++) {
        if (arr[i] > max) {
            max = arr[i];
        }
    }
    return max;
}

int findMin(int arr[], int size) {
    int min = arr[0];
    for (int i = 1; i < size; i++) {
        if (arr[i] < min) {
            min = arr[i];
        }
    }
    return min;
}

int findAvg(int arr[], int size) {
    int sum = 0;
    for (int i = 0; i < size; i++) {
        sum += arr[i];
    }
    return sum / size;
}


int main() {

    // NOTE: Only works for 2-digit numbers

    // Pointers to the 7-segment display sections
    volatile int * HEX3_HEX0 = (int *) 0x10000020;
    volatile int * HEX7_HEX4 = (int *) 0x10000030;

    int M, N, O, P, Q, R, S;

    int arr[10] = {3, 2, 3, 45, 6, 44, 1, 5, 8, 15};

    int Digits[10] = {0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110,
                    0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111};

    int maxNum = findMax(arr, 10);
    int minNum = findMin(arr, 10);
    int avgNum = findAvg(arr, 10);

    M = maxNum / 10; // M holds first number of maxNum (ex. maxNum = 52 => M = 5)
    N = maxNum % 10; // N holds second number of maxNum (ex. maxNum = 52 => N = 2)
    M = Digits[M] << 8; // Set M to the corresponding digit and shift left by 8 bits to leave space for the maxNum digits
    N = Digits[N] | M; // Combine M and N and store the result in M

    O = minNum / 10;
    P = minNum % 10;
    O = Digits[O] << 8;
    P = Digits[P] | O;
    P = P << 16; // Make space for the maxNum digits
    Q = P | N; // Combine minNum and maxNum digits

    R = avgNum / 10;
    S = avgNum % 10;
    R = Digits[R] << 8;
    S = Digits[S] | R;

    *(HEX3_HEX0) = Q; // First 4 7-segment digits display "minNum" and "maxNum"
    *(HEX7_HEX4) = S; // Last 4 7-segment digits display "avgNum"


}