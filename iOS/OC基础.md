# OC基础

## 对象的本质

<details><summary>一个NSObject对象占多少内存</summary>16字节</details>
<details><summary>将文件编译为iphone平台的cpp文件</summary>xcrun -sdk iphoneos clang -arch arm64 -rewrite-objc 文件名 -o 目标文件名.app</details>
```objectivec
// Implementation
struct NSObject_IMP {
	Class isa;    // 8个字节
}

NSObject *obj = [[NSObject alloc] init];
    
// NSObject实例对象成员变量所占用的大小：8
NSLog(@"%zd", class_getInstanceSize([NSObject class]));
    
// obj 指针所指向内存大小 16
NSLog(@"%zu",malloc_size((__bridge const void*)anim));
```

iOS系统，小端模式读取内存

class_getInstanceSize返回的大小遵循内存对其，为8的倍数

libmalloc分配内存时有内存对齐规则，为16的倍数

sizeof(obj)只是在编译阶段直接把obj指针的大小转成数字，是运算符并不是调用方法

## 对象的分类

实例对象，通过alloc出来的对象

* isa指针

* 其它成员变量

类对象

获取类对象的方法：

```objectivec
NSObject *obj = [[NSObject alloc] init];
Class objClass = [obj class];
Class objClass2 = object_getClass(obj);
Class objClass3 = [NSObject class];
NSLog(@"%p %p %p",objClass,objClass2,objClass3);
```

* isa指针
* superclass指针
* 类的属性信息
* 类的成员变量的描述信息
* 实例方法信息
* 类的协议信息，
* 类的成员变量信息(ivar)

元类对象

获取元类对象的方法：

```objectivec
// 将类对象传入，获得元类对象
Class objectMetaClass = object_getClass([NSObject class]);

// class 方法，返回的始终是类对象。并不能返回元类对象
Class objClass = [[NSObject class] class];
```

每个类在内存中有且仅有一个meta-class对象

meta-class对象和class对象的内存布局结构一样，但是用途不同，在内存中存储的信息主要包括：

* isa指针

* superclass指针

* 类方法信息

## isa 指针

<details><summary>instance的isa</summary>指向class，当调用对象方法时，通过instance的isa找到class，最后找到对象方法的实现进行调用
</details>

<details><summary>class的isa</summary>指向meta-class,当调用类方法时，通过class的isa找到meta-class，最后找到类方法的实现进行调用</details>
> 64系统，对象的isa&ISA_MASK获取的才是对象的类对象地址，类对象的isa&ISA_MASK才是元类的地址

## superclass指针

### class对象

Student的instance对象要调用Person的方法时，会先通过isa找到Student的类对象，然后通过superclass找到Person的类对象，最后找到对象方法的实现进行调用

类对象的superclass指向父类的类对象

### meta-class对象

元类对象的superclass指向父类的元类对象，Root class的superclass指向Root class的类对象

## class结构

### ![OC基础01](/img/OC基础01.png)

## KVO

被监听的对象，修改属性时会调用set方法，然后执行监听的回调。

被监听的对象的isa指针，指向叫做NSKVONotifying_XXX的动态创建的类，是XXX类型的子类。

NSKVONotifying_XXX--> setFun-->`Foundation`_NSSetIntValueAndNotify()

NSSetIntValueAndNotify方法名称中的类型与监听的属性类型有关

```objectivec
// 伪代码
void setFun:(id)value {
	_NSSetIntValueAndNofify()
}

void _NSSetIntValueAndNofify() {
	  [self willChangeValueForKey:"key"];
	  [super setFun:value];
	  [self didChangeValueForKey:"key"];
}

- (void)didChangeValueForKey(NSString *)key {
		// 通知监听器
		[observer observeValueForKeyPath:key ofObject:self change:nil context:nil];
}
```

### 窥探Foundation

_NSSet***ValueAndNotify

NSKVONotifying_XXX

```objectivec
void setFun:(id)value {
	_NSSetIntValueAndNofify()
}

- (Class)class {
  // 为了屏蔽内部的实现
  return [Original class];
}

- (BOOL)_isKOA {
  return YES;
}

- (void)dealloc {
  
}
```

```objectivec
unsigned int count;
class_copyMethodList(pls, &count);// 获取所有的方法
```

手动触发：
```objectivec
[obj willChangeForKey:"key"];
obj->key = @"aaa";
[obj didChangeForKey:"key"];
```

## KVC

KVC会触发KVO

<details><summary>setValueForKey的流程:</summary> setValue:forKey ===> setKey:/_setKey:如果没有两个set方法会执行以下方法，询问是否可以访问成员变量
+(BOOL)accessIntanceVariablesDirectly
return NO； 则会崩溃。
return YES；依次访问_key, _isKey, key, isKey
如果都访问不到，则崩溃抛出异常。
</details>

<details><summary>valueForKey的流程：</summary>按照getKey, key, isKey, _ key的顺序调用， 如果没这四个方法会执行以下方法，询问是否可以访问成员变量accessIntanceVariablesDirectly，returnNO则抛出异常。return YES，则依次访问_ key,  _isKey, key,  isKey
如果都访问不到，则崩溃抛出异常。</details>

## Category

运行时机制，runtime动态将分类方法合并到类对象和元类中。

每一个分类，编译后会变成一个结构体对象:

```objectivec
sturct _category_t {
	const char *name;
	struct _class_t *cls;
	const struct _method_list_t *instance_methods;
	const struct _method_list_t *class_methods;
	const struct _protocol_list_t *protocols;
	const sturct _prop_list_t *properties;
}
```

<details>
	<summary>源码实现</summary>  
运行时添加方法列表，在添加分类时，现将存放方法的数组重新分配大小，然后将之前的方法列表，通过memomove方法移动到末尾的位置，最后将新增的分类放在扩容后的数组的前面。最后编译的分类方法放在最前的位置
</details>

### 类扩展（class extension）

编译期就将.m文件中的类拓展内容合并到类信息里。

### memmove与memcopy的区别

将3,4移动到4,1的位置

Copy:

[3,4,1,2]

[3,3,1,2]

[3,3,3,2]

Move:

[3,4,1,2]

[3,4,4,2]

[3,3,4,2]

### +load

先调用所有类的load方法，直接获取load方法地址，并没有遍历类对象方法列表。

