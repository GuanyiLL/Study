//
//  AnimatedTransitioning.swift
//  Parallax-collectionView
//
//  Created by Guanyi on 2017/12/4.
//  Copyright © 2017年 yiguan. All rights reserved.
//

import UIKit

class AnimatedTransitioning:NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let destinationVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! ParallaxDetailController
        
        let sourceVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! ViewController
        
        let container = transitionContext.containerView
        
        guard let cell = sourceVC.selectedCell else { fatalError()}
        
        let snapshotView = cell.container.snapshot
        snapshotView.frame = container.convert((sourceVC.selectedCell?.container.frame)!, from: sourceVC.selectedCell as! UIView)
        sourceVC.selectedCell?.bgImageView.isHidden = true
        
        //3.设置目标控制器的位置，并把透明度设为0，在后面的动画中慢慢显示出来变为1
        destinationVC.view.frame = transitionContext.finalFrame(for: destinationVC)
        destinationVC.view.alpha = 0
        
        //4.都添加到 container 中。注意顺序不能错了
        container.addSubview(destinationVC.view)
        container.addSubview(snapshotView)
        
        UIView .animate(withDuration: 0.35) {
            destinationVC.view.alpha = 1;
            snapshotView.frame = container.convert(destinationVC.imageView.frame, from: destinationVC.view)
            print(snapshotView)
        }
        
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }

}
