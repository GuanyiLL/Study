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

class_rw_t**

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

扩容时会将原有的表清空，然后重新构建缓存。





