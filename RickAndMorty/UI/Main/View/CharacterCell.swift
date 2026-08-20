////
////  CharacterCell.swift
////  RickAndMortyApp
////
////  Created by Elchın on 12.08.26.
////

import UIKit

final class NoAnimationGradientLayer: CAGradientLayer {
    override func action(forKey event: String) -> CAAction? {
        return NSNull()
    }
}

class CharacterCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CharacterCell"
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Inter18pt-Bold", size: 20) ?? .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let speciesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Inter18pt-Medium", size: 20) ?? .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusBadgeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let statusGradientLayer: NoAnimationGradientLayer = {
        let layer = NoAnimationGradientLayer()
        layer.cornerRadius = 15
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        return layer
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let bookmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "vector")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(red: 18/255, green: 147/255, blue: 23/255, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if statusBadgeView.bounds != .zero {
            statusGradientLayer.frame = statusBadgeView.bounds
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        statusGradientLayer.colors = nil
    }
        
    private func setupUI() {
        contentView.addSubview(characterImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(speciesLabel)
        contentView.addSubview(statusBadgeView)
        contentView.addSubview(logoImageView)
        contentView.addSubview(bookmarkImageView)
        
        statusBadgeView.layer.insertSublayer(statusGradientLayer, at: 0)
        statusGradientLayer.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            characterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            characterImageView.heightAnchor.constraint(equalTo: characterImageView.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            
            speciesLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            speciesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            speciesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            speciesLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            
            statusBadgeView.topAnchor.constraint(equalTo: characterImageView.topAnchor, constant: 13),
            statusBadgeView.trailingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: -8),
            statusBadgeView.widthAnchor.constraint(equalToConstant: 30),
            statusBadgeView.heightAnchor.constraint(equalToConstant: 30),
            
            logoImageView.centerXAnchor.constraint(equalTo: statusBadgeView.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: statusBadgeView.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 20),
            logoImageView.heightAnchor.constraint(equalToConstant: 20),
            
            bookmarkImageView.topAnchor.constraint(equalTo: characterImageView.topAnchor, constant: 17),
            bookmarkImageView.leadingAnchor.constraint(equalTo: characterImageView.leadingAnchor, constant: 6),
            bookmarkImageView.widthAnchor.constraint(equalToConstant: 21),
            bookmarkImageView.heightAnchor.constraint(equalToConstant: 25)
            
        ])
        
    }
    
    func configure(with character: Character) {
        nameLabel.text = character.name
        speciesLabel.text = character.species
        characterImageView.loadImage(from: character.image)
        
        switch character.status.lowercased() {
        case "alive":
            statusGradientLayer.colors = [
                UIColor(red: 0/255, green: 220/255, blue: 7/255, alpha: 1).cgColor,   // #00DC07
                UIColor(red: 18/255, green: 147/255, blue: 23/255, alpha: 1).cgColor, // #129317
                UIColor(red: 0/255, green: 220/255, blue: 7/255, alpha: 1).cgColor    // #00DC07
            ]
        case "dead":
            statusGradientLayer.colors = [
                UIColor(red: 220/255, green: 0/255, blue: 0/255, alpha: 1).cgColor,   // #DC0000
                UIColor(red: 147/255, green: 18/255, blue: 18/255, alpha: 1).cgColor, // #931212
                UIColor(red: 220/255, green: 0/255, blue: 0/255, alpha: 1).cgColor    // #DC0000
            ]
        default:
            statusGradientLayer.colors = [
                UIColor(red: 208/255, green: 207/255, blue: 207/255, alpha: 1).cgColor, // #D0CFCF
                UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1).cgColor, // #9B9B9B
                UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1).cgColor  // #D3D3D3
            ]
        }
        statusGradientLayer.locations = [0.0, 0.5, 1.0]
        
        switch character.gender.lowercased() {
        case "male":
            logoImageView.image = UIImage(named: "male")
        case "female":
            logoImageView.image = UIImage(named: "female")
        default:
            logoImageView.image = UIImage(named: "questionmark")

        }
        
        bookmarkImageView.isHidden = !BookmarkManager.isBookmarked(id: character.id)
    }
}










//import UIKit
//
//class CharacterCell: UICollectionViewCell {
//
//    static let reuseIdentifier = "CharacterCell"
//
//    private let characterImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 16
//        imageView.backgroundColor = .gray
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//
//    private let nameLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .center
//        label.font = UIFont(name: "Inter-Bold", size: 20)
//        label.numberOfLines = 2
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    private let speciesLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .center
//        label.font = UIFont(name: "Inter-Medium", size: 20)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    private let statusBadgeView: UIView = {
//        let view = UIView()
//        view.layer.cornerRadius = 15
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    private let logoImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.backgroundColor = .clear
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//
//    private let bookmarkImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "vector")
//        imageView.contentMode = .scaleAspectFill
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.isHidden = true
//        return imageView
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupUI() {
//        contentView.addSubview(characterImageView)
//        contentView.addSubview(nameLabel)
//        contentView.addSubview(speciesLabel)
//        contentView.addSubview(statusBadgeView)
//        contentView.addSubview(logoImageView)
//        contentView.addSubview(bookmarkImageView)
//
//        NSLayoutConstraint.activate([
//            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            characterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            characterImageView.heightAnchor.constraint(equalTo: characterImageView.widthAnchor),
//
//            nameLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 8),
//            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
//            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
//
//            speciesLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
//            speciesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
//            speciesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
//            speciesLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
//
//            statusBadgeView.topAnchor.constraint(equalTo: characterImageView.topAnchor, constant: 13),
//            statusBadgeView.trailingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: -8),
//            statusBadgeView.widthAnchor.constraint(equalToConstant: 30),
//            statusBadgeView.heightAnchor.constraint(equalToConstant: 30),
//
//            logoImageView.centerXAnchor.constraint(equalTo: statusBadgeView.centerXAnchor),
//            logoImageView.centerYAnchor.constraint(equalTo: statusBadgeView.centerYAnchor),
//            logoImageView.widthAnchor.constraint(equalToConstant: 20),
//            logoImageView.heightAnchor.constraint(equalToConstant: 20),
//
//            bookmarkImageView.topAnchor.constraint(equalTo: characterImageView.topAnchor, constant: 17),
//            bookmarkImageView.leadingAnchor.constraint(equalTo: characterImageView.leadingAnchor, constant: 6),
//            bookmarkImageView.widthAnchor.constraint(equalToConstant: 21),
//            bookmarkImageView.heightAnchor.constraint(equalToConstant: 25)
//
//        ])
//    }
//
//    func configure(with character: Character) {
//        nameLabel.text = character.name
//        speciesLabel.text = character.species
//        characterImageView.loadImage(from: character.image)
//
//        switch character.status.lowercased() {
//        case "alive":
//            statusBadgeView.backgroundColor = .systemGreen
//        case "dead":
//            statusBadgeView.backgroundColor = .systemRed
//        default:
//            statusBadgeView.backgroundColor = .systemGray
//        }
//
//        switch character.gender.lowercased() {
//        case "male":
//            logoImageView.image = UIImage(named: "male")
//        case "female":
//            logoImageView.image = UIImage(named: "female")
//        default:
//            logoImageView.image = UIImage(named: "questionmark")
//
//        }
//
//        bookmarkImageView.isHidden = !BookmarkManager.isBookmarked(id: character.id)
//    }
//}
