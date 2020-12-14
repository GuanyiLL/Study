An `image` is represented by a 2-D array of integers, each integer representing the pixel value of the image (from 0 to 65535).

Given a coordinate `(sr, sc)` representing the starting pixel (row and column) of the flood fill, and a pixel value `newColor`, "flood fill" the image.

To perform a "flood fill", consider the starting pixel, plus any pixels connected 4-directionally to the starting pixel of the same color as the starting pixel, plus any pixels connected 4-directionally to those pixels (also with the same color as the starting pixel), and so on. Replace the color of all of the aforementioned pixels with the newColor.

At the end, return the modified image.

**Example 1:**

```
Input: 
image = [[1,1,1],[1,1,0],[1,0,1]]
sr = 1, sc = 1, newColor = 2
Output: [[2,2,2],[2,2,0],[2,0,1]]
Explanation: 
From the center of the image (with position (sr, sc) = (1, 1)), all pixels connected 
by a path of the same color as the starting pixel are colored with the new color.
Note the bottom corner is not colored 2, because it is not 4-directionally connected
to the starting pixel.
```



**Solution**

```swift
func bfs(_ image:inout [[Int]],_ row: Int, _ col: Int,_ newColor: Int, _ oldColor: Int) {
    if row > image.count - 1 || row < 0 || col < 0 || col > image[0].count - 1 || newColor == oldColor {
        return
    }
    if image[row][col] == oldColor {
        image[row][col] = newColor
    } else {
        return
    }
    bfs(&image, row - 1, col, newColor, oldColor)
    bfs(&image, row, col + 1, newColor, oldColor)
    bfs(&image, row + 1, col, newColor, oldColor)
    bfs(&image, row, col - 1, newColor, oldColor)
}

func floodFill(_ image: [[Int]], _ sr: Int, _ sc: Int, _ newColor: Int) -> [[Int]] {
    var res = image
    let oldColor = image[sr][sc]
    bfs(&res, sr, sc, newColor, oldColor)
    return res
}
```

