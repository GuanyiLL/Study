# Day 7: Arrays

**Objective**
Today, we're learning about the *Array* data structure. Check out the [Tutorial](https://www.hackerrank.com/challenges/30-arrays/tutorial) tab for learning materials and an instructional video!

**Task**
Given an array,A , of N integers, print A's elements in *reverse* order as a single line of space-separated numbers.

**Input Format**

The first line contains an integer, N(the size of our array).
The second line contains N space-separated integers describing array A's elements.

**Constraints**

- 1<=N<=1000
- 1<=Ai<=10000, where A is the ith integer in the array.

**Output Format**

Print the elements of array A in reverse order as a single line of space-separated numbers.

**Sample Input**

```
4
1 4 3 2
```

**Sample Output**

```
2 3 4 1
```

**Solution**

```cpp
#include <bits/stdc++.h>

using namespace std;

vector<string> split_string(string);



int main()
{
    int n;
    cin >> n;
    cin.ignore(numeric_limits<streamsize>::max(), '\n');

    string arr_temp_temp;
    getline(cin, arr_temp_temp);

    vector<string> arr_temp = split_string(arr_temp_temp);

    vector<int> arr(n);

    for (int i = 0; i < n; i++) {
        int arr_item = stoi(arr_temp[i]);

        arr[i] = arr_item;
    }

    for (int i = n - 1; i >= 0; i--) {
        printf("%d ",arr[i]);
    }

    return 0;
}

vector<string> split_string(string input_string) {
    string::iterator new_end = unique(input_string.begin(), input_string.end(), [] (const char &x, const char &y) {
        return x == y and x == ' ';
    });

    input_string.erase(new_end, input_string.end());

    while (input_string[input_string.length() - 1] == ' ') {
        input_string.pop_back();
    }

    vector<string> splits;
    char delimiter = ' ';

    size_t i = 0;
    size_t pos = input_string.find(delimiter);

    while (pos != string::npos) {
        splits.push_back(input_string.substr(i, pos - i));

        i = pos + 1;
        pos = input_string.find(delimiter, i);
    }

    splits.push_back(input_string.substr(i, min(pos, input_string.length()) - i + 1));

    return splits;
}

```

