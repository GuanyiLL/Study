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
    },

    onLoad: function () {
        var anim = this.getComponent(cc.Animation);

        anim.play('rotation');
    },

    createNewArrow: function () {
        var arrow = cc.instantiate(this.arrowPrefab);
        this.node.addChild(arrow);

        arrow.setPosition(cc.p(0,0));
        arrow.rotation = -this.node.rotation;
    },

    update (dt) {

    },
});
