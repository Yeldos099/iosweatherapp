//
//  PushTransition.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 09.05.2026.
//

import UIKit

final class PushTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else { return }
        
        let container = transitionContext.containerView
        container.addSubview(toVC.view)
        
        toVC.view.frame = container.bounds
        toVC.view.transform = CGAffineTransform(translationX: 0, y: container.bounds.height)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.5) {
            fromVC.view.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
            fromVC.view.alpha = 0.7
            toVC.view.transform = .identity
        } completion: { finished in
            fromVC.view.transform = .identity
            fromVC.view.alpha = 1
            transitionContext.completeTransition(finished)
        }
    }
    
    
    
}
