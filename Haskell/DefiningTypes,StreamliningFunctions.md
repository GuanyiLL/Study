# Definning Types, Streamlining Fuctions

## 定义新的数据类型

使用`data`关键字可以定义新的数据类型：

```hs
--file: ch03/BookStroe.hs
data BookInfo = Book Int String [String]
                deriving (Show)
```

`data`关键字后的`BookInfo`就是新类型的名字， 我们称`BookInfo`为类型构造器。类型构造器用于指代类型。

`Book`是值构造器的名字。类型的值就是由值构造器创建的。

在`Book`之后的`Int, String`和`[String]`是类型的组成部分。即便类型成分一样，但是还是被当做两种类型，因为类型构造器和值构造器不相同。

可以将值构造器看做一个函数--它创建并返回某个类型值。在这个书店的例子里，我们将Int、String和[String]三个类型的值应用到Book，从而创建一个BookInfo类型的值：

```hs
--file: ch03/BookStore.hs
myInfo = Book 97801350724555 "Algerbra of Programming"
              ["Richard Bird","One de Moor"]
```

定义类型的工作完成后，可以到ghci里载入并测试这些新类型：

```hs
Prelude> :load BookStore.hs
[1 of 1] Compiling Main             ( BookStore.hs, interpreted )
Ok, 1 module loaded.
*Main> myInfo
Book 9780135072455 "Algebra of Programming" ["Richard Bird","Oege de Moor"]
```

## 类型构造器和值构造器的命名

在Haskell里，类型构造器和值构造器的名字是相互独立的。类型构造器只能出现在类型的定义，或者类型签名中。而值构造器只能出现在实际的代码中。因为这种差别，给类型构造器和值构造器赋予一个相同的名字实际上并不会产生任何问题。

## 类型别名

```hs
--file: ch03/BookStore.hs
type CustomerID = Int
type ReviewBody = String

data BetterReview = BetterReview BookInfo CustomerID ReviewBody
```

可以将类型别名看做c中的`typedef`

## 代数数据类型

