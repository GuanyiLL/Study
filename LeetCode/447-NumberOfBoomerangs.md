# Description

Given n points in the plane that are all pairwise distinct, a "boomerang" is a tuple of points (i, j, k) such that the distance between i and j equals the distance between i and k (the order of the tuple matters).

Find the number of boomerangs. You may assume that n will be at most 500 and coordinates of points are all in the range [-10000, 10000] (inclusive).

#### Ex1

```
Input:
[[0,0],[1,0],[2,0]]

Output:
2

Explanation:
The two boomerangs are [[1,0],[0,0],[2,0]] and [[1,0],[2,0],[0,0]]

```

# Code

```cpp

int getDistance(pair<int,int> a, pair<int,int> b) {
    int dx = a.first - b.first;
    int dy = a.second - b.second;
    return dx*dx + dy*dy;
}

int numberOfBoomerangs(vector<pair<int, int>>& points) {
    int res = 0;
    unordered_map<int, int> m;
    for(int i=0; i<points.size(); i++) {
        for(int j=0; j<points.size(); j++) {
            if(i == j) continue;
            int d = getDistance(points[i], points[j]);
            m[d]= m[d] + 1;
        }
        for(auto& val : m) res += val.second * (val.second-1);
        m.clear();
    }
    return res;
}

```
