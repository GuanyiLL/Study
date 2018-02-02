# Description

Given an array of size n, find the majority element. The majority element is the element that appears more than ⌊ n/2 ⌋ times.

You may assume that the array is non-empty and the majority element always exist in the array.

# Code

```c++

    int majorityElement(vector<int>& nums) {
        map<int,int> m;
        for(int n : nums){
            m[n]++;
        }
        for(map<int,int>::iterator item = m.begin(); item != m.end(); item++){
            if(item->second > nums.size()/2) return item->first;
        }
        return 0;
    }

```


