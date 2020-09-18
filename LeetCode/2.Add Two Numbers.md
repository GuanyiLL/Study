# Description

You are given two non-empty linked lists representing two non-negative integers. The digits are stored in reverse order and each of their nodes contain a single digit. Add the two numbers and return it as a linked list.

You may assume the two numbers do not contain any leading zero, except the number 0 itself.

## EX1 

```
Input: (2 -> 4 -> 3) + (5 -> 6 -> 4)
Output: 7 -> 0 -> 8
Explanation: 342 + 465 = 807.
```

## Code

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
    ListNode* addTwoNumbers(ListNode* l1, ListNode* l2) {
        int carry = 0;
        ListNode* res = new ListNode(0);
        ListNode* current = res;
        while(l1 || l2)
        {
            int first = l1 ? l1->val : 0;
            int second = l2 ? l2->val : 0;
            int sum = first + second + carry;
            if(sum > 9)
            {
                carry  = sum/10;
                sum -= 10;
            } else
            {
                carry  = 0;
            }
            ListNode* nextNode = new ListNode(sum);
            current->next = nextNode;
            current = current->next;
            if(l1) l1 = l1->next;
            if(l2) l2 = l2->next;
        }
        if(carry)
            current->next = new ListNode(carry);
        return res->next;
    }
};

```
