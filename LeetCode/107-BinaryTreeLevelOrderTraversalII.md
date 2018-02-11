# Description

Given a binary tree, return the bottom-up level order traversal of its nodes' values. (ie, from left to right, level by level from leaf to root).

For example:
Given binary tree `[3,9,20,null,null,15,7]`,
```
    3
   / \
  9  20
    /  \
   15   7

```

return its bottom-up level order traversal as:

```
[
  [15,7],
  [9,20],
  [3]
]
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
    void dfs(vector<vector<int>> &list, TreeNode * root, int depth){
        if(root==NULL)
            return;
        if(list.size()<depth)
            list.resize(depth);
        list[depth-1].push_back(root->val);
        dfs(list,root->left,depth+1);
        dfs(list,root->right,depth+1);
    }
    vector<vector<int>> levelOrderBottom(TreeNode* root) {
        vector<vector<int>> list={};
        dfs(list,root,1);
        reverse(list.begin(),list.end());
        return list;
    }
};
```


