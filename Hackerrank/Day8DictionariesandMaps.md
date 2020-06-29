# Day 8: Dictionaries and Maps

**Objective**
Today, we're learning about Key-Value pair mappings using a *Map* or *Dictionary* data structure. Check out the [Tutorial](https://www.hackerrank.com/challenges/30-dictionaries-and-maps/tutorial) tab for learning materials and an instructional video!

**Task**
Given `n`names and phone numbers, assemble a phone book that maps friends' names to their respective phone numbers. You will then be given an unknown number of names to query your phone book for. For each `name`queried, print the associated entry from your phone book on a new line in the form `name=phoneNumber`; if an entry for `name` is not found, print `Not found` instead.

**Note:** Your phone book should be a Dictionary/Map/HashMap data structure.

**Input Format**

The first line contains an integer,`n` , denoting the number of entries in the phone book.
Each of the `n` subsequent lines describes an entry in the form of `2` space-separated values on a single line. The first value is a friend's name, and the second value is an 8-digit phone number.

After the lines of phone book entries, there are *an unknown number of lines of queries*. Each line (query) contains a `name` to look up, and you must continue reading lines until there is no more input.

**Note:** Names consist of lowercase English alphabetic letters and are *first names* only.

**Sample Input**

```
3
sam 99912222
tom 11122222
harry 12299933
sam
edward
harry
```

**Sample Output**

```
sam=99912222
Not found
harry=12299933
```

**Solution**

```cpp
#include <cmath>
#include <cstdio>
#include <vector>
#include <iostream>
#include <algorithm>
#include <map>
using namespace std;


int main() {
    int N;
    string name;
    cin >> N;

    map<string, int> phone_book;

    for (int i = 0; i < N; i++) {
        cin >> name;

        if (!phone_book[name]) {
            cin >> phone_book[name];
        }
    }

    while (cin>>name) {

        if (phone_book[name]) {
            cout << name << "=" << phone_book[name] << endl;
        } else {
            cout << "Not found" << endl;
        }
    }
    return 0;
}

```

