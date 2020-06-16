# Weekly Contest 193

### 1480. Running Sum of 1d Array

Given an array `nums`. We define a running sum of an array as `runningSum[i] = sum(nums[0]…nums[i])`.

Return the running sum of `nums`.

**Example 1:**

```
Input: nums = [1,2,3,4]
Output: [1,3,6,10]
Explanation: Running sum is obtained as follows: [1, 1+2, 1+2+3, 1+2+3+4].
```

**Example 2:**

```
Input: nums = [1,1,1,1,1]
Output: [1,2,3,4,5]
Explanation: Running sum is obtained as follows: [1, 1+1, 1+1+1, 1+1+1+1, 1+1+1+1+1].
```

**Example 3:**

```
Input: nums = [3,1,2,10,1]
Output: [3,4,6,16,17]
```

**Constraints:**

- `1 <= nums.length <= 1000`
- `-10^6 <= nums[i] <= 10^6`

**Solution**

```swift
func runningSum(_ nums: [Int]) -> [Int] {
    var res = [Int]()
    for idx in 0..<nums.count {
        var sum = nums[idx]
        for j in 0..<idx {
            sum += nums[j]
        }
        res.append(sum)
    }
    return res
}
```

---

### 1481. Least Number of Unique Integers after K Removals

Given an array of integers `arr` and an integer `k`. Find the *least number of unique integers* after removing **exactly** `k` elements**.**

**Example 1:**

```
Input: arr = [5,5,4], k = 1
Output: 1
Explanation: Remove the single 4, only 5 is left.
```

**Example 2:**

```
Input: arr = [4,3,1,1,3,3,2], k = 3
Output: 2
Explanation: Remove 4, 2 and either one of the two 1s or three 3s. 1 and 3 will be left.
```

**Constraints:**

- `1 <= arr.length <= 10^5`
- `1 <= arr[i] <= 10^9`
- `0 <= k <= arr.length`

**Solution**

```swift
func findLeastNumOfUniqueInts(_ arr: [Int], _ k: Int) -> Int {
    var map = [Int:Int]()
    for i in arr {
        map[i] = (map[i] ?? 0) + 1
    }
    var a = map.sorted{ $0.value < $1.value }
    var count = 0
    for dic in a {
        for _ in 0..<dic.value {
            if count == k {
                break
            }
            map[dic.key]! -= 1
            if map[dic.key]! == 0 {
                a.removeFirst()
                map[dic.key] = nil
            }
            count += 1
        }
    }
    
    return map.count
}
```

---

### 1482. Minimum Number of Days to Make m Bouquets

Given an integer array `bloomDay`, an integer `m` and an integer `k`.

We need to make `m` bouquets. To make a bouquet, you need to use `k` **adjacent flowers** from the garden.

The garden consists of `n` flowers, the `ith` flower will bloom in the `bloomDay[i]` and then can be used in **exactly one** bouquet.

Return *the minimum number of days* you need to wait to be able to make `m` bouquets from the garden. If it is impossible to make `m` bouquets return **-1**.

**Example 1:**

```
Input: bloomDay = [1,10,3,10,2], m = 3, k = 1
Output: 3
Explanation: Let's see what happened in the first three days. x means flower bloomed and _ means flower didn't bloom in the garden.
We need 3 bouquets each should contain 1 flower.
After day 1: [x, _, _, _, _]   // we can only make one bouquet.
After day 2: [x, _, _, _, x]   // we can only make two bouquets.
After day 3: [x, _, x, _, x]   // we can make 3 bouquets. The answer is 3.
```

**Example 2:**

```
Input: bloomDay = [1,10,3,10,2], m = 3, k = 2
Output: -1
Explanation: We need 3 bouquets each has 2 flowers, that means we need 6 flowers. We only have 5 flowers so it is impossible to get the needed bouquets and we return -1.
```

**Example 3:**

```
Input: bloomDay = [7,7,7,7,12,7,7], m = 2, k = 3
Output: 12
Explanation: We need 2 bouquets each should have 3 flowers.
Here's the garden after the 7 and 12 days:
After day 7: [x, x, x, x, _, x, x]
We can make one bouquet of the first three flowers that bloomed. We cannot make another bouquet from the last three flowers that bloomed because they are not adjacent.
After day 12: [x, x, x, x, x, x, x]
It is obvious that we can make two bouquets in different ways.
```

**Example 4:**

```
Input: bloomDay = [1000000000,1000000000], m = 1, k = 1
Output: 1000000000
Explanation: You need to wait 1000000000 days to have a flower ready for a bouquet.
```

**Example 5:**

```
Input: bloomDay = [1,10,2,9,3,8,4,7,5,6], m = 4, k = 2
Output: 9
day1:[x,_,_,_,_,_,_,_,_,_]
day2:[x,_,x,_,_,_,_,_,_,_]
day3:[x,_,x,_,x,_,_,_,_,_]
day4:[x,_,x,_,x,_,x,_,_,_]
day5:[x,_,x,_,x,_,x,_,x,_]
day6:[x,_,x,_,x,_,x,_,x,x]
day7:[x,_,x,_,x,_,x,x,x,x]
day8:[x,_,x,_,x,x,x,x,x,x] 
day9:[x,_,x,x,x,x,x,x,x,x]
```

**Solution**

**Java:**

```python
    public int minDays(int[] A, int m, int k) {
        int n = A.length, left = 1, right = (int)1e9;
        if (m * k > n) return -1;
        while (left < right) {
            int mid = (left + right) / 2, flow = 0, bouq = 0;
            for (int j = 0; j < n; ++j) {
                if (A[j] > mid) {
                    flow = 0;
                } else if (++flow >= k) {
                    bouq++;
                    flow = 0;
                }
            }
            if (bouq < m) {
                left = mid + 1;
            } else {
                right = mid;
            }
        }
        return left;
    }
```

