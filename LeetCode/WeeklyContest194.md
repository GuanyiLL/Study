# Weekly Contest 194

### 1486. XOR Operation in an Array

Given an integer `n` and an integer `start`.

Define an array `nums` where `nums[i] = start + 2*i` (0-indexed) and `n == nums.length`.

Return the bitwise XOR of all elements of `nums`.

**Example 1:**

```
Input: n = 5, start = 0
Output: 8
Explanation: Array nums is equal to [0, 2, 4, 6, 8] where (0 ^ 2 ^ 4 ^ 6 ^ 8) = 8.
Where "^" corresponds to bitwise XOR operator.
```

**Example 2:**

```
Input: n = 4, start = 3
Output: 8
Explanation: Array nums is equal to [3, 5, 7, 9] where (3 ^ 5 ^ 7 ^ 9) = 8.
```

**Example 3:**

```
Input: n = 1, start = 7
Output: 7
```

**Example 4:**

```
Input: n = 10, start = 5
Output: 2
```

**Constraints:**

- `1 <= n <= 1000`
- `0 <= start <= 1000`
- `n == nums.length`

**Solution**

```swift
func xorOperation(_ n: Int, _ start: Int) -> Int {
    var res = start
    for idx in 1 ..< n {
        let num = start + idx * 2
        res ^= num
    }
    return res
}
```



---

### 1487. Making File Names Unique

Given an array of strings `names` of size `n`. You will create `n` folders in your file system **such that**, at the `ith` minute, you will create a folder with the name `names[i]`.

Since two files **cannot** have the same name, if you enter a folder name which is previously used, the system will have a suffix addition to its name in the form of `(k)`, where, `k` is the **smallest positive integer** such that the obtained name remains unique.

Return *an array of strings of length `n`* where `ans[i]` is the actual name the system will assign to the `ith` folder when you create it.

**Example 1:**

```
Input: names = ["pes","fifa","gta","pes(2019)"]
Output: ["pes","fifa","gta","pes(2019)"]
Explanation: Let's see how the file system creates folder names:
"pes" --> not assigned before, remains "pes"
"fifa" --> not assigned before, remains "fifa"
"gta" --> not assigned before, remains "gta"
"pes(2019)" --> not assigned before, remains "pes(2019)"
```

**Example 2:**

```
Input: names = ["gta","gta(1)","gta","avalon"]
Output: ["gta","gta(1)","gta(2)","avalon"]
Explanation: Let's see how the file system creates folder names:
"gta" --> not assigned before, remains "gta"
"gta(1)" --> not assigned before, remains "gta(1)"
"gta" --> the name is reserved, system adds (k), since "gta(1)" is also reserved, systems put k = 2. it becomes "gta(2)"
"avalon" --> not assigned before, remains "avalon"
```

**Example 3:**

```
Input: names = ["onepiece","onepiece(1)","onepiece(2)","onepiece(3)","onepiece"]
Output: ["onepiece","onepiece(1)","onepiece(2)","onepiece(3)","onepiece(4)"]
Explanation: When the last folder is created, the smallest positive valid k is 4, and it becomes "onepiece(4)".
```

**Example 4:**

```
Input: names = ["wano","wano","wano","wano"]
Output: ["wano","wano(1)","wano(2)","wano(3)"]
Explanation: Just increase the value of k each time you create folder "wano".
```

**Example 5:**

```
Input: names = ["kaido","kaido(1)","kaido","kaido(1)"]
Output: ["kaido","kaido(1)","kaido(2)","kaido(1)(1)"]
Explanation: Please note that system adds the suffix (k) to current name even it contained the same suffix before.
```

**Constraints:**

- `1 <= names.length <= 5 * 10^4`
- `1 <= names[i].length <= 20`
- `names[i]` consists of lower case English letters, digits and/or round brackets.

**Solution**

