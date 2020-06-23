# Day 3: Intro to Conditional Statements

**Objective**
In this challenge, we're getting started with conditional statements. Check out the [Tutorial](https://www.hackerrank.com/challenges/30-conditional-statements/tutorial) tab for learning materials and an instructional video!

**Task**
Given an integer,n , perform the following conditional actions:

- If n is odd, print `Weird`
- If n is even and in the inclusive range of to , print `Not Weird`
- If n is even and in the inclusive range of to , print `Weird`
- If n is even and greater than , print `Not Weird`

Complete the stub code provided in your editor to print whether or not is weird.

**Input Format**

A single line containing a positive integer, .

**Constraints**

- 1<= n<=100

**Output Format**

Print `Weird` if the number is weird; otherwise, print `Not Weird`.

```cpp
#include <bits/stdc++.h>
using namespace std;
int main()
{
    int N;
    cin >> N;
    cin.ignore(numeric_limits<streamsize>::max(), '\n');
    if (N % 2 == 0) {
        if (2<= N && N<=5) {
            cout << "Not Weird" << endl;
        } else if (6<=N && N<=20) {
            cout << "Weird" << endl;
        } else if (N > 20) {
            cout << "Not Weird" << endl;
        } else {
            cout << "Not Weird" << endl;
        }
    } else {
        cout << "Weird" << endl;
    }
    return 0;
}

```

