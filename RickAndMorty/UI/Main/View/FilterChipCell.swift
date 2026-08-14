//
//  FilterChipCell.swift
//  RickAndMortyApp
//
//  Created by Elchın on 12.08.26.
//

import UIKit

class FilterChipCell: UICollectionViewCell {
    
    static let reuseIdentifier = "FilterChipCell"
    
    let menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.showsMenuAsPrimaryAction = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.down"))
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        contentView.layer.cornerRadius = 16
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(menuButton)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            arrowImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 6),
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 12),
            arrowImageView.heightAnchor.constraint(equalToConstant: 12),
            
            menuButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            menuButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            menuButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            menuButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(title: String, showArrow: Bool = true) {
        titleLabel.text = title
        arrowImageView.isHidden = !showArrow
    }
    
    func updateTitle(_ title: String) {
        titleLabel.text = title
    }
}
