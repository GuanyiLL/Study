Design your implementation of the circular queue. The circular queue is a linear data structure in which the operations are performed based on FIFO (First In First Out) principle and the last position is connected back to the first position to make a circle. It is also called "Ring Buffer".

One of the benefits of the circular queue is that we can make use of the spaces in front of the queue. In a normal queue, once the queue becomes full, we cannot insert the next element even if there is a space in front of the queue. But using the circular queue, we can use the space to store new values.

Your implementation should support following operations:

- `MyCircularQueue(k)`: Constructor, set the size of the queue to be k.
- `Front`: Get the front item from the queue. If the queue is empty, return -1.
- `Rear`: Get the last item from the queue. If the queue is empty, return -1.
- `enQueue(value)`: Insert an element into the circular queue. Return true if the operation is successful.
- `deQueue()`: Delete an element from the circular queue. Return true if the operation is successful.
- `isEmpty()`: Checks whether the circular queue is empty or not.
- `isFull()`: Checks whether the circular queue is full or not.

 

**Example:**

```
MyCircularQueue circularQueue = new MyCircularQueue(3); // set the size to be 3
circularQueue.enQueue(1);  // return true
circularQueue.enQueue(2);  // return true
circularQueue.enQueue(3);  // return true
circularQueue.enQueue(4);  // return false, the queue is full
circularQueue.Rear();  // return 3
circularQueue.isFull();  // return true
circularQueue.deQueue();  // return true
circularQueue.enQueue(4);  // return true
circularQueue.Rear();  // return 4
```

 

**Note:**

- All values will be in the range of [0, 1000].
- The number of operations will be in the range of [1, 1000].
- Please do not use the built-in Queue library.



**Solution**

```swift
class MyCircularQueue {
    
    var queue: [Int]
    var head: Int = -1
    var tail: Int = -1
    
    /** Initialize your data structure here. Set the size of the queue to be k. */
    init(_ k: Int) {
        queue = Array(repeating: 0, count: k)
    }
    
    /** Insert an element into the circular queue. Return true if the operation is successful. */
    func enQueue(_ value: Int) -> Bool {
        if isFull() {
            return false
        }
        
        if isEmpty() {
            queue[0] = value
            head = 0
            tail = 0
            return true
        }
        
        tail += 1
        tail %= queue.count
        queue[tail] = value
        return true
    }
    
    /** Delete an element from the circular queue. Return true if the operation is successful. */
    func deQueue() -> Bool {
        if isEmpty() {
            return false
        }
        
        if head == tail {
            queue[head] = 0
            head = -1
            tail = -1
            return true
        }
        
        queue[head] = 0
        head += 1
        head %= queue.count
        return true
    }
    
    /** Get the front item from the queue. */
    func Front() -> Int {
        if isEmpty() {
            return -1
        }
        return queue[head]
    }
    
    /** Get the last item from the queue. */
    func Rear() -> Int {
        if isEmpty() {
            return -1
        }
        return queue[tail]
    }
    
    /** Checks whether the circular queue is empty or not. */
    func isEmpty() -> Bool {
        return head == -1
    }
    
    /** Checks whether the circular queue is full or not. */
    func isFull() -> Bool {
        return (tail + 1) % queue.count == head
    }
}
/**
 * Your MyCircularQueue object will be instantiated and called as such:
 * let obj = MyCircularQueue(k)
 * let ret_1: Bool = obj.enQueue(value)
 * let ret_2: Bool = obj.deQueue()
 * let ret_3: Int = obj.Front()
 * let ret_4: Int = obj.Rear()
 * let ret_5: Bool = obj.isEmpty()
 * let ret_6: Bool = obj.isFull()
 */
```





