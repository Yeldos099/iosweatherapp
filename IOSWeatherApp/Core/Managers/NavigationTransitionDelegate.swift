//
//  NavigationTransitionDelegate.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 09.05.2026.
//

import UIKit

final class NavigationTransitionDelegate: NSObject, UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) ->  UIViewControllerAnimatedTransitioning? {
        switch operation {
            case .push: return PushTransition()
            case .pop: return PopTransition()
        default : return nil
        }
    }
}
