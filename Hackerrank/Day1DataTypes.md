# Day 1: Data Types

**Objective**
Today, we're discussing data types. Check out the [Tutorial](https://www.hackerrank.com/challenges/30-data-types/tutorial) tab for learning materials and an instructional video!

**Task**
Complete the code in the editor below. The variables , , and are already declared and initialized for you. You must:

1. Declare variables: one of type *int*, one of type *double*, and one of type *String*.
2. Read lines of input from stdin (according to the sequence given in the *Input Format* section below) and initialize your variables.
3. Use the operator to perform the following operations:
   1. Print the sum of plus your int variable on a new line.
   2. Print the sum of plus your double variable to a scale of one decimal place on a new line.
   3. Concatenate with the string you read as input and print the result on a new line.

**Note:** If you are using a language that doesn't support using for string concatenation (e.g.: C), you can just print one variable immediately following the other on the same line. The string provided in your editor *must* be printed first, immediately followed by the string you read as input.

**Input Format**

The first line contains an integer that you must sum with .
The second line contains a double that you must sum with .
The third line contains a string that you must concatenate with .

**Output Format**

Print the sum of both integers on the first line, the sum of both doubles (scaled to decimal place) on the second line, and then the two concatenated strings on the third line.

**Sample Input**

```
12
4.0
is the best place to learn and practice coding!
```

**Sample Output**

```
16
8.0
HackerRank is the best place to learn and practice coding!
```

**Explanation**

When we sum the integers and , we get the integer .
When we sum the floating-point numbers and , we get .
When we concatenate `HackerRank `with `is the best place to learn and practice coding!`, we get `HackerRank is the best place to learn and practice coding!`.

**You will not pass this challenge if you attempt to assign the \*Sample Case\* values to your variables instead of following the instructions above and reading input from stdin.**

```cpp
#include <iostream>
#include <iomanip>
#include <limits>

using namespace std;

int main() {
    int i = 4;
    double d = 4.0;
    string s = "HackerRank ";

    
        // Declare second integer, double, and String variables.
    int i2 = 0;
    double d2 = 0.0;
    string  s2 = "";
    // Read and save an integer, double, and String to your variables.
    // Note: If you have trouble reading the entire string, please go back and review the Tutorial closely.
    string reader = "";
    getline(cin>>ws, reader);
    i2 = stoi(reader);
    getline(cin>>ws,reader);
    d2 =  stod(reader);
    getline(cin>>ws,s2);
    // Print the sum of both integer variables on a new line.
    cout << i2 + i << endl;
    // Print the sum of the double variables on a new line.
    cout << fixed << setprecision(1) << d2 + d << endl;
    // Concatenate and print the String variables on a new line
    // The 's' variable above should be printed first.
    cout << s + s2 << endl;
    return 0;
```



You may find this information helpful when completing this challenge in C++.

To consume the whitespace or newline between the end of a token and the beginning of the next line:

```
// eat whitespace
getline(cin >> ws, s2);
```

where `s2` is a string. In addition, you can specify the *scale* of floating-point output with the following code:

```
#include <iostream>
#include <iomanip>

using namespace std;
int main(int argc, char *argv[]) {
    double pi = 3.14159;
	
    // Let's say we wanted to scale this to 2 decimal places:
    cout << fixed << setprecision(2) << pi << endl;
    printf("%.2f", pi);
}
```

which produces this output:

```
3.14
3.14
```

ws usage：

```cpp
// ws manipulator example
#include <iostream>     // std::cout, std::noskipws
#include <sstream>      // std::istringstream, std::ws

int main () {
  char a[10], b[10];

  std::istringstream iss ("one \n \t two");
  iss >> std::noskipws;
  iss >> a >> std::ws >> b;
  std::cout << a << ", " << b << '\n';

  return 0;
}
```

Output:

```
one, two 
```

setprecision usage:

```
// setprecision example
#include <iostream>     // std::cout, std::fixed
#include <iomanip>      // std::setprecision

int main () {
  double f =3.14159;
  std::cout << std::setprecision(5) << f << '\n';
  std::cout << std::setprecision(9) << f << '\n';
  std::cout << std::fixed;
  std::cout << std::setprecision(5) << f << '\n';
  std::cout << std::setprecision(9) << f << '\n';
  return 0;
}
```

Output:

```
3.1416 
3.14159 
3.14159 
3.141590000 
```

fixed usage:

```cpp
// modify floatfield
#include <iostream>     // std::cout, std::fixed, std::scientific

int main () {
  double a = 3.1415926534;
  double b = 2006.0;
  double c = 1.0e-10;

  std::cout.precision(5);

  std::cout << "default:\n";
  std::cout << a << '\n' << b << '\n' << c << '\n';

  std::cout << '\n';

  std::cout << "fixed:\n" << std::fixed;
  std::cout << a << '\n' << b << '\n' << c << '\n';

  std::cout << '\n';

  std::cout << "scientific:\n" << std::scientific;
  std::cout << a << '\n' << b << '\n' << c << '\n';
  return 0;
}
```

Possible output:

```
default: 
3.1416 
2006 
1e-010 
fixed: 
3.14159 
2006.00000 
0.00000 
scientific: 
3.14159e+000 
2.00600e+003 
1.00000e-010 
```

