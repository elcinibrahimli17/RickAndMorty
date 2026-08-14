//
//  CharacterCell.swift
//  RickAndMortyApp
//
//  Created by Elchın on 12.08.26.
//

import UIKit

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
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let speciesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusBadgeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let genderSymbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bookmarkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "bookmark.fill"))
        imageView.tintColor = .systemGreen
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
    
    private func setupUI() {
        contentView.addSubview(characterImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(speciesLabel)
        contentView.addSubview(statusBadgeView)
        statusBadgeView.addSubview(genderSymbolLabel)
        contentView.addSubview(bookmarkImageView)
        
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
            
            statusBadgeView.topAnchor.constraint(equalTo: characterImageView.topAnchor, constant: 8),
            statusBadgeView.trailingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: -8),
            statusBadgeView.widthAnchor.constraint(equalToConstant: 24),
            statusBadgeView.heightAnchor.constraint(equalToConstant: 24),
            
            genderSymbolLabel.centerXAnchor.constraint(equalTo: statusBadgeView.centerXAnchor),
            genderSymbolLabel.centerYAnchor.constraint(equalTo: statusBadgeView.centerYAnchor),
            
            bookmarkImageView.topAnchor.constraint(equalTo: characterImageView.topAnchor, constant: 6),
            bookmarkImageView.leadingAnchor.constraint(equalTo: characterImageView.leadingAnchor, constant: 6),
            bookmarkImageView.widthAnchor.constraint(equalToConstant: 20),
            bookmarkImageView.heightAnchor.constraint(equalToConstant: 20)
            
        ])
    }
    
    func configure(with character: Character) {
        nameLabel.text = character.name
        speciesLabel.text = character.species
        characterImageView.loadImage(from: character.image)
        
        switch character.status.lowercased() {
        case "alive":
            statusBadgeView.backgroundColor = .systemGreen
        case "dead":
            statusBadgeView.backgroundColor = .systemRed
        default:
            statusBadgeView.backgroundColor = .systemGray
        }
        
        switch character.gender.lowercased() {
        case "male":
            genderSymbolLabel.text = "♂"
        case "female":
            genderSymbolLabel.text = "♀"
        default:
            genderSymbolLabel.text = "?"
        }
        
        bookmarkImageView.isHidden = !BookmarkManager.isBookmarked(id: character.id)
    }
}
