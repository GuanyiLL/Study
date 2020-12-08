Given an `m x n` 2d `grid` map of `'1'`s (land) and `'0'`s (water), return *the number of islands*.

An **island** is surrounded by water and is formed by connecting adjacent lands horizontally or vertically. You may assume all four edges of the grid are all surrounded by water.

 

**Example 1:**

```
Input: grid = [
  ["1","1","1","1","0"],
  ["1","1","0","1","0"],
  ["1","1","0","0","0"],
  ["0","0","0","0","0"]
]
Output: 1
```

**Example 2:**

```
Input: grid = [
  ["1","1","0","0","0"],
  ["1","1","0","0","0"],
  ["0","0","1","0","0"],
  ["0","0","0","1","1"]
]
Output: 3
```

 

**Constraints:**

- `m == grid.length`
- `n == grid[i].length`
- `1 <= m, n <= 300`
- `grid[i][j]` is `'0'` or `'1'`.



**Solution**

```swift
class Solution {
  
func dfs(_ grid: inout [[Character]], row: Int, col: Int) {
    if row  < 0 || row  > grid.count - 1 || col < 0 || col > grid[0].count - 1 || grid[row][col] == "0" {
        return
    }
    grid[row][col] = "0"
    dfs(&grid, row: row, col: col + 1)
    dfs(&grid, row: row + 1, col: col)
    dfs(&grid, row: row, col: col - 1)
    dfs(&grid, row: row - 1, col: col)
}

func numIslands(_ grid: [[Character]]) -> Int {
    var islands = 0
    var grid = grid
    for i in 0..<grid.count {
        for j in 0..<grid[0].count {
            if grid[i][j] == "0" {
                continue
            }
            dfs(&grid, row: i, col: j)
            islands += 1
        }
    }
    return islands
}
}
```

