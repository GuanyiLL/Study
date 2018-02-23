# Description

Given an integer, write a function to determine if it is a power of two.

# Code

```cpp

class Solution {
public:
    bool isPowerOfTwo(int n) {        
        if(n<0) return false;
        while(n>1){
            if(n%2!=0) return false;
            n=n/2;
        }
        return n==1;
    }
};

```
