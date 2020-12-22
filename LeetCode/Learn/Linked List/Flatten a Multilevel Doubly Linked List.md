You are given a doubly linked list which in addition to the next and previous pointers, it could have a child pointer, which may or may not point to a separate doubly linked list. These child lists may have one or more children of their own, and so on, to produce a multilevel data structure, as shown in the example below.

Flatten the list so that all the nodes appear in a single-level, doubly linked list. You are given the head of the first level of the list.

 

**Example 1:**



```
Input: head = [1,2,3,4,5,6,null,null,null,7,8,9,10,null,null,11,12]
Output: [1,2,3,7,8,11,12,9,10,4,5,6]
```

**Example 2:**

```
Input: head = [1,2,null,3]
Output: [1,3,2]
Explanation:

The input multilevel linked list is as follows:

  1---2---NULL
  |
  3---NULL
```

**Example 3:**

```
Input: head = []
Output: []
```

 

**How multilevel linked list is represented in test case:**

We use the multilevel linked list from **Example 1** above:

```
 1---2---3---4---5---6--NULL
         |
         7---8---9---10--NULL
             |
             11--12--NULL
```

The serialization of each level is as follows:

```
[1,2,3,4,5,6,null]
[7,8,9,10,null]
[11,12,null]
```

To serialize all levels together we will add nulls in each level to signify no node connects to the upper node of the previous level. The serialization becomes:

```
[1,2,3,4,5,6,null]
[null,null,7,8,9,10,null]
[null,11,12,null]
```

Merging the serialization of each level and removing trailing nulls we obtain:

```
[1,2,3,4,5,6,null,null,null,7,8,9,10,null,null,11,12]
```

**Solution**

```swift

public class Node {
    public var val: Int
    public var prev: Node?
    public var next: Node?
    public var child: Node?
    public init(_ val: Int) {
        self.val = val
        self.prev = nil
        self.next = nil
        self.child  = nil
    }
}

func flatten(_ head: Node?) -> Node? {
    if head == nil { return head }
    let head = head
    var curr = head
    
    while curr != nil {
        // current node doesn't have a child
        if curr?.child == nil {
            curr = curr?.next
            continue
        }
        // head of child list
        let child = curr?.child
        // tail of child list
        var tail = child
        while tail?.next != nil { tail = tail?.next }

        // Merge child link
        // Step1: break child
        curr?.child = nil
        // Step2: connect child
        child?.prev = curr
        // Step3: connect tail
        if curr?.next != nil {
            curr?.next?.prev = tail
        }
        tail?.next = curr?.next

        // Update curr
        curr?.next = child
        curr = curr?.next
    }
    return head
}

//func flatten(_ head: Node?) -> Node? {
//    if head == nil { return head }
//    var node = head
//    while node?.next != nil || node?.child != nil {
//        if  node!.child != nil {
//            let tail = node!.next
//
//            node!.next = node?.child
//            node!.child?.prev = node
//            node?.child = nil
//
//            var childHead = flatten(node!.next)
//
//            while childHead?.next != nil {
//                childHead = childHead?.next
//            }
//
//            childHead?.next = tail
//            tail?.prev = childHead
//        }
//        node = node!.next
//    }
//    return head
//}
```

