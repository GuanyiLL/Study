Design your implementation of the linked list. You can choose to use a singly or doubly linked list.
A node in a singly linked list should have two attributes: `val` and `next`. `val` is the value of the current node, and `next` is a pointer/reference to the next node.
If you want to use the doubly linked list, you will need one more attribute `prev` to indicate the previous node in the linked list. Assume all nodes in the linked list are **0-indexed**.

Implement the `MyLinkedList` class:

- `MyLinkedList()` Initializes the `MyLinkedList` object.
- `int get(int index)` Get the value of the `indexth` node in the linked list. If the index is invalid, return `-1`.
- `void addAtHead(int val)` Add a node of value `val` before the first element of the linked list. After the insertion, the new node will be the first node of the linked list.
- `void addAtTail(int val)` Append a node of value `val` as the last element of the linked list.
- `void addAtIndex(int index, int val)` Add a node of value `val` before the `indexth` node in the linked list. If `index` equals the length of the linked list, the node will be appended to the end of the linked list. If `index` is greater than the length, the node **will not be inserted**.
- `void deleteAtIndex(int index)` Delete the `indexth` node in the linked list, if the index is valid.

 

**Example 1:**

```
Input
["MyLinkedList", "addAtHead", "addAtTail", "addAtIndex", "get", "deleteAtIndex", "get"]
[[], [1], [3], [1, 2], [1], [1], [1]]
Output
[null, null, null, null, 2, null, 3]

Explanation
MyLinkedList myLinkedList = new MyLinkedList();
myLinkedList.addAtHead(1);
myLinkedList.addAtTail(3);
myLinkedList.addAtIndex(1, 2);    // linked list becomes 1->2->3
myLinkedList.get(1);              // return 2
myLinkedList.deleteAtIndex(1);    // now the linked list is 1->3
myLinkedList.get(1);              // return 3
```

 

**Constraints:**

- `0 <= index, val <= 1000`
- Please do not use the built-in LinkedList library.
- At most `2000` calls will be made to `get`, `addAtHead`, `addAtTail`, `addAtIndex` and `deleteAtIndex`.



**Solution**

