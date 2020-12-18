Merge two sorted linked lists and return it as a new **sorted** list. The new list should be made by splicing together the nodes of the first two lists.

```
Input: l1 = [1,2,4], l2 = [1,3,4]
Output: [1,1,2,3,4,4]
```

**Example 2:**

```
Input: l1 = [], l2 = []
Output: []
```

**Example 3:**

```
Input: l1 = [], l2 = [0]
Output: [0]
```

**Solution**

```swift
func mergeTwoLists(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
    guard let l1 = l1 else {
        return l2
    }
    
    guard let l2 = l2 else {
        return l1
    }

    var n = ListNode()

    if l1.val < l2.val {
        n = l1
        n.next = mergeTwoLists(l1.next, l2)
    } else {
        n = l2
        n.next = mergeTwoLists(l1, l2.next)
    }
    return n
}
```

