# Run Loops 

RunLoop是与线程关联的基础结构的一部分。RunLoop是事件处理循环，可用于计划工作和协调传入事件的接收。RunLoop的目的是在有工作要做时让线程忙，而在没有工作时让线程进入睡眠状态。

RunLoop管理不是完全自动的。仍然需要设计线程的代码以在适当的时候启动RunLoop并响应传入的事件。 Cocoa和Core Foundation都提供RunLoop对象，以帮助配置和管理线程的RunLoop。开发应用程序时不需要显式创建这些对象。每个线程（包括应用程序的主线程）都有一个关联的RunLoop对象。但是，只有辅助线程需要显式地运行其RunLoop。在应用程序启动过程中，应用程序框架会自动在主线程上设置并运行RunLoop。

## Run Loop解析

RunLoop就如同字面表达的意思。是一个让线程进入并且用于处理传入事件响应的循环。您的代码提供了用于实现RunLoop实际循环部分的控制语句-换句话说，您的代码提供了驱动RunLoop的while或for循环。在循环内，您可以使用RunLoop对象来“运行”事件处理代码，以接收事件并调用已安装的处理程序。

RunLoop从两种不同类型的源接收事件。输入源传递异步事件，通常是来自另一个线程或其他应用程序的消息。定时器源传递同步事件，这些事件在计划的时间或重复的间隔发生。两种类型的源都使用特定于应用程序的处理程序例程来处理事件到达时的事件。

下图显示了RunLoop和各种来源的概念结构。输入源将异步事件传递给相应的处理程序，并调用`runUntilDate：`方法（在线程关联的`NSRunLoop`对象上调用）退出。定时器源将事件传递到其处理程序例程，但不会导致RunLoop退出。

![runloop1](/img/runloop1.png)

除了处理输入源之外，RunLoop还生成有关RunLoop行为的通知。 注册的RunLoop观察者可以接收这些通知，并使用它们在线程上进行其他处理。 

### Run Loop Modes

RunLoop模式是要监视的输入源和定时器的集合，也是被通知的RunLoop观察者的集合。每次运行RunLoop时，都可以指定运行的特定“模式”。在RunLoop的整个过程中，仅监视与该模式关联的源，并允许其传递事件。与其他模式相关联的源将保留任何新事件，直到随后以适当的模式通过该循环。

Cocoa和Core Foundation都定义了默认模式和几种常用模式，以及用于在代码中指定这些模式的字符串。可以为模式名称指定自定义字符串来自定义一个模式。尽管分配给自定义模式的名称是任意的，但是这些模式的内容却不是。必须确保将一个或多个输入源，定时器或RunLoop观察者添加到创建的模式中。

可以使用RunLoop的模式来过滤不想要的事件。通常我们在系统定义的“默认”模式下使用RunLoop。但是有些时候，可能会需要在“模式面板”模式下运行。在这种模式下，只有与模式面板相关的源才将事件传递给线程。对于辅助线程，则可以使用自定义模式来防止低优先级源在时间紧迫的操作期间传递事件。

下表列出了Cocoa和Core Foundation定义的标准模式，以及何时使用该模式的说明。 名称列列出了用于在代码中指定模式的实际常量：

| 模式           | 名称                                                         | 描述                                                         |
| :------------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| Default        | `NSDefaultRunLoopMode` (Cocoa)`kCFRunLoopDefaultMode` (Core Foundation) | 大多数时候，应该使用此模式来启动RunLoop并配置输入源。        |
| Connection     | `NSConnectionReplyMode` (Cocoa)                              | Cocoa将此模式与`NSConnection`对象结合使用以监视接收。 几乎不需要自己使用此模式。 |
| Modal          | `NSModalPanelRunLoopMode` (Cocoa)                            | Cocoa使用此模式来识别用于模式面板的事件。                    |
| Event tracking | `NSEventTrackingRunLoopMode` (Cocoa)                         | Cocoa使用此模式来限制鼠标拖动循环和其他类型的用户界面跟踪循环期间的传入事件。 |
| Common modes   | `NSRunLoopCommonModes` (Cocoa)`kCFRunLoopCommonModes` (Core Foundation) | 这是一组常用模式的可配置组。 将输入源与此模式相关联还将其与组中的每个模式相关联。 对于Cocoa应用程序，此集合默认包括Default,Modal和Event tracking模式。 最初，Core Foundation仅包括默认模式。 可以使用`CFRunLoopAddCommonMode`函数将自定义模式添加到集合中。 |

### 输入源

输入源将事件异步传递到线程中。事件的来源取决于输入来源的类型。基于端口的输入源监听应用程序的Mach端口。自定义输入源监听事件的自定义源。就RunLoop而言，输入源是基于端口的还是自定义的都无关紧要。系统通常实现两种类型的输入源。两种信号源之间的唯一区别是信号的发送方式。基于端口的源由内核自动发出信号，而自定义源必须从另一个线程手动发出信号。

创建输入源时，可以将其分配给RunLoop的一种或多种模式。模式会影响在任何给定时刻监视哪些输入源。大多数情况下会在默认模式下运行RunLoop，但也可以使用自定义模式。如果输入源不在当前监听的模式下，则它生成的任何事件都将保留，直到RunLoop以正确的模式运行。

#### 基于端口的源

Cocoa和Core Foundation提供了内置支持，用于使用与端口相关的对象和功能创建基于端口的输入源。 例如，在Cocoa中，不需要直接创建输入源。 您只需创建一个端口对象，然后使用NSPort的方法将该端口添加到RunLoop中即可。 端口对象为您处理所需输入源的创建和配置。

在Core Foundation中，必须手动创建端口及其RunLoop源。 在这两种情况下，都使用与端口不透明类型关联的函数（CFMachPortRef，CFMessagePortRef或CFSocketRef）来创建适当的对象。

