# Description

Suppose Andy and Doris want to choose a restaurant for dinner, and they both have a list of favorite restaurants represented by strings.

You need to help them find out their common interest with the least list index sum. If there is a choice tie between answers, output all of them with no order requirement. You could assume there always exists an answer.

#### Ex1:

```
Input:
["Shogun", "Tapioca Express", "Burger King", "KFC"]
["Piatti", "The Grill at Torrey Pines", "Hungry Hunter Steakhouse", "Shogun"]
Output: ["Shogun"]
Explanation: The only restaurant they both like is "Shogun".

```

#### Ex2:

```
Input:
["Shogun", "Tapioca Express", "Burger King", "KFC"]
["KFC", "Shogun", "Burger King"]
Output: ["Shogun"]
Explanation: The restaurant they both like and have the least index sum is "Shogun" with index sum 1 (0+1).

```

#### Note:

1. The length of both lists will be in the range of [1, 1000].
2. The length of strings in both lists will be in the range of [1, 30].
3. The index is starting from 0 to the list length minus 1.
4. No duplicates in both lists.

# Code

```cpp

class Solution {
public:
    vector<string> findRestaurant(vector<string>& list1, vector<string>& list2) {
        map<string, int> m;
        vector<string> res;
        int min = INT_MAX;
        for (int i = 0; i < list1.size(); i++) m[list1[i]] = i;
        for (int i = 0; i < list2.size(); i++) {
            auto &s = list2[i];
            if (m.count(s) > 0) {
                if (m[s] + i < min) {
                    min = m[s] + i;
                    res.clear();
                    res.push_back(list2[i]);
                } else if (m[s] + i == min) {
                    res.push_back(list2[i]);
                }
            }
        }
        return res;
    }
};

```
