# Day 10: Binary Numbers

**Objective**
Today, we're working with binary numbers. Check out the [Tutorial](https://www.hackerrank.com/challenges/30-binary-numbers/tutorial) tab for learning materials and an instructional video!

**Task**
Given a base-10 integer,n, convert it to binary (base-2). Then find and print the base-10 integer denoting the maximum number of consecutive 1's in n's binary representation.

**Input Format**

A single integer, n.

**Constraints**

- 1<=n<=10^6

**Output Format**

Print a single base-10 integer denoting the maximum number of consecutive 1's in the binary representation of n.

**Sample Input 1**

```
5
```

**Sample Output 1**

```
1
```

**Sample Input 2**

```
13
```

**Sample Output 2**

```
2
```

**Solution**

```cpp
#include <bits/stdc++.h>

using namespace std;



int main()
{
    int n;
    cin >> n;
    cin.ignore(numeric_limits<streamsize>::max(), '\n');

    int temp = 0,res = 0;
    while (n > 0) {
        if (n%2) {
            temp++;
            if (temp > res) res = temp;
        } else {
          	temp = 0;
        };
        n = n/2;
    }
    cout << res << endl;

    return 0;
}
```

