#Description

Given a non-empty binary tree, return the average value of the nodes on each level in the form of an array.

#### Ex1

![Feature-1](/img/LeetCode637.jpeg)

#### Note:

  The range of node's value is in the range of 32-bit signed integer.

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
    vector<double> averageOfLevels(TreeNode* root) {
        vector<double> res;
        queue<TreeNode> q;
        q.push(*root);
        while (!q.empty()) {
            size_t count = q.size();
            double sum = 0;
            for (int idx = 0; idx < count; idx++) {
                TreeNode node = q.front();
                q.pop();
                if (node.left) q.push(*node.left);
                if (node.right) q.push(*node.right);
                sum += node.val;
            }
            res.push_back(sum / count);
        }
        return res;
    }
};

```
