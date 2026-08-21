//
//  DetailViewController.swift
//  RickAndMortyApp
//
//  Created by Elchın on 12.08.26.
//

import UIKit

class DetailViewController: UIViewController {
    
    private let viewModel: DetailViewModel
    
    init(character: Character) {
        self.viewModel = DetailViewModel(character: character)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IrishGrover-Regular", size: 44)
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.2, green: 0.05, blue: 0.35, alpha: 1.0)
        
        viewModel.delegate = self
        
        setupHierarchy()
        setupConstraints()
        configure()
        setupNavigationBar()
    }
    
    private func setupHierarchy() {
        view.addSubview(characterImageView)
        view.addSubview(nameLabel)
        view.addSubview(infoStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 107),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 59),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -59),
            
            characterImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 171),
            characterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            characterImageView.widthAnchor.constraint(equalToConstant: 361),
            characterImageView.heightAnchor.constraint(equalToConstant: 329),
            
            infoStackView.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 51),
            infoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configure() {
        nameLabel.text = viewModel.name
        characterImageView.loadImage(from: viewModel.imageURL)
        
        for field in viewModel.infoFields {
            let label = UILabel()
            let boldText = "\(field.title): "
            let attributedText = NSMutableAttributedString(
                string: boldText,
                attributes: [.font: UIFont(name: "Inter-Bold", size: 20) ?? .systemFont(ofSize: 20, weight: .bold), .foregroundColor: UIColor.white]
            )
            attributedText.append(NSAttributedString(
                string: field.value,
                attributes: [.font: UIFont(name: "Inter-Medium", size: 20) ?? .systemFont(ofSize: 20, weight: .medium), .foregroundColor: UIColor.white]
            ))
            label.attributedText = attributedText
            infoStackView.addArrangedSubview(label)
        }
    }
    
    
    
    private func setupNavigationBar() {
        let bookmarkImage = UIImage(systemName: viewModel.isBookmarked ? "bookmark.fill" : "bookmark")
        let bookmarkButton = UIBarButtonItem(
            image: bookmarkImage,
            style: .plain,
            target: self,
            action: #selector(bookmarkTapped)
        )
        bookmarkButton.tintColor = .white
        navigationItem.rightBarButtonItem = bookmarkButton
    }
    
    @objc private func bookmarkTapped() {
        viewModel.toggleBookmark()
    }
}

extension DetailViewController: DetailViewModelDelegate {
    
    func didUpdateBookmark(isBookmarked: Bool) {
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
    }
}
