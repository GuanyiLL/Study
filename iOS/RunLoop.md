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