有关如何设置和配置基于端口的定制源的示例，请参阅[配置基于端口的输入源](#配置基于端口的输入源)。

#### 自定义输入源

若要创建自定义输入源，必须在Core Foundation中使用与`CFRunLoopSourceRef`不透明类型关联的功能。 通过使用多个回调函数配置自定义输入源。 当从RunLoop中删除源时，Core Foundation会在不同位置调用这些函数以配置源，处理所有传入事件并销毁源。

除了定义事件到达时自定义源的行为外，还必须定义事件传递机制。 这一部分源需要在单独的线程上运行，并负责为输入源提供其数据，在准备好处理数据时向其发出信号。 

有关如何创建自定义输入源的示例，请参阅[定义自定义输入源](#定义输入源)。 有关自定义输入源的参考信息，另请参见CFRunLoopSource参考。 

#### Cocoa Perform Selector Sources

除了基于端口的源代码外，Cocoa还定义了一个自定义输入源，该源可让您在任何线程上执行选择器。

除了基于端口的源代码外，Cocoa还定义了一个自定义输入源，该源可让您在任何线程上执行选择器。 像基于端口的源一样，执行选择器请求在目标线程上被序列化，从而减轻了在一个线程上运行多个方法时可能发生的许多同步问题。 与基于端口的源不同，执行选择器源在执行选择器后将其自身从RunLoop中删除。

在另一个线程上执行选择器时，目标线程必须具有活动的RunLoop。 对于自己创建的线程，这意味着要一直等到用代码显式启动RunLoop。 但是，由于主线程启动了自己的RunLoop，因此只要应用程序调用应用程序委托的`applicationDidFinishLaunching:`方法就可以开始在该线程上发出调用。 每次循环中，RunLoop都会处理所有排队的执行选择器调用，而不是在每次循环迭代时都处理一个。

下表列出了NSObject上定义的方法，这些方法可用于在其他线程上执行选择器。 由于这些方法是在NSObject上声明的，因此可以在任何有权访问Objective-C对象的线程中使用它们，包括POSIX线程。 这些方法实际上不会创建新线程来执行选择器。

| Methods                                                      | Description                                                  |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| performSelectorOnMainThread:withObject:waitUntilDone: performSelectorOnMainThread:withObject:waitUntilDone:modes: | 在该线程的下一个RunLoop周期内，在该应用程序的主线程上执行指定的选择器。 这些方法使您可以选择阻塞当前线程，直到任务执行完。 |
| performSelector:onThread:withObject:waitUntilDone: performSelector:onThread:withObject:waitUntilDone:modes: | 在具有NSThread对象的任何线程上执行指定的选择器。 这些方法使您可以选择阻塞当前线程，直到任务执行完。 |
| performSelector:withObject:afterDelay: performSelector:withObject:afterDelay:inModes: | 在下一个RunLoop周期中以及可选的延迟时间之后，在当前线程上执行指定的选择器。 因为它一直等到下一个RunLoop周期执行选择器，所以这些方法提供了当前执行代码的最小自动延迟。 多个排队的选择器按照队列的顺序依次执行。 |
| cancelPreviousPerformRequestsWithTarget: cancelPreviousPerformRequestsWithTarget:selector:object: | 可以将performSelector：withObject：afterDelay：或performSelector：withObject：afterDelay：inModes：发送的消息取消。 |

### 定时器源

定时器源在将来的预设时间将事件同步传递到您的线程。定时器是线程通知自己执行某事的一种方式。例如，一旦在来自用户的连续击键之间经过了一定的时间，然后搜索字段可以使用定时器来启动自动搜索。使用此延迟时间使用户有机会在开始搜索之前键入尽可能多的所需搜索字符串。

尽管定时器生成基于时间的通知，但它不是实时机制。像输入源一样，定时器与RunLoop的特定模式相关联。如果定时器不在RunLoop当前正在监视的模式下，则只有在以定时器支持的一种模式执行RunLoop后，定时器才会触发。同样，如果RunLoop在执行处理程序例程的中间触发定时器，则定时器将等到下一次通过RunLoop调用其处理例程。如果RunLoop根本没有运行，则定时器永远不会触发。

也可以将定时器配置为仅一次或重复生成事件。重复定时器会根据计划的触发时间（而不是实际的触发时间）自动重新计划自身。例如，如果计划将定时器在特定时间触发，然后每5秒触发一次，则即使实际触发时间被延迟，计划的触发时间也将始终落在原始的5秒时间间隔上。如果触发时间延迟得太多，以致错过了一个或多个计划的触发时间，则定时器将在错过的时间段内仅触发一次。在错过了一段时间后触发后，定时器将重新安排为下一个计划的触发时间。

有关配置定时器源的更多信息，请参见[配置定时器源](#配置定时器源)。有关参考信息，请参见`NSTimer`类参考或`CFRunLoopTimer`参考。

### Run Loop 观察者

与在适当的异步或同步事件发生时触发的源相反，RunLoop观察者在RunLoop本身执行期间的特殊位置才触发。 您可以使用RunLoop观察者来准备线程以处理给定事件，或者在线程进入睡眠状态之前准备线程。 您可以将RunLoop观察者与RunLoop中的以下事件相关联：

- RunLoop的进入。
- 当RunLoop将要处理定时器时。
- 当RunLoop将要处理输入源时。
- 当RunLoop即将进入睡眠状态时。
- 当RunLoop被唤醒，但在处理该事件之前将其唤醒。
- RunLoop的退出。

您可以使用Core Foundation将RunLoop观察者添加到应用程序。 要创建RunLoop观察器，请创建`CFRunLoopObserverRef`的实例。 此类型跟踪自定义回调函数及其关注的活动。

与定时器类似，RunLoop观察者可以使用一次或重复使用。 一次触发的观察者在触发后将其从RunLoop中删除，而重复的观察者仍保持连接。 可以指定观察者在创建时是运行一次还是重复运行。

有关如何创建RunLoop观察者的示例，请参见配置RunLoop。 有关参考信息，请参见`CFRunLoopObserver`。

### 事件的RunLoop序列

每次运行它时，线程的RunLoop都会处理未决事件，并为所有附加的观察者生成通知。 它执行此操作顺序如下：

1. 通知观察者已进入RunLoop。
2. 通知观察者任何准备就绪的定时器即将启动。
3. 通知观察者任何不基于端口的输入源都将被触发。
4. 触发所有已准备触发的非基于端口的输入源。
5. 如果基于端口的输入源已准备好并等待启动，请立即处理事件。 转到步骤9。
6. 通知观察者线程即将休眠。
7. 直到发生以下事件之一，使线程进入睡眠状态：
   - 事件到达基于端口的输入源。
   - 定时器启动。
   - 为RunLoop设置的超时值到期。
   - RunLoop被明确唤醒。
8. 通知观察者线程刚被唤醒。
9. 处理未决事件。
   - 如果触发了用户定义的定时器，请处理定时器事件并重新启动循环。 转到步骤2。
   - 如果触发了输入源，请传递事件。
   - 如果RunLoop已显式唤醒，但尚未超时，请重新启动循环。 转到步骤2。
10. 通知观察者RunLoop已退出。

由于定时器和输入源的观察者通知是在这些事件实际发生之前传递的，因此通知时间和实际事件时间之间可能会有偏差。如果这些事件之间的时间很关键，则可以使用睡眠和从睡眠中唤醒通知来关联实际事件之间的时间。

由于在运行RunLoop时会传递定时器和其他周期事件，因此应该规避该循环会破坏这些事件的传递。比如每当通过进入循环并且重复从应用程序请求事件来实现鼠标跟踪例程时就会发生。因为代码是直接捕获事件，而不是让应用程序正常分配事件，所以直到鼠标跟踪例程退出并将控制权返回给应用程序之后，定时器才会触发。

可以使用RunLoop对象显式唤醒RunLoop。其他事件也可能导致RunLoop被唤醒。例如，添加另一个非基于端口的输入源将唤醒RunLoop，以便可以立即处理输入源，而不是等到其它事件结束。

## 何时使用Run Loop?

唯一需要明确运行RunLoop的时间是在为应用程序创建辅助线程时。应用程序主线程的RunLoop是基础架构的关键部分。因此，应用程序框架提供了用于运行主应用程序循环并自动启动该循环的代码。如果使用Xcode创建模版项目，则不必用户调用这些例程。

对于辅助线程，需要确定是否需要RunLoop，如果需要，请自行配置并启动它。但是无需在所有情况下都启动线程的RunLoop。例如，如果使用线程执行一些长时间运行的预定任务，则不用启动RunLoop。RunLoop用于需要与线程进行更多交互的情况。例如，如果您打算执行以下任一操作，则需要启动RunLoop：

- 使用端口或自定义输入源与其他线程进行通信。
- 在线程中使用定时器。
- 在Cocoa中使用任何`performSelector…`方法。
- 保持线程执行周期性任务。

如果确定选择使用RunLoop，配置和设置也非常简单。 与所有线程编程一样，您应该有一个计划，在适当的情况下退出辅助线程。 最好让线程自己完成任务结束，而不是强制终止线程。 

## 使用 Run Loop 对象

RunLoop对象提供了用于将输入源、定时器和观察者添加到RunLoop然后运行它的主界面。 每个线程都有一个与之关联的RunLoop对象。 在Cocoa中，此对象是`NSRunLoop`类的实例。 在底层程序中，它是指向`CFRunLoopRef`类型的指针。

### 获取 Run Loop 对象

要获取当前线程的RunLoop，请使用以下方法之一：

* 在Cocoa应用程序中，使用`NSRunLoop`的`currentRunLoop`方法获取`NSRunLoop`对象。
* 使用`CFRunLoopGetCurrent`函数。

### 配置 Run Loop

在辅助线程上运行RunLoop之前，必须向其添加至少一个输入源或定时器。如果RunLoop没有任何要监视的源，则当您尝试运行它时，它将立即退出。有关如何将源添加到RunLoop的示例，请参见[配置RunLoop源](#配置 Run Loop 源)。

除了安装源，还可以安装RunLoop观察者，并使用它们来检测RunLoop的不同执行阶段。要安装RunLoop观察者，请创建`CFRunLoopObserverRef`类型，然后使用`CFRunLoopAddObserver`函数将其添加到RunLoop中。即使对于Cocoa应用程序，也必须使用Core Foundation创建RunLoop观察者。

下面显示了将RunLoop观察程序附加到其RunLoop的线程的主例程。该示例的目的是展示如何创建RunLoop观察者，因此代码仅设置了一个RunLoop观察者以监视所有RunLoop活动。基本处理程序例程（未显示）在处理定时器请求时仅记录RunLoop活动。

```objectivec
- (void)threadMain {
    // The application uses garbage collection, so no autorelease pool is needed.
    NSRunLoop* myRunLoop = [NSRunLoop currentRunLoop];
 
    // Create a run loop observer and attach it to the run loop.
    CFRunLoopObserverContext  context = {0, self, NULL, NULL, NULL};
    CFRunLoopObserverRef    observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
            kCFRunLoopAllActivities, YES, 0, &myRunLoopObserver, &context);
 
    if (observer) {
        CFRunLoopRef    cfLoop = [myRunLoop getCFRunLoop];
        CFRunLoopAddObserver(cfLoop, observer, kCFRunLoopDefaultMode);
    }
 
    // Create and schedule the timer.
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self
                selector:@selector(doFireTimer:) userInfo:nil repeats:YES];
 
    NSInteger loopCount = 10;
    do {
        // Run the run loop 10 times to let the timer fire.
        [myRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        loopCount--;
    }
    while (loopCount);
}
```

为了让RunLoop生命周期更长，最好添加至少一个输入源以接收消息。 尽管可以只连接一个定时器即可进入RunLoop，但是一旦定时器启动，它通常就会失效，这将导致RunLoop退出。 附加重复定时器可以使RunLoop在更长的时间内运行，但是会涉及定期触发定时器以唤醒线程，这实际上是轮询的另一种形式。 相比之下，输入源会等待事件发生，使线程保持睡眠状态直到事件发生。

### 开启 Run Loop

仅对于程序中的辅助线程才需要启动RunLoop。 一个RunLoop必须至少有一个输入源或定时器来监视。 如果未连接，则RunLoop立即退出。

以下几种方法可以启动RunLoop：

* 无条件
* 设定时间限制
* 在特定模式下

无条件启动RunLoop是最简单的选择，但也是最不希望的。无条件启动RunLoop会将线程置于永久循环，这使得几乎无法控制RunLoop本身。这种方式下也可以添加和删除输入源和定时器，但是停止RunLoop的唯一方法是终止RunLoop。也没有办法在自定义模式下启动RunLoop。

与其无条件地运行RunLoop，不如使用超时值来启动RunLoop。使用超时值时，RunLoop将运行直到事件到达或运行到限定时间为止。如果事件到达，则将该事件调度到处理程序进行处理，然后退出RunLoop。然后，代码可以重新启动RunLoop以处理下一个事件。如果超过分配的时间，则可以简单地重新启动RunLoop，或使用该时间进行任何必要的内务处理。

除了超时值之外，还可以使用特定模式启动RunLoop。模式和超时值不是互斥的，并且在启动RunLoop时都可以使用。模式限制了将事件传递到RunLoop的源类型，并且在[Run Loop Modes](#Run Loop Modes)中有更详细的描述。 

以下示例的关键部分显示了RunLoop的基本结构。 本质上，将输入源和定时器添加到RunLoop，然后重复调用例程之一来启动RunLoop。 每次RunLoop例程返回时，都要检查是否出现了可能需要退出线程的条件。 该示例使用Core FoundationRunLoop例程，以便可以检查返回结果并确定为什么退出RunLoop。 如果使用的是Cocoa，则不需要检查返回值，还可以使用NSRunLoop类的方法以类似的方式启动RunLoop。 

```objectivec
- (void)skeletonThreadMain
{
    // Set up an autorelease pool here if not using garbage collection.
    BOOL done = NO;
 
    // Add your sources or timers to the run loop and do any other setup.
 
    do {
        // Start the run loop but return after each source is handled.
        SInt32    result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 10, YES);
 
        // If a source explicitly stopped the run loop, or if there are no
        // sources or timers, go ahead and exit.
        if ((result == kCFRunLoopRunStopped) || (result == kCFRunLoopRunFinished))
            done = YES;
 
        // Check for any other exit conditions here and set the
        // done variable as needed.
    }
    while (!done);
 
    // Clean up code here. Be sure to release any allocated autorelease pools.
}
```

如果有需要可以递归运行RunLoop。 换句话说，可以从输入源或定时器的处理程序例程中调用CFRunLoopRun，CFRunLoopRunInMode或使用任何NSRunLoop方法来启动RunLoop。 这样做时，可以使用任何要运行嵌套RunLoop的模式，包括外部RunLoop使用的模式。

### 退出 Run Loop

在处理事件之前，有两种方法可以使RunLoop退出：

* 配置RunLoop以超时值运行。
* 告诉RunLoop停止。

如果可以将超时值管理的很好，使用超时值无疑是首选。 指定超时值可使RunLoop在退出之前完成其所有正常处理，包括将通知传递给RunLoop观察者。

使用`CFRunLoopStop`函数停止RunLoop会产生类似于超时的结果。 RunLoop向所有剩余的RunLoop消息发送后再退出。

尽管删除RunLoop的输入源和定时器也可能导致RunLoop退出，但这不是停止RunLoop的可靠方法。 一些系统例程将输入源添加到RunLoop中以处理所需的事件。 因为代码可能无法意识到这些是输入源，所以它将无法删除它们，这将阻止RunLoop退出。

### 线程安全和 Run Loop 对象

线程安全取决于用来操纵RunLoop的API。 Core Foundation中的函数通常是线程安全的，可以从任何线程中调用。 但是，如果执行的操作会更改RunLoop的配置，则最好还是从拥有RunLoop的线程中进行更改。

Cocoa `NSRunLoop`类本质上不像其Core Foundation对应类那样保证线程安全。 如果使用`NSRunLoop`类来修改RunLoop，则应仅从拥有该RunLoop的同一线程进行修改。 将输入源或定时器添加到属于不同线程的RunLoop中可能会导致代码崩溃或行为异常。

## 配置 Run Loop 源

### 定义一个自定义输入源

创建自定义输入元涉及以下内容:

- 希望输入源处理的信息
- 调度程序，让相关客户端知道如何联系输入源
- 处理程序例程，用于执行客户端发送的请求
- 取消例程，使输入源无效

由于创建了一个自定义输入源来处理定制信息，所以实际配置需要设置的比较灵活。调度程序、处理程序和取消例程是自定义输入源必备的关键例程。但是，其余大多数输入源的行为都发生在处理程序之外。

以下显示了自定义输入源的示例配置。在此示例中，应用程序的主线程维护输入源、该输入源的自定义命令缓冲区以及安装该输入源的RunLoop的引用。当主线程拥有要移交给工作线程的任务时，它将命令与工作线程启动任务所需的所有信息一起发布到命令缓冲区。 （由于主线程和工作线程的输入源都可以访问命令缓冲区，因此必须同步该访问。）一旦发布命令，主线程将向输入源发出信号并唤醒工作线程的RunLoop。收到唤醒命令后，RunLoop将调用输入源的处理程序，该处理程序将处理在命令缓冲区中找到的命令。

![RunLoop2](/img/runloop2.png)

#### 定义输入源

定义自定义输入源需要使用Core Foundation来配置RunLoop源并将其附加到RunLoop。 尽管基本处理程序是基于C的函数，但可以使用Objective-C或C ++实现代码主体。

上图中引入的输入源使用一个Objective-C对象来管理命令缓冲区并与RunLoop相协调。 以下代码显示了此对象的定义。 `RunLoopSource`对象管理命令缓冲区，并使用该缓冲区从其他线程接收消息。 还显示了`RunLoopContext`对象的定义，该对象实际上只是一个容器对象，用于将`RunLoopSource`对象和RunLoop引用传递给应用程序的主线程。

```objectivec
@interface RunLoopSource : NSObject
{
    CFRunLoopSourceRef runLoopSource;
    NSMutableArray* commands;
}
 
- (id)init;
- (void)addToCurrentRunLoop;
- (void)invalidate;
 
// Handler method
- (void)sourceFired;
 
// Client interface for registering commands to process
- (void)addCommand:(NSInteger)command withData:(id)data;
- (void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runloop;
 
@end
 
// These are the CFRunLoopSourceRef callback functions.
void RunLoopSourceScheduleRoutine (void *info, CFRunLoopRef rl, CFStringRef mode);
void RunLoopSourcePerformRoutine (void *info);
void RunLoopSourceCancelRoutine (void *info, CFRunLoopRef rl, CFStringRef mode);
 
// RunLoopContext is a container object used during registration of the input source.
@interface RunLoopContext : NSObject
{
    CFRunLoopRef        runLoop;
    RunLoopSource*        source;
}
@property (readonly) CFRunLoopRef runLoop;
@property (readonly) RunLoopSource* source;
 
- (id)initWithSource:(RunLoopSource*)src andLoop:(CFRunLoopRef)loop;
@end
```

尽管Objective-C代码管理输入源的自定义数据，但是将输入源附加到RunLoop需要基于C的回调函数。 将RunLoop源实际添加到RunLoop时，将调用这些函数中的第一个，如下所示。 因为此输入源只有一个客户端（主线程），所以它使用调度程序功能发送消息以在该线程上的应用程序代理中注册自己。 当代理希望与输入源进行通信时，它将使用`RunLoopContex`t对象中的信息进行通信。

```objectivec
void RunLoopSourceScheduleRoutine (void *info, CFRunLoopRef rl, CFStringRef mode)
{
    RunLoopSource* obj = (RunLoopSource*)info;
    AppDelegate*   del = [AppDelegate sharedAppDelegate];
    RunLoopContext* theContext = [[RunLoopContext alloc] initWithSource:obj andLoop:rl];
 
    [del performSelectorOnMainThread:@selector(registerSource:)
                                withObject:theContext waitUntilDone:NO];
}
```

在输入源被信号通知处理自定义数据是最重要的回调之一。 以下代码显示了与`RunLoopSource`对象关联的`perform`回调例程。 此函数只是将完成工作的请求转发到`sourceFired`方法，然后处理命令缓冲区中存在的所有命令。

```objectivec
void RunLoopSourcePerformRoutine (void *info)
{
    RunLoopSource*  obj = (RunLoopSource*)info;
    [obj sourceFired];
}
```

如果使用`CFRunLoopSourceInvalidate`函数从RunLoop中删除输入源，则系统会调用输入源的取消例程。使用此方法来通知客户端您的输入源不再有效，并且他们应删除对其的所有引用。 以下代码显示了向`RunLoopSource`对象注册的取消回调例程。 此函数将另一个`RunLoopContext`对象发送给应用程序委托，但这一次要求委托删除对RunLoop源的引用。

```objectivec
void RunLoopSourceCancelRoutine (void *info, CFRunLoopRef rl, CFStringRef mode)
{
    RunLoopSource* obj = (RunLoopSource*)info;
    AppDelegate* del = [AppDelegate sharedAppDelegate];
    RunLoopContext* theContext = [[RunLoopContext alloc] initWithSource:obj andLoop:rl];
 
    [del performSelectorOnMainThread:@selector(removeSource:)
                                withObject:theContext waitUntilDone:YES];
}
```

#### 安装输入源

以下代码展示了`RunLoopSource`类的`init`和`addToCurrentRunLoop`方法。` init`方法创建`CFRunLoopSourceRef`类型，该类型必须附加到RunLoop。 它将`RunLoopSource`对象本身作为上下文信息传递，以便回调例程具有指向该对象的指针。 在工作线程调用`addToCurrentRunLoop`方法之前，不会安装输入源，此时将调用`RunLoopSourceScheduleRoutine`回调函数。 将输入源添加到RunLoop后，线程可以启动其RunLoop以等待消息。

```objectivec
- (id)init {
    CFRunLoopSourceContext    context = {0, self, NULL, NULL, NULL, NULL, NULL,
                                        &RunLoopSourceScheduleRoutine,
                                        RunLoopSourceCancelRoutine,
                                        RunLoopSourcePerformRoutine};
 
    runLoopSource = CFRunLoopSourceCreate(NULL, 0, &context);
    commands = [[NSMutableArray alloc] init];
 
    return self;
}
 
- (void)addToCurrentRunLoop {
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopAddSource(runLoop, runLoopSource, kCFRunLoopDefaultMode);
}
```

#### 协调输入源与客户端

为了使输入源起作用，需要对其进行操控并从另一个线程发出信号。输入源的目的是让其关联的线程进入休眠状态，直到有事要处理。这个事实使得应用程序中的其他线程必须了解输入源并有一种与之通信的方法。

通知客户有关输入源的一种方法是在输入源首次安装在RunLoop中时发出注册请求。以下程序显示了由应用程序委托定义的注册方法，此方法接收`RunLoopSource`对象提供的`RunLoopContext`对象，并将其添加到其源列表中。

```objectivec
- (void)registerSource:(RunLoopContext*)sourceInfo;
{
    [sourcesToPing addObject:sourceInfo];
}
 
- (void)removeSource:(RunLoopContext*)sourceInfo
{
    id    objToRemove = nil;
 
    for (RunLoopContext* context in sourcesToPing)
    {
        if ([context isEqual:sourceInfo])
        {
            objToRemove = context;
            break;
        }
    }
 
    if (objToRemove)
        [sourcesToPing removeObject:objToRemove];
}
```

#### 向输入源发送信号

客户端将其数据交给输入源后，客户端必须向该源发出信号并唤醒其RunLoop。 向源发出信号可使RunLoop知道该源已准备好进行处理。 并且因为当信号出现时线程可能处于睡眠状态，所以您应该始终显式唤醒RunLoop。 否则，可能会导致输入源处理延迟。

以下代码显示了`RunLoopSource`对象的`fireCommandsOnRunLoop`方法。 客户端准备好让源处理它们添加到缓冲区的命令时，客户端将调用此方法。

```objectivec
- (void)fireCommandsOnRunLoop:(CFRunLoopRef)runloop
{
    CFRunLoopSourceSignal(runLoopSource);
    CFRunLoopWakeUp(runloop);
}
```

> 注意：切勿尝试通过传递自定义输入源来尝试处理SIGHUP或其他类型的过程级信号。 唤醒RunLoop的Core Foundation函数不是信号安全的，因此不应在应用程序的信号处理程序例程中使用。 有关信号处理程序例程的更多信息，请参见[sigaction](https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man2/sigaction.2.html#//apple_ref/doc/man/2/sigaction)手册页。

### 配置定时器源

要创建定时器源，就是创建一个定时器对象并将其配置在RunLoop中。在Cocoa中，可以使用`NSTimer`类创建新的定时器对象，在Core Foundation中，可以使用`CFRunLoopTimerRef`类型。`NSTimer`类只是Core Foundation的扩展，提供了一些便利功能。

在Cocoa中，可以使用以下两种方法之一同时创建和配置定时器：

* `scheduleTimerWithTimeInterval:target:selector:userInfo:repeats:`
* `scheduleTimerWithTimeInterval:invocation:repeats:`

这些方法会创建定时器，并以默认模式（`NSDefaultRunLoopMode`）将其添加到当前线程的RunLoop中。如果需要，还可以手动设置定时器，首先创建`NSTimer`对象，然后使用`NSRunLoop`的`addTimer:forMode:`方法将其添加到RunLoop中。两种技术基本上都具有相同的作用，但是可以提供对时器配置的不同级别的控制。例如，如果创建定时器并将其手动添加到RunLoop中，则可以使用默认模式以外的其他模式来执行此操作。以下代码显示了如何使用这两种技术创建定时器。第一个定时器的初始延迟为1秒，但此后每隔0.1秒有规律地触发一次。第二个定时器在最初的0.2秒延迟后开始触发，然后在此之后每0.2秒触发一次。

```objectivec
NSRunLoop* myRunLoop = [NSRunLoop currentRunLoop];
 
// Create and schedule the first timer.
NSDate* futureDate = [NSDate dateWithTimeIntervalSinceNow:1.0];
NSTimer* myTimer = [[NSTimer alloc] initWithFireDate:futureDate
                        interval:0.1
                        target:self
                        selector:@selector(myDoFireTimer1:)
                        userInfo:nil
                        repeats:YES];
[myRunLoop addTimer:myTimer forMode:NSDefaultRunLoopMode];
 
// Create and schedule the second timer.
[NSTimer scheduledTimerWithTimeInterval:0.2
                        target:self
                        selector:@selector(myDoFireTimer2:)
                        userInfo:nil
                        repeats:YES];
```

以下代码显示了使用Core Foundation函数配置定时器所需的代码。 尽管此示例未在上下文结构中传递任何用户定义的信息，但是可以使用此结构传递定时器所需的任何自定义数据。 有关此结构的内容的更多信息，请参见[CFRunLoopTimer](https://developer.apple.com/documentation/corefoundation/cfrunlooptimer-rhk)中的描述。

```objectivec
CFRunLoopRef runLoop = CFRunLoopGetCurrent();
CFRunLoopTimerContext context = {0, NULL, NULL, NULL, NULL};
CFRunLoopTimerRef timer = CFRunLoopTimerCreate(kCFAllocatorDefault, 0.1, 0.3, 0, 0,
                                        &myCFTimerCallback, &context);
 
CFRunLoopAddTimer(runLoop, timer, kCFRunLoopCommonModes);

```

### 配置基于端口的输入源

Cocoa和Core Foundation都提供了基于端口的对象，用于在线程之间或进程之间进行通信。 以下各节说明如何使用几种不同类型的端口来设置端口通信。

#### 配置一个NSMachPort对象

要与[NSMachPort](https://developer.apple.com/documentation/foundation/nsmachport)对象建立本地连接，创建端口对象并将其添加到主线程的RunLoop中。 启动辅助线程时，将同一对象传递给线程的入口函数。 辅助线程可以使用同一对象将消息发送回主线程。

#####  实现主线程代码

以下代码显示了用于启动辅助工作线程的主线程代码。 因为Cocoa框架执行许多干预步骤来配置端口和RunLoop，所以`launchThread`方法明显短于其Core Foundation等效方法； 但是，两者的行为几乎相同。 一个区别是，此方法不是将本地端口的名称发送到工作线程，而是直接发送`NSPort`对象。

```objectivec
- (void)launchThread
{
    NSPort* myPort = [NSMachPort port];
    if (myPort)
    {
        // This class handles incoming port messages.
        [myPort setDelegate:self];
 
        // Install the port as an input source on the current run loop.
        [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
 
        // Detach the thread. Let the worker release the port.
        [NSThread detachNewThreadSelector:@selector(LaunchThreadWithPort:)
               toTarget:[MyWorkerClass class] withObject:myPort];
    }
}
```

为了在线程之间建立双向通信通道，有时希望工作线程在签入消息中将其自己的本地端口发送到主线程。 接收到签入消息可以使您的主线程知道在启动第二个线程时一切进展顺利，还提供了一种向该线程发送更多消息的方法。

以下代码显示了主线程的`handlePortMessage：`方法。 当数据到达线程自己的本地端口时，将调用此方法。 当签入消息到达时，该方法直接从端口消息中检索辅助线程的端口，并将其保存以供以后使用。

```objectivec
#define kCheckinMessage 100
 
// Handle responses from the worker thread.
- (void)handlePortMessage:(NSPortMessage *)portMessage {
    unsigned int message = [portMessage msgid];
    NSPort* distantPort = nil;
 
    if (message == kCheckinMessage) {
        // Get the worker thread’s communications port.
        distantPort = [portMessage sendPort];
 
        // Retain and save the worker port for later use.
        [self storeDistantPort:distantPort];
    } else {
        // Handle other messages.
    }
}

```

##### 实现辅助线程代码

对于辅助工作线程，必须配置线程并使用指定的端口将信息传递回主线程。

以下代码显示了配置工作线程的代码。 在为线程创建自动释放池之后，该方法将创建一个工作器对象以驱动线程执行。 工作程序对象的`sendCheckinMessage：`方法为工作程序线程创建本地端口，并将签入消息发送回主线程。

```objectivec
+(void)LaunchThreadWithPort:(id)inData
{
    NSAutoreleasePool*  pool = [[NSAutoreleasePool alloc] init];
 
    // Set up the connection between this thread and the main thread.
    NSPort* distantPort = (NSPort*)inData;
 
    MyWorkerClass*  workerObj = [[self alloc] init];
    [workerObj sendCheckinMessage:distantPort];
    [distantPort release];
 
    // Let the run loop process things.
    do
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                            beforeDate:[NSDate distantFuture]];
    }
    while (![workerObj shouldExit]);
 
    [workerObj release];
    [pool release];
}
```

使用`NSMachPort`时，本地线程和远程线程可以将同一端口对象用于线程之间的单向通信。 换句话说，一个线程创建的本地端口对象可以成为另一线程的远程端口对象。

以下代码显示了辅助线程的签入例程。 此方法设置自己的本地端口以用于将来的通信，然后将签入消息发送回主线程。 该方法使用在`LaunchThreadWithPort：`方法中接收的端口对象作为消息的目标。

```objectivec
// Worker thread check-in method
- (void)sendCheckinMessage:(NSPort*)outPort {
    // Retain and save the remote port for future use.
    [self setRemotePort:outPort];
 
    // Create and configure the worker thread port.
    NSPort* myPort = [NSMachPort port];
    [myPort setDelegate:self];
    [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
 
    // Create the check-in message.
    NSPortMessage* messageObj = [[NSPortMessage alloc] initWithSendPort:outPort
                                         receivePort:myPort components:nil];
 
    if (messageObj) {
        // Finish configuring the message and send it immediately.
        [messageObj setMsgId:kCheckinMessage];
        [messageObj sendBeforeDate:[NSDate date]];
    }
}

```

#### 配置一个NSMessagePort对象

要与`NSMessagePort`对象建立本地连接，不能简单地在线程之间传递端口对象。 远程消息端口必须按名称获取。 要在Cocoa中实现此功能，需要使用特定名称注册本地端口，然后将该名称传递给远程线程，以便它可以获取适当的端口对象以进行通信。 以下代码显示了要使用消息端口的情况下的端口创建和注册过程。

```objectivec
NSPort* localPort = [[NSMessagePort alloc] init];
 
// Configure the object and add it to the current run loop.
[localPort setDelegate:self];
[[NSRunLoop currentRunLoop] addPort:localPort forMode:NSDefaultRunLoopMode];
 
// Register the port using a specific name. The name must be unique.
NSString* localPortName = [NSString stringWithFormat:@"MyPortName"];
[[NSMessagePortNameServer sharedInstance] registerPort:localPort
                     name:localPortName];

```

#### 使用Core Foundation配置基于端口的输入源

本节说明如何使用Core Foundation在应用程序的主线程和辅助线程之间建立双向通信通道。

以下代码显示了应用程序的主线程调用以启动工作线程的代码。 代码要做的第一件事是设置`CFMessagePortRef`类型，以监听来自工作线程的消息。 工作线程需要使用端口名称进行连接，以便将字符串值传递到工作线程的入口函数。 在当前用户上下文中，端口名称通常应该是唯一的，否则，可能会遇到冲突。

```objectivec
#define kThreadStackSize        (8 *4096)
 
OSStatus MySpawnThread()
{
    // Create a local port for receiving responses.
    CFStringRef myPortName;
    CFMessagePortRef myPort;
    CFRunLoopSourceRef rlSource;
    CFMessagePortContext context = {0, NULL, NULL, NULL, NULL};
    Boolean shouldFreeInfo;
 
    // Create a string with the port name.
    myPortName = CFStringCreateWithFormat(NULL, NULL, CFSTR("com.myapp.MainThread"));
 
    // Create the port.
    myPort = CFMessagePortCreateLocal(NULL,
                myPortName,
                &MainThreadResponseHandler,
                &context,
                &shouldFreeInfo);
 
    if (myPort != NULL)
    {
        // The port was successfully created.
        // Now create a run loop source for it.
        rlSource = CFMessagePortCreateRunLoopSource(NULL, myPort, 0);
 
        if (rlSource)
        {
            // Add the source to the current run loop.
            CFRunLoopAddSource(CFRunLoopGetCurrent(), rlSource, kCFRunLoopDefaultMode);
 
            // Once installed, these can be freed.
            CFRelease(myPort);
            CFRelease(rlSource);
        }
    }
 
    // Create the thread and continue processing.
    MPTaskID        taskID;
    return(MPCreateTask(&ServerThreadEntryPoint,
                    (void*)myPortName,
                    kThreadStackSize,
                    NULL,
                    NULL,
                    NULL,
                    0,
                    &taskID));
}
```

安装端口并启动线程后，主线程可以在等待线程检入的同时继续其常规操作。当检入消息到达时，它将分派到主线程的`MainThreadResponseHandler`函数，如以下代码所示，此函数提取工作线程的端口名称，并创建用于将来通信的管道。

```objectivec
#define kCheckinMessage 100
 
// Main thread port message handler
CFDataRef MainThreadResponseHandler(CFMessagePortRef local,
                    SInt32 msgid,
                    CFDataRef data,
                    void* info)
{
    if (msgid == kCheckinMessage)
    {
        CFMessagePortRef messagePort;
        CFStringRef threadPortName;
        CFIndex bufferLength = CFDataGetLength(data);
        UInt8* buffer = CFAllocatorAllocate(NULL, bufferLength, 0);
 
        CFDataGetBytes(data, CFRangeMake(0, bufferLength), buffer);
        threadPortName = CFStringCreateWithBytes (NULL, buffer, bufferLength, kCFStringEncodingASCII, FALSE);
 
        // You must obtain a remote message port by name.
        messagePort = CFMessagePortCreateRemote(NULL, (CFStringRef)threadPortName);
 
        if (messagePort)
        {
            // Retain and save the thread’s comm port for future reference.
            AddPortToListOfActiveThreads(messagePort);
 
            // Since the port is retained by the previous function, release
            // it here.
            CFRelease(messagePort);
        }
 
        // Clean up.
        CFRelease(threadPortName);
        CFAllocatorDeallocate(NULL, buffer);
    }
    else
    {
        // Process other messages.
    }
 
    return NULL;
}
```

配置好主线程后，剩下的唯一事情就是让新创建的工作线程创建自己的端口并检入。以下代码显示了工作线程的入口函数。 该函数提取主线程的端口名，并使用它来创建返回到主线程的远程连接。 然后，该函数为其自身创建一个本地端口，将该端口安装在线程的RunLoop中，并将包含本地端口名称的签入消息发送到主线程。

```objectivec
OSStatus ServerThreadEntryPoint(void* param)
{
    // Create the remote port to the main thread.
    CFMessagePortRef mainThreadPort;
    CFStringRef portName = (CFStringRef)param;
 
    mainThreadPort = CFMessagePortCreateRemote(NULL, portName);
 
    // Free the string that was passed in param.
    CFRelease(portName);
 
    // Create a port for the worker thread.
    CFStringRef myPortName = CFStringCreateWithFormat(NULL, NULL, CFSTR("com.MyApp.Thread-%d"), MPCurrentTaskID());
 
    // Store the port in this thread’s context info for later reference.
    CFMessagePortContext context = {0, mainThreadPort, NULL, NULL, NULL};
    Boolean shouldFreeInfo;
    Boolean shouldAbort = TRUE;
 
    CFMessagePortRef myPort = CFMessagePortCreateLocal(NULL,
                myPortName,
                &ProcessClientRequest,
                &context,
                &shouldFreeInfo);
 
    if (shouldFreeInfo)
    {
        // Couldn't create a local port, so kill the thread.
        MPExit(0);
    }
 
    CFRunLoopSourceRef rlSource = CFMessagePortCreateRunLoopSource(NULL, myPort, 0);
    if (!rlSource)
    {
        // Couldn't create a local port, so kill the thread.
        MPExit(0);
    }
 
    // Add the source to the current run loop.
    CFRunLoopAddSource(CFRunLoopGetCurrent(), rlSource, kCFRunLoopDefaultMode);
 
    // Once installed, these can be freed.
    CFRelease(myPort);
    CFRelease(rlSource);
 
    // Package up the port name and send the check-in message.
    CFDataRef returnData = nil;
    CFDataRef outData;
    CFIndex stringLength = CFStringGetLength(myPortName);
    UInt8* buffer = CFAllocatorAllocate(NULL, stringLength, 0);
 
    CFStringGetBytes(myPortName,
                CFRangeMake(0,stringLength),
                kCFStringEncodingASCII,
                0,
                FALSE,
                buffer,
                stringLength,
                NULL);
 
    outData = CFDataCreate(NULL, buffer, stringLength);
 
    CFMessagePortSendRequest(mainThreadPort, kCheckinMessage, outData, 0.1, 0.0, NULL, NULL);
 
    // Clean up thread data structures.
    CFRelease(outData);
    CFAllocatorDeallocate(NULL, buffer);
 
    // Enter the run loop.
    CFRunLoopRun();
}
```

进入RunLoop后，所有将来发送到线程端口的事件都将由`ProcessClientRequest`函数处理。 该函数的实现取决于线程执行的工作类型，此处未显示。



**来源：[Threading Programming Guide-Run Loops](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Multithreading/RunLoopManagement/RunLoopManagement.html#//apple_ref/doc/uid/10000057i-CH16-SW10)**

