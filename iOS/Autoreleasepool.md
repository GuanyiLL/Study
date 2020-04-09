# 使用自动释放池

自动释放池提供了一种机制，可以通过该机制放弃对象的所有权，但可以避免将其立即释放的可能性（例如，从方法返回对象时）。 通常情况下不需要创建自己的自动释放池。

## 基础

自动释放池使用`@autoreleasepool`作为标记：

```objectivec
@autoreleasepool {
  	// 代码写这里
}
```

在自动释放池的末尾，向在该作用域内接收到`autorelease`消息的对象发送`release`消息。自动释放池也可以嵌套使用：

```objectivec
@autoreleasepool {
  	//...
  	@autoreleasepool {
  			// 代码写这里
		}
  	...
}
```

Cocoa始终希望代码在自动释放池中执行，否则自动释放的对象将不会被释放并且还会造成会内存泄漏。 AppKit和UIKit框架处理自动释放池中的每个事件循环迭代（例如，鼠标按下事件或敲击）。 因此，我们不必自己创建一个自动释放池，甚至不必查看用于创建一个自动释放池的代码。 但是，在三种情况下，可能会使用自己的自动释放池：

* 如果您正在编写不基于UI框架的程序，例如命令行工具。
* 如果编写一个创建许多临时对象的循环。（比如10w次的循环）
* 如果产生辅助线程

一旦线程开始执行，就必须创建自己的自动释放池。否则，将会产生内存泄漏。

## 使用本地自动释放池块来减少峰值内存占用量

许多程序会创建自动释放的临时对象。直到代码结束为止， 这些对象会增加程序占有的内存。 在许多情况下，允许临时对象累积到当前循环迭代结束之前不会导致过多的开销。但在某些情况下可能会创建大量临时对象，这些临时对象会占据大量内存，而我们需要尽快处理。 在后一种情况下，可以创建自己的自动释放池块。 在自动释放池的最后，释放临时对象，这样可以尽快重新分配内存，从而减少了程序的内存占用。

以下示例显示了如何在for循环中使用本地自动释放池块:

```objectivec
NSArray *urls = <# An array of file URLs #>;
for (NSURL *url in urls) {
 
    @autoreleasepool {
        NSError *error;
        NSString *fileContents = [NSString stringWithContentsOfURL:url
                                         encoding:NSUTF8StringEncoding error:&error];
        /* Process the string, creating and autoreleasing more objects. */
    }
}
```

for循环中每次处理一个文件。 在自动释放池内的每个被发送了自动释放消息的对象（例如fileContents）都在该代码块的末尾释放。

在自动释放池中的对象，都不应该再向它发送消息，如果需要作为方法的返回值，那么可以在自动释放池中对该对象进行retain操作，在返回的时候发送autorelease消息：

```objectivec
– (id)findMatchingObject:(id)anObject {
 
    id match;
    while (match == nil) {
        @autoreleasepool {
 
            /* Do a search that creates a lot of temporary objects. */
            match = [self expensiveSearchForObject:anObject];
 
            if (match != nil) {
                [match retain]; /* Keep match around. */
            }
        }
    }
 
    return [match autorelease];   /* Let match go and return it. */
}
```

在自动释放池外保留`match`对象，然后在返回的时候发送`autorelease`消息来延长生命周期。



