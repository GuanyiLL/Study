# 如何通过位运算作来有效地解决问题

## Wiki

计算机编程任务中需要位运算的有：底层设备控制，错误识别和修正算法，数据压缩，算法加密和优化。在大多数的任务中，编程语言允许程序员世界使用抽象技术来替代直接使用位运算。代码使用的位相关的运算符有：与，或，非，异或和位移。

位运算在某些情况，可以避免或者减少对数据结构的遍历，并且在运行速度上成倍增加，因为位操作是并行的，但代码可能变得难以编写与维护。



## Details

### Basics

位运算的核心运算符`&`(与),`|`(或),`~`(非)和`^`(异或)和位移操作符`<<`、`>>`左位移与右位移。

> 异或操作没有对应的布尔值对应，但是可以简单的解释为同0异1。
>
> 101 ^ 110 = 011 
>
> 只有当左右两边相同，则返回1，不同则返回0。异或操作符会对每一位都进行异或操作。简称为XOR。

* 合集 A | B
* 交集 A & B
* 差集 A & ~B
* 按位取反 ALL_BITS ^ A 或者 ~ A
* 设置指定位为1 A |= 1 << bit   
* 设置指定位为0 A &= ~(1 << bit)
* 查看指定位是否为1  (A & 1 << bit) != 0
* 提取最后一位 A&-A 或者 A & ~(A-1) 或者 x^(x&(x-1))
* 删除最后一位 A&(A-1) (个人理解为移除最后一个1 ，1100 -> 1000)
* 获取所有1的位 ~0

### Exs

统计一个给定数字二进制表示中1的个数：

```c++
int count_one(int n) {
    while(n) {
        n = n & (n - 1);
        count++;
    }
    return count;
}
```

是否为4的整数次幂：

```c++
bool isPowerOfFour(int n) {
  	return !(n&(n-1)) && (n & 0x55555555);
}
```

##### `^`tricks

使用`^`来移除完全相同的数并且保存奇数，或者保存不同的位移除相同位。

两个整数相加

使用`^`与`&`让两个数字相加：

```c++
int getSum(int a, int b) {
  	return b == 0? a:getSum(a^b,(a&b)<<1);
}
```

##### 缺少的数字

指定一个数组从0到n，找到缺少的数字。比如输入`nums = [0, 1, 3]` 返回2。

```c++
int missingNumber(vector<int>& nums) {
  	int ret = 0;
  	for (int i = 0; i < nums.size(); i++) {
      	ret ^= i;
      	ret ^= nums[i];
  	}
  	return ret ^= nums.size();
}
```

##### `|`tricks

找出给定数字内，最大的2整数次幂：

```c++
long largest_power(long N) {
    //changing all right side bits to 1.
    N = N | (N>>1);
    N = N | (N>>2);
    N = N | (N>>4);
    N = N | (N>>8);
    N = N | (N>>16);
    return (N+1)>>1;
}
```

##### 反转位

```c++
uint32_t reverseBits(uint32_t n) {
  	unsigned int mask = 1 << 31, res = 0;
  	for (int i = 0; i < 32; i++) {
      	if(n & 1) res |= mask;
      	mask >>= 1;
      	n >>= 1;
  	}
  	return res;
}
```

```c++
uint32_t reverseBits(uint32_t n) {
  	uint32_t mask = 1, ret = 0;
  	for (int i = 0; i < 32; i++) {
      	ret <<= 1;
      	if (mask & n) ret |= i;
      	mask <<= i;
  	}
  	return ret;
}
```

##### `&`tricks

Just selecting certain bits

Reversing the bits in integer (这个看不懂是讲啥，干啥用的)

```c++
x = ((x & 0xaaaaaaaa) >> 1) | ((x & 0x55555555) << 1);
x = ((x & 0xcccccccc) >> 2) | ((x & 0x33333333) << 2);
x = ((x & 0xf0f0f0f0) >> 4) | ((x & 0x0f0f0f0f) << 4);
x = ((x & 0xff00ff00) >> 8) | ((x & 0x00ff00ff) << 8);
x = ((x & 0xffff0000) >> 16) | ((x & 0x0000ffff) << 16);
```

##### 按位与数字范围

给定一个范围 [m, n] 切 0 <= m <= n <= 2147483647，返回范围中所有数字按位与的结果。比如, 给定范围 [5, 7]，你应该返回4（5&6&7 = 4）。

```c++
int rangeBitwiseAnd(int m, int n) {
    int a = 0;
    while(m != n) {
        m >>= 1;
        n >>= 1;
        a++;
    }
    return m << a; 
}
```

##### Number of 1 Bits

输入一个无符号整数，输出二进制表达时1的个数。

```c++
int hammingWeight(uint32_t) {
  	int count = 0;
  	while(n) {
      	n = n & (n - 1);
      	count++;
  	}
  	return count;
}
```

```c++
int hammingWeight(uint32_t n) {
  	ulong mask = 1;
  	for (i = 0;i < 32; i ++) {
      	if (mask & n) count++;
      	mask <<= 1;
  	}
  	return count;
}
```

