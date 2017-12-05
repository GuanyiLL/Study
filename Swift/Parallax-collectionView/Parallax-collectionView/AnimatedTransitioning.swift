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
        
        guard let cell = sourceVC.selectedCell else { fatalError() }
        
        let snapshotView = cell.container.snapshot
        snapshotView.frame = container.convert(cell.container.frame, from: cell.container)
        sourceVC.selectedCell?.bgImageView.isHidden = true
        
        destinationVC.view.frame = transitionContext.finalFrame(for: destinationVC)
        destinationVC.view.alpha = 0
        
        container.addSubview(destinationVC.view)
        container.addSubview(snapshotView)
        
        UIView.animate(withDuration: 0.5, animations: {
            snapshotView.image = destinationVC.image
            snapshotView.frame = container.convert(destinationVC.imageView.frame, from: destinationVC.view)
            print(snapshotView)
        }) { (finish) in
            if finish {
                destinationVC.view.alpha = 1;
                snapshotView.isHidden = true
                destinationVC.imageView.isHidden = false
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}
