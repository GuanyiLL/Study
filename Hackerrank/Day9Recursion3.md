# Day 9: Recursion 3

**Objective**
Today, we're learning and practicing an algorithmic concept called *Recursion*. Check out the [Tutorial](https://www.hackerrank.com/challenges/30-recursion/tutorial) tab for learning materials and an instructional video!

**Recursive Method for Calculating Factorial**
$$
factorial(N)= \begin{cases} 1, & N \leq 1 \\ N \times  factorial(N-1), & \text{otherwise} \end{cases}
$$
**Task**
Write a *factorial* function that takes a positive integer, as a parameter and prints the result of ( factorial).

**Note:** If you fail to use recursion or fail to name your recursive function *factorial* or *Factorial*, you will get a score of .

**Input Format**

A single integer, (the argument to pass to *factorial*).

**Solution**

```cpp
#include <bits/stdc++.h>

using namespace std;

// Complete the factorial function below.
int factorial(int n) {
    if (n < 1) {
        return 1;
    } else {
        return n * factorial(n - 1);
    }

}

int main()
{
    ofstream fout(getenv("OUTPUT_PATH"));

    int n;
    cin >> n;
    cin.ignore(numeric_limits<streamsize>::max(), '\n');

    int result = factorial(n);

    fout << result << "\n";

    fout.close();

    return 0;
}

```

