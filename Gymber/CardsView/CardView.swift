//
//  CardView.swift
//  Gymber
//
//  Created by Andrés Guzmán on 17/12/21.
//

import UIKit

final class CardView: UIView {
    // VIEWS
    private var titleLable = UILabel()
    private var descriptionLabel: UILabel!
    private var photoView = UIImageView()
    private var likeButton = UIButton()
    private var dislikeButton = UIButton()
    private var bottomCardView = UIView()
    
    private var containerView: UIView!
    
    private let tiltRadian : CGFloat = 30 * CGFloat((Double.pi/180))
    
    weak var delegate : SwipeCardDelegate?
    
    var viewModel : GymCardViewModel? {
        didSet {
            titleLable.text = viewModel?.title
            guard let image = viewModel?.image else { return }
            photoView.load(from: image)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
        } else {
            backgroundColor = .white
        }
        configContainer()
        setupPhotoView()
        setupTitle()
        setupBottomCardView()
        layer.cornerRadius = .defaultCornerRadius
        clipsToBounds = true
        addPanGestureOnCards()
    }
    
    func setupMatchedCard() {
        descriptionLabel = UILabel()
        
        bottomCardView.addSubview(descriptionLabel)
        
        descriptionLabel.text = "It's a match!"
        descriptionLabel.backgroundColor = .clear
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = .zero
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 28)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leftAnchor.constraint(equalTo: bottomCardView.leftAnchor).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: bottomCardView.rightAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: bottomCardView.topAnchor).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: bottomCardView.bottomAnchor).isActive = true
        
        descriptionLabel.alpha = .zero
        
        UIView.transition(with: self, duration: .defaultAnimationDuration, options: [.curveEaseIn]) {
            self.bottomCardView.backgroundColor = .systemGreen
            self.likeButton.alpha = .zero
            self.dislikeButton.alpha = .zero
            self.descriptionLabel.alpha = 1
        }
    }
    
    private func configContainer() {
        containerView = UIView()
        
        addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    private func setupPhotoView() {
        
        containerView.addSubview(photoView)
        
        photoView.contentMode = .scaleAspectFill
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        photoView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        photoView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        photoView.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
    }
    
    private func setupTitle() {
        containerView.addSubview(titleLable)
        
        titleLable.backgroundColor = .white
        titleLable.textColor = .black
        titleLable.textAlignment = .center
        titleLable.numberOfLines = .zero
        titleLable.font = UIFont.boldSystemFont(ofSize: 20)
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleLable.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        titleLable.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    private func setupBottomCardView() {
        bottomCardView.backgroundColor = .white
        
        containerView.addSubview(bottomCardView)
        
        bottomCardView.translatesAutoresizingMaskIntoConstraints = false
        bottomCardView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        bottomCardView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        bottomCardView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        bottomCardView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        setupLikeButton()
        setupDislikeButton()
    }
    
    private func setupLikeButton() {
        if #available(iOS 13.0, *) {
            likeButton.setImage(.checkmark, for: .normal)
        } else {
            // Fallback on earlier versions
        }
        
        bottomCardView.addSubview(likeButton)
        
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.centerYAnchor.constraint(equalTo: bottomCardView.centerYAnchor).isActive = true
        likeButton.rightAnchor.constraint(equalTo: bottomCardView.rightAnchor, constant: -(.defaultMargins * 2)).isActive = true
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func likeButtonTapped(_ caller: UIButton) {
        animateLikedGym()
    }
    
    private func setupDislikeButton() {
        if #available(iOS 13.0, *) {
            dislikeButton.setImage(.remove, for: .normal)
        } else {
            // Fallback on earlier versions
        }
        
        bottomCardView.addSubview(dislikeButton)
        
        dislikeButton.translatesAutoresizingMaskIntoConstraints = false
        dislikeButton.centerYAnchor.constraint(equalTo: bottomCardView.centerYAnchor).isActive = true
        dislikeButton.leftAnchor.constraint(equalTo: bottomCardView.leftAnchor, constant: (.defaultMargins * 2)).isActive = true
        
        dislikeButton.addTarget(self, action: #selector(dislikeButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func dislikeButtonTapped(_ caller: UIButton) {
        animatedDislikedGym()
    }
    
    private func addPanGestureOnCards() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
    }
    
    //MARK: - Handlers
    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
        let card = sender.view as! CardView
        let point = sender.translation(in: self)
        let centerOfParentContainer = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        card.center = CGPoint(x: centerOfParentContainer.x + point.x, y: centerOfParentContainer.y + point.y)
        
        let screenWidth = UIScreen.main.bounds.width
        // TODO: Improve swipe limit algorithm
        
        switch sender.state {
        case .ended:
            if (card.center.x) >= screenWidth {
                animateLikedGym(point: point)
                return
            } else if card.center.x <= .zero {
                animatedDislikedGym(point: point)
                return
            }
            
            resetPosition()
            
        case .changed:
            let rotation = tan(point.x / (self.frame.width * 2.0))
            card.transform = CGAffineTransform(rotationAngle: rotation)
            
        default:
            break
        }
    }
}

extension CardView: GymberAnimationsHandler {
    func animateLikedGym(point: CGPoint = CGPoint.zero) {
        let screenWidth = UIScreen.main.bounds.width
        let centerOfParentContainer = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        UIView.animate(withDuration: .defaultAnimationDuration) {
            self.center = CGPoint(x: centerOfParentContainer.x + point.x + screenWidth * 3/4, y: centerOfParentContainer.y + point.y + 75)
            self.transform = CGAffineTransform(rotationAngle: self.tiltRadian)
            self.alpha = .zero
            self.layoutIfNeeded()
        } completion: { _ in
            self.delegate?.swipeRightEnded(on: self)
        }
    }
    
    func animatedDislikedGym(point: CGPoint = CGPoint.zero) {
        let screenWidth = UIScreen.main.bounds.width
        let centerOfParentContainer = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        UIView.animate(withDuration: .defaultAnimationDuration) {
            self.center = CGPoint(x: centerOfParentContainer.x + point.x - screenWidth * 3/4, y: centerOfParentContainer.y + point.y + 75)
            self.transform = CGAffineTransform(rotationAngle: -self.tiltRadian)
            self.alpha = .zero
            self.layoutIfNeeded()
        } completion: { _ in
            self.delegate?.swipeLeftEnded(on: self)
        }
    }
}
