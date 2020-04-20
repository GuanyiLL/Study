# Block

## 理解Block

### 基础

一个最基本的`block`长这样：

```objectivec
^{
  // Block需要做xxx
}
```

`block`也可以作为一个变量使用，而一个没有参数也没有返回值的`block`大概长这样：

```objectivec
void (^someBlock)() = ^{
  // Block需要做xxx
}
```

上面的代码定义了一个叫做`someBlock`的`block`变量，语法有些奇怪，可以总结成这样：

```objectivec
return_type (^block_name)(parameters)
```

定义一个返回值为`int`类型，参数为2个`int`类型的`block`：

```objectivec
int (^addBlock)(int a, int b) = ^(int a, int b){
  return a+b;
}
```

`block`可以作为函数使用，因此可以这样调用刚才的`addBlock`:

```objectivec
int add = addBlock(2, 5) // add = 7
```

在`block`中可以截获外部定义的变量：

```objectivec
int additional = 5;
int (^addBlock)(int a, int b) = ^(int a, int b) {
  return a + b + additional;
};
int add = addBlock(2, 5); // add = 12
```

然而外部定义的变量，在`block`中只能使用无法更改，如果强行更改编译器会报错，如果需要更改外部变量的值，就必须在声明变量的前面加上`__block`。

```objectivec
__block int additional = 5;
int (^addBlock)(int a, int b) = ^(int a, int b) {
  additional += 1;
  return a + b + additional;
};
int add = addBlock(2, 5); // add = 13
```

`block`在截获一个对象的时候，也会持有这个对象。而这个对象会在`block`释放的时候才会随着释放。`blcok`其实也是一个对象，所以也使用引用计数方式管理内存。如果`block`定义在一个OC的类中，那么`self`会跟随着每个这个类的实例变量。而实例变量不需要明确添加`__block`，但是如果实例变量进行读写操作时被`block`截获，那么`self`也会被截获，举个例子：

```objectivec
- (void)anInstanceMethod {
  //...
  void(^someBlock) = ^{
    _anInstanceVariable = @"something";
    NSLog(@"_anInstanceVariable = %@", _anInstanceVariable);
  };
  //...
}
```

如果A类中有一个这样的对象方法，那么当调用时`self`其实也被捕获了，因为访问实例变量的时候，等同于以下写法：

```objectivec
self->_anInstanceVariable = @"something";
```

而成员变量(property)则可以清楚的看到`self`:

```objectivec
self.aProperty = @"something";
```

`self`会被截获并持有的情况需要注意，因为可能会引起循环引用。

### 进阶

`block`的内存布局：

![memory layout](../img/block1.png)

其中最重要的是`invoke`，指向`block`的实现存放处的函数指针。该函数至少含有一个`void*`,也就是`block`自身。`block`其实也就是一个匿名函数指针,将以前使用标准C语言功能完成的操作包装的更简洁易用。

`descriptor`是一个指向结构体的指针，声明了`block`对象的整体大小以及用于复制和处理助手的函数指针。这些助手往往在`block`捕获对象时进行持有、释放操作时起到作用。

一个`block`包含所有的被截获的对象的副本。这些副本存储在`descriptor`之后，并占用存储所有捕获变量所需的空间。注意，这并不意味着对象本身被复制，并且还包含变量的指针。运行`block`时，将从该内存区域读取捕获的变量，这就是为什么需要将该`block`作为参数传递到`invoke`函数的原因。

### 全局、栈和堆中的Blocks

当一个`block`被定义后，它将在栈中占有一块空间。也就是说这个`block`仅仅在所定义的作用域才有效。代码这么写会有问题：

```objective-c
void(^block)();
if (/*some condition*/) {
  	block = ^{
      	NLog(@"Block A");
    }
} else {
		block = ^{
      	NSLog(@"Block B");
    }
}
block();
```

