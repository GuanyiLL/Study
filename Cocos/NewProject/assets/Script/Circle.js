// Learn cc.Class:
//  - [Chinese] http://docs.cocos.com/creator/manual/zh/scripting/class.html
//  - [English] http://www.cocos2d-x.org/docs/creator/en/scripting/class.html
// Learn Attribute:
//  - [Chinese] http://docs.cocos.com/creator/manual/zh/scripting/reference/attributes.html
//  - [English] http://www.cocos2d-x.org/docs/creator/en/scripting/reference/attributes.html
// Learn life-cycle callbacks:
//  - [Chinese] http://docs.cocos.com/creator/manual/zh/scripting/life-cycle-callbacks.html
//  - [English] http://www.cocos2d-x.org/docs/creator/en/scripting/life-cycle-callbacks.html

cc.Class({
    extends: cc.Component,

    properties: {
        rotationSpeed: 0,
        defaultArrawCount: 0,
        arrowPrefab: {
            default: null,
            type: cc.Prefab
        },

        animState: null,
    },

    onLoad: function () {
        var anim = this.getComponent(cc.Animation);
        this.animState = anim.play('rotation');
    },

    createNewArrow: function () {
        var arrow = cc.instantiate(this.arrowPrefab);
        this.node.addChild(arrow);

        arrow.rotation = -this.node.rotation;

        var x1 = (this.node.height / 2 - 10) * Math.cos((this.node.rotation + 90) * 3.14 / 180); 
        var y1 = (this.node.height / 2 - 10) * Math.sin((this.node.rotation + 90) * 3.14 / 180);

        arrow.setPosition(cc.p(-x1,-y1));
    },

    upgrade: function () {
        self.defaultArrawCount = 4;
        this.animState.speed = 1.5;
        this.node.removeAllChildren();
    },

    update (dt) {

    },
});
