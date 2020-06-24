

# Day 4: Class vs. Instance

**Objective**
In this challenge, we're going to learn about the difference between a *class* and an *instance*; because this is an *Object Oriented* concept, it's only enabled in certain languages. Check out the [Tutorial](https://www.hackerrank.com/challenges/30-class-vs-instance/tutorial) tab for learning materials and an instructional video!

**Task**
Write a *Person* class with an instance variable, age , and a constructor that takes an integer, initialAge, as a parameter. The constructor must assign initialAge to age after confirming the argument passed as initialAge is not negative; if a negative argument is passed as initialAge , the constructor should set age to 0 and print `Age is not valid, setting age to 0.`. In addition, you must write the following instance methods:

1. *yearPasses()* should increase the age instance variable by 1 .
2. amIOld() should perform the following conditional actions:
   - If age < 13, print `You are young.`.
   - If age >= 13 and age < 18, print `You are a teenager.`.
   - Otherwise, print `You are old.`.

To help you learn by example and complete this challenge, much of the code is provided for you, but you'll be writing everything in the future. The code that creates each instance of your *Person* class is in the *main* method. Don't worry if you don't understand it all quite yet!

**Note:** Do not remove or alter the stub code in the editor.

**Sample Input**

```
4
-1
10
16
18
```

**Sample Output**

```
Age is not valid, setting age to 0.
You are young.
You are young.

You are young.
You are a teenager.

You are a teenager.
You are old.

You are old.
You are old.
```

```cpp
using namespace std;
#include <iostream>

class Person{
    public:
        int age;
        Person(int initialAge);
        void amIOld();
        void yearPasses();
    };

    Person::Person(int initialAge){
        // Add some more code to run some checks on initialAge
        if (initialAge < 0) {
            this->age = 0;
            cout << "Age is not valid, setting age to 0." << endl;
        } else {
            this->age = initialAge;
        }
    }

    void Person::amIOld(){
        // Do some computations in here and print out the correct statement to the console 
        int a = this->age;
        if (a < 13 && a  >= 0) {
            cout << "You are young." <<endl;
        } else if (a >= 13 && a  < 18) {
            cout << "You are a teenager." << endl;
        } else {
            cout << "You are old." << endl;
        }
    }

    void Person::yearPasses(){
        // Increment the age of the person in here
        this->age += 1;
    }

int main(){
    int t;
	int age;
    cin >> t;
    for(int i=0; i < t; i++) {
    	cin >> age;
        Person p(age);
        p.amIOld();
        for(int j=0; j < 3; j++) {
        	p.yearPasses(); 
        }
        p.amIOld();
      
		cout << '\n';
    }

    return 0;
}
```

