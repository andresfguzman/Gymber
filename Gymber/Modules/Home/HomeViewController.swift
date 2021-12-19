//
//  ViewController.swift
//  Gymber
//
//  Created by Andrés Guzmán on 16/12/21.
//

import UIKit

protocol HomeViewProtocol: AnyObject {
    func setLoading(_ isLoading: Bool)
    func reloadData()
    func showErrorAlert(with message: String)
}

final class HomeViewController: UIViewController {
    
    //MARK: - Properties
    var homeViewModel: HomeViewModelProtocol?
    private var stackContainer : CardCollectionView!
    private var activityIndicator: UIActivityIndicatorView!
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemGray
        setupActivityIndicator()
        configureStackContainer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackContainer.dataSource = self
        homeViewModel?.fetchModelData()
    }
    
    //MARK: - Configurations
    private func configureStackContainer() {
        stackContainer = CardCollectionView()
        view.addSubview(stackContainer)
        
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        stackContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackContainer.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - (.defaultMargins * 2)).isActive = true
        stackContainer.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 10/7).isActive = true
    }
    
    private func setupActivityIndicator() {
        if #available(iOS 13.0, *) {
            activityIndicator = UIActivityIndicatorView(style: .large)
        } else {
            activityIndicator = UIActivityIndicatorView()
        }
        view.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints =  false
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.startAnimating()
    }
}

extension HomeViewController: CardCollectionViewDataSource {
    func card(at index: Int) -> CardView {
        let card = CardView()
        card.viewModel = homeViewModel?.model(at: index)
        return card
    }
    
    func visibleCards() -> Int {
        return homeViewModel?.cardsCount() ?? .zero
    }
}

extension HomeViewController: HomeViewProtocol {
    func setLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        activityIndicator.isHidden = !isLoading
    }
    
    func reloadData() {
        stackContainer.reloadData()
    }
    
    func showErrorAlert(with message: String) {
        let alert = UIAlertController(title: "General.Alert.Error.Title".localized, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "General.Alert.OK".localized, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
