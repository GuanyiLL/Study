# Description

Given two binary trees, write a function to check if they are the same or not.

Two binary trees are considered the same if they are structurally identical and the nodes have the same value.

#### EX1:

```

Input:     1         1
          / \       / \
         2   3     2   3

        [1,2,3],   [1,2,3]

Output: true

```

#### Ex2:

```

Input:     1         1
          /           \
         2             2

        [1,2],     [1,null,2]

Output: false

```

#### Ex3:

```
Input:     1         1
          / \       / \
         2   1     1   2

        [1,2,1],   [1,1,2]

Output: false

```

# Code

```c++

/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode(int x) : val(x), left(NULL), right(NULL) {}
 * };
 */
class Solution {
public:
    bool isSameTree(TreeNode* p, TreeNode* q) {
        if (p == NULL && q == NULL) return true;
        if (p == NULL || q == NULL || p->val != q->val) {
            return false;
        }
        return isSameTree(p->left, q->left) && isSameTree(p->right, q->right);
    }
};
```

```swift
func isSameTree(_ p: TreeNode?, _ q: TreeNode?) -> Bool {
    if (p == nil && q == nil) {
        return true
    }
    if (p == nil && q != nil) || (p != nil && q == nil) {
        return false
    }
    
    var q1 = [TreeNode]()
    var q2 = [TreeNode]()
    
    q1.append(p!)
    q2.append(q!)

    while (!q1.isEmpty && !q2.isEmpty) {
        let t1 = q1.removeLast()
        let t2 = q2.removeLast()
        
        if t1.val != t2.val {
            return false
        }
        
        if (t1.left != nil && t2.left != nil) {
            q1.append(t1.left!)
            q2.append(t2.left!)
        } else if (t1.left == nil && t2.left != nil) || (t1.left != nil && t2.left == nil) {
            return false
        }
        if (t1.right != nil && t2.right != nil) {
            q2.append(t2.right!)
            q1.append(t1.right!)
        } else if (t1.right == nil && t2.right != nil) || (t1.right != nil && t2.right == nil) {
            return false
        }
    }
    
    return true
}
```

