# Defer

撸代码时想到swift与golang中都有一个关键词叫defer，作用也都一样，于是想找到OC中的这种解决方案，后来看到了这个大神的文章：https://draveness.me/defer/，但是根据里面的方案编译时会有报错，最终解决方案如下：

```objectivec
#define ext_keywordify autoreleasepool {}
typedef void (^spdb_ext_cleanupBlock_t)();
#define metamacro_concat(A, B) A##B

static inline void spdb_ext_executeCleanupBlock (__strong spdb_ext_cleanupBlock_t *block) {
  (*block)();
}

#define defer \
  ext_keywordify \
  spdb_ext_cleanupBlock_t metamacro_concat(ext_exitBlock_, __LINE__) __attribute__((cleanup(spdb_ext_executeCleanupBlock), unused)) = ^

```

使用时：

```objectivec
- (void)foo {
	@defer {
		//do something
	};
}
```







