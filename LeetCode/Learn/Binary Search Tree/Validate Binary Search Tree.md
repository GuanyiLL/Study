Given the `root` of a binary tree, *determine if it is a valid binary search tree (BST)*.

A **valid BST** is defined as follows:

- The left subtree of a node contains only nodes with keys **less than** the node's key.
- The right subtree of a node contains only nodes with keys **greater than** the node's key.
- Both the left and right subtrees must also be binary search trees.

 

**Example 1:**

![img](https://assets.leetcode.com/uploads/2020/12/01/tree1.jpg)

```
Input: root = [2,1,3]
Output: true
```

**Example 2:**

![img](https://assets.leetcode.com/uploads/2020/12/01/tree2.jpg)

```
Input: root = [5,1,4,null,null,3,6]
Output: false
Explanation: The root node's value is 5 but its right child's value is 4.
```

**Solution**

```swift
class Solution {
    var prev = -1

    func isValidBST(_ root: TreeNode?) -> Bool {
        guard let node = root else { return true }
        
        if !isValidBST(node.left) {
            return false
        }
        
        if (prev != -1 && node.val <= prev) {
            return false;
        }
        prev = node.val
        return  isValidBST(node.right)
    }

}
```

```swift
class Solution {
    func isValidBST(_ root: TreeNode?) -> Bool {
        return isValidBSTHelper(root, maxValue: nil, minValue: nil)
    }
    
    func isValidBSTHelper(_ root: TreeNode?, maxValue: Int?, minValue: Int?) -> Bool {
        guard let root = root else  { return true }

        if let max = maxValue, root.val >= max { return false }
        if let min = minValue, root.val <= min { return false }

        return isValidBSTHelper(root.left, maxValue: root.val, minValue: minValue) &&
            isValidBSTHelper(root.right, maxValue: maxValue, minValue: root.val)
}
}
```

