Implement the `BSTIterator` class that represents an iterator over the **[in-order traversal](https://en.wikipedia.org/wiki/Tree_traversal#In-order_(LNR))** of a binary search tree (BST):

- `BSTIterator(TreeNode root)` Initializes an object of the `BSTIterator` class. The `root` of the BST is given as part of the constructor. The pointer should be initialized to a non-existent number smaller than any element in the BST.
- `boolean hasNext()` Returns `true` if there exists a number in the traversal to the right of the pointer, otherwise returns `false`.
- `int next()` Moves the pointer to the right, then returns the number at the pointer.

Notice that by initializing the pointer to a non-existent smallest number, the first call to `next()` will return the smallest element in the BST.

You may assume that `next()` calls will always be valid. That is, there will be at least a next number in the in-order traversal when `next()` is called.

 

**Example 1:**

![img](https://assets.leetcode.com/uploads/2018/12/25/bst-tree.png)

```
Input
["BSTIterator", "next", "next", "hasNext", "next", "hasNext", "next", "hasNext", "next", "hasNext"]
[[[7, 3, 15, null, null, 9, 20]], [], [], [], [], [], [], [], [], []]
Output
[null, 3, 7, true, 9, true, 15, true, 20, false]

Explanation
BSTIterator bSTIterator = new BSTIterator([7, 3, 15, null, null, 9, 20]);
bSTIterator.next();    // return 3
bSTIterator.next();    // return 7
bSTIterator.hasNext(); // return True
bSTIterator.next();    // return 9
bSTIterator.hasNext(); // return True
bSTIterator.next();    // return 15
bSTIterator.hasNext(); // return True
bSTIterator.next();    // return 20
bSTIterator.hasNext(); // return False
```



**Solution**

```swift
class BSTIterator {
    private var idx = -1
    private var sequence = [Int]()
    init(_ root: TreeNode?) {
        inorder(root: root)
    }
    
    func next() -> Int {
        if hasNext() {
            let val = sequence[idx + 1]
            idx += 1
            return val
        } else {
            return -1
        }
    }
    
    func hasNext() -> Bool {
        return idx < sequence.count - 1
    }
    
    private func inorder(root: TreeNode?) {
        guard let node = root else {
            return
        }
        inorder(root: node.left)
        sequence.append(node.val)
        inorder(root: node.right)
    }
}
```

- Time complexity :$O(N)$ is the time taken by the constructor for the iterator. The problem statement only asks us to analyze the complexity of the two functions, however, when implementing a class, it's important to also note the time it takes to initialize a new object of the class and in this case it would be linear in terms of the number of nodes in the BST. In addition to the space occupied by the new array we initialized, the recursion stack for the inorder traversal also occupies space but that is limited to $O(h)$ where $h$ is the height of the tree.
  - `next()` would take $O(1)$
  - `hasNext()` would take $O(1)$
- Space complexity : O(N)*O*(*N*) since we create a new array to contain all the nodes of the BST. This doesn't comply with the requirement specified in the problem statement that the maximum space complexity of either of the functions should be $O(h)$ where $h$ is the height of the tree and for a well balanced BST, the height is usually $logN$. So, we get great time complexities but we had to compromise on the space. Note that the new array is used for both the function calls and hence the space complexity for both the calls is $O(N)$.

```swift
class BSTIterator {
    private var stack = [TreeNode]()
    init(_ root: TreeNode?) {
        if root == nil { return }
        putIntoStack(root!)
    }
    
    func next() -> Int {
        if hasNext() {
            let node = stack.removeLast()
            if node.right != nil {
                putIntoStack(node.right)
            }
            return node.val
        }
        return -1
    }
    
    func hasNext() -> Bool {
        return stack.count > 0
    }
    
    private func putIntoStack(_ node: TreeNode?) {
        var node = node
        while node != nil {
            stack.append(node!)
            node = node!.left
        }
    }
}
```

- Time complexity : The time complexity for this approach is very interesting to analyze. Let's look at the complexities for both the functions in the class:

  - `hasNext` is the easier of the lot since all we do in this is to return true if there are any elements left in the stack. Otherwise, we return false. So clearly, this is an $O(1)$ operation every time. Let's look at the more complicated function now to see if we satisfy all the requirements in the problem statement

  - `next` involves two major operations. One is where we pop an element from the stack which becomes the next smallest element to return. This is a $O(1)$ operation. However, we then make a call to our helper function `_inorder_left` which iterates over a bunch of nodes. This is clearly a linear time operation i.e.  $O(n)$ in the worst case. This is true.

    > However, the important thing to note here is that we only make such a call for nodes which have a right child. Otherwise, we simply return. Also, even if we end up calling the helper function, it won't always process N nodes. They will be much lesser. Only if we have a skewed tree would there be N nodes for the root. But that is the only node for which we would call the helper function.

    Thus, the amortized (average) time complexity for this function would still be $O(1)$ which is what the question asks for. We don't need to have a solution which gives constant time operations for *every* call. We need that complexity on average and that is what we get.

- Space complexity: The space complexity is $O(N)$  ($N$ is the number of nodes in the tree), which is occupied by our custom stack for simulating the inorder traversal. Again, we satisfy the space requirements as well as specified in the problem statement.