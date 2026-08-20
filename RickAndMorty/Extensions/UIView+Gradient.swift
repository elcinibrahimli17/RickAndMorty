//
//  UIView+Gradient.swift
//  RickAndMorty
//
//  Created by Elchın on 19.08.26.
//

import UIKit

extension UIView {
    private static let gradientLayerName = "appliedGradientLayer"
    
    func applyGradient(colors: [UIColor], startPoint: CGPoint = CGPoint(x: 0, y: 0), endPoint: CGPoint = CGPoint(x: 1, y: 1)) {
        clipsToBounds = true
        
        let gradientLayer: CAGradientLayer
        if let existing = layer.sublayers?.first(where: { $0.name == UIView.gradientLayerName }) as? CAGradientLayer {
            gradientLayer = existing
        } else {
            gradientLayer = CAGradientLayer()
            gradientLayer.name = UIView.gradientLayerName
            layer.insertSublayer(gradientLayer, at: 0)
//            guard let gradientLayer = layer.sublayers?.first(where: { $0.name == UIView.gradientLayerName }) as? CAGradientLayer else { return }
//            gradientLayer.frame = bounds

        }
        
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
    }
    
    func updateGradientFrame() {
        guard let gradientLayer = layer.sublayers?.first(where: { $0.name == UIView.gradientLayerName }) as? CAGradientLayer else { return }
        gradientLayer.frame = bounds
    }
}
