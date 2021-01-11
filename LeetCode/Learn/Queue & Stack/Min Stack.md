Design a stack that supports push, pop, top, and retrieving the minimum element in constant time.

- push(x) -- Push element x onto stack.
- pop() -- Removes the element on top of the stack.
- top() -- Get the top element.
- getMin() -- Retrieve the minimum element in the stack.

 

**Example 1:**

```
Input
["MinStack","push","push","push","getMin","pop","top","getMin"]
[[],[-2],[0],[-3],[],[],[],[]]

Output
[null,null,null,null,-3,null,0,-2]

Explanation
MinStack minStack = new MinStack();
minStack.push(-2);
minStack.push(0);
minStack.push(-3);
minStack.getMin(); // return -3
minStack.pop();
minStack.top();    // return 0
minStack.getMin(); // return -2
```

 

**Constraints:**

- Methods `pop`, `top` and `getMin` operations will always be called on **non-empty** stacks.



**Solution**

my solution:

```swift
class MinStack {

    /** initialize your data structure here. */
    var stack = [Int]()
    
    init() {
        
    }
    
    func push(_ x: Int) {
        stack.append(x)
    }
    
    func pop() {
        stack.removeLast()
    }
    
    func top() -> Int {
        return stack.last ?? -1
    }
    
    func getMin() -> Int {
        if stack.isEmpty {
            return -1
        }
        var min = stack.first!
        for i in 1..<stack.count {
            if stack[i] < min {
                min = stack[i]
            }
        }
        return min
    }
}
```

best solution:

```swift
class MinStack {

    /** initialize your data structure here. */
    var stack = Stack<Int>()
    var minStack = Stack<Int>()
    
    
    func push(_ x: Int) {
        stack.push(x)
        if minStack.isEmpty() {
            minStack.push(x)
        } else if x <= minStack.peek() {
            minStack.push(x)
        }
    }
    
    func pop() {
        let pop = stack.pop()
        if pop == minStack.peek() {
            minStack.pop()
        }
    }

    func top() -> Int {
        return stack.peek()
    }
    
    func getMin() -> Int {
        return minStack.peek()
    }
}

struct Stack<Element> {
    private var stack = [Element]()

    mutating func push(_ x: Element) {
        stack.append(x)
    }

    func isEmpty() -> Bool {
        return stack.isEmpty
    }

    func peek() -> Element {
        return stack[stack.count - 1]
    }

    mutating func pop() -> Element {
        return stack.remove(at: stack.count - 1)
    }
}
```

