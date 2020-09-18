# Biweekly Contest 28

### 1475. Final Prices With a Special Discount in a Shop

Given the array `prices` where `prices[i]` is the price of the `ith` item in a shop. There is a special discount for items in the shop, if you buy the `ith` item, then you will receive a discount equivalent to `prices[j]` where `j` is the **minimum** index such that `j > i` and `prices[j] <= prices[i]`, otherwise, you will not receive any discount at all.

*Return an array where the `ith` element is the final price you will pay for the `ith` item of the shop considering the special discount.*

**Example 1:**

```
Input: prices = [8,4,6,2,3]
Output: [4,2,4,2,3]
Explanation: 
For item 0 with price[0]=8 you will receive a discount equivalent to prices[1]=4, therefore, the final price you will pay is 8 - 4 = 4. 
For item 1 with price[1]=4 you will receive a discount equivalent to prices[3]=2, therefore, the final price you will pay is 4 - 2 = 2. 
For item 2 with price[2]=6 you will receive a discount equivalent to prices[3]=2, therefore, the final price you will pay is 6 - 2 = 4. 
For items 3 and 4 you will not receive any discount at all.
```

**Example 2:**

```
Input: prices = [1,2,3,4,5]
Output: [1,2,3,4,5]
Explanation: In this case, for all items, you will not receive any discount at all.
```

**Example 3:**

```
Input: prices = [10,1,1,6]
Output: [9,0,1,6]
```

**Constraints:**

- `1 <= prices.length <= 500`
- `1 <= prices[i] <= 10^3`

**Solution:**

```swift
func finalPrices(_ prices: [Int]) -> [Int] {
    let n = prices.count
    var res = [Int]()
    for i in 0..<n {
        res.append(prices[i])
        for j in i+1..<n {
            if prices[j] <= prices[i] {
                res[i] = prices[i] - prices[j]
                break
            }
        }
    }
    return res
}
```

**Other Solution:**

**Java:**

```java
    public int[] finalPrices(int[] A) {
        Stack<Integer> stack = new Stack<>();
        for (int i = 0; i < A.length; i++) {
            while (!stack.isEmpty() && A[stack.peek()] >= A[i])
                A[stack.pop()] -= A[i];
            stack.push(i);
        }
        return A;
    }
```

**C++:**

```c++
    vector<int> finalPrices(vector<int>& A) {
        vector<int> stack;
        for (int i = 0; i < A.size(); ++i) {
            while (stack.size() && A[stack.back()] >= A[i]) {
                A[stack.back()] -= A[i];
                stack.pop_back();
            }
            stack.push_back(i);
        }
        return A;
    }
```

**Python:**

```python
    def finalPrices(self, A):
        stack = []
        for i, a in enumerate(A):
            while stack and A[stack[-1]] >= a:
                A[stack.pop()] -= a
            stack.append(i)
        return A
```

---

### 1476. Subrectangle Queries

Implement the class `SubrectangleQueries` which receives a `rows x cols` rectangle as a matrix of integers in the constructor and supports two methods:

1.` updateSubrectangle(int row1, int col1, int row2, int col2, int newValue)`

- Updates all values with `newValue` in the subrectangle whose upper left coordinate is `(row1,col1)` and bottom right coordinate is `(row2,col2)`.

2.` getValue(int row, int col)`

- Returns the current value of the coordinate `(row,col)` from the rectangle.

**Example 1:**

```
Input
["SubrectangleQueries","getValue","updateSubrectangle","getValue","getValue","updateSubrectangle","getValue","getValue"]
[[[[1,2,1],[4,3,4],[3,2,1],[1,1,1]]],[0,2],[0,0,3,2,5],[0,2],[3,1],[3,0,3,2,10],[3,1],[0,2]]
Output
[null,1,null,5,5,null,10,5]
Explanation
SubrectangleQueries subrectangleQueries = new SubrectangleQueries([[1,2,1],[4,3,4],[3,2,1],[1,1,1]]);  
// The initial rectangle (4x3) looks like:
// 1 2 1
// 4 3 4
// 3 2 1
// 1 1 1
subrectangleQueries.getValue(0, 2); // return 1
subrectangleQueries.updateSubrectangle(0, 0, 3, 2, 5);
// After this update the rectangle looks like:
// 5 5 5
// 5 5 5
// 5 5 5
// 5 5 5 
subrectangleQueries.getValue(0, 2); // return 5
subrectangleQueries.getValue(3, 1); // return 5
subrectangleQueries.updateSubrectangle(3, 0, 3, 2, 10);
// After this update the rectangle looks like:
// 5   5   5
// 5   5   5
// 5   5   5
// 10  10  10 
subrectangleQueries.getValue(3, 1); // return 10
subrectangleQueries.getValue(0, 2); // return 5
```

