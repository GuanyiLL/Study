# Haskell 入门

修改ghci的提示符：

```hs
Prelude> :set prompt "ghci>"
ghci>
```

加载模块：

```hs
ghci> :module + Data.Ratio
```

Haskell用`/=`来表示数学中的不等于，而不像C语言中的`!=`。另外，类C语言中通常使用`!`来表示逻辑非的操作，而Haskell中用函数`not`。

对于操作符使用`:info`来看操作符的优先级

```hs
ghci> :info (+)
```

## 列表(List)

```hs
ghci> [1 , 2, 3]
```

列表中元素类型必须相同。

如果使用列举符号(enumeration notation)来表示一系列元素，Haskell会自动填充

```hs
ghci> [1..10]
[1,2,3,4,5,6,7,8,9,10]
```

使用列举时，可以通过最初两个元素之间的步调大小，来指明后续元素如何生成。

```hs
ghci> [1.0,1.25..2.0]
[1.0,1.25,1.5,1.75,2.0]

ghci> [1,4..15]
[1,4,7,10,13]

ghci> [10,9..1]
[10,9,8,7,6,5,4,3,2,1]
```

如果省略列举的终点，如果类型没有自然的上限，将产生无穷列表。

```hs
ghci> [1.0..1.8]
[1.0,2.0]
```

>Note
>为了避免浮点数舍入问题，Haskell从1.0到1.8 + 0.5进行了列举

## 列表操作符

连接两个列表时使用(++)

```hs
ghci> [3,1,3] ++ [3,7]
[3,1,3,3,7]

ghci> [] ++ [False,True] ++ [True]
[False,True,True]
```

更加基础的操作符是(:)，用于增加一个元素到列表的头部。它读成“cons”(construct)

```hs
ghci> 1 :[2, 3]
[1,2,3]
```

## 字符串和字符

文本字符串是单一字符的列表。

```hs
ghci> let a = ['h','e','l','l','o',',','w','o','r','l','d']
ghci> a == "hello,world"
True
```

## 初识类型

使用`:set +t`来打印返回结构的类型

```hs
ghci> :set +t
ghci> 'c'
'c'
it :: Char
```

Haskell的整数类型为Integer。Integer类型值的长度只受限于系统的内存大小。

分数和整数看上去不大相同，它使用`%`操作符来构建，其中分子放在操作符左边，而分母放在操作符右边：

```hs
ghci> :m +Data.Ratio
ghci> 11 % 29
11 % 29
it :: Integral a => Ratio a
```

使用`:unset`取消类型信息打印，如果想要知道某个值或表达式的类型，可以使用`:type`命令显示打印类型信息：

```hs
ghci> :type a
a :: [Char]
ghci> "foo"
"foo"
it :: [Char]
ghci> :type it  
it :: [Char]
```

这里it为ghci中最后一次求得的值。

## 行计数程序

```hs
--file: ch01/WC.hs
--lines beginning with "--" are comments

main = interact wordCount
       where wordCount input = show (length(lines input)) ++ "\n"
```

在创建一个quux.txt包含以下内容

```txt
Teignmouth, England
Paris, France
Ulm, Germany
Auxerre, France
Brunswick, Germany
Beaumont-en-Auge, France
Ryazan, Russia
```

然后，在shell执行以下代码：

```hs
runghc WC < quux.txt
7
```
