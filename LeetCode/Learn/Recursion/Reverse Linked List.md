Reverse a singly linked list.

**Example:**

```
Input: 1->2->3->4->5->NULL
Output: 5->4->3->2->1->NULL
```

**Follow up:**

A linked list can be reversed either iteratively or recursively. Could you implement both?

**Solution**

```swift
func reverseList(_ head: ListNode?) -> ListNode? {
    let newhead = helper(head)
    head?.next = nil
    return newhead
}

func helper(_ head: ListNode?) -> ListNode? {
    guard let head = head else { return nil }
    guard let next = head.next else { return head }
    
    let newhead = helper(next)
    
    next.next = head
    return newhead
}
```

