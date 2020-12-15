Given inorder and postorder traversal of a tree, construct the binary tree.

**Note:**
You may assume that duplicates do not exist in the tree.

For example, given

```
inorder = [9,3,15,20,7]
postorder = [9,15,7,20,3]
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

func buildTree(_ inorder: [Int], _ postorder: [Int]) -> TreeNode? {
    if inorder.count == 0 || postorder.count == 0 {
        return nil
    }
    var map = [Int: Int]()
    for i in 0..<inorder.count {
        map[inorder[i]] = i
    }
    return buildTree(inorder, postorder,  0, inorder.count - 1, 0, postorder.count - 1, map)
}

func buildTree(_ inorder: [Int], _ postorder: [Int], _ inorderBegin: Int, _ inorderEnd: Int, _ postorderBegin: Int, _ postorderEnd: Int, _ inorderPosition: [Int: Int]) -> TreeNode? {
    if inorderBegin > inorderEnd || postorderBegin > postorderEnd {
        return nil
    }
    let rootVal = postorder[postorderEnd]
    let root = TreeNode(rootVal)
    
    let rootPosition = inorderPosition[rootVal]!

    root.left = buildTree(inorder, postorder, inorderBegin, rootPosition - 1, postorderBegin, postorderBegin + rootPosition - inorderBegin - 1, inorderPosition)
    root.right = buildTree(inorder, postorder, rootPosition + 1, inorderEnd, postorderBegin + rootPosition - inorderBegin, postorderEnd - 1, inorderPosition)
    
    return root
}
```

Faster 

```swift
func buildTree(_ inorder: [Int], _ postorder: [Int]) -> TreeNode? {
        var root = postorder.count - 1
        var map = [Int: Int]()
        for i in 0 ..< inorder.count {
            map[inorder[i]] = i
        }
        return buildHelper(map, postorder, &root, 0, inorder.count-1)
    }
    
    func buildHelper(_ inOrder: [Int: Int], _ postOrder: [Int], _ root: inout Int, _ s: Int, _ e: Int) -> TreeNode? {
        
        if s > e{
            return nil
        }
        
        
        let val = postOrder[root]
        var rootNode = TreeNode(val)
        root -= 1
        //Find the partition
        var index = inOrder[val]!
        rootNode.right = buildHelper(inOrder, postOrder, &root, index+1, e)
        rootNode.left = buildHelper(inOrder, postOrder, &root, s, index-1)
        return rootNode
    }
```

