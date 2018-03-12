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
paresInt("123",10); // 123
paresInt("010",10); // 10
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
isFinity(1/0); //false
isFinity(Infinity); // false
isFinity(NaN); //false
isFinity(-Infinity); //false

isFinity(0); //true
isFinity(2e64); //true

isFinity("0"); //true, 如果是纯数值类型检测，则返回false：Number.isFinity("0");
```
> Note: 
> `parseInt()`和`parseFloat()`函数会尝试逐个解析字符串中的字符，直到遇上一个无法被解析成数字的字符，然后返回该字符前所有数字字符组成的数字。使用运算符"+"将字符串转换成数字，只要字符串中含有无法被解析成数字的字符，该字符串将被转换成`NaN`。

## 字符串

