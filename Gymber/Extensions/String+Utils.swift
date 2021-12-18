//
//  String+Utils.swift
//  Gymber
//
//  Created by Andrés Guzmán on 18/12/21.
//

import Foundation

extension String {
    static var empty = ""
    
    var localized: String {
        return NSLocalizedString(self, comment: "GYMBER STRING")
    }
}
