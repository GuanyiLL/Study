# Description 


Given a binary tree, return all root-to-leaf paths.

For example, given the following binary tree:

```

   1
 /   \
2     3
 \
  5

```

All root-to-leaf paths are:

```

["1->2->3", "1->3"]

```

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
    vector<string> binaryTreePaths(TreeNode* root) {
        vector<string> res;
        searchBT(root, "", res);
        return res;
    }
    
    void searchBT(TreeNode* node, string path, vector<string> &res) {
        if (node == NULL) return;
        if (node->left == NULL && node->right == NULL) res.push_back(path + to_string(node->val));
        if (node->left != NULL) searchBT(node->left, path + to_string(node->val) + "->", res);
        if (node->right != NULL) searchBT(node -> right, path + to_string(node->val) + "->", res);
    }
    
};

```
