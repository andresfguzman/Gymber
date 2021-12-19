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
    private var topCardView = UIView()
    
    private var containerView: UIView!
    
    private let tiltRadian: CGFloat = 20 * CGFloat((Double.pi/180))
    
    weak var delegate: SwipeCardDelegate?
    
    var viewModel: GymCardViewModel? {
        didSet {
            titleLable.text = viewModel?.title
            guard let image = viewModel?.image else { return }
            photoView.load(from: image)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .white
        configContainer()
        setupPhotoView()
        setupTopCardView()
        setupBottomCardView()
        layer.cornerRadius = .defaultCornerRadius
        clipsToBounds = true
        addPanGestureOnCards()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMatchedCard() {
        descriptionLabel = UILabel()
        
        bottomCardView.addSubview(descriptionLabel)
        
        descriptionLabel.text = "CardView.Match.Message".localized
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
            self.topCardView.backgroundColor = .systemGreen
            self.titleLable.textColor = .white
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
        topCardView.addSubview(titleLable)
        
        titleLable.textColor = .black
        titleLable.textAlignment = .center
        titleLable.numberOfLines = .zero
        titleLable.font = UIFont.boldSystemFont(ofSize: 20)
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.leftAnchor.constraint(equalTo: topCardView.leftAnchor).isActive = true
        titleLable.rightAnchor.constraint(equalTo: topCardView.rightAnchor).isActive = true
        titleLable.topAnchor.constraint(equalTo: topCardView.topAnchor).isActive = true
        titleLable.bottomAnchor.constraint(equalTo: topCardView.bottomAnchor).isActive = true
    }
    
    private func setupBottomCardView() {
        bottomCardView.backgroundColor = .white
        
        containerView.addSubview(bottomCardView)
        
        bottomCardView.translatesAutoresizingMaskIntoConstraints = false
        bottomCardView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        bottomCardView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        bottomCardView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        bottomCardView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        setupStackButtonView()
    }
    
    private func setupStackButtonView() {
        likeButton.setImage(UIImage(named: "like_button_asset"), for: .normal)
        likeButton.imageView?.contentMode = .scaleAspectFit
        dislikeButton.setImage(UIImage(named: "dislike_button_asset"), for: .normal)
        dislikeButton.imageView?.contentMode = .scaleAspectFit
        
        let buttonStackView = UIStackView(arrangedSubviews: [dislikeButton, likeButton])
        buttonStackView.alignment = .center
        buttonStackView.distribution = .fillEqually
        buttonStackView.axis = .horizontal
        bottomCardView.addSubview(buttonStackView)
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.leftAnchor.constraint(equalTo: bottomCardView.leftAnchor).isActive = true
        buttonStackView.rightAnchor.constraint(equalTo: bottomCardView.rightAnchor).isActive = true
        buttonStackView.bottomAnchor.constraint(equalTo: bottomCardView.bottomAnchor, constant: -4.0).isActive = true
        buttonStackView.topAnchor.constraint(equalTo: bottomCardView.topAnchor, constant: 4.0).isActive = true
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
        dislikeButton.addTarget(self, action: #selector(dislikeButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func setupTopCardView() {
        topCardView.backgroundColor = .white
        containerView.addSubview(topCardView)
        
        topCardView.translatesAutoresizingMaskIntoConstraints = false
        topCardView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        topCardView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        topCardView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        topCardView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        setupTitle()
    }
    
    @objc private func likeButtonTapped(_ caller: UIButton) {
        animateLikedGym()
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
        } completion: { _ in
            self.delegate?.swipeLeftEnded(on: self)
        }
    }
}
