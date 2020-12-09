Implement a first in first out (FIFO) queue using only two stacks. The implemented queue should support all the functions of a normal queue (`push`, `peek`, `pop`, and `empty`).

Implement the `MyQueue` class:

- `void push(int x)` Pushes element x to the back of the queue.
- `int pop()` Removes the element from the front of the queue and returns it.
- `int peek()` Returns the element at the front of the queue.
- `boolean empty()` Returns `true` if the queue is empty, `false` otherwise.

**Notes:**

- You must use **only** standard operations of a stack, which means only `push to top`, `peek/pop from top`, `size`, and `is empty` operations are valid.
- Depending on your language, the stack may not be supported natively. You may simulate a stack using a list or deque (double-ended queue) as long as you use only a stack's standard operations.

**Follow-up:** Can you implement the queue such that each operation is **[amortized](https://en.wikipedia.org/wiki/Amortized_analysis)** `O(1)` time complexity? In other words, performing `n` operations will take overall `O(n)` time even if one of those operations may take longer.

 

**Example 1:**

```
Input
["MyQueue", "push", "push", "peek", "pop", "empty"]
[[], [1], [2], [], [], []]
Output
[null, null, null, 1, 1, false]

Explanation
MyQueue myQueue = new MyQueue();
myQueue.push(1); // queue is: [1]
myQueue.push(2); // queue is: [1, 2] (leftmost is front of the queue)
myQueue.peek(); // return 1
myQueue.pop(); // return 1, queue is [2]
myQueue.empty(); // return false
```

 

**Constraints:**

- `1 <= x <= 9`
- At most `100` calls will be made to `push`, `pop`, `peek`, and `empty`.
- All the calls to `pop` and `peek` are valid.



**Solution**

```swift
class MyQueue {
    var stack = [Int]()
    
    /** Initialize your data structure here. */
    init() {
        
    }
    
    /** Push element x to the back of queue. */
    func push(_ x: Int) {
        if stack.count == 0 {
            stack.append(x)
        } else {
            var newStack = [Int]()
            newStack.append(x)
            reverse(&newStack)
            stack = newStack
        }
    }
    
    func reverse(_ stack:inout [Int]) {
        let last = self.stack.popLast()
        if self.stack.count > 0 {
            reverse(&stack)
        }
        stack.append(last!)
    }
    
    
    /** Removes the element from in front of queue and returns that element. */
    func pop() -> Int {
        stack.popLast()!
    }
    
    /** Get the front element. */
    func peek() -> Int {
        stack.last!
    }
    
    /** Returns whether the queue is empty. */
    func empty() -> Bool {
        stack.isEmpty
    }
}
```

**two stacks solution:**

Push:

![image-20201209133851324](/Users/edz/Library/Application Support/typora-user-images/image-20201209133851324.png)

```java
private Stack<Integer> s1 = new Stack<>();
private Stack<Integer> s2 = new Stack<>();

// Push element x to the back of queue.
public void push(int x) {
    if (s1.empty())
        front = x;
    s1.push(x);
}
```

- Time complexity : O(1)
- Space complexity : O(n). 

pop:

![image-20201209133921495](/Users/edz/Library/Application Support/typora-user-images/image-20201209133921495.png)

```java
// Removes the element from in front of queue.
public void pop() {
    if (s2.isEmpty()) {
        while (!s1.isEmpty())
            s2.push(s1.pop());
    }
    s2.pop();    
}
```

Empty:

```java
// Return whether the queue is empty.
public boolean empty() {
    return s1.isEmpty() && s2.isEmpty();
}
```

Peek:

```java
// Get the front element.
public int peek() {
    if (!s2.isEmpty()) {
        return s2.peek();
    }
    return front;
}
```

Time complexity : O(1)

Space complexity : O(1)

