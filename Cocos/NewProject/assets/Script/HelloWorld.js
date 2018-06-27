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
        shootingArrow: null,
        hasCrashed: false,
        score: 0,
        arrowCount: 10
    },

    onLoad: function () {
        this.circle.tag = 50;
        this.arrowCountDisplay.string = this.arrowCount.toString();
        this.initializeCurrentArrow();
        this.node.on('touchend',function(event){
            this.shootingArrow = this.currentArrow;
            var shoot = cc.moveTo(0.1, cc.p(0, this.circle.y - this.circle.height / 2 + 10));
            var finished = cc.callFunc(function(){
                if  (this.hasCrashed) {
                    this.gameOver();
                } else {
                    this.gainScore();
                    this.initializeCurrentArrow();
                }
            }, this);
            var myAction = cc.sequence(shoot, finished);
            this.shootingArrow.runAction(myAction);
        },this);
    },

    initializeCurrentArrow: function () {
        var newArrow = cc.instantiate(this.arrowPrefab);
        newArrow.getComponent('Arrow').helloWorld = this;
        this.node.addChild(newArrow);
        newArrow.setPosition(cc.p(0, -100));
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
        this.shootingArrow.removeFromParent();
        if (this.arrowCount == 0) {
            this.levelUpgrade();
        } else {
            this.circle.addChild(this.shootingArrow);
            this.shootingArrow.rotation = -this.circle.rotation;
            var x1 = (this.circle.height / 2 - 10) * Math.cos((this.circle.rotation + 90) * 3.14 / 180); 
            var y1 = (this.circle.height / 2 - 10) * Math.sin((this.circle.rotation + 90) * 3.14 / 180);
            this.shootingArrow.setPosition(cc.p(-x1,-y1));
        }
    },

    levelUpgrade() {
        this.arrowCount = 15;
        this.arrowCountDisplay.string = this.arrowCount.toString();
        this.circle.getComponent('Circle').upgrade();
    }
});
