
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
        this.defaultArrawCount = 4;
        this.animState.speed = 1.2;
        this.createDefaultArrow();
    },

    createDefaultArrow: function () {
        this.node.removeAllChildren();
        for (var i = 0; i < this.defaultArrawCount; i ++) {
            var arrow = cc.instantiate(this.arrowPrefab);
            this.node.addChild(arrow);
            arrow.rotation = -360 / this.defaultArrawCount * i;
            var x1 = (this.node.height / 2 - 10) * Math.cos((360 / this.defaultArrawCount * i + 90) * 3.14 / 180); 
            var y1 = (this.node.height / 2 - 10) * Math.sin((360 / this.defaultArrawCount * i + 90) * 3.14 / 180);
            arrow.setPosition(cc.p(-x1,-y1));
        }
    },

    update (dt) {

    },
});
