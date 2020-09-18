# Description

In MATLAB, there is a very useful function called 'reshape', which can reshape a matrix into a new one with different size but keep its original data.

You're given a matrix represented by a two-dimensional array, and two positive integers r and c representing the row number and column number of the wanted reshaped matrix, respectively.

The reshaped matrix need to be filled with all the elements of the original matrix in the same row-traversing order as they were.

If the 'reshape' operation with given parameters is possible and legal, output the new reshaped matrix; Otherwise, output the original matrix.

#### Ex1:

> Input: 
> nums = 
> [[1,2],
>  [3,4]]
> r = 1, c = 4
> Output: 
> [[1,2,3,4]]
> Explanation:
> The row-traversing of nums is [1,2,3,4]. The new reshaped matrix is a 1 * 4 matrix, fill it row by row by using the previous list.

#### Ex2:

> Input:
> nums =
> [[1,2],
> [3,4]]
> r = 2, c = 4
> Output:
> [[1,2],
> [3,4]]
> Explanation:
> There is no way to reshape a 2 * 2 matrix to a 2 * 4 matrix. So output the original matrix.

#### Note:
1. The height and width of the given matrix is in range [1, 100].
2. The given r and c are all positive.

# Code

```c++

class Solution {
public:
    vector<vector<int>> matrixReshape(vector<vector<int>>& nums, int r, int c) {
        int column = nums[0].size();
        int row = nums.size();
        if (column <= c && row <= r) {
            return nums;
        }
        int total = column * row;
        vector<vector<int>> res(r, vector<int>(c, 0));
    
        int x = 0, y = 0, idx = 0;
        int xx = 0, yy = 00;
        while(idx < total) {
            if ( idx > 0 && idx % column == 0) {
                y++;
                x = 0;
            }
            if (idx > 0 && idx % c == 0) {
                yy++;
                xx = 0;
            }
            res[yy][xx] = nums[y][x];
            xx++;
            x++;
            idx++;
        }
        return res;
    }
};

```
