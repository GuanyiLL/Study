# Day 6: Let's Review

**Objective**
Today we're expanding our knowledge of Strings and combining it with what we've already learned about loops. Check out the [Tutorial](https://www.hackerrank.com/challenges/30-review-loop/tutorial) tab for learning materials and an instructional video!

**Task**
Given a string, S, of length that is indexed from 0 to N - 1, print its *even-indexed* and *odd-indexed* characters as 2 space-separated strings on a single line (see the *Sample* below for more detail).

**Note:**0 is considered to be an *even* index.

**Input Format**

The first line contains an integer, T(the number of test cases).
Each line i of the T subsequent lines contain a String,S .

**Constraints**

- 1<=T<=10
- 2<=length of S<=10000

**Output Format**

For each String Sj(where 0<=j<=T-1), print Sj 's *even-indexed* characters, followed by a space, followed by Sj 's *odd-indexed* characters.

**Sample Input**

```
2
Hacker
Rank
```

**Sample Output**

```
Hce akr
Rn ak
```

```cpp
#include <cmath>
#include <cstdio>
#include <string>
#include <vector>
#include <iostream>
#include <algorithm>
using namespace std;


int main() {
    /* Enter your code here. Read input from STDIN. Print output to STDOUT */
         /* Enter your code here. Read input from STDIN. Print output to STDOUT */
    int count = 0;
    string reader = "";
    getline(cin>>ws, reader);
    count = stoi(reader);
    for (int i = 0; i < count; i++) {
        getline(cin>>ws, reader);
        string odd = "";
        string even = "";
        for (int j = 0; j < reader.length(); j++) {
            if (j % 2 == 0) {
                 odd += reader[j];
            } else {
                even += reader[j];
            }
        }
        cout << odd + " " + even << endl;
    }
    return 0;
}

```

