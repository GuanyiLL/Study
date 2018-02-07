# Description

Given a binary tree, you need to compute the length of the diameter of the tree. The diameter of a binary tree is the length of the longest path between any two nodes in a tree. This path may or may not pass through the root.

#### Ex

```

          1
         / \
        2   3
       / \
      4   5

```

Return 3, which is the length of the path [4,2,1,3] or [5,2,1,3].

Note: The length of path between two nodes is represented by the number of edges between them.

# Code

```cpp

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
    int maxDepth(TreeNode* root, int &depth){
        if(!root)
            return 0;
        int left = maxDepth(root->left, depth);
        int right = maxDepth(root->right, depth);
        depth = max(depth, left+right);
        return max(left,right) + 1;
    }
    int diameterOfBinaryTree(TreeNode* root) {
        int depth = 0;
        maxDepth(root, depth);
        return depth;
    }
};

```
