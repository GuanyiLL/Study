# Runtime

arm64架构开始，对isa进行了优化，变成一个共用体(union)结构，还是用了位域来存储更多的信息。

```objectivec
union {
        char bits;
        struct {
            char val1 : 1;
            char val2 : 1;
            char val3 : 1;
            char val4 : 1;
        };
    } _someValue;
```

共用体中bits与_someValue公用一块内存，struct中只是为了代码可读性更强，并未参与存储。

## Class结构

**class_rw_t**

```objectivec
struct class_rw_t {
	method_array_t method; // 存放的是method_list_t，其中元素类型为method_t
	property_array_t properties;
	protocol_array_t protocols;
}
```

**class_ro_t**

存放类中的初始信息，baseMethodList，baseProtocols，ivars，baseProperties都是只读的。

**method_t**

```objectivec
struct method_t {
	SEL name; // 函数名
	const char *types; //编码（返回值类型、参数类型）
	IMP imp; //指向函数的指针（函数地址）
}
```

**cache_t**

调用过的方法，会放入类对象的cache_t中，第二次调用的时候，从cache_t中获取方法，以提升效率。

```objectivec
struct cache_t {
	struct bucket_t *_buckets; //散列表
	mask_t _mask;	//散列表长度-1 
	mask_t _occupied; //已经缓存的方法数量
}
struct bucket_t {
	cache_key_t _key; //SEL作为key
	IMP _impl //函数内存地址
}
```

散列表

将方法的selector作为key，与mask进行按位与操作，得到索引，然后存储到buckets中，读取缓存的时候也同样适用这种方法。如果计算后得到的索引与想存取的key不符，则直接将索引减一，直至到0，如果还无法存取，则改为mask继续查找。

扩容时会将原有的表清空，然后重新构建缓存。扩容量为原容量*2.

## objc_msgSend

给消息接收者，发送消息。分为三个阶段：

1. 消息发送
2. 动态方法解析
3. 消息转发

### 消息发送

1. 判断receiver是否为nil,是直接return，否则进入步骤2
2. 从reveiverClass的cache中查找方法，如果找到就直接调用并且结束查找，否则进步骤3
3. 从reveiverClass的class_rw_t中查找方法，如果找到，执行步骤4，没找到，进入步骤5
4. 执行，并将方法缓存到reveiverClass的cache，结束查找。
5. 从superClass的cache中查找方法，如果查找到，则执行步骤4，如果没找到则执行步骤6
6. 从superClass的class_rw_t中查找方法，如果找到，责执行步骤4，如果没有责执行步骤7
7. 判断上层是否还有superClass，如果有责执行步骤5，如果没有责进入动态方法解析。

### 动态方法解析

```objectivec
+(BOOL)resoveInstanMethod:(SEL)sel {
	if (sel == @selector(targetFunc)) {
    Method method = class_getInstanceMethod(self, @selector(someMehod));
		class_addMethod(self, sel, method_getImplementation(method), method_getTypeEncoding(method));
		return YES;
	} 
	return [super resoveInstanMethod:sel];
}
```

然后回到消息发送步骤。

解析过程：

1. 是否曾经有动态解析，如果是，进入消息转发，否进入步骤2
2. 调用+resolveInstanceMethod:或者+resolveClassMethod:方法来动态解析方法，然后执行步骤3
3. 标记为已经动态解析
4. 回到消息发送阶段，从receiverClass的cache中查找方法这一步开始执行

### 消息转发

```objectivec
-(id)forwardingTargetForSelector:(SEL)aSelector {
	return nil;
}

// 方法签名：返回值类型、参数类型
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
  if (aSelector == @selector()) {
    return [NSMethodSignature signatureWithObjCTypes:"v16@0:8"];
  }
  return [super forwardingTargetForSelector:sel];
}

// NSInvocation封装了一个方法调用，包括：方法调用者、方法名、方法参数
- (void)forwardInvocation:(NSInvocation *)anInvocation {
	[anInvocation invokeWithTarget:[[YourClass alloc] init]];
}
```

消息转发步骤：

1. 调用forwardingTargetForSelector:方法，如果不返回nil，则调用objc_msgSend(返回的对象, SEL)，如果返回nil，执行步骤2
2. 调用methodSignatureForSelector:方法，如果不返回nil，则调用forwardInvocation:方法，如果为nil，直接抛出异常。

## super

1. 消息接收者仍然是子类对象
2. 从父类开始查找方法实现

`[self class]`与`[super class]`，最终class方法的实现都在NSObject中。

```objectivec
-(Class)class {
 	return objc_getClass(self);
}

-(SuperClass) {
  return class_getSuperClass(object_getClass(self));
}
```

消息接收者决定了返回值的类型，而super仅仅是从父类方法列表开始搜寻方法。

```objectivec
struct objc_msgSendSuper2 {
	id receiver;
	Class current_class
}
```

### isMemberOfClass / isKindOfClass

对于类对象调用，比较的是元类之前的关系

```objectivec
+ (BOOL)isKindOfClass:(Class)cls {
    for (Class tcls = self->ISA(); tcls; tcls = tcls->superclass) {
        if (tcls == cls) return YES;
    }
    return NO;
}
+ (BOOL)isMemberOfClass:(Class)cls {
    return self->ISA() == cls;
}
```

栈空间分配变量，从高地址到低地址。



