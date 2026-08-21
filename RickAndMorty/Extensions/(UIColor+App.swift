//
//  (UIColor+App.swift
//  RickAndMorty
//
//  Created by Elchın on 21.08.26.
//

import UIKit

extension UIColor {
    static func app(_ name: String) -> UIColor {
        UIColor(named: name) ?? .black
    }
}