**Example 2:**

```
Input
["SubrectangleQueries","getValue","updateSubrectangle","getValue","getValue","updateSubrectangle","getValue"]
[[[[1,1,1],[2,2,2],[3,3,3]]],[0,0],[0,0,2,2,100],[0,0],[2,2],[1,1,2,2,20],[2,2]]
Output
[null,1,null,100,100,null,20]
Explanation
SubrectangleQueries subrectangleQueries = new SubrectangleQueries([[1,1,1],[2,2,2],[3,3,3]]);
subrectangleQueries.getValue(0, 0); // return 1
subrectangleQueries.updateSubrectangle(0, 0, 2, 2, 100);
subrectangleQueries.getValue(0, 0); // return 100
subrectangleQueries.getValue(2, 2); // return 100
subrectangleQueries.updateSubrectangle(1, 1, 2, 2, 20);
subrectangleQueries.getValue(2, 2); // return 20
```

**Constraints:**

- There will be at most `500` operations considering both methods: `updateSubrectangle` and `getValue`.
- `1 <= rows, cols <= 100`
- `rows == rectangle.length`
- `cols == rectangle[i].length`
- `0 <= row1 <= row2 < rows`
- `0 <= col1 <= col2 < cols`
- `1 <= newValue, rectangle[i][j] <= 10^9`
- `0 <= row < rows`
- `0 <= col < cols`

**Solution:**

```swift
class SubrectangleQueries {
    var matrix = [[Int]]()
    init(_ rectangle: [[Int]]) {
        matrix = rectangle
    }
    
    func updateSubrectangle(_ row1: Int, _ col1: Int, _ row2: Int, _ col2: Int, _ newValue: Int) {
        for i in row1...row2 {
            for j in col1...col2 {
                matrix[i][j] = newValue
            }
        }
    }
    
    func getValue(_ row: Int, _ col: Int) -> Int {
        return matrix[row][col]
    }
}
```

---

### 1477. Find Two Non-overlapping Sub-arrays Each With Target Sum

Given an array of integers `arr` and an integer `target`.

You have to find **two non-overlapping sub-arrays** of `arr` each with sum equal `target`. There can be multiple answers so you have to find an answer where the sum of the lengths of the two sub-arrays is **minimum**.

Return *the minimum sum of the lengths* of the two required sub-arrays, or return ***-1*** if you cannot find such two sub-arrays.

**Example 1:**

```
Input: arr = [3,2,2,4,3], target = 3
Output: 2
Explanation: Only two sub-arrays have sum = 3 ([3] and [3]). The sum of their lengths is 2.
```

**Example 2:**

```
Input: arr = [7,3,4,7], target = 7
Output: 2
Explanation: Although we have three non-overlapping sub-arrays of sum = 7 ([7], [3,4] and [7]), but we will choose the first and third sub-arrays as the sum of their lengths is 2.
```

**Example 3:**

```
Input: arr = [4,3,2,6,2,3,4], target = 6
Output: -1
Explanation: We have only one sub-array of sum = 6.
```

**Example 4:**

```
Input: arr = [5,5,4,4,5], target = 3
Output: -1
Explanation: We cannot find a sub-array of sum = 3.
```

**Example 5:**

```
Input: arr = [3,1,1,1,5,1,2,1], target = 3
Output: 3
Explanation: Note that sub-arrays [1,2] and [2,1] cannot be an answer because they overlap.
```

**Constraints:**

- `1 <= arr.length <= 10^5`
- `1 <= arr[i] <= 1000`
- `1 <= target <= 10^8`

