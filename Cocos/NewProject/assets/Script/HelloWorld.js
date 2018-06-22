cc.Class({
    extends: cc.Component,

    properties: {
        circle: {
            default: null,
            type: cc.Node
        },

        arrowPrefab: {
            default: null,
            type: cc.Prefab
        },

        currentArrow: null
    },

    onLoad: function () {
        this.initializeCurrentArrow();

        var preArrow = cc.instantiate(this.arrowPrefab);
        // 将新增的节点添加到 Canvas 节点下面
        this.node.addChild(preArrow);
        // 为星星设置一个随机位置
        preArrow.setPosition(cc.p(0, -500));

        this.node.on('touchend',function(event){
            var shoot = cc.moveTo(0.2, cc.p(0, this.circle.y));
            var finished = cc.callFunc(function(){
                this.circle.getComponent('Circle').createNewArrow();
                this.currentArrow.destroy();
                this.initializeCurrentArrow();
            }, this);

            var myAction = cc.sequence(shoot, finished);
            this.currentArrow.runAction(myAction);
        },this);
    },

    initializeCurrentArrow: function () {
        var newArrow = cc.instantiate(this.arrowPrefab);
        this.node.addChild(newArrow);
        newArrow.setPosition(cc.p(0, -250));
        this.currentArrow = newArrow;
    },

    // called every frame
    update: function (dt) {

    },
});