这两个`block`定义在`if-else`语句中，并且存放在栈内存中，当为每个`block`分配堆栈内存时，编译器可以在分配该内存的作用域末尾自由覆盖该内存。 因此，保证每个块仅在其各自的if语句部分内有效。 这段代码编译可以通过，但在运行时可能会崩溃。如果系统没有重写这段`block`所占用的内存，则该代码将运行而不会出错，反之，肯定会发生崩溃。

而向这个`block`发送`copy`消息，则可以将`block`从栈内存复制到堆内存中，这样`block`则可以在定义的作用域外被使用。这个`block`也跟其他的OC对象一样使用引用计数管理内存，当引用计数为0时，则会释放。

```objective-c
void(^block)();
if (/*some condition*/) {
  	block = [^{
      	NLog(@"Block A");
    } copy];
} else {
		block = [^{
      	NSLog(@"Block B");
    } copy];
}
block();
```

这样代码就安全了，而全局`block`则是独立在栈与堆空间以外的内存，它在编译时就决定了所使用的内存，所以全局`block`也不用每次使用的时候在栈上开辟内存，也无需进行`copy`操作。基本上长这样：

```objective-c
void (^block)() = ^{
  	NSLog(@"This is a block");
};
```



## 使用typedefs

`block`也可以当作变量使用

```objective-c
^(BOOL flag, int value) {
  	if (flag) {
      	return value *5;
    } else {
      	return value *10;
    }
}

//以上是一个普通的block，现在将它赋值给某个变量

int (^variableName)(BOOL flag, int value) = ^(BOOL flag, int value) {
  	// Implementation
  	return someInt;
}
```

以上的写法虽然与普通的数据类型不一样，但是看起来很像函数指针。为了让繁琐的`block`类型看起来简洁一些，可以使用C语言中的类型定义`typedefs`。我们可以这样定义一个新的类型：

```objective-c
typedef int(^EOCSomeBlock)(BOOL flag, int value);
```

这样就定义了一个新的类型`EOCSomeBlock`,而在使用的时候可以这样：

```objective-c
EOCSomeBlock block = ^(BOOL flag, int value) {
  	// Implementation
};
```

而在设计API的时候，也可以通过使用类型定义来简化方法中的`block`：

```objective-c
- (void)startWithCompletionHandler:(void(^)(NSData *data,NSError *error))completion;

//使用typedef改造后

typedef void(^EOCCompletionHandler)(NSData *data,NSError *error);
- (void)startWithCompletionHandler:(EOCCompletionHandler)completion;

```

这样写的话不仅看起来变量意义更明确，而且也更便于维护，如果代码中有多个地方使用了这个类型，那么在需求变更或者有改动的时候，只需要更改定义类型的地方就可以了，而不用整个工程找使用过的地方。

## 避免循环引用

```objective-c
// EOCNetworkFetcher.h
#import <Foundation/Foundation.h>

typedef void(^EOCNetworkFetcherCompletionHandler)(NSData *data);

@interface EOCNetworkFetcher : NSObject
@property (nonatomic, strong) NSURL *url;
- (id)initWithURL:(NSRUL *)url;
- (void)startWithCompletionHandler:(EOCNetworkFetcherCompletionHandler)completion;
@end

// EOCNetworkFetcher.m
#import "EOCNetworkFetcher.h"

@interface EOCNetworkFetcher()
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, copy) EOCNetworkFetcherCompletionHandler completionHandler;
@property (nonatomic, strong) NSData *downloadedData;
@end
  
@implementation EOCNetworkFetcher
 - (id)initWithURL:(NSURL *)url {
  	if (self = [super init]) {
      	_url = url;
    }
  	return self;
}

- (void)startWithCompletionHandler:(EOCNetworkFetcherCompletionHandler)completion {
  	self.completionHandler = completion;
  	//Start the request
  	//Request sets downloadedData property
  	//When request is finished, p_requestCompleted is called
}

- (void)p_requestCompleted {
  	if (_completionHandler) {
      	_completionHandler(_downloadedData);
    }
}
@end
```

这时候另一个类使用这个类进行网络请求：

