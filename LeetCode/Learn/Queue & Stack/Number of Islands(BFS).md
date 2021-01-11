# Number of Islands



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
    var visited = Dictionary<Int, Int>()
    var queue = [Int]()

    func addToQueue(row: Int, col: Int, grid: [[Character]]) {
        
        var i = row - 1
        var j = col
        var index = i * grid.first!.count + j
        if i >= 0 && visited[index] != 1 {
            queue.append(index)
            visited[index, default: 0] = 1
        }
        
        i = row
        j = col + 1
        index = i * grid.first!.count + j
        if j < grid.first!.count && visited[index] != 1 {
            queue.append(index)
            visited[index, default: 0] = 1
        }
        
        i = row + 1
        j = col
        index = i * grid.first!.count + j
        if i < grid.count && visited[index] != 1 {
            queue.append(index)
            visited[index, default: 0] = 1
        }
        
        i = row
        j = col - 1
        index = i * grid.first!.count + j
        if j >= 0 && visited[index] != 1 {

            queue.append(index)
            visited[index, default: 0] = 1
        }
    }
    
    func numIslands(_ grid: [[Character]]) -> Int {
        var islands = 0
        
        for (i, items) in grid.enumerated() {
            for (j, item) in items.enumerated() {
                let index = i * grid.first!.count + j
                if  visited[index] == 1 {
                    continue
                }
                visited[index, default:0] = 1
                if item == "0" {
                    continue
                }
                queue.append(index)
                
                while !queue.isEmpty {
                    let item = queue.removeFirst()
                    
                    let j = item % grid.first!.count
                    let i = (item - j) / grid.first!.count
                    
                    if grid[i][j] == "0" {
                        continue
                    }
                    self.addToQueue(row: i, col: j, grid: grid)
                }
                islands += 1
            }
        }
        return islands
    }
}
```

My solution just like a piece of shit



Best solution:

```swift
class Solution {
    func numIslands(_ grid: [[Character]]) -> Int {
        var count = 0
        var grid = grid
        let row = grid.count
        if row == 0 {
            return count
        }
        let col = grid[0].count
        
        for i in 0..<row {
            for j in 0..<col {
                if grid[i][j] == "1" {
                    helper(&grid, i, j)
                    count += 1
                }
            }
        }
        
        return count
    }
    
    func helper(_ grid: inout [[Character]], _ i: Int, _ j: Int) {
        if i < 0 || j < 0 || i >= grid.count || j >= grid[0].count || grid[i][j] == "0" {
            return
        }
        
        grid[i][j] = "0"
        helper(&grid, i + 1, j)
        helper(&grid, i - 1, j)
        helper(&grid, i, j + 1)
        helper(&grid, i, j - 1)
    }
}
```

