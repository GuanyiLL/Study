Given preorder and inorder traversal of a tree, construct the binary tree.

**Note:**
You may assume that duplicates do not exist in the tree.

For example, given

```
preorder = [3,9,20,15,7]
inorder = [9,3,15,20,7]
```

Return the following binary tree:

```
    3
   / \
  9  20
    /  \
   15   7
```



**Solution**

```swift
func buildTree(_ preorder: [Int], _ inorder: [Int]) -> TreeNode? {
    var map = [Int :Int]()
    for i in 0..<inorder.count {
        map[inorder[i]] = i
    }
    var root = 0
    return buildTree(map, preorder, &root, 0, inorder.count - 1)
}

func buildTree(_ inorder: [Int:Int],_ preorder: [Int], _ root:inout Int, _ s: Int, _ e: Int) -> TreeNode? {
    if s > e { return nil }
    
    let rootVal = preorder[root]
    let n = TreeNode(rootVal)
    root += 1
    
    let rootIndex = inorder[rootVal]!
    
    n.left = buildTree(inorder, preorder, &root, s, rootIndex - 1)
    n.right = buildTree(inorder, preorder, &root, rootIndex + 1, e)
    return n
}
```

