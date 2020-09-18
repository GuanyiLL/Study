# Description

Merge two sorted linked lists and return it as a new list. The new list should be made by splicing together the nodes of the first two lists.

#### Ex

```
Input: 1->2->4, 1->3->4
Output: 1->1->2->3->4->4

```

#Code

```cpp

/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution {
public:
    ListNode* mergeTwoLists(ListNode* l1, ListNode* l2) {
        // ListNode res(0);
        // ListNode *current = &res;
        // while(l1 && l2) {
        //     if (l1->val < l2->val) {
        //         current->next = l1;
        //         l1 = l1->next;
        //     } else {
        //         current->next = l2;
        //         l2 = l2->next;
        //     }
        //     current = current->next;
        // }
        // current->next = l1 ? l1 : l2;
        // return res.next;
        
        if (l1 == NULL) return l2;
        if (l2 == NULL) return l1;
        if (l1->val < l2->val) {
            l1->next = mergeTwoLists(l1->next, l2);
            return l1;
        } else {
            l2->next = mergeTwoLists(l2->next, l1);
            return l2;
        }
    }
};

```
