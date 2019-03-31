//
//  PopAnimator.swift
//  Marvel
//
//  Created by Lucas Salton Cardinali on 28/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    let duration = 0.5
    var presenting = true
    var originFrame = CGRect.zero

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        toView.frame = containerView.frame
        let detailView = presenting ? toView : transitionContext.view(forKey: .from)!

        let initialFrame = presenting ? originFrame : detailView.frame
        let finalFrame = presenting ? detailView.frame : originFrame

        let xScaleFactor = presenting ?

            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width

        let yScaleFactor = presenting ?

            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height

        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor,
                                               y: yScaleFactor)

        if presenting {
            detailView.transform = scaleTransform
            detailView.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY)
            detailView.clipsToBounds = true
        }

        containerView.addSubview(toView)
        containerView.bringSubviewToFront(detailView)

        UIView.animate(withDuration: duration,
                       animations: {
                        detailView.transform = self.presenting ?
                            CGAffineTransform.identity : scaleTransform
                        detailView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        },
                       completion: { _ in
                        transitionContext.completeTransition(true)
        }
        )

    }
}
