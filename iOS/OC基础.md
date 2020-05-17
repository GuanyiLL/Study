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

<details><summary>setValueForKey的流程:</summary> setValue:forKey ===> setKey:/_setKey:</br>如果没有两个set方法会执行以下方法，询问是否可以访问成员变量</br>
+(BOOL)accessIntanceVariablesDirectly</br>
return NO； 则会崩溃。</br>
return YES；依次访问_key, _isKey, key, isKey</br>
如果都访问不到，则崩溃抛出异常。
</details>

<details><summary>valueForKey的流程：</summary>按照getKey, key, isKey, _ key的顺序调用， 如果没这四个方法会执行以下方法，询问是否可以访问成员变量</br>accessIntanceVariablesDirectly，</br>returnNO则抛出异常。</br>return YES，则依次访问_ key,  _isKey, key,  isKey
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
运行时添加方法列表，在添加分类时，现将存放方法的数组重新分配大小，然后将之前的方法列表，通过memmove方法移动到末尾的位置，最后将新增的分类放在扩容后的数组的前面。最后编译的分类方法放在最前的位置
</details>

### 类扩展（class extension）

编译期就将.m文件中的类拓展内容合并到类信息里。

### memmove与memcopy的区别

将3,4移动到4,1的位置

Copy:

[3,4,1,2] -> [3,3,1,2] -> [3,3,3,2]

Move:

[3,4,1,2] -> [3,4,4,2] -> [3,3,4,2]

### +load

runtime加载类、分类的时候调用

每个类、分类的+load，在程序中只调用一次

调用顺序：

先调用类的+load方法，直接获取类的load方法地址，并没有遍历类对象方法列表。

按照编译先后顺序调用（先编译，先调用）

调用子类的+load之前先调用父类的+load（递归添加到数组中，将父类传入方法）

调用分类的load方法

### +initialize

一个类在第一次接收消息的时候调用。通过msgSend方法调用。

先调用父类的+initialize，然后调用子类的+initialize。如果分类中有+initialize方法，则调用分类中的。

如果子类没有实现+initialize，则会调用父类的

```
if (SubclassIsInitialized) {
	if (SuperclassIsInitialized) {
		objc_msgSend([Superclass class], @selector(initialize));
		SuperclassIsInitialized = YES;
	}
	objc_msgSend([Subclass class], @selector(initialize));
	SubclassIsInitialized = YES;
}
```

Objc-runtime-new.mm中的调用顺序：

1. class_getInstanceMethod

2. lookUpImpOrNil

3. lookUpImpOrForward

4. _class_initialize

5. callInitialize

6. objc_msgSend(cls,SEL_initialize)

### load、initialize区别

1. 调用方式
   1. load根据函数地址直接调用
   2. initialize通过objc_msgSend调用
2. 调用时刻
   1. load是runtime加载类、分类时调用（只会调用一次）
   2. initialize第一次接收消息时调用，每一个类只会调用一次（父类可能多次调用）

调用顺序：

1. load
   1. 先调用类的load
      1. 先编译的类，有先调用load
      2. 调用子类load之前，会调用父类的load
   2. 调用分类的load
      1. 先编译的分类，优先调用load
2. initailize
   1. 先初始化父类
   2. 初始化子类（可能最终调用父类的initialize）

## 关联属性

在分类中使用property只会生成get/set方法的声明，并没有成员变量与get/set的方法实现。

key的定义:

```objectivec
static const void* Key1 = &key1
static const void* Key2 = &key2
  
static const char Key1;
static const char Key2;

直接传入@"key1",@"key2"
# define Key @"key1"
# define Key @"key2"
  
@selector(key1)
@selector(key2)
  
_cmd == @selector(key) //隐式参数
```

### 实现核心对象

AssociationsManager

AssociationsHashMap

ObjectAssociationMap

ObjcAssociation

源码：objc-reference.mm

![AssociateObject1](/img/AssociateObject1.png)

## Block

### auto变量截获

```objectivec
int age = 20;
void (^block)(void) = ^{
	NSLog(@"age = %d", age);
}
```

一个普通的block，底层编译后变为：

```objectivec
struct __main_block_impl_0 {
	struct __block_imp impl;
	struct __main_block_desc_0 *Desc;
	int age; //外部截获的变量
}

struct __block_impl {
	void *isa;
	int Flags;
	int Reserved;
	void *FuncPtr;   // 存放block内的函数地址
}

struct __main_block_desc_0 {
	size_t reserved;
	size_t Block_size; // block的大小
}
```

### static变量截获

```objectivec
static int age = 20;
void (^block)(void) = ^{
	NSLog(@"age = %d", age);
}

struct __main_block_impl_0 {
	struct __block_imp impl;
	struct __main_block_desc_0 *Desc;
	int *age; //外部截获的变量
}
```

block初始化时，将age的地址传入block，在调用block时，会访问age的地址，因此age的改动会影响block内的值。

### 全局变量截获

并不会截获，block调用时会直接访问全局变量，无需捕获。

### block类型

没有访问auto变量--GlobalBlock

访问auto变量--StackBlock

对StackBlock执行了copy操作--MallocBlock

### block的copy

ARC下，编译器会根据情况自动将栈上的block进行copy操作复制到堆上：

1. block作为函数返回值时
2. 将block赋值给__strong 指针时
3. block作为CocoaAPI中方法名含有usingBlock的方式参数时

### 对象类型的auto变量

当block内访问了对象类型的auto变量

如果block在栈上，将不会对auto变量产生强引用

如果block被拷贝到堆上

	* 会调用block内部的copy函数
	* copy函数内部会调用_Block_object_assin函数
	* _Block_object_assign函数会根据auto变量的修饰符(__ strong ,   __ weak, __unsafe_unretained)作出相应的操作，类似于retain(形成强引用，弱引用)

如果block在堆中被移除

	* 会调用block内部的dispose函数
	* dispose函数内部会调用_Block_object_dispose函数
	* _Block_object_dispose函数会自动释放引用的auto变量，类似于release

### __block的内存管理

编译器会将捕获的变量包装成一个对象。

block在栈上，并不会对__block变量产生强引用

block在堆上，

	* 会调用block内部的copy函数
	* copy函数会调用_Block_object_assign函数
	* _Block_object_assign函数会对__block变量形成强引用

block在被copy到堆上时，相对应持有的__block变量也会被copy到堆上。

block从堆中移除时

* 会调用block内部的dispose函数
* dispose函数内部会调用_Block_object_dispose函数
* _Block_object_dispose函数会自动释放引用的 _block变量

### __forwarding

![forwarding](/img/forwarding.png)

### 被__block修饰的对象类型

- 当__block变量在栈上时，不会对指向的对象产生强引用
- 当__block变量被copy到堆时
  - 会调用__block变量内部的copy函数
  - copy函数内部会调用_Block_object_assign函数
  - _Block_object_assign函数会根据所指向对象的修饰符（__ strong、__ weak、__unsafe_unretained）做出相应的操作，形成强引用（retain）或者弱引用（注意：这里仅限于ARC时会retain，MRC时不会retain）

- 如果__block变量从堆上移除
  - 会调用__block变量内部的dispose函数
  - dispose函数内部会调用_Block_object_dispose函数
  - _Block_object_dispose函数会自动释放指向的对象（release）

