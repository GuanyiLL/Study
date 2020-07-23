# iOS subscript用法

数组和字典等集合类型，可以通过下标的方式来快速获取相对应的值。在swift中，可以通过subscript来实现这个功能。而在Swift中，

假设有一个学生类，有一个成员属性names来记录所有学生的姓名：

```swift
class Students {
    var names: [String] = {
        return ["zhangsan", "lisi", "wangwu"]
    }()
}

let students = Students()
let name = students.names[0]
```


那么在获取数组中指定位置的元素，需要通过names来获取元素。而使用subscript后：

```swift
extension Students {
    subscript(n: Int) -> String {
        return names[n]
    }
}

let name2 = students[0]
```

这样就可以不通过访问names来获取指定的学生姓名。可是这样只能用下标来获取元素，如果要设置则需要实现get和set方法：

```swift
extension Students {
    subscript(n: Int) -> String {
        get {
            return names[n]
        }
        set(name) {
            names[n] = name
        }
    }
}

let name3 = students[0]
students[0] = "XXXX"
```

这样就可以将names直接通过下标的方式来设置和获取了。是不是感觉帅帅的。不仅仅类似数组、字典，多维的情况下也可以：

```swift
struct Matrix {
    
    var data: [[Double]]
    let row: Int
    let col: Int
    
    init (row: Int, col: Int) {
        
        self.row = row
        self.col = col
        
        data = [[Double]]()
        for _ in 0 ..< row {
            let arow = Array(repeating: 0.0, count: col)
            data.append(arow)
        }
    }
    
    subscript(x: Int, y: Int) -> Double {
    
        get {
            assert(x >= 0 && x < self.row && y >= 0 && y < self.col, "Index out of range.")
            return data[x][y]
        }
        
        set {
            assert(x >= 0 && x < self.row && y >= 0 && y < self.col, "Index out of range.")
            data[x][y] = newValue
        }
        
    }
    
    subscript(x: Int) -> [Double] {
    
        get {
            assert(x >= 0 && x < self.row, "Index out of range")
            return data[x]
        }
        
        set(vector) {
            assert(vector.count == self.col, "Column number does not match.")
            data[x] = vector
        }
    }
}
```

而在OC中，其实也提供了实现自定义类直接通过下标访问元素的方法：

```objectivec
//List.h
@interface List : NSObject

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(id)anObject atIndexedSubscript:(NSUInteger)index;

@end

//List.m
#import "List.h"

@implementation List {
    NSMutableArray *_list;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _list = [NSMutableArray array];
    }
    return self;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return _list[idx];
}

- (void)setObject:(id)anObject atIndexedSubscript:(NSUInteger)index {
    const NSUInteger length = [_list count];
    if(index > length)
        return;

    if(index == length)
        [_list addObject:anObject];
    else
        [_list replaceObjectAtIndex:index withObject:anObject];
}

@end

```

使用的时候，跟系统提供的数组一样：

```objectivec
List *list = [[List alloc] init];
list[0] = @"asdff";
```

如果想实现字典访问方式，则实现以下两个方法即可：

```objectivec
- (id)objectForKeyedSubscript:(id)key{
    return self.dict[key];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx{
    return self.array[idx];
}
```

