# Description

Initially, there is a Robot at position (0, 0). Given a sequence of its moves, judge if this robot makes a circle, which means it moves back to the original place.

The move sequence is represented by a string. And each move is represent by a character. The valid robot moves are `R` (Right), `L` (Left), `U` (Up) and `D` (down). The output should be true or false representing whether the robot makes a circle.

#### Ex 1:
> Input: "UD"
> Output: true

#### Ex 2:
> Input: "LL"
> Output: false

# Code

```
bool judgeCircle(string moves) {
    int vcount = 0;
    int hcount = 0;
    for (char c : moves) {
          switch(c){
            case 'U': vcount++; break;
            case 'D': vcount--; break;
            case 'L': hcount++; break;
            case 'R': hcount--; break;
        }
    }
    return vcount == 0 && hcount == 0;
}
```
