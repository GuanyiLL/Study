# Description

Given a non-empty 2D array `grid` of 0's and 1's, an island is a group of `1`'s (representing land) connected 4-directionally (horizontal or vertical.) You may assume all four edges of the grid are surrounded by water.

Find the maximum area of an island in the given 2D array. (If there is no island, the maximum area is 0.)

#### Ex1:
```

[[0,0,1,0,0,0,0,1,0,0,0,0,0],
 [0,0,0,0,0,0,0,1,1,1,0,0,0],
 [0,1,1,0,1,0,0,0,0,0,0,0,0],
 [0,1,0,0,1,1,0,0,1,0,1,0,0],
 [0,1,0,0,1,1,0,0,1,1,1,0,0],
 [0,0,0,0,0,0,0,0,0,0,1,0,0],
 [0,0,0,0,0,0,0,1,1,1,0,0,0],
 [0,0,0,0,0,0,0,1,1,0,0,0,0]]

```
Given the above grid, return `6`. Note the answer is not 11, because the island must be connected 4-directionally

#### Ex2:

```

[[0,0,0,0,0,0,0,0]]

```

Given the above grid,return `0`.

#### Note:

The length of each dimension in the given `grid` does not exceed 50.

# Code

```c++

class Solution {
public:
    int maxAreaOfIsland(vector<vector<int>>& grid) {
        int res = 0;
        for (int i = 0; i < grid.size(); i++) {
            for (int j = 0; j < grid[0].size(); j++) {
                if (grid[i][j] == 1) res = max(res, area(grid, i, j));
            }
        }
        return res;
    }
public:
int area(vector<vector<int>> &grid, int row, int column) {
    if (row < 0 || row >= grid.size() || column < 0 || column >= grid[0].size() || grid[row][column] == 0) {
            return 0;
        }
        grid[row][column] = 0;
        return 1 + area(grid, row - 1, column) + area(grid, row + 1, column) + area(grid, row, column - 1) + area(grid, row, column + 1);
    }
};

```
