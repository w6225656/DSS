#include "gSum.h"

int main(){
   int A[1000];
   for (int i = 0; i < 1000; i++)
        A[i] = (i%2)?i:-i;
   int s = gSum(A);
   return 0;
}
