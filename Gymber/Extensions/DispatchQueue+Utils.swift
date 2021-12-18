//
//  DispatchQueue+Utils.swift
//  Gymber
//
//  Created by Andrés Guzmán on 18/12/21.
//

import Foundation

extension DispatchQueue {
    static func performUIUpdates(with closure: @escaping () -> Void) {
        if Thread.isMainThread {
            closure()
        } else {
            main.async(execute: closure)
        }
    }
}
