Given a singly linked list, determine if it is a palindrome.

**Example 1:**

```
Input: 1->2
Output: false
```

**Example 2:**

```
Input: 1->2->2->1
Output: true
```

**Follow up:**
Could you do it in O(n) time and O(1) space?

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
    func isPalindrome(_ head: ListNode?) -> Bool {
        var count = 0
        var idx = 0
        var tmp = head
        let res = helper(head, &tmp,&count, &idx)
        return res
    }

    func helper(_ head: ListNode?,_ tmp:inout ListNode?, _ count: inout Int, _ index: inout Int) -> Bool {
        if head == nil {
            return true
        }
        count += 1
        let res = helper(head?.next, &tmp, &count, &index)
        if res == false { return false }
    
        if tmp?.val != head?.val {
            return false
        }
    
        tmp = tmp?.next
        index += 1
    
        if index > count / 2 {
            return true
        }
        return true
    }

}
```

