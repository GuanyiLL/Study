# Description
Given a Binary Search Tree and a target number, return true if there exist two elements in the BST such that their sum is equal to the given target.

#### Ex1:

```
Input: 
    5
   / \
  3   6
 / \   \
2   4   7

Target = 9

Output: True

```

#### Ex2:

```

Input:
    5
   / \
  3   6
 / \   \
2   4   7

Target = 28

Output: False

```

# Code

```c++

class Solution {
public:
    bool find(TreeNode* root, int k, set<int>* s) {
        if (root == NULL) return false;
        if (s->count(k - root->val)) return true;
        s->insert(root->val);
        return find(root->left,k,s) || find(root->right, k, s);
    }
    
    bool findTarget(TreeNode* root, int k) {
        set<int> s;
        return find(root, k, &s);
    }
};

```
