var Tool = require('Tool');
cc.Class({
    extends: cc.Component,

    properties: {
        rotationSpeed: 0,
        defaultArrawCount: {
            get () {
                return this._defaultArrawCount;
            },
            set (value) {
                this._defaultArrawCount = value;
                this.createDefaultArrow();
            }
        },
        arrowPrefab: {
            default: null,
            type: cc.Prefab
        },

        animState: null,
    },

    onLoad: function () {
        var anim = this.getComponent(cc.Animation);
        this.animState = anim.play('rotation');
        this.defaultArrawCount = Tool.defaultArrowCount();
        var speed = Tool.speed();
        this.animState.speed = speed[0];
    },

    upgrade: function () {
        this.defaultArrawCount = Tool.defaultArrowCount();
        var speed = Tool.speed();
        // if (speed.length() > 1) {
        this.animState.speed = speed[0];
        // } else {
            // this.animState.speed = speed[0];
        // }
    },

    createDefaultArrow: function () {
        this.node.removeAllChildren();
        for (var i = 0; i < this.defaultArrawCount; i ++) {
            var arrow = cc.instantiate(this.arrowPrefab);
            arrow.getComponent('Arrow').isOnCircle = true;
            this.node.addChild(arrow);
            arrow.rotation = -360 / this.defaultArrawCount * i;
            var x1 = (this.node.height / 2 + arrow.height / 2 - 10) * Math.cos((360 / this.defaultArrawCount * i + 90) * 3.14 / 180); 
            var y1 = (this.node.height / 2 + arrow.height / 2 - 10) * Math.sin((360 / this.defaultArrawCount * i + 90) * 3.14 / 180);
            arrow.setPosition(cc.p(-x1,-y1));
        }
    },

    pauseRotation: function () {
        var anim = this.getComponent(cc.Animation);
        anim.pause('rotation');
    },

    resumeRotation: function () {
        var anim = this.getComponent(cc.Animation);
        anim.resume('rotation');
    },

    // update (dt) {

    // },
});
