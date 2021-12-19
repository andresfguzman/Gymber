//
//  CardCollectionView.swift
//  Gymber
//
//  Created by Andrés Guzmán on 16/12/21.
//

import UIKit

final class CardCollectionView: UIView {
    
    private enum SwipeDirection {
        case right
        case left
    }
    
    //MARK: - Properties
    private var visibleCardsCount: Int = .zero
    private var cardsToBeVisible: Int = 3
    private var cardViews : [CardView] = []
    private var remainingcards: Int = .zero
    
    private let horizontalInset: CGFloat = 8.0
    private let verticalInset: CGFloat = 5.0
    
    private var visibleCards: [CardView] {
        return subviews as? [CardView] ?? []
    }
    var dataSource: CardCollectionViewDataSource? {
        didSet {
            reloadData()
        }
    }
    
    func reloadData() {
        removeAllCardViews()
        guard let datasource = dataSource else { return }
        visibleCardsCount = datasource.visibleCards()
        remainingcards = visibleCardsCount
        
        for i in 0..<min(visibleCardsCount,cardsToBeVisible) {
            addCardView(cardView: datasource.card(at: i), atIndex: i )
        }
    }
    
    //MARK: - Configurations
    
    func addCardFrame(index: Int, cardView: CardView) {
        var cardViewFrame = bounds
        let horizontalInset = (CGFloat(index) * self.horizontalInset)
        let verticalInset = CGFloat(index) * self.verticalInset
        
        cardViewFrame.size.width -= 2 * horizontalInset
        cardViewFrame.origin.x += horizontalInset
        cardViewFrame.origin.y += verticalInset
        
        cardView.frame = cardViewFrame
    }
    
    private func addCardView(cardView: CardView, atIndex index: Int) {
        cardView.delegate = self
        addCardFrame(index: index, cardView: cardView)
        cardViews.append(cardView)
        insertSubview(cardView, at: .zero)
        remainingcards -= 1
    }
    
    private func removeAllCardViews() {
        for cardView in visibleCards {
            cardView.removeFromSuperview()
        }
        cardViews = []
    }
    
    private func swipeDidEnd(on view: CardView, direction: SwipeDirection) {
        guard let datasource = dataSource else { return }
        
        if view.viewModel?.isMatch ?? false, direction == .right {
            matchAnimation(in: datasource, for: view)
        } else {
            handleNextCard(with: datasource, for: view)
        }
    }
    
    private func handleNextCard(with datasource: CardCollectionViewDataSource, for card: CardView) {
        cardViews.removeAll(where: { $0 == card })
        card.removeFromSuperview()
        
        let newIndex = datasource.visibleCards() - remainingcards
        if newIndex < datasource.visibleCards() {
            addCardView(cardView: datasource.card(at: newIndex), atIndex: cardsToBeVisible)
        }
        
        visibleCards.reversed().enumerated().forEach { item in
            UIView.animate(withDuration: .defaultAnimationDuration, delay: .zero, options: .allowUserInteraction) {
                self.addCardFrame(index: item.offset, cardView: item.element)
                item.element.layoutIfNeeded()
            } completion: { _ in
                self.isUserInteractionEnabled = true
            }
        }
    }
    
    private func matchAnimation(in datasource: CardCollectionViewDataSource, for card: CardView) {
        self.isUserInteractionEnabled = false
        card.resetPosition { _ in
            card.setupMatchedCard()
            UIView.animate(withDuration: .defaultAnimationDuration, delay: 1.0) {
                card.transform = CGAffineTransform(scaleX: 2, y: 2)
                card.alpha = .zero
            } completion: { _ in
                self.handleNextCard(with: datasource, for: card)
            }
        }
    }
}

extension CardCollectionView: SwipeCardDelegate {
    func swipeLeftEnded(on card: CardView) {
        swipeDidEnd(on: card, direction: .left)
    }
    
    func swipeRightEnded(on card: CardView) {
        swipeDidEnd(on: card, direction: .right)
    }
}