```swift
func getFolderNames(_ names: [String]) -> [String] {
    
    var res = [String]()
    var m = [String:Int]()
    for i in 0..<names.count {
        let name = names[i]
        var targetName = name
        if m.keys.contains(name) {
            targetName = "\(name)(\(m[name]!+1))"
            var temp =  m[name]!
            while (m[targetName] != nil) {
                temp += 1
                targetName = "\(name)(\(temp))"
            }
            res.append(targetName)
            m[name] = temp
            m[targetName] = 0
        } else {
            m[name] = 0
            res.append(name)
        }
    }
    return res
}
```

---

### 1488. Avoid Flood in The City

[My Submissions](https://leetcode.com/contest/weekly-contest-194/problems/avoid-flood-in-the-city/submissions/)[Back to Contest](https://leetcode.com/contest/weekly-contest-194/)

- **User Accepted:**1202
- **User Tried:**3504
- **Total Accepted:**1240
- **Total Submissions:**11201
- **Difficulty:****Medium**

Your country has an infinite number of lakes. Initially, all the lakes are empty, but when it rains over the `nth` lake, the `nth` lake becomes full of water. If it rains over a lake which is **full of water**, there will be a **flood**. Your goal is to avoid the flood in any lake.

Given an integer array `rains` where:

- `rains[i] > 0` means there will be rains over the `rains[i]` lake.
- `rains[i] == 0` means there are no rains this day and you can choose **one lake** this day and **dry it**.

Return *an array `ans`* where:

- `ans.length == rains.length`
- `ans[i] == -1` if `rains[i] > 0`.
- `ans[i]` is the lake you choose to dry in the `ith` day if `rains[i] == 0`.

If there are multiple valid answers return **any** of them. If it is impossible to avoid flood return **an empty array**.

Notice that if you chose to dry a full lake, it becomes empty, but if you chose to dry an empty lake, nothing changes. (see example 4)

 

**Example 1:**

```
Input: rains = [1,2,3,4]
Output: [-1,-1,-1,-1]
Explanation: After the first day full lakes are [1]
After the second day full lakes are [1,2]
After the third day full lakes are [1,2,3]
After the fourth day full lakes are [1,2,3,4]
There's no day to dry any lake and there is no flood in any lake.
```

**Example 2:**

```
Input: rains = [1,2,0,0,2,1]
Output: [-1,-1,2,1,-1,-1]
Explanation: After the first day full lakes are [1]
After the second day full lakes are [1,2]
After the third day, we dry lake 2. Full lakes are [1]
After the fourth day, we dry lake 1. There is no full lakes.
After the fifth day, full lakes are [2].
After the sixth day, full lakes are [1,2].
It is easy that this scenario is flood-free. [-1,-1,1,2,-1,-1] is another acceptable scenario.
```

**Example 3:**

```
Input: rains = [1,2,0,1,2]
Output: []
Explanation: After the second day, full lakes are  [1,2]. We have to dry one lake in the third day.
After that, it will rain over lakes [1,2]. It's easy to prove that no matter which lake you choose to dry in the 3rd day, the other one will flood.
```

**Example 4:**

```
Input: rains = [69,0,0,0,69]
Output: [-1,69,1,1,-1]
Explanation: Any solution on one of the forms [-1,69,x,y,-1], [-1,x,69,y,-1] or [-1,x,y,69,-1] is acceptable where 1 <= x,y <= 10^9
```

**Example 5:**

```
Input: rains = [10,20,20]
Output: []
Explanation: It will rain over lake 20 two consecutive days. There is no chance to dry any lake.
```

**Constraints:**

- `1 <= rains.length <= 10^5`
- `0 <= rains[i] <= 10^9`

**Solution**

**Two key things to note-**

1. When drying a lake #L, it is only useful to dry it if it is FULL already. Otherwise its of no use. (Explained this in the code with a small example as well.)
2. Which lake to dry on a day when there is no rain, can not be determined without knowing the rain sequence that is coming next.
   For example - If you have rains = [1, 2, 0, ??]. Without knowing what the '??' is, you can not determine which lake to dry on the 3rd day (rains[2]), this is because if '??' = 1, then you must dry the lake #1 to avoid flooding. Similarly, if '??' =2, then you must dry lake #2 to avoid flooding.

Detailed Comments in the code.

```cpp
class Solution {
public:
    vector<int> avoidFlood(vector<int>& rains) {
        vector<int> ans; // Store the final answer here.
        int n = rains.size(); 
        unordered_map<int, int> fulllakes; // Lake number -> day on which it became full.
        set<int> drydays;     // Set of available days that can be used for drying a full lake.
        for (int i=0; i<n; i++) {  // For each day - 
            if (rains[i] == 0) {  // No rain on this day.
                drydays.insert(i); // This day can be used as a day to dry some lake.
                                   // We don't know which lake to prioritize for drying yet.
                ans.push_back(1);  // Any number would be ok. This will get overwritten eventually.
                                   // If it doesn't get overwritten, its totally ok to dry a lake
                                   // irrespective of whether it is full or empty.
            } else { // Rained in rains[i]-th lake.
                int lake = rains[i]; 
                if (fulllakes.find(lake) != fulllakes.end()) { // If it is already full -
                    // We must dry this lake before it rains in this lake.
                    // So find a day in "drydays" to dry this lake. Obviously, that day must be
                    // a day that is after the day on which the lake was full.
                    // i.e. if the lake got full on 7th day, we must find a dry day that is 
                    // greater than 7.
                    auto it = drydays.lower_bound(fulllakes[lake]);
                    if (it == drydays.end()) { // If there is no available dry day to dry the lake,
                                               // flooding is inevitable.
                        return {}; // Sorry, couldn't stop flooding.
                    }
                    int dryday = *it; // Great, we found a day which we can use to dry this lake.
                    ans[dryday] = lake; // Overwrite the "1" and dry "lake"-th lake instead.
                    drydays.erase(dryday); // We dried "lake"-th lake on "dryday", and we can't use
                                           // the same day to dry any other lake, so remove the day
                                           // from the set of available drydays.
                }
                fulllakes[lake] = i; // Update that the "lake" became full on "i"-th day.
                ans.push_back(-1); // As the problem statement expects.
            }
        }
        return ans; // Congratualtions, you avoided flooding.
    }
};
```

```swift
func avoidFlood(_ rains: [Int]) -> [Int] {
    var map = [Int:Int]()
    var zeros = [Int]()
    var res = Array(repeating: 0, count: rains.count);
    for i in 0..<rains.count {
        if (rains[i] == 0) {
            zeros.append(i)
        } else {
            if (map.keys.contains(rains[i])) {
                let next = zeros.first{ $0 >= map[rains[i]]! }
                if next == nil {
                    return []
                }
                res[next!] = rains[i];
                zeros.remove(at: zeros.firstIndex(of: next!)!)
            }
            res[i] = -1;
            map[rains[i]] = i;
        }
    }
    for i in zeros {
        res[i] = 1;
    }
    return res
}
```



---



### 1489. Find Critical and Pseudo-Critical Edges in Minimum Spanning Tree

Given a weighted undirected connected graph with `n` vertices numbered from `0` to `n-1`, and an array `edges` where `edges[i] = [fromi, toi, weighti]` represents a bidirectional and weighted edge between nodes `fromi` and `toi`. A minimum spanning tree (MST) is a subset of the edges of the graph that connects all vertices without cycles and with the minimum possible total edge weight.

Find *all the critical and pseudo-critical edges in the minimum spanning tree (MST) of the given graph*. An MST edge whose deletion from the graph would cause the MST weight to increase is called a *critical edge*. A *pseudo-critical edge*, on the other hand, is that which can appear in some MSTs but not all.

Note that you can return the indices of the edges in any order.

 

**Example 1:**

![img](https://assets.leetcode.com/uploads/2020/06/04/ex1.png)

```
nput: n = 5, edges = [[0,1,1],[1,2,1],[2,3,2],[0,3,2],[0,4,3],[3,4,3],[1,4,6]]
Output: [[0,1],[2,3,4,5]]
Explanation: The figure above describes the graph.
The following figure shows all the possible MSTs:

Notice that the two edges 0 and 1 appear in all MSTs, therefore they are critical edges, so we return them in the first list of the output.
The edges 2, 3, 4, and 5 are only part of some MSTs, therefore they are considered pseudo-critical edges. We add them to the second list of the output.
```

**Example 2:**

![img](https://assets.leetcode.com/uploads/2020/06/04/ex2.png)

```
Input: n = 4, edges = [[0,1,1],[1,2,1],[2,3,1],[0,3,1]]
Output: [[],[0,1,2,3]]
Explanation: We can observe that since all 4 edges have equal weight, choosing any 3 edges from the given 4 will yield an MST. Therefore all 4 edges are pseudo-critical.
```

**Constraints:**

- `2 <= n <= 100`
- `1 <= edges.length <= min(200, n * (n - 1) / 2)`
- `edges[i].length == 3`
- `0 <= fromi < toi < n`
- `1 <= weighti <= 1000`
- All pairs `(fromi, toi)` are distinct.

**Solution**



We use the standard MST algorithm as a baseline, and denote the total MST weight as `origin_mst`.
To generate critical and pseudo-critical lists, we enumerate each edge:



1. If deleting the edge and re-calculating the mst again makes mst total weight increase (or can't form mst), then the edge goes into critical list.
2. If we force adding the edge to the mst (by first adding the edge to the mst edge set and run the standard MST algorithm for the rest of the edges), and find that the mst doesn't change, then the edge goes into pseudo-critical list. (This is because if an edge can be in any mst, we can always add it to the edge set first, without changing the final mst total weight).

```cpp
class UnionFind {
public:
    UnionFind(int n) {
        rank = vector<int>(n, 1);
        f.resize(n);
        for (int i = 0; i < n; ++i) f[i] = i;
    }
    
    int Find(int x) {
        if (x == f[x]) return x;
        else return f[x] = Find(f[x]);
    }
    
    void Union(int x, int y) {
        int fx = Find(x), fy = Find(y);
        if (fx == fy) return;
        if (rank[fx] > rank[fy]) swap(fx, fy);
        f[fx] = fy;
        if (rank[fx] == rank[fy]) rank[fy]++;
    }
    
private:
    vector<int> f, rank;
};

class Solution {
public:
    vector<vector<int>> findCriticalAndPseudoCriticalEdges(int n, vector<vector<int>>& edges) {
        for (int i = 0; i < edges.size(); ++i) {
            edges[i].push_back(i);
        }
        sort(edges.begin(), edges.end(), [](const vector<int>& a, const vector<int>& b) {
            return a[2] < b[2];
        });
        int origin_mst = GetMST(n, edges, -1);
        vector<int> critical, non_critical;
        for (int i = 0; i < edges.size(); ++i) {
            if (origin_mst < GetMST(n, edges, i)) {
                critical.push_back(edges[i][3]);
            } else if (origin_mst == GetMST(n, edges, -1, i)) {
                non_critical.push_back(edges[i][3]);
            }
        }
        return {critical, non_critical};
    }
    
private:
    int GetMST(const int n, const vector<vector<int>>& edges, int blockedge, int pre_edge = -1) {
        UnionFind uf(n);
        int weight = 0;
        if (pre_edge != -1) {
            weight += edges[pre_edge][2];
            uf.Union(edges[pre_edge][0], edges[pre_edge][1]);
        }
        for (int i = 0; i < edges.size(); ++i) {
            if (i == blockedge) continue;
            const auto& edge = edges[i];
            if (uf.Find(edge[0]) == uf.Find(edge[1])) continue;
            uf.Union(edge[0], edge[1]);
            weight += edge[2];
        }
        for (int i = 0; i < n; ++i) {
            if (uf.Find(i) != uf.Find(0)) return 1e9+7;
        }
        return weight;
    }
};
```

