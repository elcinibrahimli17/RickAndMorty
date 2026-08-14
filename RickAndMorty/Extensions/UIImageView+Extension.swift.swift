//
//  UIImageView+Extension.swift.swift
//  RickAndMortyApp
//
//  Created by Elchın on 12.08.26.
//

import UIKit

extension UIImageView {
    
    func loadImage(from urlString: String) {
        self.image = nil
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, error == nil, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
        .resume()
    }
}
