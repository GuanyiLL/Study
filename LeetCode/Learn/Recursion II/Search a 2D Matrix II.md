Write an efficient algorithm that searches for a `target` value in an `m x n` integer `matrix`. The `matrix` has the following properties:

- Integers in each row are sorted in ascending from left to right.
- Integers in each column are sorted in ascending from top to bottom.

**Example 1:**

![img](https://assets.leetcode.com/uploads/2020/11/24/searchgrid2.jpg)

```
Input: matrix = [[1,4,7,11,15],[2,5,8,12,19],[3,6,9,16,22],[10,13,14,17,24],[18,21,23,26,30]], target = 5
Output: true
```

**Example 2:**

![img](https://assets.leetcode.com/uploads/2020/11/24/searchgrid.jpg)

```
Input: matrix = [[1,4,7,11,15],[2,5,8,12,19],[3,6,9,16,22],[10,13,14,17,24],[18,21,23,26,30]], target = 20
Output: false
```

 **Solution**

my solution(D&C):

```swift
func searchMatrix(_ matrix: [[Int]], _ target: Int) -> Bool {
    return divide(matrix, target, 0, matrix.count - 1, 0, matrix[0].count - 1)
}

func divide(_ matrix: [[Int]], _ target: Int, _ rl:Int, _ rh:Int, _ cl:Int, _ ch:Int) -> Bool {
    if rl > rh || cl > ch || rh > matrix.count || ch > matrix[0].count {
        return false
    }
    let pivot = (rl + (rh - rl) / 2, cl + (ch - cl) / 2)
    if matrix[pivot.0][pivot.1] == target {
        return true
    }

    if matrix[pivot.0][pivot.1] > target {
        let topLeftResult    = divide(matrix, target, rl, pivot.0 - 1, cl, pivot.1 - 1)
        let topRightResult   = divide(matrix, target,  rl, pivot.0 - 1, pivot.1 , ch)
        let bottomLeftResult = divide(matrix, target, pivot.0, rh, cl, pivot.1 - 1)
        return topLeftResult || topRightResult || bottomLeftResult
    } else {
        let topRightResult    = divide(matrix, target,  rl, pivot.0, pivot.1 + 1, ch)
        let bottomLeftResult  = divide(matrix, target, pivot.0 + 1, rh, cl, pivot.1)
        let bottomRightResult = divide(matrix, target, pivot.0 + 1, rh, pivot.1 + 1, ch)
        return topRightResult || bottomLeftResult || bottomRightResult
    }
}
```

Fastest (from top-right iteration):

```swift
func searchMatrix(_ matrix: [[Int]], _ target: Int) -> Bool {
    if matrix.isEmpty || matrix[0].isEmpty { return false }

    var row = 0
    var column = matrix[0].count - 1

    while column >= 0 && row < matrix.count {
        let value = matrix[row][column]

        if target == value {
            return true
        } else if target > value {
            row += 1
        } else {
            column -= 1
        }
    }

    return false
}
```

two lines:

```swift
func searchMatrix(_ matrix: [[Int]], _ target: Int) -> Bool {
    let flatmapMatrix = matrix.flatMap{ $0 }.filter({ $0 == target})
    return flatmapMatrix.count > 0 ? true : false
}
```

