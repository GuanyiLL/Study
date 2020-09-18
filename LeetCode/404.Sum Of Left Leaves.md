# Description

Find the sum of all left leaves in a given binary tree.

#### Ex1:

```

    3
   / \
  9  20
    /  \
   15   7

There are two left leaves in the binary tree, with values 9 and 15 respectively. Return 24.

```

## Thinking

需要求出的只有左侧叶子的和，而不是所有左侧节点与叶子的和。

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
    int sumOfLeftLeaves(TreeNode* root) {
        if(root == NULL) return 0;
        int result = 0;
        if(root->left != NULL && root->left->left == NULL&&root->left->right == NULL) result += root->left->val;
        result += sumOfLeftLeaves(root->left);
        result += sumOfLeftLeaves(root->right);
        return result;
    }
};

```
