int main(void)
{
    // Pointers to the 7-segment display sections
    volatile int * HEX3_HEX0 = (int *) 0x10000020;
    volatile int * HEX7_HEX4 = (int *) 0x10000030;
    int n = 3828335395; // Original integer value
            
    int N,M,O,P,n1,K,n2,A,B;
        
    // 7-segment digits (0-9)
    int Digits[10] = {0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110,
                    0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111};
    n1=~n;	// n1 is the bitwise negation of n (n = 001100 => n1 = 110011)
    n2 = (n & ~(n << 1)) | (~n & (n >> 1)); //100110

    // Count the number of consecutive set bits (set bit = 1) in the original n(ide dok ne bude nula jedinica)
    int count = 0; 
    while (n != 0) 
            { 
                n = (n & (n << 1)); // Shift n by 1 bit to the left and AND it with the original n
                count++; // Increase the counter
            } 
    // Count the number of consecutive set bits (set bit = 1) in the negated n1
    int count1 = 0; 
    while (n1 != 0) 
            {   
                n1 = (n1 & (n1 << 1)); 
                count1++; 
            } 
    // Count the number of consecutive set bits (set bit = 1) in n2
    int count2 = 0; 
    while (n2!= 0) 
            { 
                n2 = (n2 & (n2 << 1)); 
                count2++; 
            } 	

    N=count/10; // N will hold the 10's digit of "count"
    M=count%10;	// M will hold the 1's digit of "count"
    N=Digits[N]<<8; // Set N to the corresponding digit, and shift left by 8 bits to leave 8 bits space for the 1's digit
    M=Digits[M]|N; // AND corresponding 1's digit with N
    // N = 10101010 => N<<8 = 1010101000000000
    // Digits[M] = 11110000 => Digits[M] AND N = 1010101011110000
    // We basically combined the 2 digits and stored them in M
        
    // Same thing as above, just with "count1"
    O=count1/10;
    P=count1%10;	
    O=Digits[O]<<8;
    P=Digits[P]|O;
    P=P<<16; // Shift P left by 16 bits, to leave space for M
    K=M|P; // K will hold M and P combined, with the first 16 bits holding "count" digits, and the last 16 bits holding "count1" digits

    // Same thing as above
    A=count2/10; 
    B=count2%10;	
    A=Digits[A]<<8; 
    B=Digits[B]|A;

    *(HEX3_HEX0) = K; // First 4 7-segment digits display "count" and "count1"
    *(HEX7_HEX4) = B; // Last 4 7-segment digits display "count2"
}
