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

在`Book`之后的`Int, String`和`[String]`是类型的组成部分。

