# Surrounded Regions

Solution

Given a 2D board containing `'X'` and `'O'` (**the letter O**), capture all regions surrounded by `'X'`.

A region is captured by flipping all `'O'`s into `'X'`s in that surrounded region.

**Example:**

```
X X X X
X O O X
X X O X
X O X X
```

After running your function, the board should be:

```
X X X X
X X X X
X X X X
X O X X
```

**Explanation:**

Surrounded regions shouldn’t be on the border, which means that any `'O'` on the border of the board are not flipped to `'X'`. Any `'O'` that is not on the border and it is not connected to an `'O'` on the border will be flipped to `'X'`. Two cells are connected if they are adjacent cells connected horizontally or vertically.

**Solution:**

**Basic Idea** Run the dfs on the boarder rows and column if current cell O, and replace all O's to new character let say P.
Then replace all left over O in matrix to X after this revert all P with O.

**Step**

1. Run dfs for first row and replace all O to P
2. Run dfs for last row and replace all O to P
3. Run dfs for first column and replace all O to P
4. Run dfs for last column and replace all O to P
5. Replaced all the reamaining O with X
6. Repalce all P with O

```swift
class Solution {
    func solve(_ board: inout [[Character]]) {
        let m = board.count
        if m == 0 {return;}
        let n = board[0].count;
        for i in 0..<m  {
            if board[i][0] == "O" {
                dfs(&board, i, 0);
            }
        }
        
        for i in 0..<m {
            if board[i][n - 1] == "O" {
                dfs(&board, i, n - 1);
            }
            
        }
        
        for j in 0..<n {
            if board[0][j] == "O" {
                dfs(&board, 0, j);
            }
        }
        
        for j in 0..<n {
            if board[m - 1][j] == "O" {
                dfs(&board, m - 1, j);
            }
        }
        
        for i in 0..<m {
            for j in 0..<n {
                if board[i][j] == "O" {
                    board[i][j] = "X";
                }
            }
        }
        
        for i in 0..<m {
            for j in 0..<n {
                if board[i][j] == "P" {
                    board[i][j] = "O";
                }
            }
        }
        
    }
    
    func dfs(_ board: inout [[Character]],_ x: Int,_ y: Int) {
        if(x >= 0 && x < board.count && y >= 0 && y < board[0].count && board[x][y] == "O") {
            board[x][y] = "P";
            dfs(&board, x + 1, y);
            dfs(&board, x, y + 1);
            dfs(&board, x - 1, y);
            dfs(&board, x, y - 1);
        }
    }
}
```

