# Type & Function

## Haskell 的类型系统

* 强类型
* 静态
* 自动推导

### 强类型

不会自动将值从一个类型转换到另一个类型，例如将一个整数座位参数传给一个接受浮点数的函数，Haskell编译器会报错，类型转换必须显示使用类型转换函数。

### 静态类型

编译器可以在编译期知道每个值和表达式的类型。

## 调用函数

先写出名字，后接函数的参数：

```hs
ghci> odd 3
True
it :: Bool
ghci> odd 6
False
it :: Bool
ghci> :unset
```

多个参数之间使用空格：

```hs
ghci> compare 2 3
LT
it :: Ordering
ghci> compare 3 3
EQ
it :: Ordering
ghci> compare 3 2
GT
it :: Ordering
```

## 符合数据类型：列表和元祖

`head`取出第一个元素：

```hs
ghci> head [1, 2, 3, 4]
1
it :: Num a => a
```

`tail`取出列表里除了第一个元素之外的其他元素：

```hs
ghci> tail [1,2,3,4]
[2,3,4]
it :: Num a => [a]
ghci> tail []
*** Exception: Prelude.tail: empty list
```

元祖和列表非常不同，它们的两个属性刚刚相反：列表可以任意长，且只能包含类型相同的值；元组的长度是固定的，但可以包含不同类型的值。

```hs
ghci> :type (True, "hello")
(True, "hello") :: (Bool, [Char])
```

`()`代表零个元素的元祖，类似于C语言中的void。

通常用元祖中元素的数量称呼元祖的前缀。元祖的类型由它所包含元素的数量、位置和类型决定。如果两个元祖里都包含着同样类型的元素，而这些元素的摆放位置不同，那么他们的类型就不相等：

```hs
ghci> :t (False,'a')
(False,'a') :: (Bool, Char)
ghci> :t ('a',False)
('a',False) :: (Char, Bool)
```

元祖的使用场景：

* 函数需要返回多个值，可以包装在一个元祖中
* 当需要使用定长容器，但又没必要自定义类型的时候，可以是用元祖进行包装

## 处理列表和元组的函数

函数`take`返回一个包含前n个元素的列表

```hs
ghci> take 2 [1, 2, 3, 4]
[1,2]
it :: Num a => [a]
```

函数`drop`返回一个丢弃前n个元素后的列表

```hs
ghci> drop 2 [1, 2, 3, 4]
[3,4]
it :: Num a => [a]
```

`fst`和`snd`接受一个元组座位参数，返回该元组的第一个和第二个元素

```hs
ghci> fst (1, 'a')
1
it :: Num a => a
ghci> snd (1, 'a')
'a'
it :: Char
```

## 将表达式传给函数

```hs
ghci> head (drop 4 "azety")
'y'
it :: Char
```

`drop 4 "azety"`这个表达式被一对括号显示的包围，作为参数传入`head`函数。

## 函数类型

```hs
ghci> :t lines
lines :: String -> [String]
```

符号`->`可以读作“映射到”，或者读作“返回”。

## 纯度

副作用指的是，函数的行为受系统的全局状态所影响。

假设某个函数，它读取并返回某个全局变量，如果过程序中其他代码可以修改这个全局变量，那么这个函数的返回值就取决于这个全局变量在某一时刻的值。我们就说这个函数带有副作用，尽管它并不亲自修改全局变量。

Haskell的函数在默认情况下都是无副作用的：函数的结果只取决于显示传入的参数。

带副作用的函数称为“不纯函数”，不带副作用的函数称为“纯函数”

不纯函数类型签名都以IO开头：

```hs
ghci> :t readFile
readFile :: FilePath -> IO String
```

## 简单函数定义

```hs
--file: ch02/add.hs
add a b = a + b
```

`=`左边的`add a b`是函数名和函数参数，右边的`a+b`则是函数体，符号`=`表示将左边的名字定义为右边的表达式。

## 变量

在Haskell中一旦变量绑定了某个表达式，那么这个变量的值就不会改变。

```hs
--file: ch02/Assign.hs
x = 10
x = 11

Prelude> :load Assign
[1 of 1] Compiling Main             ( Assign.hs, interpreted )

Assign.hs:3:1: error:
    Multiple declarations of ‘x’
    Declared at: Assign.hs:2:1
                 Assign.hs:3:1
  |
3 | x = 11
  | ^
Failed, 0 modules loaded.
```

## 条件求职

```hs
-- file: ch02/myDrop.hs
myDrop n xs = if n <= 0 || null xs
              then xs
              else myDrop(n -1) (tail xs)
```

`if`表达式引入了一个带有三个部分的表达式：

* 跟在if之后的是一个Bool类型的表达式，它是if的条件部分
* 跟在then关键字之后的是另一个表达式，这个表达式在条件部分的值为True时被执行
* 跟在else关键字之后的又是另一个表达式，这个表达式在条件部分的值为False时被执行

> 两个分支的类型需要相同，否则编译器会报错。Haskell是面向表达式(expression-oriented)的语言。在命令语言中，代码由陈述(statement)而不是表达式组成，因此在省略if语句的else分支的情况下，程序仍是有意义的。省略else分支对于Haskell是无意义的，编译器也不会允许。

`null`函数检查一个列表是否为空：

```hs
ghci> :type null
null :: Foldable t => t a -> Bool
ghci> null []
True
it :: Bool
ghci> null [1, 2, 3]
False
it :: Bool
```

## 惰性求职

```hs
--file:ch02/isOdd.hs
isOdd n = mod n 2 == 1
```

在严格求值的语言里，函数的参数总是在应用函数之前被求职。Haskell使用了非严格求值。这种情况下，`isOdd(1+2)`并不会即刻使得子表达式1+2被求职为3，相反，编译器做出一个“承诺”，“当真正需要的时候，会计算出isOdd(1+2)的值”

* 可以通过代还(substitution)和重写(rewriting)去了解Haskell求值表达式的方式
* 惰性求职可以延迟计算直到真正需要一个值为止，并且在求值时，也只执行可以给出(establish)值的那部分表达式。
* 函数的返回值可能是一个块(一个被延迟计算的表达式)。

