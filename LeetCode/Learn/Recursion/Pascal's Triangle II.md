Given an integer `rowIndex`, return the `rowIndexth` row of the Pascal's triangle.

Notice that the row index starts from **0**.

**Example 1:**

```
Input: rowIndex = 3
Output: [1,3,3,1]
```

**Example 2:**

```
Input: rowIndex = 0
Output: [1]
```

**Example 3:**

```
Input: rowIndex = 1
Output: [1,1]
```

**Solution**

```swift
func getRow(_ rowIndex: Int) -> [Int] {
		guard rowIndex > 0 else {
				return [1]
		}
		if rowIndex == 1 { return [1, 1] }
		let previous = getRow(rowIndex - 1)
		var ret = [Int]()
		ret.append(1)
		for i in 1..<previous.count {
				ret.append(previous[i] + previous[i-1])
		}
		ret.append(1)
		return ret          
}
```

