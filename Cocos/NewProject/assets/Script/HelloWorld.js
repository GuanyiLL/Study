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

        scoreDisplay: {
            default: null,
            type: cc.Label
        },

        arrowCountDisplay: {
            default: null,
            type: cc.Label
        },

        currentArrow: null,
        hasCrashed: false,
        score: 0,
        arrowCount: 10
    },

    onLoad: function () {
        this.arrowCountDisplay.string = this.arrowCount.toString();
        this.initializeCurrentArrow();
        this.node.on('touchend',function(event){
            var shoot = cc.moveTo(0.2, cc.p(0, this.circle.y - this.circle.height / 2 + 10));
            var finished = cc.callFunc(function(){
                if  (this.hasCrashed) {
                    this.gameOver();
                } else {
                    this.gainScore();
                    this.circle.getComponent('Circle').createNewArrow();
                }
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
        newArrow.getComponent('Arrow').helloWorld = this;
        this.node.addChild(newArrow);
        newArrow.setPosition(cc.p(0, -250));
        this.currentArrow = newArrow;
    },

    gameOver() {
        cc.director.loadScene('helloworld');
    },

    gainScore: function () {
        this.score += 1;
        this.arrowCount -= 1;
        this.scoreDisplay.string = 'Score: ' + this.score.toString();
        this.arrowCountDisplay.string = this.arrowCount.toString();
    },
});
