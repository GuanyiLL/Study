You are given the `root` node of a binary search tree (BST) and a `value` to insert into the tree. Return *the root node of the BST after the insertion*. It is **guaranteed** that the new value does not exist in the original BST.

**Notice** that there may exist multiple valid ways for the insertion, as long as the tree remains a BST after insertion. You can return **any of them**.

 

**Example 1:**

![img](https://assets.leetcode.com/uploads/2020/10/05/insertbst.jpg)

```
Input: root = [4,2,7,1,3], val = 5
Output: [4,2,7,1,3,5]
Explanation: Another accepted tree is:
```

**Example 2:**

```
Input: root = [40,20,60,10,30,50,70], val = 25
Output: [40,20,60,10,30,50,70,null,null,25]
```

**Example 3:**

```
Input: root = [4,2,7,1,3,null,null,null,null,null,null], val = 5
Output: [4,2,7,1,3,5]
```

 

**Constraints:**

- The number of nodes in the tree will be in the range `[0, 104]`.
- `-108 <= Node.val <= 108`
- All the values `Node.val` are **unique**.
- `-108 <= val <= 108`
- It's **guaranteed** that `val` does not exist in the original BST.

**Solution**

```swift
class Solution {

func insertion(_ node: TreeNode?, _ val: Int) {
    guard let node = node else {
        return
    }
    
    if val < node.val {
        if let leftSubTree = node.left {
            insertion(leftSubTree, val)
        } else {
            let newNode = TreeNode(val)
            node.left = newNode
        }
    } else {
        if let rightSubTree = node.right {
            insertion(rightSubTree, val)
        } else {
            let newNode = TreeNode(val)
            node.right = newNode
        }
    }
}

func insertIntoBST(_ root: TreeNode?, _ val: Int) -> TreeNode? {
    guard let node = root else {
        return TreeNode(val)
    }
    insertion(node, val)
    return node
}
}
```

Best solutions:

```swift

/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     public var val: Int
 *     public var left: TreeNode?
 *     public var right: TreeNode?
 *     public init() { self.val = 0; self.left = nil; self.right = nil; }
 *     public init(_ val: Int) { self.val = val; self.left = nil; self.right = nil; }
 *     public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
 *         self.val = val
 *         self.left = left
 *         self.right = right
 *     }
 * }
 */
class Solution {
    func insertIntoBST(_ root: TreeNode?, _ val: Int) -> TreeNode? {
        // return BST_Insert(root, val)
        return BST_Insert_Iterative(root, val)
    }
    

    func BST_Insert(_ root: TreeNode?, _ data: Int) -> TreeNode? {
        if root == nil {
            return TreeNode(data)
        }

        if data <= (root?.val)! {
            root?.left = BST_Insert(root?.left, data)
        } else {
            root?.right = BST_Insert(root?.right, data)
        }

        return root
    }


    func BST_Insert_Iterative(_ root: TreeNode?, _ data: Int) -> TreeNode? {
        if root == nil {
            return TreeNode(data)
        }
        var pre: TreeNode? = nil
        var curr = root

        while curr != nil {
            pre = curr
            if data < (curr?.val)! {
                curr = curr?.left
            } else {
                curr = curr?.right
            }
        } 

        if data < (pre?.val)! {
            pre?.left = TreeNode(data)
        } else {
            pre?.right = TreeNode(data)
        }

        return root

    }
}
```

