# RunLoop

定时器

GCD Async Main Queue

事件响应、手势识别、界面刷新

网络请求

AutoreleasePool

## RunLoop对象

Foundation 					

```objectivec
[NSRunLoop currentRunLoop];
```

CoreFoundation

```objectivec
CFRunLoopGetCurrent()
```

- CFRunLoopRef
- CFRunLoopModeRef
- CFRunLoopSourceRef
- CFRunLoopTimerRef
- CFRunLoopObserverRef

常见的mode:

- kCFRunLoopDefaultMode（NSDefaultRunLoopMode）：App的默认Mode，通常主线程是在这个Mode下运行
- UITrackingRunLoopMode：界面跟踪 Mode，用于 ScrollView 追踪触摸滑动，保证界面滑动时不受其他 Mode 影响

lldb打印调用栈：bt

模式切换的时候，先退出当前mode，然后再进入新的mode。

## RunLoop运行逻辑

- Source0
  - 触摸事件处理
  - performSelector:onThread:

- Source1
  - 基于Port的线程间通信
  - 系统事件捕捉

- Timers
  - NSTimer
  - performSelector:withObject:afterDelay:

- Observers
  - 用于监听RunLoop的状态
  - UI刷新（BeforeWaiting）
  - Autorelease pool（BeforeWaiting）

1. 通知Observers：进入Loop
2. 通知Observers：即将处理Timers

3. 通知Observers：即将处理Sources

4. 处理Blocks

5. 处理Source0（可能会再次处理Blocks）

6. 如果存在Source1，就跳转到第8步

7. 通知Observers：开始休眠（等待消息唤醒）

8. 通知Observers：结束休眠（被某个消息唤醒）
    1. 处理Timer
    2. 处理GCD Async To Main Queue
    3. Source1

9. 处理Blocks

10. 根据前面执行的结果，决定如何操作
    1. 回到2
    2. 退出Loop

11. 同志Observers：退出Loop

RunLoop线程休眠，切换到内核态，然后将线程阻塞。

如果Mode里没有任何Source0/Source1/Timer/Observer，RunLoop会立马退出

Source1->source0

**NSTimer失效**

NSTime scheduledTimer方法会将Timer添加到RunLoop的默认Mode下，使用timerWithTimeInterval创建一个Timer，然后手动添加到CommonModes。

NSRunLoopCommonModes是一个标记，包含DefaultMode与TrackingMode。



