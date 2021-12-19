//
//  CardCollectionProtocols.swift
//  Gymber
//
//  Created by Andrés Guzmán on 17/12/21.
//

import UIKit

protocol CardCollectionViewDataSource {
    func card(at index: Int) -> CardView
    func visibleCards() -> Int
}

protocol SwipeCardDelegate: AnyObject {
    func swipeLeftEnded(on card: CardView)
    func swipeRightEnded(on card: CardView)
}


protocol GymberAnimationsHandler {
    func animateLikedGym(point: CGPoint)
    func animatedDislikedGym(point: CGPoint)
}

extension GymberAnimationsHandler where Self: CardView {
    func resetPosition(onFinished: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: .defaultAnimationDuration) {
            self.transform = .identity
            self.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
            self.alpha = 1
        } completion: { finised in
            onFinished?(finised)
        }
    }
}
