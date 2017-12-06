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

        cell.frame = container.convert(cell.contentView.frame, from: sourceVC.selectedCell)

        destinationVC.view.frame = transitionContext.finalFrame(for: destinationVC)
        destinationVC.view.alpha = 0
        
        container.addSubview(destinationVC.view)
        container.addSubview(cell)
        
        UIView.animate(withDuration: 0.5, animations: {
            destinationVC.view.alpha = 1;
            cell.frame = container.convert(destinationVC.view.frame, from: destinationVC.view)
        }) { finish in
            if finish {
                cell.isHidden = true
                destinationVC.imageView.isHidden = false
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}
