// Learn cc.Class:
//  - [Chinese] http://docs.cocos.com/creator/manual/zh/scripting/class.html
//  - [English] http://www.cocos2d-x.org/docs/creator/en/scripting/class.html
// Learn Attribute:
//  - [Chinese] http://docs.cocos.com/creator/manual/zh/scripting/reference/attributes.html
//  - [English] http://www.cocos2d-x.org/docs/creator/en/scripting/reference/attributes.html
// Learn life-cycle callbacks:
//  - [Chinese] http://docs.cocos.com/creator/manual/zh/scripting/life-cycle-callbacks.html
//  - [English] http://www.cocos2d-x.org/docs/creator/en/scripting/life-cycle-callbacks.html
var speedLevel00 = 0.4;
var speedLevel01 = 0.8;
var speedLevel02 = 1;


var levelInfos = {
    0: {
        defaultArrow:1,
        speed:[speedLevel01],
        totalArrow:12,
    },
    1: {
        defaultArrow:5,
        speed:[speedLevel01],
        totalArrow:12
    },
    2: {
        defaultArrow:7,
        speed:[speedLevel01],
        totalArrow:12
    },
    3: {
        defaultArrow:8,
        speed:[speedLevel01],
        totalArrow:12
    },
    4: {
        defaultArrow:9,
        speed:[speedLevel01],
        totalArrow:13
    },
    5: {
        defaultArrow:9,
        speed:[speedLevel01],
        totalArrow:14
    },
    6: {
        defaultArrow:8,
        speed:[speedLevel01],
        totalArrow:15
    },
    7: {
        defaultArrow:9,
        speed:[speedLevel01],
        totalArrow:15
    },
    8: {
        defaultArrow:8,
        speed:[speedLevel01],
        totalArrow:17
    },
    9: {
        defaultArrow:9,
        speed:[speedLevel01],
        totalArrow:17
    },
    10: {
        defaultArrow:9,
        speed:[speedLevel01],
        totalArrow:18
    },
    11: {
        defaultArrow:8,
        speed:[speedLevel01],
        totalArrow:20
    },
    12: {
        defaultArrow:7,
        speed:[speedLevel01],
        totalArrow:14
    },
    13: {
        defaultArrow:6,
        speed:[speedLevel01],
        totalArrow:20
    },
    14: {
        defaultArrow:6,
        speed:[speedLevel01],
        totalArrow:23
    },
    15: {
        defaultArrow:7,
        speed:[speedLevel01],
        totalArrow:20
    },
    16: {
        defaultArrow:10,
        speed:[speedLevel01],
        totalArrow:18
    },
    17: {
        defaultArrow:5,
        speed:[speedLevel00, speedLevel02],
        totalArrow:13
    },
    18: {
        defaultArrow:5,
        speed:[speedLevel00, speedLevel02],
        totalArrow:14
    },
    19: {
        defaultArrow:5,
        speed:[speedLevel00, speedLevel02],
        totalArrow:16
    },
    20: {
        defaultArrow:6,
        speed:[speedLevel00, speedLevel02],
        totalArrow:16
    },
    21: {
        defaultArrow:6,
        speed:[speedLevel00, speedLevel02],
        totalArrow:20
    },
    22: {
        defaultArrow:1,
        speed:[speedLevel02],
        totalArrow:27
    },
    23: {
        defaultArrow:8,
        speed:[speedLevel00,speedLevel02],
        totalArrow:21
    }
}

cc.Class({
    extends: cc.Component,
    statics: {
        level: 0,
        levelUp:function () {
            if(this.level == 23) { return; }
            this.level += 1;
        },

        speed: function () {
            return levelInfos[this.level]['speed'];
        },
        
        defaultArrowCount: function () {
            return levelInfos[this.level]['defaultArrow'];
        },

        totalArrowCount: function() {
            return levelInfos[this.level]['totalArrow'];
        }
    }
});