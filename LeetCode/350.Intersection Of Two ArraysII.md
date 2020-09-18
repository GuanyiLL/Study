# Description

Given two arrays, write a function to compute their intersection.

#### Ex
Given nums1 = [1, 2, 2, 1], nums2 = [2, 2], return [2, 2].

#### Note:
* Each element in the result should appear as many times as it shows in both arrays.
* The result can be in any order.

#### Follow up:

* What if the given array is already sorted? How would you optimize your algorithm?
* What if nums1's size is small compared to nums2's size? Which algorithm is better?
* What if elements of nums2 are stored on disk, and the memory is limited such that you cannot load all elements into the memory at once?

# Code

```cpp

class Solution {
public:
    vector<int> intersect(vector<int>& nums1, vector<int>& nums2) {
        unordered_map<int,int> m;
        vector<int> res;
        for (int i = 0; i < nums1.size(); i++) m[nums1[i]]++;
        for (int i = 0; i < nums2.size(); i++) 
            if (--m[nums2[i]] >= 0) 
                res.push_back(nums2[i]);
        
        return res;
    }
};

/*
 
 vector<int> intersect(vector<int>& nums1, vector<int>& nums2) {
        sort(nums1.begin(), nums1.end());
        sort(nums2.begin(), nums2.end());
        int L = 0, R = 0;
        vector<int> res;
        while (L < nums1.size() && R < nums2.size()) {
            if (nums1[L] == nums2[R]) {
                res.push_back(nums1[L]);
                L++; R++;
            }else if (nums1[L] > nums2[R]) R++;
            else L++;
        }
        return res;
    }
 */

```
