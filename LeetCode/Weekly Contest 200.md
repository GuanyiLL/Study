# Weekly Contest 200

## 1534. Count Good Triplets

Given an array of integers `arr`, and three integers `a`, `b` and `c`. You need to find the number of good triplets.

A triplet `(arr[i], arr[j], arr[k])` is **good** if the following conditions are true:

- `0 <= i < j < k < arr.length`
- `|arr[i] - arr[j]| <= a`
- `|arr[j] - arr[k]| <= b`
- `|arr[i] - arr[k]| <= c`

Where `|x|` denotes the absolute value of `x`.

Return *the number of good triplets*.

**Example 1:**

```
Input: arr = [3,0,1,1,9,7], a = 7, b = 2, c = 3
Output: 4
Explanation: There are 4 good triplets: [(3,0,1), (3,0,1), (3,1,1), (0,1,1)].
```

**Example 2:**

```
Input: arr = [1,1,2,2,3], a = 0, b = 0, c = 1
Output: 0
Explanation: No triplet satisfies all conditions.
```

 

**Constraints:**

- `3 <= arr.length <= 100`
- `0 <= arr[i] <= 1000`
- `0 <= a, b, c <= 1000`



**Solution**

```java
public int countGoodTriplets(int[] arr, int a, int b, int c) {
    int count = 0;
    for (int i = 0; i < arr.length; i++) {
        int x = arr[i];
        for (int j = i+1; j < arr.length; j++) {
            int y = arr[j];
            if (Math.abs(x - y) > a) continue;
            for (int k = j+1; k < arr.length; k++) {
                int z = arr[k];
                if (Math.abs(z - y) <= b && Math.abs(z - x) <= c) 		
                    count++;
            }
        }
    }
    return count;
}
```



# 1535. Find the Winner of an Array Game

Given an integer array `arr` of **distinct** integers and an integer `k`.

A game will be played between the first two elements of the array (i.e. `arr[0]` and `arr[1]`). In each round of the game, we compare `arr[0]` with `arr[1]`, the larger integer wins and remains at position `0` and the smaller integer moves to the end of the array. The game ends when an integer wins `k` consecutive rounds.

Return *the integer which will win the game*.

It is **guaranteed** that there will be a winner of the game.

 

**Example 1:**

```
Input: arr = [2,1,3,5,4,6,7], k = 2
Output: 5
Explanation: Let's see the rounds of the game:
Round |       arr       | winner | win_count
  1   | [2,1,3,5,4,6,7] | 2      | 1
  2   | [2,3,5,4,6,7,1] | 3      | 1
  3   | [3,5,4,6,7,1,2] | 5      | 1
  4   | [5,4,6,7,1,2,3] | 5      | 2
So we can see that 4 rounds will be played and 5 is the winner because it wins 2 consecutive games.
```

**Example 2:**

```
Input: arr = [3,2,1], k = 10
Output: 3
Explanation: 3 will win the first 10 rounds consecutively.
```

**Example 3:**

```
Input: arr = [1,9,8,2,3,7,6,4,5], k = 7
Output: 9
```

**Example 4:**

```
Input: arr = [1,11,22,33,44,55,66,77,88,99], k = 1000000000
Output: 99
```

 

**Constraints:**

- `2 <= arr.length <= 10^5`
- `1 <= arr[i] <= 10^6`
- `arr` contains **distinct** integers.
- `1 <= k <= 10^9`

**Solution**

```java
public static int getWinner(int[] arr, int k) {
    if (k == 1) return Math.max(arr[0], arr[1]);
    int n = arr.length, cnt = 0, cur = arr[0];
    for (int i = 1; i < n; i++) {
        if (arr[i] > cur) {
            cnt = 1;
            cur = arr[i];
        } else {
            cnt++;
            if (cnt == k) return cur;
        }
    }
    return cur;
}
```

https://leetcode.com/contest/weekly-contest-200 

3、4题没有思路