**Solution:**

Keep track of the running prefix-sum and the length of the shortest sub-array that sums to the target up to that point (`best_till` in my solution).
Each time we find another such sub-array, look up that length value at the index right before it starts.

```python
class Solution:
    def minSumOfLengths(self, arr: List[int], target: int) -> int:
        prefix = {0: -1}
        best_till = [math.inf] * len(arr)
        ans = best = math.inf
        for i, curr in enumerate(itertools.accumulate(arr)):
            if curr - target in prefix:
                end = prefix[curr - target]
                if end > -1:
                    ans = min(ans, i - end + best_till[end])
                best = min(best, i - end)
            best_till[i] = best
            prefix[curr] = i
        return -1 if ans == math.inf else ans
```

1. precalculate at each position, i, the min length of array with target sum from left and from right respectively.
   a. fromLeft[i]: from the leftmost to position, i, `(i.e. [0 .. i])`, the min length of the array with target sum
   b. fromRight[i]: from the rightmost to position, i, `(i.e. [i .. n-1])`, the min length of the array with target sum
2. use DP to find the min sum of length at each pisition, i. `(i.e. , dp[i] = fromLeft[i] + fromRight[i+1])`
   a. consider the minimal sum of two arrays' length at each index, i. `(i.e. min sum of length at index i = min length in the range of [0 .. i] + min length in the range of [i+1 .. n-1])`
   b. reverse the given array and apply the same subfunction to simply the code.
3. complexity
   a. Time complexity : O(N)
   b. Space complexity: O(N)

```cpp
class Solution {
public:
    int minSumOfLengths(vector<int>& arr, int target) {
        // from the left, min length of array with sum = target
        vector<int> left = minLen(arr, target);

        // from the right, min length of array with sum = target
        vector<int> arrReverse(arr.begin(), arr.end());
        reverse(arrReverse.begin(), arrReverse.end());
        vector<int> right = minLen(arrReverse, target);
        
        // consider each position to find the min sum of length of the two array with target sum
        int min_val = arr.size() + 1;
        int n = arr.size();
        for(int i = 0; i < arr.size() - 1; ++i) {
            min_val = min(min_val, left[i] + right[n-1-i-1]);
        }
        return min_val == arr.size() + 1 ? -1 : min_val;
    }
    
    // at each position, i, find the min length of array with target sum 
    vector<int> minLen(vector<int> &arr, int target) {
        int n = arr.size();
        vector<int> presum(n, 0);
        unordered_map<int, int> idx;
        vector<int> ans(n, n + 1);
        idx[0] = -1;
        for(int i = 0; i < arr.size(); ++i) {
            presum[i] = i == 0 ? arr[i] : arr[i] + presum[i-1];
            int len = arr.size() + 1;
            if(idx.find(presum[i] - target) != idx.end()) {
                len = i - idx[presum[i]-target];
            }
            idx[presum[i]] = i;
            ans[i] = i == 0 ? len : min(ans[i-1], len);    
        }
        return ans;
    }
    
};
```

---

### 1478. Allocate Mailboxes

Given the array `houses` and an integer `k`. where `houses[i]` is the location of the ith house along a street, your task is to allocate `k` mailboxes in the street.

Return the **minimum** total distance between each house and its nearest mailbox.

The answer is guaranteed to fit in a 32-bit signed integer.

**Example 1:**