**C++:**

```
    int minDays(vector<int>& A, int m, int k) {
        int n = A.size(), left = 1, right = 1e9;
        if (m * k > n) return -1;
        while (left < right) {
            int mid = (left + right) / 2, flow = 0, bouq = 0;
            for (int j = 0; j < n; ++j) {
                if (A[j] > mid) {
                    flow = 0;
                } else if (++flow >= k) {
                    bouq++;
                    flow = 0;
                }
            }
            if (bouq < m) {
                left = mid + 1;
            } else {
                right = mid;
            }
        }
        return left;
    }
```

**Python:**

```
    def minDays(self, A, m, k):
        if m * k > len(A): return -1
        left, right = 1, max(A)
        while left < right:
            mid = (left + right) / 2
            flow = bouq = 0
            for a in A:
                flow = 0 if a > mid else flow + 1
                if flow >= k:
                    flow = 0
                    bouq += 1
                    if bouq == m: break
            if bouq == m:
                right = mid
            else:
                left = mid + 1
        return left
```

---

### 1483. Kth Ancestor of a Tree Node

You are given a tree with `n` nodes numbered from `0` to `n-1` in the form of a parent array where `parent[i]` is the parent of node `i`. The root of the tree is node `0`.

Implement the function `getKthAncestor``(int node, int k)` to return the `k`-th ancestor of the given `node`. If there is no such ancestor, return `-1`.

The *k-th* *ancestor* of a tree node is the `k`-th node in the path from that node to the root.

**Example:**

**![img](https://assets.leetcode.com/uploads/2019/08/28/1528_ex1.png)**

```
Input:
["TreeAncestor","getKthAncestor","getKthAncestor","getKthAncestor"]
[[7,[-1,0,0,1,1,2,2]],[3,1],[5,2],[6,3]]

Output:
[null,1,0,-1]

Explanation:
TreeAncestor treeAncestor = new TreeAncestor(7, [-1, 0, 0, 1, 1, 2, 2]);

treeAncestor.getKthAncestor(3, 1);  // returns 1 which is the parent of 3
treeAncestor.getKthAncestor(5, 2);  // returns 0 which is the grandparent of 5
treeAncestor.getKthAncestor(6, 3);  // returns -1 because there is no such ancestor
```

**Constraints:**

- `1 <= k <= n <= 5*10^4`
- `parent[0] == -1` indicating that `0` is the root node.
- `0 <= parent[i] < n` for all `0 < i < n`
- `0 <= node < n`
- There will be at most `5*10^4` queries.

**Solution**

**Python:**

```python
    step = 15
    def __init__(self, n, A):
        A = dict(enumerate(A))
        jump = [A]
        for s in xrange(self.step):
            B = {}
            for i in A:
                if A[i] in A:
                    B[i] = A[A[i]]
            jump.append(B)
            A = B
        self.jump = jump

    def getKthAncestor(self, x, k):
        step = self.step
        while k > 0 and x > -1:
            if k >= 1 << step:
                x = self.jump[step].get(x, -1)
                k -= 1 << step
            else:
                step -= 1
        return x
```

**Java**
@changeme

```java
    int[][] jump;
    int maxPow;

    public TreeAncestor(int n, int[] parent) {
        // log_base_2(n)
        maxPow = (int) (Math.log(n) / Math.log(2)) + 1;
        jump = new int[maxPow][n];
        jump[0] = parent;
        for (int p = 1; p < maxPow; p++) {
            for (int j = 0; j < n; j++) {
                int pre = jump[p - 1][j];
                jump[p][j] = pre == -1 ? -1 : jump[p - 1][pre];
            }
        }
    }

    public int getKthAncestor(int node, int k) {
        int maxPow = this.maxPow;
        while (k > 0 && node > -1) {
            if (k >= 1 << maxPow) {
                node = jump[maxPow][node];
                k -= 1 << maxPow;
            } else
                maxPow -= 1;
        }
        return node;
    }
```

**C++**
all from @user4745

ok so there is concept of binary lifting,
what is binary lifting ??

So any number can be expressed power of 2,
and we can greedily find that ,
by taking highest powers and taking the modulo,
or just utilising the inbuilt binary format that
how numbers are stored in computer,
so we know how to represent k in binary format,
so now using the same concept we will jump on k height using binary powers,
and remove the highest power ,
but here we must know the 2^i th height parent from every node,
so we will preprocess the tree as shown in the code,
so u could see as 2^i = 2^(i-1) + 2^(i-1),
so if we calculated 2^(i-1) th parent of every node beforehand
we could calculate 2^i th parent from that,
like 2^(i-1) th parent of 2^(i-1) th parent of the node,
right like 4th parent is 2nd parent of 2nd parent of node,
this is called binary lifting.

so now utilise the binary version of k and jump accordingly.
I have also made parent of 0 to -1,
so that I could stop if I went above the node.

```cpp
    vector<vector<int>>v;
    TreeAncestor(int n, vector<int>& parent) {
        vector<vector<int>> par(n, vector<int>(20));
        for (int i = 0; i < n; i++) par[i][0] = parent[i];
        for (int j = 1; j < 20; j++) {
            for (int i = 0; i < n; i++) {
                if (par[i][j - 1] == -1) par[i][j] = -1;
                else par[i][j] = par[par[i][j - 1]][j - 1];
            }
        }
        swap(v, par);
    }
    int getKthAncestor(int node, int k) {
        for (int i = 0; i < 20; i++) {
            if ((k >> i) & 1) {
                node = v[node][i];
                if (node == -1) return -1;
            }
        }
        return node;
    }
```