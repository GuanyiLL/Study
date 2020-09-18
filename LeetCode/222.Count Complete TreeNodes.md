# Count Complete Tree Nodes

Given a **complete** binary tree, count the number of nodes.

**Note:**

**Definition of a complete binary tree from [Wikipedia](http://en.wikipedia.org/wiki/Binary_tree#Types_of_binary_trees):**
In a complete binary tree every level, except possibly the last, is completely filled, and all nodes in the last level are as far left as possible. It can have between 1 and 2h nodes inclusive at the last level h.

**Example:**

```
Input: 
    1
   / \
  2   3
 / \  /
4  5 6

Output: 6
```

**Solution**

```swift
func countNodes(_ root: TreeNode?) -> Int {
    guard let root = root  else{
        return 0
    }
    return countNodeRec(root)
}

private func countNodeRec(_ node: TreeNode?) -> Int{
    if node == nil {
        return 0
    }
    
    return countNodeRec(node?.left) + countNodeRec(node?.right) + 1
    
}
```