![img](https://assets.leetcode.com/uploads/2020/05/07/sample_11_1816.png)

```
Input: houses = [1,4,8,10,20], k = 3
Output: 5
Explanation: Allocate mailboxes in position 3, 9 and 20.
Minimum total distance from each houses to nearest mailboxes is |3-1| + |4-3| + |9-8| + |10-9| + |20-20| = 5 
```

**Example 2:**

![img](https://assets.leetcode.com/uploads/2020/05/07/sample_2_1816.png)

```
Input: houses = [2,3,5,12,18], k = 2
Output: 9
Explanation: Allocate mailboxes in position 3 and 14.
Minimum total distance from each houses to nearest mailboxes is |2-3| + |3-3| + |5-3| + |12-14| + |18-14| = 9.
```

**Example 3:**

```
Input: houses = [7,4,6,1], k = 1
Output: 8
```

**Example 4:**

```
Input: houses = [3,6,14,10], k = 4
Output: 0
```

**Constraints:**

- `n == houses.length`
- `1 <= n <= 100`
- `1 <= houses[i] <= 10^4`
- `1 <= k <= n`
- Array `houses` contain unique integers.

**Solution:**

**Idea**
The idea is we try to allocate each mailbox to `k` group of the consecutive houses `houses[i:j]`. We found a solution if we can distribute total `k` mailboxes to `n` houses devided into `k` groups `[0..i], [i+1..j], ..., [l..n-1]`.
After all, we choose the **minimum cost** among our solutions.
![image](https://assets.leetcode.com/users/hiepit/image_1592073922.png)
*(Attached image from Leetcode for easy to understand the idea)*

`costs[i][j]` is the cost to put a mailbox among `houses[i:j]`, the best way is put the mail box at **median position** among houses[i:j]
![image](https://assets.leetcode.com/users/hiepit/image_1592098756.png)

**Complexity**

- Time: 

  ```
  O(n^3)
  ```

  - `costs` takes `O(n^3)`
  - `dp` takes `O(k*n*n)`, because `dp(k, i)` has total `k*n` states, each state need a for loop up to `n` elements.

- Space: `O(n^2)`

**Python 3 ~ 540ms**

```python
class Solution:
    def minDistance(self, houses: List[int], k: int) -> int:
        n = len(houses)
        houses = sorted(houses)
        costs = [[0] * n for _ in range(n)]
        for i in range(n):
            for j in range(n):
                median = houses[(i + j) // 2]
                for t in range(i, j + 1):
                    costs[i][j] += abs(median - houses[t])

        @lru_cache(None)
        def dp(k, i):
            if k == 0 and i == n: return 0
            if k == 0 or i == n: return math.inf
            ans = math.inf
            for j in range(i, n):
                cost = costs[i][j]  # Try to put a mailbox among house[i:j]
                ans = min(ans, cost + dp(k - 1, j + 1))
            return ans

        return dp(k, 0)
```

**Java ~ 40ms**

```java
class Solution {
    public final int MAX = 100, INF = 100 * 10000;
    int[][] costs = new int[MAX][MAX];
    int[][] memo = new int[MAX][MAX];
    public int minDistance(int[] houses, int k) {
        int n = houses.length;
        Arrays.sort(houses);
        for (int i = 0; i < n; i++)
            for (int j = 0; j < n; j++)
                for (int t = i; t <= j; t++)
                    costs[i][j] += Math.abs(houses[(i + j) / 2] - houses[t]);
        return dp(houses, n, k, 0);
    }
    int dp(int[] houses, int n, int k, int i) {
        if (k == 0 && i == n) return 0;
        if (k == 0 || i == n) return INF;
        if (memo[k][i] != 0) return memo[k][i];
        int ans = INF;
        for (int j = i; j < n; j++)
            ans = Math.min(ans, costs[i][j] + dp(houses, n, k-1, j + 1));
        return memo[k][i] = ans;
    }
}
```

**C++ ~ 104ms**

```cpp
#define MAX 100
#define INF 1000000
class Solution {
public:
    int costs[MAX][MAX] = {};
    int memo[MAX][MAX] = {};
    int minDistance(vector<int>& houses, int k) {
        int n = houses.size();
        sort(houses.begin(), houses.end());
        for (int i = 0; i < n; i++)
            for (int j = 0; j < n; j++)
                for (int t = i; t <= j; t++)
                    costs[i][j] += abs(houses[(i + j) / 2] - houses[t]);
        return dp(houses, n, k, 0);
    }
    int dp(vector<int>& houses, int n, int k, int i) {
        if (k == 0 && i == n) return 0;
        if (k == 0 || i == n) return INF;
        if (memo[k][i] != 0) return memo[k][i];
		int ans = INF;
        for (int j = i; j < n; j++)
            ans = min(ans, costs[i][j] + dp(houses, n, k-1, j + 1));
        return memo[k][i] = ans;
    }
};
```