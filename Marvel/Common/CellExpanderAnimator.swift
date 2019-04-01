//
//  PopAnimator.swift
//  Marvel
//
//  Created by Lucas Salton Cardinali on 28/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import UIKit

final class CellExpanderAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    let originLocation: CGRect
    let presenting: Bool

    init(originLocation: CGRect, presenting: Bool) {
        self.originLocation = originLocation
        self.presenting = presenting
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to) else {
                return
        }

        let duration = self.transitionDuration(using: transitionContext)

        var snapshotView: UIView?

        if presenting {
            transitionContext.containerView.addSubview(toViewController.view)
            toViewController.view.frame = originLocation
            toViewController.view.clipsToBounds = true
        } else {
            let snapshot = fromViewController.view.snapshotView(afterScreenUpdates: false)
            snapshot?.frame = fromViewController.view.frame
            snapshotView = snapshot
            fromViewController.view.removeFromSuperview()
            if let snapshot = snapshot {
                transitionContext.containerView.addSubview(snapshot)
                transitionContext.containerView.insertSubview(toViewController.view, belowSubview: snapshot)
            }
        }

        let viewToAnimate = presenting ? toViewController.view : snapshotView
        let toFrame = presenting ? transitionContext.containerView.frame : self.originLocation

        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            viewToAnimate?.frame = toFrame
            snapshotView?.alpha = 0
        }, completion: { _ in
            snapshotView?.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
