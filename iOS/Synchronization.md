# 同步

**临界资源**：我们称一次仅允许一个进程使用的资源成为临界资源。

**同步**：同步亦称直接制约关系，是指未完成某种任务而建立的两个或多个进程，这些进程因为需要在某些位置上协调他们的工作次序而等待、传递信息锁产生的制约关系。进程间的直接制约关系源于他们之间的相互合作。

**互斥**：互斥亦称间接制约关系。当一个进程进入临界区使用临界资源，另一个进程必须等待，当占用临界资源的进程退出临界区后，另一进程才允许去访问此临界资源。

## 同步工具

为了防止不同的线程意外更改数据，您可以将应用程序设计为不存在同步问题，也可以使用同步工具。 虽然最好能完全避免同步问题，但这并不现实。

### Atomic

原子操作是一种简单的同步形式，适用于简单的数据类型。 原子操作的优点是它们不会阻塞竞争线程。 对于简单的操作（例如增加计数器变量），这可以比锁获得更好的性能。

`/usr/include/libkern/OSAtomic.h` 头文件中提供了很多Atomic的基本方法，这些方法都是线程安全的。

### 内存屏障与易失型变量

内存屏障是一种非阻塞同步工具，用于确保内存操作以正确的顺序发生。易失性变量将另一种类型的内存约束应用于单个变量。由于内存屏障和易失性变量都减少了编译器可执行的优化次数，因此应谨慎使用它们，并且仅在需要确保正确性的地方使用它们。有关使用内存屏障的信息，请参见[OSMemoryBarrier](https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man3/OSMemoryBarrier.3.html#//apple_ref/doc/man/3/OSMemoryBarrier)。

### 锁

以下列出了常用的锁：

|               锁                |                             描述                             |
| :-----------------------------: | :----------------------------------------------------------: |
|           互斥(Mutex)           | 互斥锁充当资源周围的保护性屏障。 互斥锁是一种信号量，它一次只能授予对一个线程的访问权限。 如果正在使用互斥锁，而另一个线程试图获取该互斥锁，则该线程将阻塞，直到该互斥锁被其原始持有者释放为止。 如果多个线程竞争同一个互斥锁，则一次只能访问一个。 |
|     递归锁(Recursive lock)      | 递归锁是互斥锁的一种变体。 递归锁允许单个线程在释放它之前多次获取该锁。 其他线程将保持阻塞状态，直到锁的所有者以获取锁的相同次数释放锁。 递归锁主要在递归迭代期间使用，但也可能用于每种方法都需要分别获取锁的情况。 |
|     读写锁(Read-write lock)     | 读写锁也称为共享独占锁。 这种类型的锁通常用于较大规模的操作，如果频繁读取受保护的数据结构并且仅偶尔进行修改，则可以显着提高性能。 在正常操作期间，多个读取器可以同时访问数据结构。 但是，当线程要写入时，它将阻塞，直到所有读取器都释放锁为止，此时，它获取了锁并可以更新结构。 当写入线程正在等待锁定时，新的读取器线程将阻塞，直到写入线程完成。 系统仅支持使用POSIX线程的读写锁。 有关如何使用这些锁的更多信息，请参见[pthread手册](https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man3/pthread.3.html#//apple_ref/doc/man/3/pthread)页。 |
|   分布式锁(Distributed lock)    | 分布式锁在进程级别提供互斥访问。 与真正的互斥锁不同，分布式锁不会阻止进程或阻止其运行。 它仅报告锁繁忙的时间，并让进程决定如何进行。 |
|        自旋锁(Spin lock)        | 自旋锁反复轮询其锁定条件，直到该条件变为true。 自旋锁最常用于锁的预期等待时间较短的多处理器系统上。 在涉及到上下文切换和线程数据结构的更新时，轮询通常比阻塞线程更有效。 由于其轮询性质，系统不提供自旋锁的任何实现，但是您可以在特定情况下轻松实现它们。 有关在内核中实现自旋锁的信息，请参见[《内核编程指南》](https://developer.apple.com/library/archive/documentation/Darwin/Conceptual/KernelProgramming/About/About.html#//apple_ref/doc/uid/TP30000905)。 |
| 双重检查锁（Double-checked lock | 双重检查锁是通过在获取锁之前测试锁定条件来减少获取锁的开销的尝试。 由于双重检查的锁可能不安全，因此不建议使用它们。 |

### 条件

条件是信号量的另一种类型，当某个条件为true时，它允许线程相互发信号。条件通常用于指示资源的可用性或确保任务以特定顺序执行。当线程检测条件时，除非该条件已经为true，否则它将阻塞。它保持阻塞状态，直到其它线程显式更改并发出条件信号为止。条件和互斥锁之间的区别在于，可以允许多个线程同时访问该条件。条件更多是看门人，它根据某些指定的标准让不同的线程通过门。

此外，cocoa还提供了选择控制器的多线程方式，详情请看[Cocoa Perform Selector Sources](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Multithreading/RunLoopManagement/RunLoopManagement.html#//apple_ref/doc/uid/10000057i-CH16-SW44).

## 同步的成本和性能

同步有助于确保代码的正确性，但这样做会牺牲性能。 即使在无争议的情况下，使用同步工具也会带来延迟。 锁和原子操作通常涉及使用内存屏障和内核级同步，以确保适当地保护代码。 如果存在争用锁的情况，线程可能会阻塞并经历更大的延迟。

如下列出了在无争议的情况下与互斥锁和原子操作相关的一些近似成本：

|      测试项目      |  近似成本  |
| :----------------: | :--------: |
|   互斥体获取时间   | 约0.2微秒  |
| 原子操作比较和交换 | 约0.05微秒 |

在设计并发任务时，正确性始终是最重要的因素，但是也要考虑性能因素。 在多个线程下可以正确执行的代码，但是比在单个线程上运行的相同代码慢，这样几乎没有改进。

## 使用 Atomic 操作

无阻塞同步是一种执行某些类型的操作并避免锁的开销的方式。尽管锁是同步两个线程的有效方法，但是即使在无争议的情况下，获取锁也是相对开销比较大的操作。相比之下，许多原子操作仅需花费一小部分时间即可完成，并且与锁一样有效。

原子运算使您可以对32位或64位值执行简单的数学和逻辑运算。这些操作依靠特殊的硬件指令（和可选的内存屏障）来确保给定的操作在再次访问受影响的内存之前完成。在多线程的情况下，您应始终使用包含内存屏障的原子操作来确保内存在线程之间正确同步。

```objectivec
int32_t  theValue = 0;
OSAtomicTestAndSet(0, &theValue);
// theValue is now 128.
 
theValue = 0;
OSAtomicTestAndSet(7, &theValue);
// theValue is now 1.
 
theValue = 0;
OSAtomicTestAndSet(15, &theValue)
// theValue is now 256.
 
OSAtomicCompareAndSwap32(256, 512, &theValue);
// theValue is now 512.
 
OSAtomicCompareAndSwap32(256, 1024, &theValue);
// theValue is still 512.
```

## 使用锁

锁是用于线程编程的基本同步工具。 锁使您可以轻松保护大部分代码，从而可以确保该代码的正确性。 OS X和iOS为所有应用程序类型提供基本互斥锁，并且Foundation框架为特殊情况定义了互斥锁的一些其他变体。 

### 使用POSIX互斥锁

POSIX互斥锁非常易于在任何应用程序中使用。 要创建互斥锁，请声明并初始化`pthread_mutex_t`结构体。 要锁定和解锁互斥锁，请使用`pthread_mutex_lock`和`pthread_mutex_unlock`函数。锁的释放则使用`pthread_mutex_destroy`方法即可，以下为基本使用方法：

```objectivec
pthread_mutex_t mutex;
void MyInitFunction()
{
    pthread_mutex_init(&mutex, NULL);
}
 
void MyLockingFunction()
{
    pthread_mutex_lock(&mutex);
    // Do work.
    pthread_mutex_unlock(&mutex);
}
```

### 使用NSLock

NSLock对象为Cocoa应用程序实现了基本的互斥锁。 实际上，所有锁（包括NSLock）的接口都是由NSLocking协议定义的，该协议定义了lock和unlock方法。 您可以像使用任何互斥锁一样使用这些方法来获取和释放锁。

除了标准的锁定行为外，NSLock类还添加了tryLock和lockBeforeDate：方法。` tryLock`方法尝试获取锁，但是如果锁不可用则不会阻塞线程； 相反，该方法则返回NO。`lockBeforeDate：`方法尝试获取锁，如果未在指定的时间限制内获取锁，会取消阻塞线程并返回NO。

下面的示例演示如何使用NSLock对象协调视觉显示的更新，该视觉显示的数据由多个线程计算。 如果线程不能立即获取锁，则它仅继续进行计算，直到可以获取锁并更新显示:

```objectivec
BOOL moreToDo = YES;
NSLock *theLock = [[NSLock alloc] init];
...
while (moreToDo) {
    /* Do another increment of calculation */
    /* until there’s no more to do. */
    if ([theLock tryLock]) {
        /* Update display used by all threads. */
        [theLock unlock];
    }
}

```

### 使用@synchronized指令

`@synchronized`指令是在Objective-C代码中动态创建互斥锁的便捷方法。 `@synchronized`指令执行任何其他互斥锁将执行的操作-防止不同的线程同时获取同一锁。 但是，在这种情况下，您不必直接创建互斥量或锁定对象。 相反，您只需将任何Objective-C对象用作锁定令牌，如以下示例所示：

```objectivec
- (void)myMethod:(id)anObj
{
    @synchronized(anObj)
    {
        // Everything between the braces is protected by the @synchronized directive.
    }
}
```

传递给`@synchronized`指令的对象是用于区分受保护块的唯一标识符。 如果您在两个不同的线程中执行上述方法，并在每个线程上为`anOb`j参数传递了一个不同的对象，则每个对象将获得其锁并继续处理而不会被另一个阻塞。 但是，如果在两种情况下都传递相同的对象，则其中一个线程将首先获取锁，而另一个线程将阻塞，直到第一个线程完成关键部分。

作为一种预防措施，`@synchronized`会向受保护的代码隐式添加一个异常处理程序。 如果抛出异常，此处理程序将自动释放互斥量。 这意味着，为了使用`@synchronized`指令，还必须在代码中启用Objective-C异常处理。 如果您不希望由隐式异常处理程序引起的额外开销，则应考虑使用NSLock。

### 使用其它Cocoa提供的锁

#### NSRecursiveLock

`NSRecursiveLock`同一线程可以多次获取该锁，而不会导致线程死锁。 每次成功获取锁都必须通过相应的`unlock`调用来平衡以解锁该锁。 仅当所有锁定和解锁调用均达到平衡时，才实际释放该锁定，以便其他线程可以获取它。

顾名思义，这种类型的锁通常在递归函数内部使用，以防止递归阻塞线程。  这是一个简单的递归函数示例，该函数通过递归获取锁。 如果此代码未使用`NSRecursiveLock`对象，则递归调用该函数时，线程将死锁。

```objectivec
NSRecursiveLock *theLock = [[NSRecursiveLock alloc] init];
 
void MyRecursiveFunction(int value)
{
    [theLock lock];
    if (value != 0)
    {
        --value;
        MyRecursiveFunction(value);
    }
    [theLock unlock];
}
 
MyRecursiveFunction(5);
```

#### NSConditionLock

`NSConditionLock`对象定义一个互斥锁，该互斥锁可以使用特定的值进行锁定和解锁。 您不应将这种类型的锁与条件混淆。 该行为在某种程度上类似于条件，但实现方式却大不相同。

通常，当线程需要以特定顺序执行任务时（例如，当一个线程产生另一个消耗的数据时），可以使用`NSConditionLock`对象。 生产者执行时，消费者使用特定的条件来获取锁。生产者完成操作后，它将解锁，并将锁定条件设置为适当的整数值以唤醒使用者线程，然后消费者线程将继续处理数据。

`NSConditionLock`对象响应的锁定和解锁方法可以任意组合使用。 例如，您可以将`lock`与`unlockWithCondition：`配对，或者将`lockWhenCondition：`消息与`unlock`配对。 当然，后一种组合可以解锁该锁，但可能不会释放等待特定条件值的线程。

下面的示例演示如何使用条件锁来处理生产者－消费者问题。 想象一个应用程序包含一个数据队列。 生产者线程将数据添加到队列，而消费者线程从队列中提取数据。 生产者不需要等待特定的条件，但是必须等待锁可用，以便可以安全地将数据添加到队列中:

```objectivec
id condLock = [[NSConditionLock alloc] initWithCondition:NO_DATA];
 
while(true)	{
    [condLock lock];
    /* Add data to the queue. */
    [condLock unlockWithCondition:HAS_DATA];
}
```

#### NSDistributedLock

`NSDistributedLock`类可由多个主机上的多个应用程序使用，以限制对某些共享资源（例如文件）的访问。 该锁本身实际上是一个互斥锁，它是使用文件系统项（例如文件或目录）实现的。 为了使`NSDistributedLock`对象可用，使用该锁的所有应用程序必须可写该锁。 这通常意味着将其放置在运行该应用程序的所有计算机都可以访问的文件系统上。

与其他类型的锁不同，`NSDistributedLock`不符合`NSLocking`协议，因此没有锁定方法。 锁定方法将阻止线程的执行，并要求系统以预定速率轮询锁定。 `NSDistributedLock`不会将这种惩罚加在您的代码上，而是提供一个`tryLock`方法，让您决定是否进行轮询。

因为它是使用文件系统实现的，所以除非所有者明确释放，否则不会释放`NSDistributedLock`对象。 如果您的应用程序在持有分布式锁的同时崩溃，则其他客户端将无法访问受保护的资源。 在这种情况下，您可以使用`breakLock`方法来破坏现有锁，以便获取它。 但是，通常应该避免破坏锁，除非您确定拥有进程已死并且无法释放锁。

与其他类型的锁一样，使用`NSDistributedLock`对象完成操作后，可以通过调用`unlock`方法来释放它。

## 使用Conditions

### 使用NSCondition

`NSCondition`类提供与POSIX条件相同的语义，但是将所需的锁和条件数据结构都包装在一个对象中。 结果是可以像互斥锁一样锁定对象，然后像条件一样等待。

以下代码演示了等待`NSCondition`对象的事件序列。 `cocoaCondition`变量包含一个`NSCondition`对象，并且`timeToDoWork`变量是一个整数，在发出该信号之前立即从另一个线程递增。

```objectivec
[cocoaCondition lock];
while (timeToDoWork <= 0)
    [cocoaCondition wait];
 
timeToDoWork--;
 
// Do real work here.
 
[cocoaCondition unlock];
```

以下代码展示了用于表示Cocoa条件并增加谓语变量的代码。 应该在发出信号之前锁定该条件。

```objectivec
[cocoaCondition lock];
timeToDoWork++;
[cocoaCondition signal];
[cocoaCondition unlock];
```

### 使用 POSIX 条件

POSIX线程条件锁要求同时使用条件数据结构和互斥锁。 尽管两个锁结构是分开的，但互斥锁在运行时与条件结构密切相关。 等待信号的线程应始终一起使用相同的互斥锁和条件结构。 更改配对会导致错误。

如下代码显示了条件和谓词的基本初始化和用法。 在初始化条件和互斥锁之后，等待线程使用`ready_to_go`变量作为谓词进入while循环。 仅当谓词已设置且随后发出条件通知时，等待线程才会唤醒并开始执行其工作。

```objectivec
pthread_mutex_t mutex;
pthread_cond_t condition;
Boolean     ready_to_go = true;
 
void MyCondInitFunction()
{
    pthread_mutex_init(&mutex);
    pthread_cond_init(&condition, NULL);
}
 
void MyWaitOnConditionFunction()
{
    // Lock the mutex.
    pthread_mutex_lock(&mutex);
 
    // If the predicate is already set, then the while loop is bypassed;
    // otherwise, the thread sleeps until the predicate is set.
    while(ready_to_go == false)
    {
        pthread_cond_wait(&condition, &mutex);
    }
 
    // Do work. (The mutex should stay locked.)
 
    // Reset the predicate and release the mutex.
    ready_to_go = false;
    pthread_mutex_unlock(&mutex);
}
```

发信号线程既负责设置谓词，又负责将信号发送到条件锁。 如下代码显示了实现此行为的代码。 在此示例中，条件在互斥锁内部发出信号，以防止在等待条件的线程之间发生竞争条件。

```objectivec
void SignalThreadUsingCondition()
{
    // At this point, there should be work for the other thread to do.
    pthread_mutex_lock(&mutex);
    ready_to_go = true;
 
    // Signal the other thread to begin work.
    pthread_cond_signal(&condition);
 
    pthread_mutex_unlock(&mutex);
}
```

