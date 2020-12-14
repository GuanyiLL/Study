Given a matrix consists of 0 and 1, find the distance of the nearest 0 for each cell.

The distance between two adjacent cells is 1.

 

**Example 1:**

```
Input:
[[0,0,0],
 [0,1,0],
 [0,0,0]]

Output:
[[0,0,0],
 [0,1,0],
 [0,0,0]]
```

**Example 2:**

```
Input:
[[0,0,0],
 [0,1,0],
 [1,1,1]]

Output:
[[0,0,0],
 [0,1,0],
 [1,2,1]]
```

 

**Note:**

1. The number of elements of the given matrix will not exceed 10,000.
2. There are at least one 0 in the given matrix.
3. The cells are adjacent in only four directions: up, down, left and right.



**Solution**

```swift

func updateMatrix(_ matrix: [[Int]]) -> [[Int]] {
    var res = matrix
    var queue = [[Int]]()
    
    for i in 0..<matrix.count {
        for j in 0..<matrix[0].count {
            if matrix[i][j] == 0 {
                queue.append([i, j])
            } else {
                res[i][j] = Int.max
            }
        }
    }
    
    let dirs = [[-1, 0], [1, 0], [0, -1], [0, 1]]
    
    while !queue.isEmpty {
        let originLocation = queue.removeFirst()
        
        for dir in dirs {
            let x = originLocation[0] + dir[0]
            let y = originLocation[1] + dir[1]
            
            if x >= matrix.count || y >= matrix[0].count || x < 0 || y < 0 || res[x][y] <= res[originLocation[0]][originLocation[1]] + 1 {
                continue
            }
            res[x][y] = res[originLocation[0]][originLocation[1]] + 1
            queue.append([x, y])
        }
    }
    
    return res
}
```

