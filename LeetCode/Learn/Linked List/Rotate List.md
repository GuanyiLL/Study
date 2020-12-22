Given the `head` of a linked list, rotate the list to the right by `k` places.

 

**Example 1:**

```
Input: head = [1,2,3,4,5], k = 2
Output: [4,5,1,2,3]
```

**Example 2:**

```
Input: head = [0,1,2], k = 4
Output: [2,0,1]
```

**Solution**

```swift
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     public var val: Int
 *     public var next: ListNode?
 *     public init() { self.val = 0; self.next = nil; }
 *     public init(_ val: Int) { self.val = val; self.next = nil; }
 *     public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
 * }
 */
class Solution {
func rotateRight(_ head: ListNode?, _ k: Int) -> ListNode? {
    if head == nil || head?.next == nil || k == 0  { return head }
    var node1 = head
    var node2 = head
    var length = 0
    while node1 != nil {
        node1 = node1?.next
        length += 1
    }
    node1 = head
    let count = k % length
    if count == 0 { return head }
    for _ in 0..<count {
        node1 = node1?.next
    }
    while node1?.next != nil {
        node1 = node1?.next
        node2 = node2?.next
    }
    let newhead = node2?.next
    node2?.next = nil
    node1?.next = head
    return newhead
}
}
```

