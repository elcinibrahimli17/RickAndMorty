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
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchTextField.backgroundColor = UIColor(hex: "D9D9D9", alpha: 0.7)
        searchBar.searchTextField.layer.cornerRadius = 15
        searchBar.searchTextField.clipsToBounds = true
        
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search...",
            attributes: [.foregroundColor: UIColor(hex: "6B007C", alpha: 0.5)]
        )
        
        if let iconView = searchBar.searchTextField.leftView as? UIImageView {
            iconView.tintColor = UIColor(hex: "6B007C")
            iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
        }
        
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
        layout.minimumInteritemSpacing = 27
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 12, left: 23, bottom: 16, right: 23)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.reuseIdentifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#3A0564")
        
        viewModel.delegate = self
        
        setupHierarchy()
        setupConstraints()
        setupDelegates()
        viewModel.fetchCharacters()
        
        let tapGesture = UITapGestureRecognizer(
                target: self,
                action: #selector(dismissKeyboard)
            )
            tapGesture.cancelsTouchesInView = false
            view.addGestureRecognizer(tapGesture)
        
    }
    
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func scrollCharactersToTopIfNeeded() {
        guard characterCollectionView.numberOfItems(inSection: 0) > 0 else { return }
        characterCollectionView.scrollToItem(at: .init(item: 0, section: 0), at: .top, animated: false)
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
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 65),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            searchBar.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 15),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            searchBar.widthAnchor.constraint(equalToConstant: 347),
            searchBar.heightAnchor.constraint(equalToConstant: 45),
            
            filterCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 14),
            filterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterCollectionView.heightAnchor.constraint(equalToConstant: 28),
            
            characterCollectionView.topAnchor.constraint(equalTo: filterCollectionView.bottomAnchor, constant: 16),
            characterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            characterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
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
        scrollCharactersToTopIfNeeded()
    }
    
    private func didSelectSpeciesFilter(_ species: String) {
        viewModel.selectSpecies(species)
        filterCollectionView.reloadItems(at: [IndexPath(item: 1, section: 0)])
        scrollCharactersToTopIfNeeded()
    }
    
    private func didSelectStatusFilter(_ status: String) {
        viewModel.selectStatus(status)
        filterCollectionView.reloadItems(at: [IndexPath(item: 2, section: 0)])
        scrollCharactersToTopIfNeeded()
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
                let isSelected = viewModel.currentGenderTitle != viewModel.filterTitles[0]
                cell.configure(title: viewModel.currentGenderTitle, isSelected: isSelected) { [weak self] in
                    self?.viewModel.selectGender(nil)
                    self?.filterCollectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
                    self?.scrollCharactersToTopIfNeeded()
                }
                
                let genderOptions = ["Male", "Female", "Genderless", "Unknown"]
                let actions = genderOptions.map { option in
                    UIAction(title: option) { [weak self] _ in
                        self?.didSelectGenderFilter(option)
                    }
                }
                cell.menuButton.menu = UIMenu(title: "", children: actions)
                
            } else if indexPath.item == 1 {
                let isSelected = viewModel.currentSpeciesTitle != viewModel.filterTitles[1]
                cell.configure(title: viewModel.currentSpeciesTitle, isSelected: isSelected) { [weak self] in
                    self?.viewModel.selectSpecies(nil)
                    self?.filterCollectionView.reloadItems(at: [IndexPath(item: 1, section: 0)])
                    self?.scrollCharactersToTopIfNeeded()
                }
                
                let speciesOptions = ["Human", "Alien", "Humanoid", "Unknown"]
                let actions = speciesOptions.map { option in
                    UIAction(title: option) { [weak self] _ in
                        self?.didSelectSpeciesFilter(option)
                    }
                }
                cell.menuButton.menu = UIMenu(title: "", children: actions)
                
            } else {
                let isSelected = viewModel.currentStatusTitle != viewModel.filterTitles[2]
                cell.configure(title: viewModel.currentStatusTitle, isSelected: isSelected) { [weak self] in
                    self?.viewModel.selectStatus(nil)
                    self?.filterCollectionView.reloadItems(at: [IndexPath(item: 2, section: 0)])
                    self?.scrollCharactersToTopIfNeeded()
                }
                
                let statusOptions = ["Alive", "Dead", "unknown"]
                let actions = statusOptions.map { option in
                    UIAction(title: option) { [weak self] _ in
                        self?.didSelectStatusFilter(option)
                    }
                }
                cell.menuButton.menu = UIMenu(title: "", children: actions)
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard collectionView == characterCollectionView else { return }
        viewModel.loadNextPageIfNeeded(currentIndex: indexPath.item)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == filterCollectionView {
//            if indexPath.item == 0 {
//                return CGSize(width: 151, height: 28)
//            }
//            let title = viewModel.filterTitles[indexPath.item]
//            let font = UIFont(name: "Inter18pt-Medium", size: 16) ?? .systemFont(ofSize: 16, weight: .medium)
//            let width = title.size(withAttributes: [.font: font]).width + 42
//            return CGSize(width: width, height: 28)
//        }
        if collectionView == filterCollectionView {
            let title: String
            if indexPath.item == 0 {
                title = viewModel.currentGenderTitle
            } else if indexPath.item == 1 {
                title = viewModel.currentSpeciesTitle
            } else {
                title = viewModel.currentStatusTitle
            }
            
            let font = UIFont(name: "Inter18pt-Medium", size: 16) ?? .systemFont(ofSize: 16, weight: .medium)
            let width = title.size(withAttributes: [.font: font]).width + 42
            return CGSize(width: width, height: 28)
            
        } else {
            let spacing: CGFloat = 27 + 23 + 23
            let width = floor((collectionView.bounds.width - spacing) / 2)
            let imageHeight = width
            let labelWidth = width - 8
            
            let nameFont = UIFont(name: "Inter18pt-Bold", size: 20) ?? .systemFont(ofSize: 20, weight: .bold)
            let speciesFont = UIFont(name: "Inter18pt-Medium", size: 20) ?? .systemFont(ofSize: 20, weight: .medium)
            
            let topGap: CGFloat = 8
            let midGap: CGFloat = 2
            let bottomPadding: CGFloat = 4
            
            func textBlockHeight(for index: Int) -> CGFloat {
                let character = viewModel.character(at: index)
                let nameHeight = Self.textHeight(character.name, font: nameFont, width: labelWidth, maxLines: 2)
                let speciesHeight = Self.textHeight(character.species, font: speciesFont, width: labelWidth, maxLines: 1)
                return nameHeight + midGap + speciesHeight
            }
            
            let rowStartIndex = (indexPath.item / 2) * 2
            let partnerIndex = rowStartIndex + 1
            
            var maxTextHeight = textBlockHeight(for: rowStartIndex)
            if partnerIndex < viewModel.numberOfCharacters {
                maxTextHeight = max(maxTextHeight, textBlockHeight(for: partnerIndex))
            }
            
            let totalHeight = imageHeight + topGap + maxTextHeight + bottomPadding
            return CGSize(width: width, height: totalHeight)
        }
    }
    
    private static func textHeight(_ text: String, font: UIFont, width: CGFloat, maxLines: Int) -> CGFloat {
        let lineHeight = font.lineHeight
        let maxHeight = lineHeight * CGFloat(maxLines)
        let boundingRect = text.boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        return min(ceil(boundingRect.height), maxHeight)
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
        scrollCharactersToTopIfNeeded()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
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

//class ViewController: UIViewController {
//
//    private let viewModel = CharacterListViewModel()
//
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Rick & Morty"
//        label.font = UIFont(name: "IrishGrover-Regular", size: 44)
//        label.textColor = .white
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    private let subtitleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "fandom"
//        label.font = UIFont(name: "IrishGrover-Regular", size: 24)
//        label.textColor = .white
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    private let searchBar: UISearchBar = {
//        let searchBar = UISearchBar()
//        searchBar.searchBarStyle = .minimal
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
//        searchBar.searchTextField.backgroundColor = UIColor(hex: "D9D9D9", alpha: 0.7)
//        searchBar.searchTextField.layer.cornerRadius = 10
//        searchBar.searchTextField.clipsToBounds = true
//
//        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
//            string: "Search...",
//            attributes: [.foregroundColor: UIColor(hex: "6B007C", alpha: 0.5)]
//        )
//
//        if let iconView = searchBar.searchTextField.leftView as? UIImageView {
//            iconView.tintColor = UIColor(hex: "6B007C")
//            iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
//        }
//
//        return searchBar
//    }()
//
//    private lazy var filterCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.minimumInteritemSpacing = 8
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = .clear
//        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.register(FilterChipCell.self, forCellWithReuseIdentifier: FilterChipCell.reuseIdentifier)
//        return collectionView
//    }()
//
//    private lazy var characterCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.minimumInteritemSpacing = 12
//        layout.minimumLineSpacing = 16
//        layout.sectionInset = UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)
//
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = .clear
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.reuseIdentifier)
//        return collectionView
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor(hex: "#3A0564")
//
//        viewModel.delegate = self
//
//        setupHierarchy()
//        setupConstraints()
//        setupDelegates()
//        viewModel.fetchCharacters()
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        characterCollectionView.reloadData()
//    }
//
//    private func setupHierarchy() {
//        view.addSubview(titleLabel)
//        view.addSubview(subtitleLabel)
//        view.addSubview(searchBar)
//        view.addSubview(filterCollectionView)
//        view.addSubview(characterCollectionView)
//    }
//
//    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//
//            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 65),
//            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),
//
//            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
//            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
//
//            searchBar.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 15),
//            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
//            searchBar.widthAnchor.constraint(equalToConstant: 347),
//            searchBar.heightAnchor.constraint(equalToConstant: 45),
//
//            filterCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 14),
//            filterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
//            filterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            filterCollectionView.heightAnchor.constraint(equalToConstant: 28),
//
//            characterCollectionView.topAnchor.constraint(equalTo: filterCollectionView.bottomAnchor, constant: 38),
//            characterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),
//            characterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -23),
//            characterCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//        ])
//    }
//
//    private func setupDelegates() {
//        filterCollectionView.dataSource = self
//        filterCollectionView.delegate = self
//
//        characterCollectionView.dataSource = self
//        characterCollectionView.delegate = self
//
//        searchBar.delegate = self
//    }
//
//    private func didSelectGenderFilter(_ gender: String) {
//        viewModel.selectGender(gender)
//        filterCollectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
//    }
//
//    private func didSelectSpeciesFilter(_ species: String) {
//        viewModel.selectSpecies(species)
//        filterCollectionView.reloadItems(at: [IndexPath(item: 1, section: 0)])
//    }
//
//    private func didSelectStatusFilter(_ status: String) {
//        viewModel.selectStatus(status)
//        filterCollectionView.reloadItems(at: [IndexPath(item: 2, section: 0)])
//    }
//
//}
//
//extension ViewController: UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == filterCollectionView {
//            return viewModel.filterTitles.count
//        } else {
//            return viewModel.numberOfCharacters
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == filterCollectionView {
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterChipCell.reuseIdentifier, for: indexPath) as? FilterChipCell else {
//                return UICollectionViewCell()
//            }
//
//            if indexPath.item == 0 {
//                let isSelected = viewModel.currentGenderTitle != viewModel.filterTitles[0]
//                cell.configure(title: viewModel.currentGenderTitle, isSelected: isSelected) { [weak self] in
//                    self?.viewModel.selectGender(nil)
//                    self?.filterCollectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
//                }
//
//                let genderOptions = ["Male", "Female", "Genderless", "Unknown"]
//                let actions = genderOptions.map { option in
//                    UIAction(title: option) { [weak self] _ in
//                        self?.didSelectGenderFilter(option)
//                    }
//                }
//                cell.menuButton.menu = UIMenu(title: "", children: actions)
//
//            } else if indexPath.item == 1 {
//                let isSelected = viewModel.currentSpeciesTitle != viewModel.filterTitles[1]
//                cell.configure(title: viewModel.currentSpeciesTitle, isSelected: isSelected) { [weak self] in
//                    self?.viewModel.selectSpecies(nil)
//                    self?.filterCollectionView.reloadItems(at: [IndexPath(item: 1, section: 0)])
//                }
//
//                let speciesOptions = ["Human", "Alien", "Humanoid", "Unknown"]
//                let actions = speciesOptions.map { option in
//                    UIAction(title: option) { [weak self] _ in
//                        self?.didSelectSpeciesFilter(option)
//                    }
//                }
//                cell.menuButton.menu = UIMenu(title: "", children: actions)
//
//            } else {
//                let isSelected = viewModel.currentStatusTitle != viewModel.filterTitles[2]
//                cell.configure(title: viewModel.currentStatusTitle, isSelected: isSelected) { [weak self] in
//                    self?.viewModel.selectStatus(nil)
//                    self?.filterCollectionView.reloadItems(at: [IndexPath(item: 2, section: 0)])
//                }
//
//                let statusOptions = ["Alive", "Dead", "unknown"]
//                let actions = statusOptions.map { option in
//                    UIAction(title: option) { [weak self] _ in
//                        self?.didSelectStatusFilter(option)
//                    }
//                }
//                cell.menuButton.menu = UIMenu(title: "", children: actions)
//            }
//
//            return cell
//        } else {
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.reuseIdentifier, for: indexPath) as? CharacterCell else {
//                return UICollectionViewCell()
//            }
//            cell.configure(with: viewModel.character(at: indexPath.item))
//            return cell
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        guard collectionView == characterCollectionView else { return }
//        viewModel.loadNextPageIfNeeded(currentIndex: indexPath.item)
//    }
//}
//
//extension ViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == filterCollectionView {
//            if indexPath.item == 0 {
//                return CGSize(width: 151, height: 28)
//            }
//            let title = viewModel.filterTitles[indexPath.item]
//            let font = UIFont(name: "Inter18pt-Medium", size: 16) ?? .systemFont(ofSize: 16, weight: .medium)
//            let width = title.size(withAttributes: [.font: font]).width + 42
//            return CGSize(width: width, height: 28)
//        } else {
//            let spacing: CGFloat = 12 + 16 + 16
//            let width = (collectionView.bounds.width - spacing) / 2
//            return CGSize(width: width, height: width + 68)
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard collectionView == characterCollectionView else { return }
//        let selectedCharacter = viewModel.character(at: indexPath.item)
//        let detailVC = DetailViewController(character: selectedCharacter)
//        navigationController?.pushViewController(detailVC, animated: true)
//    }
//}
//
//extension ViewController: UISearchBarDelegate {
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        viewModel.search(with: searchText)
//    }
//}
//
//extension ViewController: CharacterListViewModelDelegate {
//    func didUpdateCharacters() {
//        characterCollectionView.reloadData()
//    }
//
//    func didFailWithError(_ message: String) {
//        print("Xəta: \(message)")
//    }
//}

