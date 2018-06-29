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
            var shoot = cc.moveTo(0.1, cc.p(0, this.circle.y - this.circle.height / 2 - 15));
            var shake1 = cc.moveTo(0.1,cc.p(0,205));
            var shake2 = cc.moveTo(0.1,cc.p(0,200));
            var circleAction = cc.sequence(shake1,shake2);
            var finished = cc.callFunc(function(){
                if  (this.hasCrashed) {
                    this.gameOver();
                } else {
                    this.gainScore();
                    this.initializeCurrentArrow();
                }
            }, this);
            var myAction = cc.sequence(shoot, finished);
            if (!this.hasCrashed) {
                this.currentArrow.runAction(myAction);
                this.circle.runAction(circleAction);
            }
        },this);
    },

    initializeCurrentArrow: function () {
        var newArrow = cc.instantiate(this.arrowPrefab);
        newArrow.getComponent('Arrow').helloWorld = this;
        newArrow.getComponent('Arrow').isOnCircle = false;
        this.node.addChild(newArrow);
        newArrow.setPosition(cc.p(0, this.circle.y - this.circle.height - newArrow.height - 50));
        this.currentArrow = newArrow;
    },

    finishCallBack: function (event) {
        this.node.getChildByName('dialog').active = true;
    },

    resumeAction: function(event, data) {
        this.node.getChildByName('dialog').active = false;
        this.circle.getComponent('Circle').resumeRotation();
        this.initializeCurrentArrow();
        this.hasCrashed = false;
    },

    resetAction: function(event, data) {
        cc.director.loadScene('helloworld');
    },

    gameOver() {
        this.circle.getComponent('Circle').pauseRotation();
        var anim = this.currentArrow.getComponent(cc.Animation);
        anim.on('finished',this.finishCallBack,this);
        anim.play('flip');
    },

    gainScore: function () {
        this.score += 1;
        this.arrowCount -= 1;
        this.scoreDisplay.string = 'Score: ' + this.score.toString();
        this.arrowCountDisplay.string = this.arrowCount.toString();
        this.currentArrow.removeFromParent();
        if (this.arrowCount == 0) {
            this.levelUpgrade();
        } else {
            this.circle.addChild(this.currentArrow);
            this.currentArrow.getComponent('Arrow').isOnCircle = true;
            this.currentArrow.rotation = -this.circle.rotation;
            var x1 = (this.circle.height / 2 + this.currentArrow.height / 2 - 10) * Math.cos((this.circle.rotation + 90) * 3.14 / 180); 
            var y1 = (this.circle.height / 2 + this.currentArrow.height / 2 - 10) * Math.sin((this.circle.rotation + 90) * 3.14 / 180);
            this.currentArrow.setPosition(cc.p(-x1,-y1));
        }
    },

    levelUpgrade() {
        this.arrowCount = 15;
        this.arrowCountDisplay.string = this.arrowCount.toString();
        this.circle.getComponent('Circle').upgrade();
    }
});
