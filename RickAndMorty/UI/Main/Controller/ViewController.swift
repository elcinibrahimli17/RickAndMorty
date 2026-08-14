//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Elchın on 13.08.26.
//

import UIKit

class ViewController: UIViewController {
    
    private let viewModel = CharacterListViewModel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Rick & Morty"
        label.font = UIFont(name: "IrishGrover-Regular", size: 44)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "fandom"
        label.font = UIFont(name: "IrishGrover-Regular", size: 24)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    private let searchBar: UISearchBar = {
//        let searchBar = UISearchBar()
//        searchBar.placeholder = "Search..."
//        searchBar.searchBarStyle = .minimal
//        searchBar.searchTextField.backgroundColor = UIColor.white.withAlphaComponent(0.2)
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
//        return searchBar
//    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search..."
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchTextField.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.7)
        searchBar.searchTextField.layer.cornerRadius = 15
        searchBar.searchTextField.clipsToBounds = true
        return searchBar
    }()
    
    private lazy var filterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FilterChipCell.self, forCellWithReuseIdentifier: FilterChipCell.reuseIdentifier)
        return collectionView
    }()
    
    private lazy var characterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.reuseIdentifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.2, green: 0.05, blue: 0.35, alpha: 1.0)
        
        viewModel.delegate = self
        
        setupHierarchy()
        setupConstraints()
        setupDelegates()
        viewModel.fetchCharacters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        characterCollectionView.reloadData()
    }
    
    private func setupHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(searchBar)
        view.addSubview(filterCollectionView)
        view.addSubview(characterCollectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
//            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),
            
            subtitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            
//            searchBar.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 12),
//            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
//            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 124),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),
            searchBar.widthAnchor.constraint(equalToConstant: 347),
            searchBar.heightAnchor.constraint(equalToConstant: 45),
            
//            filterCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
//            filterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            filterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            filterCollectionView.heightAnchor.constraint(equalToConstant: 44),
            
            filterCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 183),
            filterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            filterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterCollectionView.heightAnchor.constraint(equalToConstant: 28),
            
            characterCollectionView.topAnchor.constraint(equalTo: filterCollectionView.bottomAnchor, constant: 8),
            characterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            characterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            characterCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupDelegates() {
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        
        characterCollectionView.dataSource = self
        characterCollectionView.delegate = self
        
        searchBar.delegate = self
    }
    
    private func didSelectGenderFilter(_ gender: String) {
        viewModel.selectGender(gender)
        filterCollectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
    }

}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filterCollectionView {
            return viewModel.filterTitles.count
        } else {
            return viewModel.numberOfCharacters
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filterCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterChipCell.reuseIdentifier, for: indexPath) as? FilterChipCell else {
                return UICollectionViewCell()
            }
            
            if indexPath.item == 0 {
                cell.configure(title: viewModel.currentGenderTitle)
                
                let genderOptions = ["Male", "Female", "Genderless", "Unknown"]
                let actions = genderOptions.map { option in
                    UIAction(title: option) { [weak self] _ in
                        self?.didSelectGenderFilter(option)
                    }
                }
                
                cell.menuButton.menu = UIMenu(title: "", children: actions)
            } else {
                cell.configure(title: viewModel.filterTitles[indexPath.item])
            }
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.reuseIdentifier, for: indexPath) as? CharacterCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: viewModel.character(at: indexPath.item))
            return cell
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == filterCollectionView {

            if indexPath.item == 0 {
                        return CGSize(width: 151, height: 28)
                    }
                    let title = viewModel.filterTitles[indexPath.item]
                    let width = title.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium)]).width + 50
                    return CGSize(width: width, height: 28)
        } else {
            let spacing: CGFloat = 12 + 16 + 16
            let width = (collectionView.bounds.width - spacing) / 2
            return CGSize(width: width, height: width + 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView == characterCollectionView else { return }
        let selectedCharacter = viewModel.character(at: indexPath.item)
        let detailVC = DetailViewController(character: selectedCharacter)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(with: searchText)
    }
}

extension ViewController: CharacterListViewModelDelegate {
    func didUpdateCharacters() {
        characterCollectionView.reloadData()
    }
    
    func didFailWithError(_ message: String) {
        print("Xəta: \(message)")
    }
}
