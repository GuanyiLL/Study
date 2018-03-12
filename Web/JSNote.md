# Javascript
类型：
* Number
* String
* Boolean
* Symbol
    * Function
    * Array
    * Date
    * RegExp
* Null
* Undefined
* Error

## 数字
JavaScript使用“IEEE 754标准定义的双精度64位格式”表示数字。JavaScript不区分浮点数与整数，所有数字均用浮点数值表示。如：
```
0.1 + 0.2 = 0.30000000000000004
```
JavaScript支持标准的算术运算符，包括加减乘除、取模等等。`Math`对象处理更多的高级数学函数和常数：
```js
Math.sin(3.5);
var d = Math.PI * (r + r)
```
使用内置函数`parseInt()`将字符串转为整形。该函数的第二个参数表示进制：
```js
parseInt("123",10); // 123
parseFloatInt("010",10); // 10
```
如果不传入第二个参数，2013年以前js实现会返回一个意外的结果：
```js
parseInt("010");    // 8
parseInt("0x10");   // 16
```
该方法通过0、0x开头自行推断数字进制。如果想把一个二进制数字字符转换成整数值，只要把第二个参数设置成2即可：
```js
parseInt("11",2); //3
```
与`parseInt`相似，还有一个用以解析浮点数子字符串的函数`parseFloat()`。而且该方法只能解析10进制数字。单元运算符`+`也可以把数字字符串转换成数值：
```js
+ "42" // 42
+ "010" // 10 
+ "0x10" // 16
```
如果解析失败，则会返回`NaN`(Not a Number)的缩写：
```js
parseInt("hello", 10); // NaN
```
如果`NaN`参与任何运算，结果也将会是`NaN`。可以使用内置函数`isNaN()`来判断一个变量是否为`NaN`。
js还有两个特殊值`Infinity`（正无穷），与`-Infinity`（负无穷）:
```js
1 / 0;    // Infinity
-1 / 0;     //-Infinity
```
可以使用`isFinite()`来判断变量是否位有穷数，如果返回类型为`Infinity`,`-Infinity`或`NaN`则返回`false`:
```js
isFinite(1/0); //false
isFinite(Infinity); // false
isFinite(NaN); //false
isFinite(-Infinity); //false

isFinite(0); //true
isFinite(2e64); //true

isFinite("0"); //true, 如果是纯数值类型检测，则返回false：Number.isFinity("0");
```
> Note: 
> `parseInt()`和`parseFloat()`函数会尝试逐个解析字符串中的字符，直到遇上一个无法被解析成数字的字符，然后返回该字符前所有数字字符组成的数字。使用运算符"+"将字符串转换成数字，只要字符串中含有无法被解析成数字的字符，该字符串将被转换成`NaN`。

## 字符串
js中的字符串是一串Unicode字符序列。它们是一串UTF-16编码单元的序列，每一个编码单元由一个16位二进制数表示。每一个Unicode字符由一个或两个编码单元来表示。
获取字符串的长度：
```js
"hello".length;    //5
```
其它基本方法：
```js
"hello".charAt(0); //"h"
"hello,world".replace("hello", "goodbye");  // "goodbye, world"
"hello".toUpperCase();   // "HELLO"
```

## 其他类型
`null`表示空值，`unddfined`表示一个未初始化的值，也就是还没有被分配的值。js允许声明变量但不对其赋值，一个未被赋值的变量就是`undefined`类型。`undefined`实际上是一个不允许修改的常量。
js按照如下规则将变量转换成布尔类型：
1. `false`、`0`、`""`、`NaN`、`null`和`undefined`被转换为`false`
2. 所有其他值被转换为`true`

也可以使用`Boolean()`函数进行显示转换：
```js
Boolean(""); // false
Boolean(234); // true
```

## 变量
声明变量使用`var`关键字：
```js
var a;
var name = "simon";
```
js的语句块中是没有作用域的，只有函数有作用域。如果在一个复合语句中使用`var`声明一个变量，那么他的作用域是整个函数。ES6后，使用`let`与`const`关键字允许创建块作用域的变量。

## 运算符
```js
x += 5; // 等价于 x = x + 5
"hello" + "world"; // hello world
"3" + 4 + 5; // 345
3 +  4 + "5"; // 75
123 == "123" // true
1 == true; // true
1 === true; // false
123 === "123"; // false
```

## 控制结构
`if` 与 `else`
```js
var name = "kittens";
if (name == "puppies") {
    name += "!";
} else if (name == "kittens") {
    name += "!!"
} else {
    name = "!" + name;
}
name == "kittens!!"; // true
```
`while` `do-while`:
```js
while (true) {
    // 一个无限循环！
}

var input;
do {
    input = get_input();
} while (inputIsNotValid(input))
```
`for`循环与C一致。

`switch`基本与其它语言一致。
```js
switch (1 + 3) {
    case 2 + 2:
        yay();
        break;
    default:
        neverhappens);
}
```

## 对象
创建控对象：
```js
var obj = new Object();
var obj = {};
```
通过字面量创建对象：
```js
var obj = {
    name = "Carrot",
    "for": "Max",
    details:{
        color: "orange",
        size: 12
    }
}
```
访问对象：
```js
obj.details.color; // orange
obj["details"]["size"]; //12
```
下面例子创建一个对象原型，Person，与这个原型的的实例，You。
```js
function Person(name, age) {
    this.name = name;
    this.age = age;
}

var You = new Person("You", 24);
// 通过如下方式进行赋值和访问
You.name = "Simon";
var name = You.name;
You["name"] = "Simon";
var name2 = You["name"];
```

## 数组
创建数组的两种方式：
```js
var a = new Array();
a[0] = "dog";
a[1] = "cat";
a[2] = "hen";
a.length; // 3

var b = ["dog", "cat", "hen"];
b.length; // 3

// Array.length 不总是等于数组种元素的个数
var a = ["dog", "cat", "hen"];
a[100] = "fox";
a.length; // 101

// * 数组的长度是比数组元素最大索引值多一的数。
// 如果试图访问一个不存在的数组索引，会得到`undefined`

typedof(a[90]); // undefined

```
[Array完整文档](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array)

常用方法：

|方法名称|描述|
|-|-:|
|a.toString()  | 返回一个包含数组中所有元素的字符串，每个元素通过逗号分隔|
|a.toLocaleString() | 根据宿主地区语言，返回一个包含所有元素的字符串，以逗号分隔|
|a.concat(item1[, item2[, ...[, itemN]]]) | 返回一个数组，数组包含原先的`a`,`item1`,`item2`...`itemN`中的所有元素|
|a.join(sep) | 返回一个包含数组中所有元素的字符串，每个元素通过制定的sep分隔|
|a.pop() | 删除并返回数组中最后一个元素|
|a.push(item1,...,itemN) | 将参数中的元素追加至数组a|。
|a.reverse() | 数组逆序|
|a.shift() | 删除并返回数组中的等一个元素|
|a.slice(start,end) | 返回子数组，以a[start]开头，以a[end]前一个元素结尾。|
|a.sort([cmpfn]) | 依据`cmpfn`返回的结构进行排序，若未指定，按字符顺序比较|
|a.splice(start,delcount[, item1[,...[, itemN]]]) | 从`start`开始，删除`delcount`个元素，然后插入所有的`item`
|a.unshift([item]) | 将`item`插入数组头部，返回数组新长度|

## 函数




