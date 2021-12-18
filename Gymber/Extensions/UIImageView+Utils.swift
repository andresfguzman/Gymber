//
//  UIImageView+Utils.swift
//  Gymber
//
//  Created by Andrés Guzmán on 18/12/21.
//

import UIKit


extension UIImageView {
    func load(from stringURL: String) {
        guard let imageURL = URL(string: stringURL) else { return }
        URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
            guard let imageData = data else { return }
            DispatchQueue.performUIUpdates { [weak self] in
                self?.image = UIImage(data: imageData)
            }
        }.resume()
    }
}
