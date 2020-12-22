You are given two **non-empty** linked lists representing two non-negative integers. The digits are stored in **reverse order**, and each of their nodes contains a single digit. Add the two numbers and return the sum as a linked list.

You may assume the two numbers do not contain any leading zero, except the number 0 itself.

**Example 1:**

```
Input: l1 = [2,4,3], l2 = [5,6,4]
Output: [7,0,8]
Explanation: 342 + 465 = 807.
```

**Example 2:**

```
Input: l1 = [0], l2 = [0]
Output: [0]
```

**Example 3:**

```
Input: l1 = [9,9,9,9,9,9,9], l2 = [9,9,9,9]
Output: [8,9,9,9,0,0,0,1]
```

**Solution**

```swift
func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
    var carryBit = 0
    var l1 = l1
    var l2 = l2
    let res = ListNode(-1)
    var tmp = res
    while l1 != nil || l2 != nil || carryBit == 1 {
        let left = l1?.val ?? 0
        let right = l2?.val ?? 0
    
        var sum = left + right + carryBit
        if sum > 9 {
            sum -= 10
            carryBit = 1
        } else {
            carryBit = 0
        }
        
        let node = ListNode(sum)
        tmp.next = node
        tmp = tmp.next!
        
        l1 = l1?.next
        l2 = l2?.next
    }
    
    return res.next
}
```

