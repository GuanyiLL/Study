# Description

Given an array of integers that is already sorted in ascending order, find two numbers such that they add up to a specific target number.

The function twoSum should return indices of the two numbers such that they add up to the target, where index1 must be less than index2. Please note that your returned answers (both index1 and index2) are not zero-based.

You may assume that each input would have exactly one solution and you may not use the same element twice.

Input: numbers={2, 7, 11, 15}, target=9
Output: index1=1, index2=2

# Intuition

由于是已经排好序的数组，因此可以使用类似二分查找的方式，从两侧同时向中间缩进，而且题目中说明肯定会有一个答案。

# Code

```c++

class Solution {
/*
    // Here is a better solution
    int lo=0, hi=numbers.size()-1;
    while (numbers[lo]+numbers[hi]!=target){
        if (numbers[lo]+numbers[hi]<target){
            lo++;
        } else {
            hi--;
        }
    }
    return vector<int>({lo+1,hi+1});
*/
public:    
    vector<int> twoSum(vector<int>& numbers, int target) {
        vector<int> res;
        vector<int> temp;
        for (int i = 0; i < numbers.size(); i++) {
            vector<int>::iterator iter=find(temp.begin(),temp.end(),target - numbers[i]);
            if (iter != temp.end()) {
                res.push_back(int(iter - temp.begin()) + 1);
                res.push_back(i + 1);
                return res;
            }
            temp.push_back(numbers[i]);
        }
        return res;
    }
};

```
