The **n-queens** puzzle is the problem of placing `n` queens on an `n x n` chessboard such that no two queens attack each other.

Given an integer `n`, return *the number of distinct solutions to the **n-queens puzzle***.

 

**Example 1:**

![img](https://assets.leetcode.com/uploads/2020/11/13/queens.jpg)

```
Input: n = 4
Output: 2
Explanation: There are two distinct solutions to the 4-queens puzzle as shown.
```

**Example 2:**

```
Input: n = 1
Output: 1
```

 

**Constraints:**

- `1 <= n <= 9`



**Solution**

```swift
var res = [[[Int]]]()
func issafe(_ curr:inout [[Int]], _ r: Int, _ c: Int) -> Bool {
    //check row
    let n = curr.count;
    
    for i in 0..<c {
        if curr[r][i] == 1 {
            return false
        }
    }
    
    var i = r, j = c
    
    while i >= 0 && j >= 0 {
        if curr[i][j] == 1 {
            return false
        }
        i -= 1
        j -= 1
    }
    
    i = r; j = c
    while i < n, j >= 0 {
        if curr[i][j] == 1 {
            return false
        }
        i += 1
        j -= 1
    }
    return true;
}

func backtrack(_ col: Int, _ n: Int, _ curr:inout [[Int]]) {
    if col == n {
        res.append(curr)
        return;
    }
    for i in 0..<n {
        if(issafe(&curr,i,col)) {
            curr[i][col] = 1;
            backtrack(col+1,n,&curr);
            curr[i][col] = 0
        }
    }
}

func totalNQueens(_ n: Int) -> Int {
    var curr = Array(repeating: Array(repeating: 0, count: n), count: n)
    backtrack(0, n, &curr)
    return res.count
}
```

Fastest:

```swift
 
 var total:Int = 0
 
 func totalNQueens(_ n: Int) -> Int {
     var arr:[Int] = Array(repeating:0, count: n)
     helper(&arr, 0)
     return total
 }
 
 func helper(_ arr: inout [Int],_ current: Int) {
     if current == arr.count {
         total += 1
         return
     }
     
     for i in 0..<arr.count {
         if !hasConflict(&arr, current, i) {
             arr[current] = i
             helper(&arr, current+1)
         }
     }
     
 }
 
 func hasConflict(_ arr:inout[Int], _ row:Int, _ col:Int) -> Bool {
     for i in 0..<row {
         if arr[i] == col || arr[i] + i == col + row || arr[i] - i == col - row {
             return true
         }
     }
     return false
 }
```

