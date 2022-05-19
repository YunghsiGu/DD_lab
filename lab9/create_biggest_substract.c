// 找出兩質數相減的最大差
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    FILE *f = fopen("biggest_prime_substraction.txt", "w");
    // perror("open file");

    int temp = 0, max = 0;
    int count = 1;  // 計算輸出幾個

    for (int j = 3; j < 9972; ++j) {
        for (int i = 2; i < 9973; ++i) {
            if (i * i >= j) {
                // 每輸出15個換行
                if (count == 15) {
                    count = 1;
                    fprintf(f, "\n");
                }
                fprintf(f, "%d\t", j - temp);
                if (j - temp > max)
                    max = j - temp;
                temp = j;
                ++count;
                break;
            } else if (j % i == 0) 
                break;
        }
    }
    fprintf(f, "\nmax = %d\n", max);
    fclose(f);
    return 0;
}