```swift
class MyLinkedList1 {
    
    class Node {
        var val: Int
        var next: Node?
        
        init(_ val: Int) {
            self.val = val
        }
    }
    
    private var head: Node?
    private var tail: Node?
    public private(set) var size = 0

    /** Initialize your data structure here. */
    init() {
        
    }
    
    /** Get the value of the index-th node in the linked list. If the index is invalid, return -1. */
    // Time: O(index), Space: O(1)
    func get(_ index: Int) -> Int {
        guard index >= 0, index < size else { return -1 }
        guard index != 0 else { return head!.val }
        guard index != size-1 else { return tail!.val }
        
        var node = head
        for _ in 0..<index {
            node = node?.next
        }
        
        return node!.val
    }
    
    /** Add a node of value val before the first element of the linked list. After the insertion, the new node will be the first node of the linked list. */
    // Time: O(1), Space: O(1)
    func addAtHead(_ val: Int) {
        let newNode = Node(val)
        newNode.next = head
        head = newNode
        
        if tail == nil {
            tail = head
        }
        
        size += 1
    }
    
    /** Append a node of value val to the last element of the linked list. */
    // Time: O(1), Space: O(1)
    func addAtTail(_ val: Int) {
        let newNode = Node(val)
        tail?.next = newNode
        tail = newNode
        
        if head == nil {
            head = tail
        }
        
        size += 1
    }
    
    /** Add a node of value val before the index-th node in the linked list. If index equals to the length of linked list, the node will be appended to the end of linked list. If index is greater than the length, the node will not be inserted. */
    // Time: O(index), Space: O(1)
    func addAtIndex(_ index: Int, _ val: Int) {
        guard index >= 0, index <= size else { return }
        
        guard index != 0 else {
            addAtHead(val)
            return
        }
        
        guard index != size else {
            addAtTail(val)
            return
        }
        
        var nodeToInsertAfter = head
        for _ in 1..<index {
            nodeToInsertAfter = nodeToInsertAfter?.next
        }
        
        let newNode = Node(val)
        newNode.next = nodeToInsertAfter?.next
        nodeToInsertAfter?.next = newNode
        size += 1
    }
    
    /** Delete the index-th node in the linked list, if the index is valid. */
    // Time: O(index), Space: O(1)
    func deleteAtIndex(_ index: Int) {
        guard index >= 0, index < size else { return }
        
        var nodeToDeleteAfter: Node?
        var nodeToDelete: Node?
        
        if index == 0 {
            nodeToDeleteAfter = nil
            nodeToDelete = head
        } else {
            nodeToDeleteAfter = head
            for _ in 1..<index {
                nodeToDeleteAfter = nodeToDeleteAfter?.next
            }
            nodeToDelete = nodeToDeleteAfter?.next
        }
        
        let nodeToDeleteBefore = nodeToDelete?.next
        nodeToDeleteAfter?.next = nodeToDeleteBefore
        nodeToDelete?.next = nil
        
        if nodeToDelete === head {
            head = nodeToDeleteBefore
        }
        
        if nodeToDelete === tail {
            tail = nodeToDeleteAfter
        }
        
        size -= 1
    }
}

/**
 * Your MyLinkedList object will be instantiated and called as such:
 * let obj = MyLinkedList()
 * let ret_1: Int = obj.get(index)
 * obj.addAtHead(val)
 * obj.addAtTail(val)
 * obj.addAtIndex(index, val)
 * obj.deleteAtIndex(index)
 */



 // Double-linked approach
class MyLinkedList {
    
    class Node {
        var val: Int
        var next: Node?
        var prev: Node?
        
        init(_ val: Int) {
            self.val = val
        }
    }

    private var head = Node(0)
    private var tail = Node(0)
    public private(set) var size = 0

    /** Initialize your data structure here. */
    init() {
        head.next = tail
        tail.prev = head
    }
    
    /** Get the value of the index-th node in the linked list. If the index is invalid, return -1. */
    // Time: O(index), Space: O(1)
    func get(_ index: Int) -> Int {
        guard index >= 0, index < size else { return -1 }
        
        var node: Node
        if index < size - index {
            node = head.next!
            for _ in 0..<index {
                node = node.next!
            }
        } else {
            node = tail.prev!
            for _ in 0..<(size-index-1) {
                node = node.prev!
            }
        }
        
        return node.val
    }
    
    /** Add a node of value val before the first element of the linked list. After the insertion, the new node will be the first node of the linked list. */
    // Time: O(1), Space: O(1)
    func addAtHead(_ val: Int) {
        let newNode = Node(val)
        let prevNode = head
        let nextNode = head.next!
        
        prevNode.next = newNode
        newNode.prev = prevNode
        
        newNode.next = nextNode
        nextNode.prev = newNode
        
        size += 1
    }
    
    /** Append a node of value val to the last element of the linked list. */
    // Time: O(1), Space: O(1)
    func addAtTail(_ val: Int) {
        let newNode = Node(val)
        let prevNode = tail.prev!
        let nextNode = tail
        
        prevNode.next = newNode
        newNode.prev = prevNode
        
        newNode.next = nextNode
        nextNode.prev = newNode
        
        size += 1
    }
    
    /** Add a node of value val before the index-th node in the linked list. If index equals to the length of linked list, the node will be appended to the end of linked list. If index is greater than the length, the node will not be inserted. */
    // Time: O(index), Space: O(1)
    func addAtIndex(_ index: Int, _ val: Int) {
        guard index >= 0, index <= size else { return }
        
        var nodeToInsertAfter: Node
        if index < size - index {
            nodeToInsertAfter = head
            for _ in 0..<index {
                nodeToInsertAfter = nodeToInsertAfter.next!
            }
        } else {
            nodeToInsertAfter = tail.prev!
            for _ in 0..<(size-index) {
                nodeToInsertAfter = nodeToInsertAfter.prev!
            }
        }
        
        let newNode = Node(val)
        let prevNode = nodeToInsertAfter
        let nextNode = nodeToInsertAfter.next!
        
        prevNode.next = newNode
        newNode.prev = prevNode
        
        newNode.next = nextNode
        nextNode.prev = newNode
        
        size += 1
    }
    
    /** Delete the index-th node in the linked list, if the index is valid. */
    // Time: O(index), Space: O(1)
    func deleteAtIndex(_ index: Int) {
        guard index >= 0, index < size else { return }
        
        var nodeToRemove: Node
        if index < size - index {
            nodeToRemove = head.next!
            for _ in 0..<index {
                nodeToRemove = nodeToRemove.next!
            }
        } else {
            nodeToRemove = tail.prev!
            for _ in 0..<(size-index-1) {
                nodeToRemove = nodeToRemove.prev!
            }
        }
        
        let prevNode = nodeToRemove.prev!
        let nextNode = nodeToRemove.next!
        
        prevNode.next = nextNode
        nextNode.prev = prevNode
        
        nodeToRemove.next = nil
        nodeToRemove.prev = nil
        
        size -= 1
    }
}
/**
 * Your MyLinkedList object will be instantiated and called as such:
 * let obj = MyLinkedList()
 * let ret_1: Int = obj.get(index)
 * obj.addAtHead(val)
 * obj.addAtTail(val)
 * obj.addAtIndex(index, val)
 * obj.deleteAtIndex(index)
 */
```

