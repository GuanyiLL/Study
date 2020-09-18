# Add Strings

Given two non-negative integers num1 and num2 represented as string, return the sum of num1 and num2.

#### Note:

1. The length of both num1 and num2 is < 5100.
2. Both num1 and num2 contains only digits 0-9.
3. Both num1 and num2 does not contain any leading zero.
4. You must not use any built-in BigInteger library or convert the inputs to integer directly.

# Code

```cpp
class Solution {
public:
    string addStrings(string num1, string num2) {
        int i = num1.length() - 1, j = num2.length() - 1;
        int x = 0, k = 0;
        string s(max(num1.length(), num2.length()) + 1, '0');
        while (i>=0 || j>=0){
            int a, b;
            a = i<0? 0 : num1[i] - '0';
            b = j<0? 0 : num2[j] - '0';
            s[k] = '0' + (a + b + x) % 10;
            x = (a + b + x) / 10;
        
            i--;j--;
        
            if (i<0 & j<0){
                if (x>0){
                    k++;s[k] = '0' + x;
                } else{
                    s.pop_back();
                }
            }
            k++;
        }
        reverse(s.begin(),s.end());
    return s;
    }
};

```