```objective-c
@implementation EOCClass {
  	EOCNetworkFetcher = _networkFetcher;
  	NSData* _fetchedData;
}

- (void)downloadData {
  	NSURL *url = [[NSURL alloc] initWithString:@"http://www.example.com.something.dat"];
  	_networkFetcher = [[EOCNetworkFetcher alloc] initWithURL:url];
  	[_networkFetcher startWithCompletionHandler:^(NSData *data){
      	NSLog(@"Request URL %@ finished",_networkFetcher.url);
      	_fetchedData = data;
    }];
}

@end
```

以上代码只是一个普通的网络请求代码，可以很好的反映出循环引用的关系：

![retain cycle](../img/block2.png)

而打破这个引用也很简单：

```objective-c
[_networkFetcher startWithCompletionHandler:^(NSData *data){
    NSLog(@"Request URL %@ finished",_networkFetcher.url);
    _fetchedData = data;
  	_networkFetcher = nil;
}];
```

```objective-c
- (void)downloadData {
  	NSURL *url = [[NSURL alloc] initWithString:@"http://www.example.com.something.dat"];
  	EOCNetworkFetcher *networkFetcher = [[EOCNetworkFetcher alloc] initWithURL:url];
  	[networkFetcher startWithCompletionHandler:^(NSData *data){
      	NSLog(@"Request URL %@ finished",networkFetcher.url);
      	_fetchedData = data;
    }];
}
```

以上两种方式都可以打破循环引用，还有一种比较简便的方式，也不用考虑回调是否需要多次使用，或者发起请求的对象是否需要多次使用：

```objective-c
__weak typeof(self) weakSelf = self;
[_networkFetcher startWithCompletionHandler:^(NSData *data){
    NSLog(@"Request URL %@ finished",self.networkFetcher.url);
    self.fetchedData = data;
}];
```

以上的方法，都是为了打破这种引用关系。至于是否形成循环引用，也可以看看对象之间是否形成引用的闭环。

**以上来自 *52 specific Ways to Improve Your iOS and OS X Programs*******

### __block 原理

为什么添加了`__block`修饰符之后就可以对截获的变量进行修改了呢？

我们可以使用

`clang -rewrite-objc 文件名`来将OC代码转换为C++文件，比如下列例子：

```objective-c
int main(int argc, const char * argv[]) {
    
    int age = 10;
    void(^myBlock)(void) = ^{
        NSLog(@"Print Age = %d", age);
    };
    age = 18;
    myBlock();
    return 0;
}
```

上述例子中，输出结果为`Print Age = 10`，将文件转换为CPP格式之后代码如下：

![Block3](/img/block3.png)

不难看出，`block`在截获普通变量的时候，只是将值传递到了`block`中，因此，不能修改外部参数。

而加上修饰符后：

![Block4](/img/block4.png)

这次`age`相关的变量，都变成了`__Block_byref_age_0`的结构体，并且传参时都使用了`&`来取地址，由于传递的是引用，因此可以修改外部变量的值。

那么在看一下OC对象的情况:

 ```objective-c
NSMutableArray *arr = [@[@1, @2, @3] mutableCopy];
void(^myBlock)(void) = ^{
    [arr addObject:@4];
};
[arr addObject:@5];
myBlock();
 ```

编译成CPP文件后：

![Block5](/img/block5.png)

在block内部，我们可以通过NSMutableArray的方法来修改该数组，但是如果在block内部重新初始化数组编译器则会报错。

加入`__block`后则可以修改：

![Block6](/img/block6.png)

可以看出，无论是基础类型还是OC对象，在block截获后，加入`__block`后，OC会将该变量声明成`__Block_bref_变量名_0`这样的结构体，然后将地址当作参数，因此在`block`内部，可以通过`__forwarding`获取到该变量堆上的地址，从而修改或者重新分配空间。我们也可以通过LLVM中的p指令来打印截获变量的地址，发现如果不加修饰符的话，地址是不一样的。
