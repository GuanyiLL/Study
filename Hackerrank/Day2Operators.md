# Day 2: Operators



**Objective**
In this challenge, you'll work with arithmetic operators. Check out the [Tutorial](https://www.hackerrank.com/challenges/30-operators/tutorial) tab for learning materials and an instructional video!

**Task**
Given the *meal price* (base cost of a meal), *tip percent* (the percentage of the *meal price* being added as tip), and *tax percent* (the percentage of the *meal price* being added as tax) for a meal, find and print the meal's *total cost*.

**Note:** Be sure to use precise values for your calculations, or you may end up with an incorrectly rounded result!

**Input Format**

There are lines of numeric input:
The first line has a double, (the cost of the meal before tax and tip).
The second line has an integer, (the percentage of being added as tip).
The third line has an integer, (the percentage of being added as tax).

**Output Format**

Print the total meal cost, where is the rounded integer result of the entire bill ( with added tax and tip).

**Sample Input**

```
12.00
20
8
```

**Sample Output**

```
15
```

**Explanation**

Given:
mealCost = 12, tipPersent = 20, taxPersent = 8

Calculations:

tip = 12 x 20 / 100 = 2.4

tax = 12 x 8 / 100 = 0.96

totalCost = mealCost + tip + tax = 12 + 2.4 + 0.96 = 15.36

round(totalCost) = 15

We round to the nearest dollar (integer) and then print our result,15 .

```cpp
#include <bits/stdc++.h>

using namespace std;

// Complete the solve function below.
void solve(double meal_cost, int tip_percent, int tax_percent) {
    double tip = meal_cost * tip_percent / 100.0;
    double tax = meal_cost * tax_percent / 100.0;
    double totalCost = meal_cost + tip + tax;
    cout << round(totalCost) << endl;
}

int main()
{
    double meal_cost;
    cin >> meal_cost;
    cin.ignore(numeric_limits<streamsize>::max(), '\n');

    int tip_percent;
    cin >> tip_percent;
    cin.ignore(numeric_limits<streamsize>::max(), '\n');

    int tax_percent;
    cin >> tax_percent;
    cin.ignore(numeric_limits<streamsize>::max(), '\n');

    solve(meal_cost, tip_percent, tax_percent);

    return 0;
}
```

