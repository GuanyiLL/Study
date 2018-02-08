# Description

Say you have an array for which the ith element is the price of a given stock on day i.

If you were only permitted to complete at most one transaction (ie, buy one and sell one share of the stock), design an algorithm to find the maximum profit.

#### Ex1

```
Input: [7, 1, 5, 3, 6, 4]
Output: 5

max. difference = 6-1 = 5 (not 7-1 = 6, as selling price needs to be larger than buying price)

```

#### Ex2

```

Input: [7, 6, 4, 3, 1]
Output: 0

In this case, no transaction is done, i.e. max profit = 0.

```

# Code

```cpp

class Solution {
public:
    int maxProfit(vector<int>& prices) {
        int min = INT_MAX;
        int res = 0;
        for (int i = 0; i < prices.size(); i++) {
            int e = prices[i];
            if (e < min) {
                min = e;
            } else if (e - min > res) {
                res = e - min;
            }
        }
        return res;
    }
};

```
