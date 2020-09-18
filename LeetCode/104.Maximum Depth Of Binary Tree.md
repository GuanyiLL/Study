# Description

Given a binary tree, find its maximum depth.

The maximum depth is the number of nodes along the longest path from the root node down to the farthest leaf node.

# Code

```c++
  //Depth-first-search

  int maxDepth(TreeNode* root) {
        if (!root) return 0;
        int res = 0;
        queue<TreeNode *> q;
        q.push(root);
        while(!q.empty()){
            size_t count = q.size();
            for (int i = 0; i < count; i++) {
                TreeNode *f = q.front();
                q.pop();
                if (f->left) q.push(f->left);
                if (f->right) q.push(f->right);
            }
            res++;
        }
        return res;
    }

//    Breadth-first-search

//    int maxDepth(TreeNode * root) {
//        return root == NULL ? 0 : max(maxDepth(root -> left), maxDepth(root -> right)) + 1;
//    }


```
